class_name DialoguePanel
extends Control

signal closed()

@onready var name_label: Label = $Panel/VBox/NpcName
@onready var text_label: Label = $Panel/VBox/Text
@onready var next_button: Button = $Panel/VBox/Next

var _lines: Array[String] = []
var _index := 0

func _ready() -> void:
	next_button.pressed.connect(_advance)
	visible = false

func open(npc_name: String, lines: Array[String]) -> void:
	_lines = lines
	_index = 0
	name_label.text = npc_name
	visible = true
	_show_line()

func _show_line() -> void:
	if _index >= _lines.size():
		close()
		return
	text_label.text = _lines[_index]
	next_button.text = "Close" if _index == _lines.size() - 1 else "Next"

func _advance() -> void:
	_index += 1
	_show_line()

func close() -> void:
	visible = false
	closed.emit()

