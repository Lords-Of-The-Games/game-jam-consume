extends CanvasLayer

const ABILITY_BUTTON = preload("res://UI/Menus/ability_button.tscn")

@export var abilityanimators : Array[ability_container]

@onready var play_time: Control = $PlayTime
#@onready var ability_menu: VBoxContainer = $AbilityMenu
@onready var button_parent: VBoxContainer = $AbilityMenu/Panel/MarginContainer/ButtonParent
@onready var cursor: Sprite2D = $Cursor

var selection_cooldown : float = 0.35
@onready var ui_selection_timer: Timer = $UI_selection

var selecting_ability : bool = false
#which ability the cursor is on right now
var highlighting_ability : int = 0
var reassigning_ability : GlobalVariables.abilities = GlobalVariables.abilities.JUMP

var menu_open : bool = false
var transitioning : bool = false


func _ready() -> void:
	call_deferred("late_ready")

func late_ready() -> void:
	MessageBus.ability_used.connect(ability_used)
	MessageBus.took_damage.connect(took_damage)
	MessageBus.opened_menu.connect(change_menu)
	MessageBus.ability_selected_in_menu.connect(assign_ability)
	#for child in button_parent.get_children():
		#child.animation_node.wait_for = ability_entrance_animator
	$PlayTime.show()
	$AbilityMenu.hide()
	cursor.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		MessageBus.opened_menu.emit()
	if !selecting_ability:
		return


	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_focus_next"):
		focus_next(1, true)
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_focus_next"):
		focus_next(1)

	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_focus_prev"):
		focus_next(-1, true)
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_focus_prev"):
		focus_next(-1)
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ability1"):
		set_ability()


func set_ability() -> void:
	selecting_ability = false
	GlobalVariables.equipped_abilities[highlighting_ability] = reassigning_ability
	abilityanimators[highlighting_ability].refresh()
	await get_tree().create_timer(0.25).timeout
	cursor.hide()
	$PlayTime.hide()
	$AbilityMenu.show()
	button_parent.get_child(0).grab_focus()
	

func ability_used(which_ability : GlobalVariables.abilities) -> void:
	GlobalVariables.ability_uses[which_ability] -= 1
	if which_ability ==	GlobalVariables.equipped_abilities[0]:
		abilityanimators[0].refresh()

	if which_ability ==	GlobalVariables.equipped_abilities[1]:
		abilityanimators[1].refresh()

	if which_ability ==	GlobalVariables.equipped_abilities[2]:
		abilityanimators[2].refresh()

func assign_ability(which_ability : GlobalVariables.abilities) -> void:
	reassigning_ability = which_ability
	$PlayTime.show()
	$AbilityMenu.hide()
	cursor.show()
	highlighting_ability = 0
	selecting_ability = true
	cursor.global_position = abilityanimators[highlighting_ability].global_position

func focus_next(next_ability : int = 1, override : bool = false) -> void:
	if !ui_selection_timer.is_stopped() and !override:
		return
	highlighting_ability = (highlighting_ability + next_ability) % abilityanimators.size()
	cursor.global_position = abilityanimators[highlighting_ability].global_position
	ui_selection_timer.start(selection_cooldown)
	

func took_damage(_amount) -> void:
	get_tree().paused = true
	play_time.hide()
	#ability_menu.populate()
	#ability_menu.show()

#region opening and closing ability menu
func change_menu () -> void:
	if transitioning:
		return
	
	if menu_open:
		unpause()
		return

	slowmo()

func slowmo() -> void:
	transitioning = true
	var tween = self.create_tween()
	tween.set_speed_scale(1.0)
	tween.tween_property(Engine, "time_scale", 0.01, 0.1)
	await tween.finished
	pause()

func pause() -> void:
	Engine.time_scale = 1.0
	MessageBus.menu_finished_slowing.emit()
	get_tree().paused = true
	var was_first_button : bool = true
	var child : int = 0
	for ability in GlobalVariables.ability_names.keys():
		var current_button : AbilityButton = button_parent.get_child(child)
		current_button.ability = ability
		var target_text = str( GlobalVariables.ability_names[ability], " : ", \
		GlobalVariables.ability_uses[ability], "/", GlobalVariables.max_ability_uses[ability])
		current_button.text = target_text
		child += 1
		if was_first_button:
			current_button.grab_focus()
			was_first_button = false
	
	$PlayTime.hide()
	$AbilityMenu.show()

	transitioning = false
	menu_open = true

func unpause() -> void:
	cursor.hide()
	selecting_ability = false
	transitioning = true
	$PlayTime.show()
	$AbilityMenu.hide()
	get_tree().paused = false
	var tween = self.create_tween()
	tween.set_speed_scale(1.0)
	Engine.time_scale = 0.1
	tween.tween_property(Engine, "time_scale", 1.0, 0.025)
	await tween.finished
	menu_open = false
	transitioning = false
#endregion
	
