extends GameTrigger

var active_enemies : int = 0
var enemies : Dictionary[Node2D, int]
func _ready() -> void:
	for i in get_overlapping_bodies():
		add_enemy(i)
	body_entered.connect(add_enemy)

func remove_body(body : Node2D) -> void:
	print_debug("received death signal")
	enemies.erase(body)
	if enemies.size() == 0:
		event_triggered.emit()

func add_enemy(body : Node2D) -> void:
	if body.is_in_group("enemy"):
		if !enemies.has(body):
			enemies[body] = 0
			body.death.connect(remove_body)
