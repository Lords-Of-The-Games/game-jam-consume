extends interactable

func late_ready() -> void:
	super()
	if saved_resource.conversation_choices["found"] == "not":
		$AnimatedSprite2D.play("box")
	else:
		$AnimatedSprite2D.play("idle")

func interact() -> void:
	super()
	GlobalVariables.ability_uses[GlobalVariables.abilities.INTERACT] -= 1
	handle_dialogue_logic()

func handle_dialogue_logic():
	if saved_resource.conversation_choices["found"] == "not":
		start_dialog("find_kitten")
		return
		
	if saved_resource.conversation_choices["cat_first_conversation"] != "finished":
		saved_resource.conversation_choices["cat_first_conversation"] = "finished"
		start_dialog("cat_first_conversation")
		return
	
	if saved_resource.conversation_choices["cat_second_conversation"]!= "finished":
		saved_resource.conversation_choices["cat_second_conversation"] = "finished"
		start_dialog("cat_second_conversation")
		return
		

func start_dialog(timeline: String) -> void:
	save()
	interaction_disabled = true
	Utils.start_dialog(timeline)
