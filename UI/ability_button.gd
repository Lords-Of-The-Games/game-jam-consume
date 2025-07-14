extends Button
class_name AbilityButton

@export var ability : GlobalVariables.abilities
@export var damaged : bool = false

func _ready() -> void:
	pressed.connect(ability_pressed)

func ability_pressed() -> void:
	if GlobalVariables.ability_uses[ability] <= 0 and !damaged:
		return
	MessageBus.ability_selected_in_menu.emit(ability, damaged)
