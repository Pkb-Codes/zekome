extends Node

# inventory items
var inventory = []
var inventory_size = 10

#hotbar items
var hotbar = []
var hotbar_size = 6

# custom signal
signal inventory_updated

#inventory slot reference
@onready var inventory_slot_scene = preload("res://scenes/inventory_Slot.tscn")

# will add player reference if actually needed
#var player_node: Node = null

func _ready():
	# this will fix the inventory size to inventory_size
	inventory.resize(inventory_size)
	hotbar.resize(hotbar_size)

#inventory items management functions
func add_item(item):
	for i in range(inventory_size):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
			inventory[i]["quantity"] += item["qunatity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
		return false

func remove_item(item):
	for i in range(inventory_size):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["typr"] == item["type"]:
			inventory[i]["quantity"] -= 1
	inventory_updated.emit()

#hotbar items management functions
func add_item_hotbar(item):
	for i in range(hotbar_size):
		if hotbar[i] == null:
			hotbar[i] = item
			inventory_updated.emit()
			return true
		return false

func remove_item_hotbar(item):
	pass

#func set_player_reference(player):
	# have to set player reference from player script to make it work
	#player_node = player
