class_name Interactable
extends Node3D

signal interacted(interactor: Node)

@export var prompt_text: String = "Interact"
@export var enabled: bool = true

func set_enabled(value: bool) -> void:
	enabled = value

func can_interact(_interactor: Node) -> bool:
	return enabled

func interact(interactor: Node) -> void:
	if not can_interact(interactor):
		return
	interacted.emit(interactor)

