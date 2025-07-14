extends Button
class_name AbilityButton

@export var ability : GlobalVariables.abilities

func _ready() -> void:
	pressed.connect(ability_pressed)

func ability_pressed() -> void:
	MessageBus.ability_selected_in_menu.emit(ability)
