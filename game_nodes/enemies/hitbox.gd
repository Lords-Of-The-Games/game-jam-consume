extends Area2D

signal dealt_damage

@export var active : bool = true
@export var target_group : String = "player"
@export var damage : int = 1

func _ready() -> void:
	collision_mask += 2

func area_entered(area : Area2D) -> void:
	if area.is_in_group(target_group):
		area.take_damage(damage)
		dealt_damage.emit()
