extends CharacterBody2D

enum State { IDLE, PATROL, ATTACK, REPOSITION }

var state = State.IDLE

@export var speed = 120
@export var patrol_radius = 200
@onready var debug: Label = $debug

var player: Node2D = null
var player_detected = false

var start_position: Vector2
var patrol_target: Vector2

var dash_direction: Vector2 = Vector2.ZERO
var dash_timer = 0.0
var dash_duration = 0.3
var windup_time = 1
var is_winding_up = true

var attack_cooldown = 1.5
var cooldown_timer = 0.0

func _ready():
	start_position = global_position
	choose_new_patrol_point()

func _physics_process(delta):

	if cooldown_timer > 0:
		cooldown_timer -= delta

	match state:
		State.IDLE:
			idle_state()

		State.PATROL:
			patrol_state()

		State.ATTACK:
			attack_state(delta)
		
		State.REPOSITION:
			reposition_state()

	debug.text = State.keys()[state]
	move_and_slide()

func idle_state():

	velocity = Vector2.ZERO

	if player_detected and cooldown_timer <= 0:
		state = State.ATTACK
		return

	if randf() < 0.01:
		choose_new_patrol_point()
		state = State.PATROL

func patrol_state():

	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed

	if global_position.distance_to(patrol_target) < 10:
		state = State.IDLE

	if player_detected and cooldown_timer <= 0:
		state = State.ATTACK

func attack_state(delta):

	if player == null:
		state = State.IDLE
		return

	if is_winding_up:

		velocity = Vector2.ZERO
		windup_time -= delta

		if windup_time <= 0:
			is_winding_up = false
			dash_timer = dash_duration
			dash_direction = (player.global_position - global_position).normalized()

		return

	if dash_timer > 0:

		velocity = dash_direction * speed * 4
		dash_timer -= delta

	else:
		reset_attack()

func reset_attack():

	is_winding_up = true
	windup_time = 1
	dash_timer = 0

	cooldown_timer = attack_cooldown
	
	choose_new_reposition_target()
	state = State.REPOSITION

func reposition_state():

	if player == null:
		state = State.IDLE
		return

	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed

	if(global_position.distance_to(patrol_target) < 10):
		state = State.ATTACK
	
func choose_new_reposition_target():
	var player_detection_radius = 100 #player_detection_radius = scale of playerDetection node * 100
	var offset_distance = randf_range(50, player_detection_radius)
	var offset_angle = set_reposition_angle()
	
	var offset = offset_distance*Vector2(cos(offset_angle),sin(offset_angle))
	patrol_target = player.global_position + offset
	
func set_reposition_angle():
	# Direction from player to enemy
	var base_direction = (global_position - player.global_position).normalized()
	var base_angle = base_direction.angle()

	# Limit angle variation (prevents crossing through player)
	var angle_offset = randf_range(-PI/2, PI/2)
	return base_angle + angle_offset
	
func choose_new_patrol_point():

	var offset = Vector2(
		randf_range(-patrol_radius, patrol_radius),
		randf_range(-patrol_radius, patrol_radius)
	)

	patrol_target = start_position + offset

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_detected = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player_detected = false
