extends Area2D

func take_damage(amount : int, player_position : Vector2) -> void:
	get_parent().take_damage(amount, player_position)
