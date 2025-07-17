extends EnemyState

const MISSILE = preload("res://game_nodes/enemies/vulture/missile.tscn")

var vector_looking_at_position : Vector2 
var player : Node2D

func enter() -> void:
	super()
	var new_missile = MISSILE.instantiate()
	animated_sprite_2d.animation_finished.connect(back_to_chase)
	player = get_tree().get_first_node_in_group("player") 
	vector_looking_at_position = (player.global_position - parent.global_position).normalized()
	parent.add_child(new_missile)
	new_missile.target_direction = vector_looking_at_position
	new_missile.global_position = parent.global_position
	

func exit() -> void:
	super()
	animated_sprite_2d.animation_finished.disconnect(back_to_chase)

func process_physics(_delta: float, _direction : Vector2) -> EnemyState:
	return null


func back_to_chase() -> void:
	if state_active:
		state_machine.change_state(states["chasing"])
