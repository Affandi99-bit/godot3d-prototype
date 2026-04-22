extends Node

func _ready() -> void:
	_ensure_key("interact", KEY_E)
	_ensure_mouse("attack_melee", MOUSE_BUTTON_LEFT)
	_ensure_mouse("attack_ranged", MOUSE_BUTTON_RIGHT)
	_ensure_key("use_item", KEY_Q)
	_ensure_key("drop_item", KEY_G)
	_ensure_key("hotbar_prev", KEY_Z)
	_ensure_key("hotbar_next", KEY_X)
	_ensure_mouse("hotbar_prev", MOUSE_BUTTON_WHEEL_UP)
	_ensure_mouse("hotbar_next", MOUSE_BUTTON_WHEEL_DOWN)

func _ensure_action(action: StringName) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)

func _ensure_key(action: StringName, keycode: Key) -> void:
	_ensure_action(action)
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey and (ev as InputEventKey).keycode == keycode:
			return
	var e := InputEventKey.new()
	e.keycode = keycode
	InputMap.action_add_event(action, e)

func _ensure_mouse(action: StringName, button: MouseButton) -> void:
	_ensure_action(action)
	for ev in InputMap.action_get_events(action):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).button_index == button:
			return
	var e := InputEventMouseButton.new()
	e.button_index = button
	InputMap.action_add_event(action, e)

