extends "res://scripts/player_states/player_state.gd"

@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2

var dash_direction: Vector2 = Vector2.ZERO
var dash_timer: float = 10.0

func enter():
	
	player.start_dash_cooldown()

	dash_direction = get_input_direction()

	if dash_direction == Vector2.ZERO:
		dash_direction = player.velocity.normalized()


	dash_timer = dash_duration

func physics_update(delta):
	player.velocity = dash_direction * dash_speed
	player.move_and_slide()

	dash_timer -= delta

	if dash_timer <= 0:
		if get_input_direction() == Vector2.ZERO:
			state_machine.change_state("IdleState")
		else:
			state_machine.change_state("MoveState")

func exit():
	player.velocity = Vector2.ZERO
	

func get_input_direction():
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return dir.normalized()
