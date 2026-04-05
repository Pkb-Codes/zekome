extends CharacterBody2D

# Define possible enemy states
enum State { IDLE, PATROL, ATTACK, REPOSITION }

# Current state
var state = State.IDLE

# Movement and patrol settings
@export var speed = 120
@export var patrol_radius = 200
@export var player_detection_radius = 200 # Should match detection area scale
# Debug label to display current state
@onready var debug: Label = $debug

# Player tracking
var player: Node2D = null
var player_detected = false

# Positions
var start_position: Vector2           # Initial spawn position
var patrol_target: Vector2            # Current movement target

# Dash (attack) variables
var dash_direction: Vector2 = Vector2.ZERO
var dash_timer = 0.0
@export var dash_duration = 0.3

# Windup before dash attack
var windup_time = 1
var is_winding_up = true

# Attack cooldown
var attack_cooldown = 1.5
var cooldown_timer = 0.0

func _ready():
	# Store initial position and pick first patrol point
	start_position = global_position
	choose_new_patrol_point()

func _physics_process(delta):

	# Reduce cooldown over time
	if cooldown_timer > 0:
		cooldown_timer -= delta

	# State machine handling
	match state:
		State.IDLE:
			idle_state()

		State.PATROL:
			patrol_state()

		State.ATTACK:
			attack_state(delta)
		
		State.REPOSITION:
			reposition_state()

	# Show current state in debug label
	debug.text = State.keys()[state]

	# Apply movement
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Detect player entering area
	if body.is_in_group("player"):
		player = body
		player_detected = true
		#print("player detected")

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Detect player leaving area
	if body == player:
		player_detected = false
		#print("player exited")
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	#damage player
	if body.is_in_group('player'):
		if body.has_method('take_damage'):
			body.take_damage(10)
			print("-10HP")	
	
func idle_state():

	# Stop movement
	velocity = Vector2.ZERO

	# If player detected and not on cooldown → attack
	if player_detected and cooldown_timer <= 0:
		state = State.ATTACK
		return

	# Random chance to start patrolling
	if randf() < 0.01:
		choose_new_patrol_point()
		state = State.PATROL

func patrol_state():

	# Move toward patrol target
	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed

	# If reached destination → go idle
	if global_position.distance_to(patrol_target) < 10:
		state = State.IDLE

	# Interrupt patrol if player detected
	if player_detected and cooldown_timer <= 0:
		state = State.ATTACK

func attack_state(delta):

	# If player lost → return to idle
	if player == null:
		state = State.IDLE
		return

	# Windup phase before dash
	if is_winding_up:

		velocity = Vector2.ZERO
		windup_time -= delta

		# After windup, prepare dash
		if windup_time <= 0:
			is_winding_up = false
			dash_timer = dash_duration
			dash_direction = (player.global_position - global_position).normalized()

		return

	# Dash phase
	if dash_timer > 0:

		# Move quickly toward player
		velocity = dash_direction * speed * 4
		dash_timer -= delta

	else:
		# Attack finished → reset
		reset_attack()

func reset_attack():

	# Reset attack variables
	is_winding_up = true
	windup_time = 1
	dash_timer = 0

	# Start cooldown
	cooldown_timer = attack_cooldown
	
	# Move to reposition state
	choose_new_reposition_target()
	state = State.REPOSITION

func reposition_state():

	# If player lost → idle
	if player == null:
		state = State.IDLE
		return

	# Move to reposition point around player
	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed

	# Once reached → attack again
	if(global_position.distance_to(patrol_target) < 10):
		state = State.ATTACK
	
func choose_new_reposition_target():
	# Random distance and angle offset
	var offset_distance = randf_range(50, player_detection_radius)
	var offset_angle = set_reposition_angle()
	
	# Convert polar to Cartesian offset
	var offset = offset_distance * Vector2(cos(offset_angle), sin(offset_angle))

	# Set target relative to player
	patrol_target = player.global_position + offset
	
func set_reposition_angle():
	# Direction from player to enemy
	var base_direction = (global_position - player.global_position).normalized()
	var base_angle = base_direction.angle()

	# Random angle variation (prevents crossing directly through player)
	var angle_offset = randf_range(-PI/2, PI/2)
	return base_angle + angle_offset
	
func choose_new_patrol_point():

	# Random point within patrol radius
	var offset = Vector2(
		randf_range(-patrol_radius, patrol_radius),
		randf_range(-patrol_radius, patrol_radius)
	)

	patrol_target = start_position + offset
