extends Node

func _ready() -> void:
	MessageBus.restart.connect(restart)

func restart() -> void:
	GlobalVariables.run_number += 1
	for i in GlobalVariables.ability_uses.keys():
		GlobalVariables.ability_uses[i] = 0
	GlobalVariables.total_resources -= 1
	SceneLoader.load_scene("res://scenes/main_game/assigning_abilities.tscn")
