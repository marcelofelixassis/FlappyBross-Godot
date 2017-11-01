# script: bird

extends RigidBody2D

# set_linear_velocity => 'move o bird para frente'
func _ready():
	set_linear_velocity(Vector2(50, get_linear_velocity().y))
	set_process_input(true)
	set_fixed_process(true)
	pass

# rad2deg => 'vir ao bird 30 graus para o norte'
# set_angular_velocity => 'força o bird para girar para o sul'
func _fixed_process(delta):
	if rad2deg(get_rot()) > 30:
		set_rot(deg2rad(30))
		set_angular_velocity(0)
	
	if get_linear_velocity().y > 0:
		set_angular_velocity(1.5)
	pass

# func set_linear_velocity => 'impulsionar o bird para cima'
# set_angular_velocity => 'faz com que o bird gire'
func flap():
	set_linear_velocity(Vector2(get_linear_velocity().x, -150))
	set_angular_velocity(-3)
	pass

# event.is_action_pressed => 'utiliza as teclas definidas(space, F) para executar [func flap()]'
func _input(event):
	if event.is_action_pressed("flap"):
		flap()
	pass