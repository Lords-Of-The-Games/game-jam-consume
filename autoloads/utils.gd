extends Node

func start_dialog(timeline : String) ->void:
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	Dialogic.start(timeline).process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.timeline_ended.connect(func():get_tree().set('paused', false))
