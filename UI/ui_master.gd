extends CanvasLayer

const ABILITY_BUTTON = preload("res://UI/Menus/ability_button.tscn")


@export var abilityanimators : Array[ability_container]

@onready var play_time: Control = $PlayTime
#@onready var ability_menu: VBoxContainer = $AbilityMenu
@onready var button_parent: VBoxContainer = $AbilityMenu/Panel/HBoxContainer/MarginContainer/ButtonParent
@onready var damage_buttons: VBoxContainer =$AbilityMenu/Panel/HBoxContainer/DamageMenu/VBoxContainer/DamageButtons
@onready var damage_label: Label = $AbilityMenu/Panel/HBoxContainer/DamageMenu/VBoxContainer/DamageLabel
@onready var damage_menu: MarginContainer = $AbilityMenu/Panel/HBoxContainer/DamageMenu
@onready var resource_label: Label = $AbilityMenu/Panel/HBoxContainer/MarginContainer/ButtonParent/ResourceLabel
@onready var message_panel: Panel = $AbilityMenu/Panel/MessagePanel
@onready var message_label: Label = $AbilityMenu/Panel/MessagePanel/MessageLabel

@onready var cursor: Sprite2D = $Cursor

var selection_cooldown : float = 0.35
@onready var ui_selection_timer: Timer = $UI_selection

var selecting_ability : bool = false
var taking_damage : bool = false
var damage_to_resolve : int = 0
#which ability the cursor is on right now
var highlighting_ability : int = 0
var reassigning_ability : GlobalVariables.abilities = GlobalVariables.abilities.JUMP

var menu_open : bool = false
var transitioning : bool = false
var receiving_message : bool = false


func _ready() -> void:
	show()
	call_deferred("late_ready")

func late_ready() -> void:
	MessageBus.ability_used.connect(ability_used)
	MessageBus.took_damage.connect(took_damage)
	MessageBus.opened_menu.connect(change_menu)
	MessageBus.ability_selected_in_menu.connect(assign_ability)
	MessageBus.received_message.connect(receive_message)
	#for child in button_parent.get_children():
		#child.animation_node.wait_for = ability_entrance_animator
	$PlayTime.show()
	$AbilityMenu.hide()
	cursor.hide()
	message_panel.hide()
	message_label.hide()
	#damage_label.hide()
	#damage_buttons.hide()

func _process(_delta: float) -> void:
	if receiving_message:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ability1"):
			if !transitioning:
				acknowledge_message()
				ui_selection_timer.start(selection_cooldown)
		return

	if Input.is_action_just_pressed("open_menu"):
		ui_selection_timer.start(selection_cooldown)
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
		ui_selection_timer.start(selection_cooldown)
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

func assign_ability(which_ability : GlobalVariables.abilities, damaged : bool = false) -> void:
	if !ui_selection_timer.is_stopped():
		return
	if damaged:
		for i in damage_buttons.get_children():
			if i.visible:
				GlobalVariables.ability_uses[i.ability] += 1
				damage_to_resolve += 1
				i.hide()
		update_buttons()
		damage_label.text = str("Damage taken: ", damage_to_resolve)
		return
	if taking_damage:
		resolve_damage(which_ability)
		return
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
	taking_damage = true
	damage_to_resolve = _amount
	Engine.time_scale = 1.0
	get_tree().paused = true	
	update_buttons()

	for i in damage_buttons.get_children():
		i.hide()

	damage_label.text = str("Damage taken: ", _amount)

	$PlayTime.hide()
	$AbilityMenu.show()
	damage_label.show()
	damage_buttons.show()

