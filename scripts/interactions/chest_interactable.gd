class_name ChestInteractable
extends Interactable

@export var item_to_spawn: ItemData
@export var pickup_scene: PackedScene
@export var spawn_offset: Vector3 = Vector3(0, 1.0, 0)

var _opened := false

func can_interact(_interactor: Node) -> bool:
	return enabled and not _opened

func interact(interactor: Node) -> void:
	super.interact(interactor)
	if _opened:
		return
	_opened = true
	prompt_text = "Empty"
	_spawn_item()

func _spawn_item() -> void:
	if not pickup_scene or not item_to_spawn:
		return
	var inst := pickup_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position + spawn_offset
	if inst.has_method("set_item_data"):
		inst.call("set_item_data", item_to_spawn)

