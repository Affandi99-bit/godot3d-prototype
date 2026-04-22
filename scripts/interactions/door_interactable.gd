class_name DoorInteractable
extends Interactable

@export var open_rotation_deg: float = 90.0
@export var speed: float = 10.0

var _open := false

func interact(interactor: Node) -> void:
	super.interact(interactor)
	_open = !_open

func _process(delta: float) -> void:
	var target := deg_to_rad(open_rotation_deg if _open else 0.0)
	rotation.y = lerp_angle(rotation.y, target, speed * delta)

