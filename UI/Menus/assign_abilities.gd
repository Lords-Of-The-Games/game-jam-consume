extends CanvasLayer

@export_file("*.tscn") var game_scene_path : String
@onready var resource_amount_label: Label = $AbilityMenu/Panel/HBoxContainer/DamageMenu/ResourceAmountLabel
@onready var button_parent: VBoxContainer = $AbilityMenu/Panel/HBoxContainer/MarginContainer/ButtonParent

var total_resources : int = GlobalVariables.total_resources

func _ready() -> void:
	MessageBus.ability_selected_in_menu.connect(assign_ability)
	for i in GlobalVariables.ability_uses.keys():
		GlobalVariables.ability_uses[i] = 0
	update_buttons()

func update_buttons(was_first_button : bool = true) -> void:
	resource_amount_label.text = str("Humanity: ", total_resources)
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

func assign_ability(which_ability : GlobalVariables.abilities, _damaged : bool = false) -> void:
	if GlobalVariables.ability_uses[which_ability] >= GlobalVariables.max_ability_uses[which_ability]:
		return
	
	GlobalVariables.ability_uses[which_ability] += 1
	total_resources -= GlobalVariables.ability_costs[which_ability]
	resource_amount_label.text = str("Humanity: ", total_resources)
	update_buttons(false)
	if total_resources <= 0:
		SceneLoader.load_scene(game_scene_path)
	var maxed_out : bool = true
	for i in GlobalVariables.ability_uses.keys():
		if GlobalVariables.ability_uses[i] < GlobalVariables.max_ability_uses[i]:
			maxed_out = false
	if maxed_out:
		SceneLoader.load_scene(game_scene_path)
		
	
