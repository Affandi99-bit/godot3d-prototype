class_name Inventory
extends Node

signal changed(slots: Array, active_index: int)
signal active_changed(active_index: int)
signal item_picked(item: ItemData)
signal item_dropped(item: ItemData)
signal item_used(item: ItemData)
signal equipment_changed(equipped: ItemData)

@export var slot_count: int = 5
@export var drop_scene: PackedScene

var slots: Array[ItemData] = []
var active_index: int = 0
var equipped: ItemData

func _ready() -> void:
	slots.resize(slot_count)
	for i in range(slot_count):
		slots[i] = null
	_emit_changed()

func _emit_changed() -> void:
	changed.emit(slots.duplicate(), active_index)

func set_active(index: int) -> void:
	active_index = clampi(index, 0, slot_count - 1)
	active_changed.emit(active_index)
	_emit_changed()

func cycle(delta: int) -> void:
	set_active((active_index + delta + slot_count) % slot_count)

func get_active_item() -> ItemData:
	return slots[active_index]

func pickup(item: ItemData) -> bool:
	if not item:
		return false
	for i in range(slot_count):
		if slots[i] == null:
			slots[i] = item
			item_picked.emit(item)
			_emit_changed()
			return true
	return false

func remove_at(index: int) -> ItemData:
	if index < 0 or index >= slot_count:
		return null
	var item := slots[index]
	slots[index] = null
	_emit_changed()
	return item

func drop_active(world_parent: Node, origin: Transform3D) -> void:
	var item := remove_at(active_index)
	if not item:
		return
	item_dropped.emit(item)
	if drop_scene and world_parent:
		var inst := drop_scene.instantiate() as Node3D
		world_parent.add_child(inst)
		inst.global_transform = origin
		if inst.has_method("set_item_data"):
			inst.call("set_item_data", item)

func use_active(user: Node) -> void:
	var item := get_active_item()
	if not item:
		return
	match item.type:
		ItemData.ItemType.CONSUMABLE:
			var health := user.get_node_or_null(^"Health") as Health
			if health:
				health.heal(item.effect_value, user)
			remove_at(active_index)
			item_used.emit(item)
		ItemData.ItemType.EQUIPMENT:
			equipped = item
			equipment_changed.emit(equipped)
			item_used.emit(item)
	_emit_changed()

func get_damage_bonus() -> int:
	return equipped.damage_bonus if equipped else 0

