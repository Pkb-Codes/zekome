extends "res://scripts/player_states/player_state.gd"

@export var speed: float = 200.0

func enter():
	pass

func physics_update(delta):
	var direction = get_input_direction()
	if direction == Vector2.ZERO:
		state_machine.change_state("IdleState")
		return
	
	if Input.is_action_just_pressed("Dash") and player.can_dash and direction!=Vector2.ZERO:
		player.dash_direction=direction.normalized()
		state_machine.change_state("DashState")
		return
	
	player.velocity = direction * speed
	player.move_and_slide()

func exit():
	pass

func get_input_direction():
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return dir.normalized()
