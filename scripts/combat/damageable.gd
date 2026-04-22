class_name Damageable
extends Node

## Thin adapter: put on root of actor, point to `Health`.
## Lets attackers call `apply_damage(amount, source)` without knowing scene tree.

@export var health_path: NodePath = ^"Health"
@export var flash_path: NodePath = ^"HitFlash"

func apply_damage(amount: int, source: Node = null) -> void:
	var health := get_node_or_null(health_path) as Health
	if health:
		health.damage(amount, source)
	var flash := get_node_or_null(flash_path) as HitFlash
	if flash:
		flash.flash()

