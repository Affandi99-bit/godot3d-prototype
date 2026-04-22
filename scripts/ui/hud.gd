class_name HUD
extends CanvasLayer

@export var player_path: NodePath

@onready var health_bar: ProgressBar = $HealthBar
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var hint_label: Label = $InteractHint
@onready var hotbar: Control = $Hotbar
@onready var dialogue_panel: Control = $DialoguePanel

var _player: Node
var _inv: Inventory
var _health: Health
var _interactor: PlayerInteractor
var _lock_target: Node

func _ready() -> void:
	hint_label.text = ""
	dialogue_panel.visible = false
	stamina_bar.visible = false
	_bind_player()

func _process(_delta: float) -> void:
	_update_stamina()

func _bind_player() -> void:
	if player_path != NodePath():
		_player = get_node_or_null(player_path)
	else:
		_player = get_tree().get_first_node_in_group("player")
	if not _player:
		return
	_inv = _player.get_node_or_null(^"Inventory") as Inventory
	_health = _player.get_node_or_null(^"Health") as Health
	_interactor = _player.get_node_or_null(^"Interactor") as PlayerInteractor
	_lock_target = _player

	if _health:
		_health.changed.connect(_on_health_changed)
		_on_health_changed(_health.current_health, _health.max_health)

	if _interactor:
		_interactor.focus_changed.connect(_on_focus_changed)

	if _inv:
		_inv.changed.connect(_on_inventory_changed)
		_on_inventory_changed(_inv.slots, _inv.active_index)

	var dlg := dialogue_panel as DialoguePanel
	if dlg:
		dlg.closed.connect(_on_dialogue_closed)

func _update_stamina() -> void:
	if not _player:
		return
	if not ("stamina" in _player and "stamina_max" in _player):
		return
	var maxv := float(_player.get("stamina_max"))
	if maxv <= 0.0:
		return
	var curv := float(_player.get("stamina"))
	stamina_bar.visible = true
	stamina_bar.max_value = maxv
	stamina_bar.value = clampf(curv, 0.0, maxv)

func _on_health_changed(current: int, maxh: int) -> void:
	health_bar.max_value = maxh
	health_bar.value = current

func _on_focus_changed(prompt: String) -> void:
	hint_label.text = ("Press E - " + prompt) if prompt != "" else ""

func _on_inventory_changed(slots: Array, active_index: int) -> void:
	var hb := hotbar as HotbarUI
	if hb:
		hb.set_slots(slots, active_index)

func start_dialogue(npc_name: String, lines: Array[String]) -> void:
	var dlg := dialogue_panel as DialoguePanel
	if not dlg:
		return
	_set_player_locked(true)
	dlg.open(npc_name, lines)

func _on_dialogue_closed() -> void:
	_set_player_locked(false)
	hint_label.text = ""

func _set_player_locked(locked: bool) -> void:
	if not _lock_target:
		return
	if _lock_target.has_method("set_locked"):
		_lock_target.call("set_locked", locked)
		return
	# proto_controller.gd uses `can_move` flag
	if "can_move" in _lock_target:
		_lock_target.set("can_move", not locked)
	if "can_jump" in _lock_target:
		_lock_target.set("can_jump", not locked)

