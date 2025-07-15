extends Area2D

func take_damage(amount : int) -> void:
	get_parent().take_damage(amount)
