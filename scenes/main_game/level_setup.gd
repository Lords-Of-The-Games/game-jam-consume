extends Node2D

@export var entrances : Dictionary[int, Marker2D]

func _ready() -> void:
	if entrances.size() > 1:
		var player : Node2D = get_tree().get_first_node_in_group("player")
		player.global_position = entrances[GlobalVariables.entrance_number_in_new_scene].global_position
