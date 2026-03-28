extends Node

# inventory items
var inventory = []
var inventory_size = 10

# custom signal
signal inventory_updated

#inventory slot reference
@onready var inventory_slot_scene = preload("res://scenes/inventory_Slot.tscn")

# will add player reference if actually needed
#var player_node: Node = null

func _ready():
	# this will fix the inventory size to inventory_size
	inventory.resize(inventory_size)

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

func remove_item():
	inventory_updated.emit()

#func set_player_reference(player):
	# have to set player reference from player script to make it work
	#player_node = player
