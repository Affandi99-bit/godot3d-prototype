class_name PlayerInventoryInput
extends Node

@export var inventory_path: NodePath = ^"../Inventory"
@export var input_use: String = "use_item"
@export var input_drop: String = "drop_item"
@export var input_prev: String = "hotbar_prev"
@export var input_next: String = "hotbar_next"

func _unhandled_input(event: InputEvent) -> void:
	var inv := get_node_or_null(inventory_path) as Inventory
	if not inv:
		return

	if Input.is_action_just_pressed(input_use):
		inv.use_active(owner)
	if Input.is_action_just_pressed(input_drop):
		var basis := (owner as Node3D).global_transform
		var forward := -(owner as Node3D).global_transform.basis.z
		var t := basis
		t.origin += forward * 1.2 + Vector3.UP * 0.5
		inv.drop_active(get_tree().current_scene, t)

	if Input.is_action_just_pressed(input_prev):
		inv.cycle(-1)
	if Input.is_action_just_pressed(input_next):
		inv.cycle(1)

	if event is InputEventKey and (event as InputEventKey).pressed:
		match (event as InputEventKey).keycode:
			KEY_1: inv.set_active(0)
			KEY_2: inv.set_active(1)
			KEY_3: inv.set_active(2)
			KEY_4: inv.set_active(3)
			KEY_5: inv.set_active(4)

