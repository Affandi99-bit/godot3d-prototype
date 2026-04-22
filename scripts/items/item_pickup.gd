class_name ItemPickup
extends Area3D

signal picked(by: Node, item: ItemData)

@export var item: ItemData

@onready var _label: Label3D = get_node_or_null(^"Label3D") as Label3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_update_label()

func set_item_data(data: ItemData) -> void:
	item = data
	_update_label()

func _update_label() -> void:
	if _label and item:
		_label.text = item.item_name

func _on_body_entered(body: Node) -> void:
	if not item:
		return
	var inv := body.get_node_or_null(^"Inventory") as Inventory
	if not inv:
		inv = body.get_node_or_null(^"../Inventory") as Inventory
	if not inv:
		return
	if inv.pickup(item):
		picked.emit(body, item)
		queue_free()

