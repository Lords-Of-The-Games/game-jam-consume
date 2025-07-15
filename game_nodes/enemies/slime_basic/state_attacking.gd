extends EnemyState

@export var attack_speed : float = 1000

var vector_looking_at_position : Vector2 
var player : Node2D

func enter() -> void:
	super()
	animated_sprite_2d.animation_finished.connect(back_to_chase)
	player = get_tree().get_first_node_in_group("player") 
	vector_looking_at_position = (player.global_position - parent.global_position).normalized()

func exit() -> void:
	super()
	animated_sprite_2d.animation_finished.disconnect(back_to_chase)

func process_physics(_delta: float, _direction : Vector2) -> EnemyState:
	parent.velocity = vector_looking_at_position * attack_speed
	parent.move_and_slide()
	return null


func back_to_chase() -> void:
	if state_active:
		state_machine.change_state(states["chasing"])
