extends Node
class_name EnemyState

@export var animation_name: String = ""
@export var states : Dictionary[String, EnemyState]
var state_machine : EnemyStateMachine
var animated_sprite_2d : AnimatedSprite2D

## Hold a reference to the parent so that it can be controlled by the state
var parent : CharacterBody2D
var state_active : bool = false
#var state_machine : Player_state_machine

func _ready() -> void:
	pass

func enter() -> void:
	if animation_name != "" :
		animated_sprite_2d.play(animation_name)
	state_active = true

func exit() -> void:
	state_active = false
	pass

func process_physics(_delta: float, _direction : Vector2) -> EnemyState:
	return null
