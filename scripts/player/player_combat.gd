class_name PlayerCombat
extends Node

signal attacked(kind: String)

@export var melee_range: float = 2.2
@export var melee_radius: float = 0.9
@export var melee_damage: int = 2
@export var melee_cooldown: float = 0.35

@export var projectile_scene: PackedScene
@export var ranged_damage: int = 1
@export var ranged_cooldown: float = 0.7
@export var projectile_speed: float = 18.0

@export var input_melee: String = "attack_melee"
@export var input_ranged: String = "attack_ranged"

@export var camera_path: NodePath = ^"../Head/Camera3D"
@export var inventory_path: NodePath = ^"../Inventory"

var _melee_cd_left := 0.0
var _ranged_cd_left := 0.0

func _physics_process(delta: float) -> void:
	_melee_cd_left = maxf(0.0, _melee_cd_left - delta)
	_ranged_cd_left = maxf(0.0, _ranged_cd_left - delta)

	if Input.is_action_just_pressed(input_melee):
		try_melee()
	if Input.is_action_just_pressed(input_ranged):
		try_ranged()

func _get_damage_bonus() -> int:
	var inv := get_node_or_null(inventory_path) as Inventory
	return inv.get_damage_bonus() if inv else 0

func try_melee() -> void:
	if _melee_cd_left > 0.0:
		return
	_melee_cd_left = melee_cooldown
	attacked.emit("melee")

	var cam := get_node_or_null(camera_path) as Camera3D
	if not cam:
		return

	var origin := cam.global_position + (-cam.global_transform.basis.z) * melee_range
	var shape := SphereShape3D.new()
	shape.radius = melee_radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = Transform3D(Basis(), origin)
	params.exclude = [owner]
	params.collide_with_areas = true
	params.collide_with_bodies = true

	var hits := cam.get_world_3d().direct_space_state.intersect_shape(params, 16)
	for h in hits:
		var target := h.get("collider") as Node
		if _apply_damage_to(target, melee_damage + _get_damage_bonus()):
			return

func try_ranged() -> void:
	if not projectile_scene:
		return
	if _ranged_cd_left > 0.0:
		return
	_ranged_cd_left = ranged_cooldown
	attacked.emit("ranged")

	var cam := get_node_or_null(camera_path) as Camera3D
	if not cam:
		return

	var proj := projectile_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(proj)
	proj.global_position = cam.global_position + (-cam.global_transform.basis.z) * 0.6
	proj.global_basis = cam.global_basis
	if proj.has_method("setup"):
		proj.call("setup", ranged_damage + _get_damage_bonus(), owner, projectile_speed)

func _apply_damage_to(node: Node, amount: int) -> bool:
	if not node:
		return false
	var cur: Node = node
	while cur:
		var dmg := cur.get_node_or_null(^"Damageable") as Damageable
		if dmg:
			dmg.apply_damage(amount, owner)
			return true
		cur = cur.get_parent()
	return false

