extends interactable

func _ready() -> void:
	interacted.connect(play_animation)
	super()

func late_ready() -> void:
	super()
	if saved_resource.interacted > 0:
		interacted.emit()

func play_animation() -> void:
	$AnimationPlayer.play("interacted")

func interact() -> void:
	super()
	saved_resource.interacted = true
	save()
