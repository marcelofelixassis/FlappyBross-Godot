extends Camera2D

onready var bird = get_node("../bird")

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	set_pos(Vector2(bird.get_pos().x, get_pos().y))
	pass
