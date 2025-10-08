extends RayCast3D
# Called when the node enters the scene tree for the first time.
@onready var prompt =$prompt
func _ready() -> void:
	add_exception(owner)

func _physics_process(_delta):
	prompt.text=""
	if is_colliding():
		var detected=get_collider()
		if detected is Item:
			prompt.text=detected.get_prompt()
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
