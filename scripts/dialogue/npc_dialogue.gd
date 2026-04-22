class_name NpcDialogue
extends Interactable

signal dialogue_requested(npc_name: String, lines: Array[String])

@export var npc_name: String = "NPC"
@export var lines: Array[String] = [
	"Hello, adventurer.",
	"Press 1-5 to swap hotbar.",
	"Use item: Q. Drop: G."
]

func interact(interactor: Node) -> void:
	super.interact(interactor)
	dialogue_requested.emit(npc_name, lines)

