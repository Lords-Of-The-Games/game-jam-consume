extends Button

@export var ability : GlobalVariables.abilities

func _ready() -> void:
	pressed.connect(ability_pressed)

func ability_pressed() -> void:
	MessageBus.ability_used.emit(ability)
