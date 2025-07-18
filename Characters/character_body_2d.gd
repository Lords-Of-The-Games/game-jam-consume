extends CharacterBody2D

var speed: int = 200
const normal_speed = 200
const jump_speed: int = -400
const dash_speed: int = 1200
const dash_length: float = .05
var current_ability1 : GlobalVariables.abilities
var current_ability2 : GlobalVariables.abilities
var current_ability3 : GlobalVariables.abilities
@onready var interaction_area: Area2D = $InteractionArea
@onready var playerDash = $PlayerDash

func _process(delta: float) -> void:
	velocity.x = 0
	
	if Input.is_action_just_pressed("ability3"):
		dash()
		playerDash.start_dash(dash_length)
	speed = dash_speed if playerDash.is_dashing() else normal_speed
	
	if Input.is_action_pressed("ui_right"):
		walk(true)
	elif Input.is_action_pressed("ui_left"):
		walk(false)
	else:
		# Only play idle if no special animation is active
		if not $PlayerSprite.is_playing() or $PlayerSprite.animation == "walk":
			$PlayerSprite.play("idle")
	
	if Input.is_action_just_pressed("ability1"):
		jump()
		
	if Input.is_action_just_pressed("ability2"):
		attack()
		
	if Input.is_action_just_pressed("ability3"):
		dash()

	move_and_slide()
	velocity += get_gravity() * delta

func jump() -> void:
	velocity.y = jump_speed
	$PlayerSprite.play("jump")
	MessageBus.ability_used.emit(GlobalVariables.abilities.JUMP)

func attack() -> void:
	$PlayerSprite.play("damage")
	MessageBus.ability_used.emit(GlobalVariables.abilities.ATTACK)

func dash() -> void:
	MessageBus.ability_used.emit(GlobalVariables.abilities.DASH)

func interact() -> void:
	MessageBus.ability_used.emit(GlobalVariables.abilities.INTERACT)

func walk(is_direction_right: bool) -> void:
	var direction = 1 if is_direction_right else -1
	velocity.x = speed * direction
	$PlayerSprite.flip_h = !is_direction_right
	if not $PlayerSprite.animation == "dash":
		$PlayerSprite.play("walk")
	
