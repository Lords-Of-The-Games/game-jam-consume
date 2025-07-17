extends StaticBody2D
class_name interactable

signal interacted

@export var saved_resource : SavedDataResource
@onready var interact_label: Label = $Interact
@onready var grayed_out: Label = $GrayedOut
var interaction_disabled : bool = false

func _ready() -> void:
	call_deferred("late_ready")

func late_ready() -> void:
	if !saved_resource.spawn:
		queue_free()
	interaction_disabled = saved_resource.interaction_disabled
	interact_label.hide()
	grayed_out.hide()

func show_interaction() -> void:
	if interaction_disabled:
		return

	if GlobalVariables.ability_uses[GlobalVariables.abilities.INTERACT] > 0:
		interact_label.show()
		grayed_out.hide()
		return
	grayed_out.show()
	interact_label.hide()

func hide_interaction() -> void:
	interact_label.hide()
	grayed_out.hide()

func interact() -> void:
	if GlobalVariables.ability_uses[GlobalVariables.abilities.INTERACT] <= 0:
		return
	if interaction_disabled:
		return
	GlobalVariables.ability_uses[GlobalVariables.abilities.INTERACT] -= 1
	interacted.emit()

func save() -> void:
	ResourceSaver.save(saved_resource)
