extends TextureRect

@export var modulate_color : Color

func _ready() -> void:
	modulate = modulate_color
