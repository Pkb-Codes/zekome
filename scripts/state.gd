extends CharacterBody2D

enum State { IDLE, PATROL, ATTACK }

var state = State.IDLE

@export var speed = 120
@export var patrol_radius = 200

var player: Node2D = null
var player_detected = false

var start_position: Vector2
var patrol_target: Vector2


func _ready():
	start_position = global_position
	choose_new_patrol_point()


func _physics_process(delta):

	match state:
		State.IDLE:
			idle_state()

		State.PATROL:
			patrol_state()

		State.ATTACK:
			attack_state()

	move_and_slide()


func idle_state():

	velocity = Vector2.ZERO

	if player_detected:
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

	if player_detected:
		state = State.ATTACK


func attack_state():

	if player == null:
		state = State.IDLE
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * 1.4

	if not player_detected:
		choose_new_patrol_point()
		state = State.PATROL


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
