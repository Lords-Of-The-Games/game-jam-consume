extends GameEvent

@export var animation_player : AnimationPlayer
@export var interactables : Array[interactable] 

func _ready() -> void:
	for triggering_event : GameTrigger in triggers:
		triggering_event.event_triggered.connect(activate)
	
	for triggering_event : interactable in interactables:
		triggering_event.interacted.connect(activate)
	

func activate() -> void:
	animation_player.play("move")
