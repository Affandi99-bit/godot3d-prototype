class_name Item
extends StaticBody3D

signal interacted(body)

@export var prompt_message="Interact"
@export var prompt_action="interact"
@onready var touched = $Touched

func get_prompt():
	var _key_name=""
	for action in InputMap.action_get_events("interact"):
		if action is InputEventKey:
			_key_name= OS.get_keycode_string(KEY_R)
		return prompt_message + "\n[" + _key_name + "]"

func interact(body):
	emit_signal("interacted", body)

	if touched:
		touched.interact()

	print("Item interacted")
