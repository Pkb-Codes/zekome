extends "res://scripts/state.gd"

func enter():
	player.velocity = Vector2.ZERO
	print("Entered Idle State")

func physics_update(delta):
	var direction = get_input_direction()

	if direction != Vector2.ZERO:
		state_machine.change_state("MoveState")
		return

	if Input.is_action_just_pressed("Dash") and player.can_dash and direction !=Vector2.ZERO:
		state_machine.change_state("DashState")

func exit():
	print("Exiting Idle State")

func get_input_direction():
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return dir.normalized()
