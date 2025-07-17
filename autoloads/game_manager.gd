extends Node

var CAT_SCENE_1 = preload("res://scenes/main_game/scene1/cat_scene1.tres")
var CAT_box = preload("uid://caumnxxkbw4jh")

func _ready() -> void:
	MessageBus.restart.connect(restart)
	Dialogic.signal_event.connect(handle_dialogic_signals)

func restart() -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	GlobalVariables.run_number += 1
	for i in GlobalVariables.ability_uses.keys():
		GlobalVariables.ability_uses[i] = 0
	GlobalVariables.total_resources -= 1
	SceneLoader.load_scene("res://scenes/main_game/assigning_abilities.tscn")

func handle_dialogic_signals(signal_name : String) -> void:
	
	if signal_name.contains("resources"):
		var resources : Array[String] = signal_name.split(":")
		var resources_obtained : int = int(resources[1])
		MessageBus.acquired_resources.emit(resources_obtained)

	if signal_name == "took_kitten":
		CAT_SCENE_1.conversation_choices["found"] = "yes"
		CAT_SCENE_1.spawn = true
		CAT_box.spawn = false
		var original_message : String = str("Humanity: ", GlobalVariables.total_resources)
		GlobalVariables.total_resources += 5
		var new_message : String = str("Humanity: ", GlobalVariables.total_resources)
		MessageBus.received_message.emit(original_message, new_message, 1.5, false)
	
	if signal_name == "first_pet":
		var original_message : String = str("Humanity: ", GlobalVariables.total_resources)
		GlobalVariables.total_resources += 5
		var new_message : String = str("Humanity: ", GlobalVariables.total_resources)
		GlobalVariables.max_ability_uses[GlobalVariables.abilities.INTERACT] += 1
		GlobalVariables.max_ability_uses[GlobalVariables.abilities.DASH] += 1
		GlobalVariables.max_ability_uses[GlobalVariables.abilities.JUMP] += 1
		GlobalVariables.max_ability_uses[GlobalVariables.abilities.ATTACK] += 1
		MessageBus.received_message.emit(original_message, new_message, 1.5, true)
		
	if signal_name == "restart":
		await get_tree().create_timer(2.5).timeout
		MessageBus.restart.emit()
