#script: negative_top
extends Area2D


func _ready():
	connect("body_enter", self, "_on_body_enter")
	pass


func _on_body_enter(other_body):
	if other_body.is_in_group(game.GROUP_BIRDS):
		if game.score_current - 1 == -1:
			var bird = utils.get_main_node().get_node("bird")
			bird.set_state(bird.STATE_GROUNDED)
			game.score_current -= 1
		elif game.score_current - 1 != -1:
			game.score_current -= 1
	pass