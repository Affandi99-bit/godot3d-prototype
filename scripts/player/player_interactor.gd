class_name PlayerInteractor
extends Node

signal focus_changed(prompt: String)
signal interact_started(target: Interactable)

@export var input_interact: String = "interact"
@export var max_distance: float = 4.0
@export var camera_path: NodePath = ^"../Head/Camera3D"

var _focused: Interactable

func _physics_process(_delta: float) -> void:
	var target := _ray_pick_interactable()
	if target != _focused:
		_focused = target
		focus_changed.emit(_focused.prompt_text if _focused else "")

	if _focused and Input.is_action_just_pressed(input_interact):
		if _focused.can_interact(owner):
			interact_started.emit(_focused)
			_focused.interact(owner)

func _ray_pick_interactable() -> Interactable:
	var cam := get_node_or_null(camera_path) as Camera3D
	if not cam:
		return null
	var from := cam.global_position
	var to := from + (-cam.global_transform.basis.z) * max_distance
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.exclude = [owner]
	var hit := cam.get_world_3d().direct_space_state.intersect_ray(params)
	if hit.is_empty():
		return null

	var node := hit["collider"] as Node
	while node:
		if node is Interactable:
			return node as Interactable
		node = node.get_parent()
	return null

