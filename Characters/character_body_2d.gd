extends CharacterBody2D

var current_ability1 : GlobalVariables.abilities
var current_ability2 : GlobalVariables.abilities
var current_ability3 : GlobalVariables.abilities
@onready var interaction_area: Area2D = $InteractionArea

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ability1"):
		jump()

	move_and_slide()
	velocity += get_gravity() * delta
	for i in interaction_area.get_overlapping_bodies():
		if i.is_in_group("interactable"):
			i.show_interaction()

func jump() -> void:
	velocity.y = -500
	MessageBus.ability_used.emit(GlobalVariables.abilities.JUMP)

func attack() -> void:
	MessageBus.ability_used.emit(GlobalVariables.abilities.ATTACK)

func dash() -> void:
	MessageBus.ability_used.emit(GlobalVariables.abilities.DASH)

func interact() -> void:
	MessageBus.ability_used.emit(GlobalVariables.abilities.INTERACT)
