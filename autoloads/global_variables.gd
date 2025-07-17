extends Node

enum abilities{NONE, JUMP, ATTACK, DASH, INTERACT, DANCE}


#region Meta game manager
var run_number : int = 1
var total_resources : int = 30
var entrance_number_in_new_scene : int = 0
#endregion

#region Abilities
func add_new_ability(_ability : abilities, _name : String, max_uses : int, cost : int = 1) -> void:
	ability_names[_ability] = _name
	max_ability_uses[_ability] = max_uses
	ability_uses[_ability] = max_uses
	ability_costs[_ability] = cost

var ability_names : Dictionary = {abilities.JUMP : "Jump", abilities.ATTACK : "Attack", \
abilities.DASH : "Dash", abilities.INTERACT : "Interact"}

var max_ability_uses : Dictionary = {abilities.JUMP : 10, abilities.ATTACK : 10,\
 abilities.DASH : 1, abilities.INTERACT : 1}

var ability_uses : Dictionary = {abilities.JUMP : 0, abilities.ATTACK : 0, \
abilities.DASH : 0, abilities.INTERACT : 0}

var ability_costs : Dictionary = {abilities.JUMP : 1, abilities.ATTACK : 1, \
abilities.DASH : 5, abilities.INTERACT : 5}

var equipped_abilities : Array[abilities] = [abilities.JUMP, abilities.ATTACK, abilities.DASH]

func _ready() -> void:
	if run_number == 1:
		for i in ability_uses.keys():
			ability_uses[i] = max_ability_uses[i]
#endregion

#region game utilities
const SAVE_GAME_PATH : String = "user://"
#endregion
