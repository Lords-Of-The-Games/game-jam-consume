extends EnemyState

@export var stagger_speed : float = 10.0
@export var stagger_duration : float = 0.5
var staggered_for = 0.0

func enter() -> void:
	super()
	staggered_for = 0.0

func process_physics(_delta: float, _direction : Vector2) -> EnemyState:
	parent.velocity = stagger_speed * state_machine.billboard["stagger_direction"]
	parent.move_and_slide()
	staggered_for += _delta
	if staggered_for >= stagger_duration:
		return states["chasing"]
	return null
