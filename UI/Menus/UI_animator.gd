class_name AnimationComponent extends Node

signal  finished_entering
@export var report : bool = false
@export var connect_as_button : bool = false
@export var entrance_animation : bool = false
@export var wait_for : AnimationComponent
@export_group("Hover Settings")
@export var hover_size : Vector2 = Vector2(0,0)
@export var hover_scale : Vector2 = Vector2(0.0, 0.0)
@export var hover_position : Vector2 = Vector2(0,0)
@export var hover_rotation : float = 0.0
@export var hover_modulate : Color = Color.WHITE
@export var hover_time : float = 0.1
@export var hover_delay : float = 0.0
@export var hover_transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@export_group("Deemphasize Settings")
@export var deepmhasize_size : Vector2 = Vector2(0,0)
@export var deepmhasize_scale : Vector2 = Vector2(0.0, 0.0)
@export var deepmhasize_position : Vector2 = Vector2(0,0)
@export var deepmhasize_rotation : float = 0.0
@export var deepmhasize_modulate : Color = Color.WHITE
@export var deepmhasize_time : float = 0.1
@export var deepmhasize_delay : float = 0.0

@export_group("Entrance Settings")
@export var random_entrance : bool = false
@export var entrance_size : Vector2 = Vector2(0,0)
@export var entrance_scale : Vector2 = Vector2(0.0, 0.0)
@export var entrance_position : Vector2 = Vector2(0,0)
@export var entrance_rotation : float = 0.0
@export var entrance_modulate : Color = Color.WHITE
@export var entrance_time : float = 0.1
@export var entrance_delay : float = 0.2
@export var entrance_transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@export_group("Exit Settings")
@export var exit_size : Vector2 = Vector2(0,0)
@export var exit_scale : Vector2 = Vector2(0.0, 0.0)
@export var exit_position : Vector2 = Vector2(0,0)
@export var exit_rotation : float = 0.0
@export var exit_modulate : Color = Color.WHITE
@export var exit_time : float = 0.2
@export var exit_delay : float = 0
@export var exit_transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@export_group("Advanced options")
@export var hover_easing : Tween.EaseType
@export var from_center : bool = true
@export var properties : Array[String] = ["scale", "position", "rotation", "size", "self_modulate"]
@export var parallel_animations : bool = true

@onready var timer: Timer = $Timer
var rng = RandomNumberGenerator.new()
var target : Control
var default_scale : Vector2
var hover_values : Dictionary
var default_values : Dictionary
var deemphasize_values : Dictionary
var entrance_values : Dictionary
var exit_values : Dictionary
var finished_setting = false
const IMMEDIATE_TRANSITION = Tween.TRANS_LINEAR

func _ready() -> void:
	rng.randomize()
	target = get_parent()
	call_deferred("setup")
	if connect_as_button:
		target.focus_entered.connect(on_hover)
		target.mouse_entered.connect(on_hover)
		target.focus_exited.connect(off_hover)
		target.mouse_exited.connect(on_hover)
	if wait_for:
		wait_for.finished_entering.connect(on_enter_deferred)
func setup() -> void:
	timer.start(0.05)
	await timer.timeout
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	default_values = {"scale" : target.scale, "position" : target.position, "rotation" : target.rotation, "size" : target.size, "self_modulate" : target.modulate}
	hover_values = {"scale" : target.scale + hover_scale, 
			"position" : target.position + hover_position, 
			"rotation" : target.rotation + hover_rotation, 
			"size" : target.size +  hover_size, 
			"self_modulate" : hover_modulate
	}
	deemphasize_values = {"scale" : target.scale + deepmhasize_scale, 
		"position" : target.position + deepmhasize_position, 
		"rotation" : target.rotation + deepmhasize_rotation, 
		"size" : target.size +  deepmhasize_size, 
		"self_modulate" : deepmhasize_modulate
	}
	entrance_values = {"scale" : entrance_scale, 
		"position" : target.position + target.size/2, 
		"rotation" : target.rotation + entrance_rotation, 
		"size" : entrance_size, 
		"self_modulate" : entrance_modulate
	}
	exit_values = {"scale" : entrance_scale, 
		"position" : target.position + entrance_position, 
		"rotation" : target.rotation + entrance_rotation, 
		"size" : target.size +  entrance_size, 
		"self_modulate" : entrance_modulate
	}
	target.visibility_changed.connect(on_enter_deferred)
	finished_setting = true
		
func on_enter_deferred(finished_waiting : bool = false):
	call_deferred("on_enter",finished_waiting)
func on_enter(finished_waiting : bool = false) -> void:
	var actual_entrance_time = entrance_time
	var actual_entrance_delay = entrance_delay
	if random_entrance:
		actual_entrance_delay = rng.randf() * entrance_delay/2 + rng.randf() * entrance_delay/2
		actual_entrance_time = rng.randf() * entrance_time/2 + rng.randf() *entrance_time/2
	if !target.visible:
		return
	if !entrance_animation:
		finished_entering.emit(true)
		return
	
	if wait_for:
		if !finished_waiting:
			add_tween(entrance_values, true, 0.0, IMMEDIATE_TRANSITION, hover_easing, 0.0)
		else:
			timer.start(actual_entrance_delay)
			await timer.timeout
			add_tween(default_values, parallel_animations, actual_entrance_time, entrance_transition, hover_easing, 0.0, true)
	else:
		add_tween(entrance_values, true, 0.0, IMMEDIATE_TRANSITION, hover_easing, 0.0)
		
		timer.start(actual_entrance_delay)
		await timer.timeout
		add_tween(default_values, parallel_animations, actual_entrance_time, entrance_transition, hover_easing, 0.0, true)

func exit():
	var tween = self.create_tween()
	tween.set_parallel(parallel_animations)
	tween.pause()
	
	for property in properties:
		tween.tween_property(target, property, exit_values[property], exit_time).set_trans(exit_transition).set_ease(hover_easing)
	if get_tree() != null:
		timer.start(exit_delay)
		await timer.timeout
		tween.play()
		await tween.finished
		target.hide()
func on_hover() -> void:
	add_tween(hover_values, parallel_animations, hover_time, hover_transition, hover_easing, hover_delay)
func off_hover() -> void:
	add_tween(default_values, parallel_animations, hover_time, hover_transition, hover_easing, hover_delay)
	
func blip() -> void:
	if hover_rotation == 0.0:
		return
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(target,"rotation",default_values["rotation"],hover_time).set_trans(hover_transition).set_ease(hover_easing )
	if hover_modulate == Color.WHITE:
		return
	tween.tween_property(target,"self_modulate",default_values["self_modulate"],hover_time).set_trans(hover_transition).set_ease(hover_easing )
func deemphasize():
	add_tween(deemphasize_values, parallel_animations, deepmhasize_time, hover_transition, hover_easing, deepmhasize_delay)


func add_tween(values : Dictionary, parallel : bool, seconds : float, transition : Tween.TransitionType, easing : Tween.EaseType, delay : float, entering : bool = false) -> void:
	if !finished_setting:
		return
	var tween = self.create_tween()
	tween.set_parallel(parallel)
	tween.pause()
	for property in properties:
		tween.tween_property(target, property, values[property], seconds).set_trans(transition).set_ease(easing)
	if !entering:
		tween.tween_callback(blip)
	if !is_inside_tree():
		return
	if get_tree() != null:
		timer.start(delay)
		await timer.timeout
		tween.play()
	if entering: 
		await tween.finished
		finished_entering.emit(true)
	
