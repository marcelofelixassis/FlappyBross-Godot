# script: bird

extends RigidBody2D

onready var state = FlyingState.new(self)

var speed = 50

const STATE_FLAYING = 0
const STATE_FLAPPING = 1
const STATE_HIT = 2
const STATE_GROUNDED = 3

signal state_changed

# set_linear_velocity => 'move o bird para frente'
func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
	add_to_group(game.GROUP_BIRDS)
	connect("body_enter", self, "_on_body_enter")
	pass

# rad2deg => 'vir ao bird 30 graus para o norte'
# set_angular_velocity => 'força o bird para girar para o sul'
func _fixed_process(delta):
	state.update(delta)
	pass

# event.is_action_pressed => 'utiliza as teclas definidas(space, F) para executar [func flap()]'
func _input(event):
	state.input(event)
	pass

func _on_body_enter(other_body):
	if state.has_method("on_body_enter"):
		state.on_body_enter(other_body)
	pass

func set_state(new_state):
	state.exit()
	
	if new_state == STATE_FLAYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)
	
	emit_signal("state_changed", self)
	pass

func get_state():
	if state extends FlyingState:
		return STATE_FLAYING
	elif state extends FlappingState:
		return STATE_FLAPPING
	elif state extends HitState:
		return STATE_HIT
	elif state extends GroundedState:
		return STATE_GROUNDED
	pass

# clas FlyingState ----------------------------------------------------------------------------------------------------

class FlyingState:
	var bird
	var prev_gravit_state
	
	func _init(bird):
		self.bird = bird
		bird.get_node("anim").play("flying")
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		
		prev_gravit_state = bird.get_gravity_scale()
		bird.set_gravity_scale(0)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		bird.set_gravity_scale(prev_gravit_state)
		bird.get_node("anim").stop()
		bird.get_node("anim_sprite").set_pos(Vector2(0, 0))
		pass

# clas FlappingState ----------------------------------------------------------------------------------------------------

class FlappingState:
	var bird
	
	func _init(bird):
		self.bird = bird
		
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		flap()
		pass
	
	
	func update(delta):
		if rad2deg(bird.get_rot()) > 30:
			bird.set_rot(deg2rad(30))
			bird.set_angular_velocity(0)
	
		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(1.5)
		pass
	
	
	func input(event):
		if event.is_action_pressed("flap"):
			flap()
		pass
	
	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUP_MISSILS):
			bird.set_state(bird.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		pass
	
	# func set_linear_velocity => 'impulsionar o bird para cima'
	# set_angular_velocity => 'faz com que o bird gire'
	
	
	func flap():
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -150))
		bird.set_angular_velocity(-3)
		bird.get_node("anim").play("flap")
		pass
	
	
	func exit():
		pass

# clas HitState ----------------------------------------------------------------------------------------------------

class HitState:
	var bird
	
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(2)
		
		var other_body = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(other_body)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		pass
	
	func exit():
		pass

# clas GroundedState ----------------------------------------------------------------------------------------------------

class GroundedState:
	var bird
	
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(0)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass