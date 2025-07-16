extends Node
class_name EnemyStateMachine

@export var starting_state : EnemyState
@export var animated_sprite_2d: AnimatedSprite2D 
@export var states : Dictionary[String, EnemyState]
var billboard : Dictionary

#region state_machine
var current_state : EnemyState
var parent : Node2D
#endregion

func initialize(_parent : Node2D) -> void:
	parent = _parent
	# Initialize to the default state
	for i in get_children():
		i.parent = parent
		i.state_machine = self
		i.animated_sprite_2d = animated_sprite_2d
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: EnemyState) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float, direction : Vector2) -> void:
	#print_debug(current_state)
	if !current_state:
		return
	var new_state = current_state.process_physics(delta, direction)
	if new_state:
		change_state(new_state)
