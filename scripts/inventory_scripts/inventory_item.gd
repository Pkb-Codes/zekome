extends Node2D

#item specifications
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture

var scene_path: String = "res://scenes/inventory_minor_scenes/inventory_item.tscn"
var player_in_range = false

@onready var ui_interact = $ui_interact
@onready var icon_sprite = $Sprite2D

func _ready() -> void:
	icon_sprite.texture = item_texture

func _process(_delta: float):
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
		ui_interact.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		ui_interact.visible = false

func set_item_data(data):
	item_type = data["type"]
	item_texture = data["texture"]
	item_name = data["name"]
