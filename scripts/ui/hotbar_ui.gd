class_name HotbarUI
extends Control

@export var slot_paths: Array[NodePath]
@export var active_style: StyleBox
@export var normal_style: StyleBox

var _slots: Array[TextureRect] = []
var _frames: Array[Panel] = []

func _ready() -> void:
	_slots.clear()
	_frames.clear()
	for p in slot_paths:
		var panel := get_node_or_null(p) as Panel
		if not panel:
			continue
		_frames.append(panel)
		var tex := panel.get_node_or_null(^"Icon") as TextureRect
		_slots.append(tex)

func set_slots(items: Array, active_index: int) -> void:
	for i in _slots.size():
		var icon := _slots[i]
		if not icon:
			continue
		var item := items[i] as ItemData if i < items.size() else null
		icon.texture = item.icon if item and item.icon else null
	for i in _frames.size():
		var frame := _frames[i]
		if not frame:
			continue
		frame.add_theme_stylebox_override("panel", active_style if i == active_index else normal_style)

