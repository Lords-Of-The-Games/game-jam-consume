extends CharacterBody2D

@export var speed : float = 50
var target_direction : Vector2
var wait_before_destruction : float = 3.0
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	hitbox.dealt_damage.connect(queue_free)



func _physics_process(delta: float) -> void:
	velocity = target_direction.normalized() * speed
	move_and_slide()
	wait_before_destruction -= delta
	if wait_before_destruction <= 0:
		queue_free()
