extends Control
class_name ability_container

@export var current_ability : GlobalVariables.abilities
@export var ability_number : int = 0
@onready var counter: Label = $Counter
@onready var key_binding: Label = $KeyBinding

func _ready() -> void:
	refresh()

func refresh() -> void:
	var equipped_ability : GlobalVariables.abilities = GlobalVariables.equipped_abilities[ability_number]
	var target_text = str( GlobalVariables.ability_names[equipped_ability], " : ", \
	GlobalVariables.ability_uses[equipped_ability], "/", GlobalVariables.max_ability_uses[equipped_ability])
	counter.text = target_text
