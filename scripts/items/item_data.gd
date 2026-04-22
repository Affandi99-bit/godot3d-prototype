class_name ItemData
extends Resource

enum ItemType { EQUIPMENT, CONSUMABLE }

@export var item_name: String = "Item"
@export var icon: Texture2D
@export var type: ItemType = ItemType.EQUIPMENT

@export_group("Equipment")
@export var damage_bonus: int = 0
@export var armor_bonus: int = 0

@export_group("Consumable")
@export var effect_value: int = 5

