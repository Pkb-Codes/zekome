extends Node2D

#item specifications
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture

var scene_path: String = "res://scripts/inventory_item.gd"

var player_in_range = false

@onready var icon_sprite = $Sprite2D

func _ready() -> void:
	icon_sprite.texture = item_texture

func _process(delta: float):
	if player_in_range and Input.is_action_just_pressed("inventory_add"):
		pickup_item()

func pickup_item():
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"name" : item_name,
		"texture" : item_texture,
		"scene_path" : scene_path
	}
	Global_Inventory.add_item(item)
	self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		body.ui_interact.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		body.ui_interact.visible = false
