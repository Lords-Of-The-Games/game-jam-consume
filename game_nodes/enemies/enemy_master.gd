extends CharacterBody2D
class_name Enemy

signal death(body)

@export var saved_data : SavedDataResource
@export var max_hp : int = 3
@export var sprite : AnimatedSprite2D
@export var state_machine : EnemyStateMachine
@export var resist_stagger : bool = false

@onready var hp_bar: Label = $Label

var current_hp : int = max_hp

func _ready() -> void:
	current_hp = saved_data.hp
	if !saved_data.spawn:
		sprite.play("dead")
		state_machine.starting_state = state_machine.states["dead"]
		state_machine.current_state = state_machine.states["dead"]
	
	state_machine.initialize(self)

func die() -> void:
	death.emit(self)
	print_debug("emitted death")
	save()

func save() -> void:
	saved_data.hp = current_hp
	if state_machine.current_state == state_machine.states["dead"]:
		saved_data.spawn = false
	ResourceSaver.save(saved_data, GlobalVariables.SAVE_GAME_PATH)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta, velocity)

func take_damage(amount : int, player_position : Vector2) -> void:
	current_hp -= amount
	hp_bar.text = str(current_hp)
	if current_hp <= 0:
		state_machine.change_state(state_machine.states["dead"])
		return
	if !resist_stagger:
		state_machine.billboard["stagger_direction"] = (global_position - player_position).normalized()
		state_machine.change_state(state_machine.states["staggering"])
	save()
