extends CharacterBody2D

@export var max_health:int =100
var health : int

func _ready():
	health=max_health
	
func take_damage(amount:int):
	health-=amount
	health=max(health,0)
func die():
	print("player died")



@export var dash_cooldown := 10.0

var can_dash := true
var dash_direction := Vector2.ZERO

func start_dash_cooldown():
	can_dash=false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash=true	
	
	
	
	
