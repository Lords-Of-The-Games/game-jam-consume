extends CanvasLayer

@export var ability1animator : ability_container
@export var ability2animator : ability_container
@export var ability3animator : ability_container

@onready var play_time: Control = $PlayTime
@onready var ability_menu: VBoxContainer = $AbilityMenu

func _ready() -> void:
	MessageBus.ability_used.connect(ability_used)
	MessageBus.took_damage.connect(took_damage)

func ability_used(which_ability : GlobalVariables.abilities) -> void:
	if which_ability ==	GlobalVariables.equipped_abilities[0]:
		ability1animator.refresh()

	if which_ability ==	GlobalVariables.equipped_abilities[1]:
		ability2animator.refresh()

	if which_ability ==	GlobalVariables.equipped_abilities[2]:
		ability3animator.refresh()

func took_damage(_amount) -> void:
	get_tree().paused = true
	play_time.hide()
	ability_menu.populate()
	ability_menu.show()
