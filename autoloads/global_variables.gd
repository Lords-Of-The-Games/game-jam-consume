extends Node

enum abilities{JUMP, ATTACK, DASH, INTERACT}

var ability_names : Dictionary = {abilities.JUMP : "Jump", abilities.ATTACK : "Attack", \
abilities.DASH : "Dash", abilities.INTERACT : "Interact"}

var max_ability_uses : Dictionary = {abilities.JUMP : 10, abilities.ATTACK : 10,\
 abilities.DASH : 1, abilities.INTERACT : 1}

var ability_uses : Dictionary = {abilities.JUMP : 10, abilities.ATTACK : 10, \
abilities.DASH : 1, abilities.INTERACT : 1}

var equipped_abilities : Array[abilities] = [abilities.JUMP, abilities.ATTACK, abilities.DASH]
