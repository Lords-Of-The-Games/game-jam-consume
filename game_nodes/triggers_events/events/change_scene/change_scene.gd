extends GameEvent

@export var new_scene : String
@export var entrance_number : int = 0

func activate() -> void:
	GlobalVariables.entrance_number_in_new_scene = entrance_number
	SceneLoader.load_scene(new_scene)
