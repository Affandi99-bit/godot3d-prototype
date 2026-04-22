class_name PlayerController
extends CharacterBody3D

signal movement_locked(locked: bool)

@export var look_speed: float = 0.002
@export var base_speed: float = 7.0
@export var sprint_speed: float = 11.0
@export var jump_velocity: float = 4.5

@export var input_left: String = "move_left"
@export var input_right: String = "move_right"
@export var input_forward: String = "move_front"
@export var input_back: String = "move_back"
@export var input_jump: String = "jump"
@export var input_sprint: String = "sprint"

@export var head_path: NodePath = ^"Head"

var mouse_captured := true
var _look_rotation := Vector2.ZERO
var _locked := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_look_rotation.y = rotation.y
	var head := get_node_or_null(head_path) as Node3D
	_look_rotation.x = head.rotation.x if head else 0.0

func set_locked(value: bool) -> void:
	_locked = value
	movement_locked.emit(_locked)
	if _locked:
		velocity = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_captured and not _locked:
		_rotate_look((event as InputEventMouseMotion).relative)
	if event is InputEventKey and (event as InputEventKey).pressed and (event as InputEventKey).keycode == KEY_ESCAPE:
		mouse_captured = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		mouse_captured = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if _locked:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed(input_jump) and is_on_floor():
		velocity.y = jump_velocity

	var speed := sprint_speed if Input.is_action_pressed(input_sprint) else base_speed
	var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_dir:
		velocity.x = move_dir.x * speed
		velocity.z = move_dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _rotate_look(rot_input: Vector2) -> void:
	var head := get_node_or_null(head_path) as Node3D
	if not head:
		return
	_look_rotation.x -= rot_input.y * look_speed
	_look_rotation.x = clamp(_look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	_look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(_look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(_look_rotation.x)

