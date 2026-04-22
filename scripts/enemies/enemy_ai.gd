class_name EnemyAI
extends Node

enum State { IDLE, CHASE, ATTACK }

@export var player_path: NodePath

@export var detect_range: float = 10.0
@export var attack_range: float = 2.0
@export var move_speed: float = 4.0

@export var attack_damage: int = 1
@export var attack_cooldown: float = 0.9

@export var body_path: NodePath = ^".."

signal state_changed(state: int)
signal attacked()

var state: int = State.IDLE
var _cd_left := 0.0

func _physics_process(delta: float) -> void:
	_cd_left = maxf(0.0, _cd_left - delta)

	var body := get_node_or_null(body_path) as CharacterBody3D
	if not body:
		return
	var player := _get_player()
	if not player:
		_set_state(State.IDLE)
		return

	var to_player := player.global_position - body.global_position
	var dist := to_player.length()

	if dist > detect_range:
		_set_state(State.IDLE)
		_stop(body)
		return

	if dist <= attack_range:
		_set_state(State.ATTACK)
		_stop(body)
		_try_attack(player)
		return

	_set_state(State.CHASE)
	_chase(body, to_player.normalized(), delta)

func _get_player() -> Node3D:
	if player_path != NodePath():
		return get_node_or_null(player_path) as Node3D
	return get_tree().get_first_node_in_group("player") as Node3D

func _set_state(s: int) -> void:
	if state == s:
		return
	state = s
	state_changed.emit(state)

func _stop(body: CharacterBody3D) -> void:
	body.velocity.x = move_toward(body.velocity.x, 0, move_speed)
	body.velocity.z = move_toward(body.velocity.z, 0, move_speed)
	body.move_and_slide()

func _chase(body: CharacterBody3D, dir: Vector3, delta: float) -> void:
	var flat := Vector3(dir.x, 0, dir.z).normalized()
	body.velocity.x = flat.x * move_speed
	body.velocity.z = flat.z * move_speed
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	body.look_at(body.global_position + flat, Vector3.UP)
	body.move_and_slide()

func _try_attack(player: Node) -> void:
	if _cd_left > 0.0:
		return
	_cd_left = attack_cooldown
	attacked.emit()

	var cur: Node = player
	while cur:
		var dmg := cur.get_node_or_null(^"Damageable") as Damageable
		if dmg:
			dmg.apply_damage(attack_damage, owner)
			return
		cur = cur.get_parent()

