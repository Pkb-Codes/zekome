extends CharacterBody2D

enum State { IDLE, PATROL, ATTACK }

var state = State.IDLE

@export var speed = 120
@export var patrol_radius = 200
@export var idle_duration = 2.0

var player: Node2D = null
var player_detected = false

var start_position: Vector2
var patrol_target: Vector2

var idle_timer = 0.0
var attack_direction = Vector2.ZERO


func _ready():
	start_position = global_position
	choose_new_patrol_point()


func _physics_process(delta):

	match state:
		State.IDLE:
			idle_state(delta)

		State.PATROL:
			patrol_state()

		State.ATTACK:
			attack_state()

	# Flip sprite based on movement
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x < 0

	move_and_slide()

func idle_state(delta):

	velocity = Vector2.ZERO
	idle_timer += delta

	if player_detected:
		state = State.ATTACK
		idle_timer = 0
		return

	if idle_timer > idle_duration:
		choose_new_patrol_point()
		state = State.PATROL
		idle_timer = 0


func patrol_state():

	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed

	if global_position.distance_to(patrol_target) < 10:
		state = State.IDLE

	if player_detected:
		state = State.ATTACK


func attack_state():

	if player == null:
		state = State.IDLE
		attack_direction = Vector2.ZERO
		return

	if attack_direction == Vector2.ZERO:
		attack_direction = (player.global_position - global_position).normalized()

	velocity = attack_direction * speed * 1.4

	if is_on_wall():
		state = State.IDLE
		attack_direction = Vector2.ZERO

	if not player_detected:
		choose_new_patrol_point()
		state = State.PATROL
		attack_direction = Vector2.ZERO



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
		player = null
