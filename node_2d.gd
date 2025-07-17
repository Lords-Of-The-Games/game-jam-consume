extends GameTrigger

@export var saved_resource : SavedDataResource

func _ready() -> void:
	if saved_resource.interacted > 0:
		event_triggered.emit()