func resolve_damage(which_ability : GlobalVariables.abilities) -> void:
	if damage_to_resolve <= 0:
		return
	var current_button : AbilityButton = damage_buttons.get_child(damage_to_resolve - 1)
	current_button.show()
	current_button.ability = which_ability
	var target_text = GlobalVariables.ability_names[which_ability]
	current_button.text = target_text
	damage_to_resolve -= 1
	damage_label.text = str("Damage taken: ", damage_to_resolve)
	GlobalVariables.ability_uses[which_ability] -= 1
	update_buttons(false)
	if damage_to_resolve <= 0:
		await get_tree().create_timer(1.0).timeout
		unpause()

func receive_message(original_message : String, new_message : String, delay : float, important : bool = false) -> void:
	pause()
	resource_label.text = str("")
	var child : int = 0
	for ability in GlobalVariables.ability_names.keys():
		var current_button : AbilityButton = button_parent.get_child(child + 1)
		current_button.text = ""
		child += 1
	
	transitioning = true
	receiving_message = true
	message_panel.show()
	await $AbilityMenu/Panel/MessagePanel/Node.finished_entering
	message_label.show()
	message_label.text = original_message
	await get_tree().create_timer(delay).timeout
	message_label.text = new_message
	transitioning = false
	if !important:
		message_panel.hide()
		message_label.hide()
		receiving_message = false
		

func acknowledge_message() -> void:
	receiving_message = false
	message_panel.hide()
	message_label.hide()
	update_buttons_slowly()
	
	
#region opening and closing ability menu
func change_menu () -> void:
	if transitioning or taking_damage:
		return
	
	if menu_open:
		unpause()
		return

	if get_tree().paused:
		return

	slowmo()

func slowmo() -> void:
	transitioning = true
	var tween = self.create_tween()
	tween.set_speed_scale(1.0)
	tween.tween_property(Engine, "time_scale", 0.01, 0.1)
	await tween.finished
	pause()
	update_buttons()

func pause() -> void:
	damage_label.hide()
	for i in damage_buttons.get_children():
		i.hide()
	Engine.time_scale = 1.0
	MessageBus.menu_finished_slowing.emit()
	get_tree().paused = true
	#update_buttons()
	
	$PlayTime.hide()
	$AbilityMenu.show()

	transitioning = false
	menu_open = true 

func unpause() -> void:
	for i in abilityanimators:
		i.refresh()
		
	cursor.hide()
	selecting_ability = false
	transitioning = true
	taking_damage = false
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

func update_buttons_slowly(delay : float = 0.5) -> void:
	menu_open = true
	transitioning = true
	await get_tree().create_timer(delay).timeout
	resource_label.text = str("Humanity:", GlobalVariables.total_resources)
	var child : int = 0
	for ability in GlobalVariables.ability_names.keys():
		await get_tree().create_timer(delay).timeout
		var current_button : AbilityButton = button_parent.get_child(child + 1)
		current_button.mouse_entered.emit()
		current_button.ability = ability
		var target_text = str( GlobalVariables.ability_names[ability], " : ", \
		GlobalVariables.ability_uses[ability], "/", GlobalVariables.max_ability_uses[ability])
		current_button.text = target_text
		child += 1
	
	child = 0
	for ability in GlobalVariables.ability_names.keys():
		var current_button : AbilityButton = button_parent.get_child(child + 1)
		current_button.mouse_exited.emit()
		child += 1
	await get_tree().create_timer(delay).timeout
	button_parent.get_child(1).grab_focus()
	transitioning = false
	
func update_buttons(was_first_button : bool = true) -> void:
	resource_label.text = str("Humanity:", GlobalVariables.total_resources)
	var child : int = 0
	for ability in GlobalVariables.ability_names.keys():
		var current_button : AbilityButton = button_parent.get_child(child + 1)
		current_button.ability = ability
		var target_text = str( GlobalVariables.ability_names[ability], " : ", \
		GlobalVariables.ability_uses[ability], "/", GlobalVariables.max_ability_uses[ability])
		current_button.text = target_text
		child += 1
		if was_first_button:
			current_button.grab_focus()
			was_first_button = false
	
#endregion
	
