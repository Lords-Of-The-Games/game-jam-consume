extends CanvasLayer

@onready var resource_amount_label: Label = $AbilityMenu/Panel/HBoxContainer/DamageMenu/ResourceAmountLabel

var total_resources : int = GlobalVariables.total_resources

func _ready() -> void:
	MessageBus.ability_selected_in_menu.connect(assign_ability)

func assign_ability(which_ability : GlobalVariables.abilities, damaged : bool = false) -> void:
	total_resources -= GlobalVariables.ability_costs[which_ability]
	resource_amount_label.text = str("Resources: ", total_resources)
	
