extends GameTrigger

@export var triggerable_times : int = 1

func _ready() -> void:
	body_entered.connect(check_for_player)

func check_for_player(body : Node2D) -> void:
	if triggerable_times == 0:
		return
	triggerable_times -= 1
	if body.is_in_group("player"):
		event_triggered.emit()
