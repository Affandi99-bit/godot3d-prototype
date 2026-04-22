class_name Health
extends Node

signal changed(current: int, max: int)
signal damaged(amount: int, source: Node)
signal healed(amount: int, source: Node)
signal died(source: Node)

@export var max_health: int = 10
@export var invulnerable: bool = false
@export var destroy_owner_on_death: bool = true

var current_health: int

func _ready() -> void:
	current_health = clampi(current_health if current_health > 0 else max_health, 0, max_health)
	changed.emit(current_health, max_health)

func set_max_health(value: int, keep_ratio: bool = true) -> void:
	value = max(1, value)
	var ratio := float(current_health) / float(max_health) if max_health > 0 else 1.0
	max_health = value
	current_health = int(round(ratio * max_health)) if keep_ratio else min(current_health, max_health)
	changed.emit(current_health, max_health)

func heal(amount: int, source: Node = null) -> void:
	if amount <= 0:
		return
	var before := current_health
	current_health = clampi(current_health + amount, 0, max_health)
	var delta := current_health - before
	if delta != 0:
		healed.emit(delta, source)
		changed.emit(current_health, max_health)

func damage(amount: int, source: Node = null) -> void:
	if amount <= 0:
		return
	if invulnerable:
		return
	var before := current_health
	current_health = clampi(current_health - amount, 0, max_health)
	var delta := before - current_health
	if delta != 0:
		damaged.emit(delta, source)
		changed.emit(current_health, max_health)
		if current_health <= 0:
			died.emit(source)
			if destroy_owner_on_death and owner and owner is Node:
				(owner as Node).queue_free()

