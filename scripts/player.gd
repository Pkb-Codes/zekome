extends CharacterBody2D

#custom signal
signal player_health_changed (current_health, max)

@export var max_health:int =100
var health : int

func _ready():
	health=max_health

# health logic
func take_damage(amount:int):
	health-=amount
	health=max(health,0)
	if health <= 0:
		die()
	emit_signal("player_health_changed", health, max_health)


func die():
	print("player died")
	
	#make player health to full for debugging and testing process
	health = max_health



# dash logic
@export var dash_cooldown := 10.0

var can_dash := true
var dash_direction := Vector2.ZERO

func start_dash_cooldown():
	can_dash=false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash=true
