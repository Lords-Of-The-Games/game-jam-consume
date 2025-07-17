extends Node

#region Reset Saves
var SLIME_1 = preload("res://scenes/main_game/scene1/slime1.tres")
var SLIME_2 = preload("res://scenes/main_game/scene1/slime2.tres")
var SLIME_3 = preload("res://scenes/main_game/scene1/slime3.tres")
var THE_OTHER_YOU_1 = preload("res://scenes/main_game/scene1/the_other_you1.tres")
var CAT_SCENE_1 = preload("res://scenes/main_game/scene1/cat_scene1.tres")
var CAT_box = preload("uid://caumnxxkbw4jh")
func reset_save() -> void:
	SLIME_1.spawn = true
	SLIME_1.hp = 3
	SLIME_2.spawn = true
	SLIME_2.hp = 3
	SLIME_3.spawn = true
	SLIME_3.hp = 3
	THE_OTHER_YOU_1.spawn = false
	THE_OTHER_YOU_1.conversation_choices["first_conversation"] = "not"
	THE_OTHER_YOU_1.conversation_choices["second_conversation"] = "not"
	THE_OTHER_YOU_1.conversation_choices["other_you_third_conversation"] = "not"
	CAT_SCENE_1.spawn = false
	CAT_SCENE_1.conversation_choices["cat_first_conversation"] = "not"
	CAT_SCENE_1.conversation_choices["cat_second_conversation"] = "not"
	CAT_SCENE_1.conversation_choices["found"] = "not"
	CAT_box.conversation_choices["found"] = "not"

	ResourceSaver.save(SLIME_1)
	ResourceSaver.save(SLIME_2)
	ResourceSaver.save(SLIME_3)
	ResourceSaver.save(THE_OTHER_YOU_1)
	ResourceSaver.save(CAT_SCENE_1)
	ResourceSaver.save(CAT_box)
	
#endregion

func _ready() -> void:
	call_deferred("reset_save")
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
	
	if signal_name == "other_you_third_conversation":
		GlobalVariables.total_resources += 5
		GlobalVariables.add_new_ability(GlobalVariables.abilities.DANCE, "Dance", 1, 1)
		MessageBus.received_message.emit("learned how to dance!", "learned how to dance!", 0.0, true)
		#await get_tree().create_timer(2.0).timeout
		MessageBus.restart.emit()
	
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
