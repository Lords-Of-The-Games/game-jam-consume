extends EnemyState

@export var speed : float = 500
##how quickly the enemy turns. At 60 it should be almost instant
@export var responsiveness : float = 30.0
@export var cooldown : float = 2.5

@onready var attack_area: Area2D = $"../../AttackArea"
@onready var timer: Timer = $Timer

var player : Node2D
var acquired_target : bool = false
var tranisition_on_cooldown : bool = false

func _ready() -> void:
	attack_area.body_entered.connect(check_for_player)

func enter() -> void:
	super()
	acquired_target = false
	player = get_tree().get_first_node_in_group("player") 
	timer.start(cooldown)
	tranisition_on_cooldown = false

func process_physics(delta: float, _direction : Vector2) -> EnemyState:
	if acquired_target:
		if !parent.is_on_floor():
			parent.velocity += parent.get_gravity() * delta
			parent.move_and_slide()
		return null
		
	if timer.is_stopped():
		if tranisition_on_cooldown:
			transition_to_attack()
			return null

	var target_velocity : float = speed
	target_velocity *= sign(player.global_position.x - parent.global_position.x)
	target_velocity = lerp(_direction.x,target_velocity, delta * responsiveness)
	if target_velocity > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

	parent.velocity.x = target_velocity
	
	if !parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()
	return null

func check_for_player(body : Node2D) -> void:
	if body.is_in_group("player"):
		if !timer.is_stopped():
			tranisition_on_cooldown = true
			return
		transition_to_attack()
func transition_to_attack() -> void:
	acquired_target = true
	animated_sprite_2d.play("windup")
	await animated_sprite_2d.animation_finished
	acquired_target = false
	if state_active:
		state_machine.change_state(states["attacking"])
