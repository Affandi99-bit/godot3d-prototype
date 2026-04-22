class_name Projectile
extends Area3D

@export var life_time: float = 2.5
@export var speed: float = 18.0

var _damage: int = 1
var _source: Node

func setup(damage_amount: int, source: Node, projectile_speed: float) -> void:
	_damage = damage_amount
	_source = source
	speed = projectile_speed

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += (-global_transform.basis.z) * speed * delta
	life_time -= delta
	if life_time <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body == _source:
		return
	var cur: Node = body
	while cur:
		var dmg := cur.get_node_or_null(^"Damageable") as Damageable
		if dmg:
			dmg.apply_damage(_damage, _source)
			queue_free()
			return
		cur = cur.get_parent()

