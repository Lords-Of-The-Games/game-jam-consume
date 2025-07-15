extends EnemyState

@onready var chase_box: Area2D = $"../../ChaseBox"
func _ready() -> void:
	super()
	chase_box.body_entered.connect(start_chase)

func process_physics(_delta: float, _direction : Vector2) -> EnemyState:
	if !parent.is_on_floor():
		parent.velocity += parent.get_gravity() * _delta
		parent.move_and_slide()
	return null

func start_chase(body : Node2D) -> void:
	if body.is_in_group("player") and state_active:
		state_machine.change_state(state_machine.states["chasing"])
