extends VBoxContainer

const ABILITY_BUTTON = preload("res://UI/Menus/ability_button.tscn")

func populate() -> void:
	for ability in GlobalVariables.ability_names.keys():
		var new_button = ABILITY_BUTTON.instantiate()
		new_button.ability = ability
		var target_text = str( GlobalVariables.ability_names[ability], " : ", \
		GlobalVariables.ability_uses[ability], "/", GlobalVariables.max_ability_uses[ability])
		new_button.text = target_text
