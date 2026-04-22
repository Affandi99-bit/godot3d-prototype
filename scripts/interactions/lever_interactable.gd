class_name LeverInteractable
extends Interactable

signal toggled(on: bool)

@export var on_rotation_deg: float = -35.0
@export var off_rotation_deg: float = 35.0

var on := false

func interact(interactor: Node) -> void:
	super.interact(interactor)
	on = !on
	toggled.emit(on)
	rotation.x = deg_to_rad(on_rotation_deg if on else off_rotation_deg)

