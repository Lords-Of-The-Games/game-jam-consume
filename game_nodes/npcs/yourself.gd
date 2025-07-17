extends interactable

func late_ready() -> void:
	super()
	if saved_resource.conversation_choices["other_you_third_conversation"] == "finished":
		$AnimatedSprite2D.play("dance")

func interact() -> void:
	super()
	GlobalVariables.ability_uses[GlobalVariables.abilities.INTERACT] -= 1
	handle_dialogue_logic()

func handle_dialogue_logic():
	if saved_resource.conversation_choices["first_conversation"] != "finished":
		saved_resource.conversation_choices["first_conversation"] = "finished"
		save()
		start_dialog("first_conversation")
		return
	
	if saved_resource.conversation_choices["second_conversation"] != "finished":
		saved_resource.conversation_choices["second_conversation"] = "finished"
		save()
		start_dialog("second_conversation")
		return
	
	if saved_resource.conversation_choices["other_you_third_conversation"] != "finished":
		saved_resource.conversation_choices["other_you_third_conversation"] = "finished"
		save()
		start_dialog("other_you_third_conversation")
		return
		

func start_dialog(timeline: String) -> void:
	interaction_disabled = true
	Utils.start_dialog(timeline)
