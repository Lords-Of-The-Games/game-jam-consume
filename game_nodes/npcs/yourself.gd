extends interactable

func interact() -> void:
	super()
	GlobalVariables.ability_uses[GlobalVariables.abilities.INTERACT] -= 1
	handle_dialogue_logic()

func handle_dialogue_logic():
	if saved_resource.conversation_choices.keys().size() < 1:
		saved_resource.conversation_choices["first_conversation"] = "had it"
		save()
		start_dialog("first_conversation")
		

func start_dialog(timeline: String) -> void:
	interaction_disabled = true
	Utils.start_dialog(timeline)
