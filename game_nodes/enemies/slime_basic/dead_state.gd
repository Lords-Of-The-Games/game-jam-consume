extends EnemyState

func enter() -> void:
	super()
	animated_sprite_2d.animation_finished.connect(play_dead)

func play_dead() -> void:
	animated_sprite_2d.play("dead")
	parent.die()

func process_physics(_delta: float, _direction : Vector2) -> EnemyState:
	if !parent.is_on_floor():
		parent.velocity += parent.get_gravity() * _delta
		parent.move_and_slide()
	return null
