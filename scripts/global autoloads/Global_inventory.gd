extends Node

# inventory items
var inventory = []
var inventory_size = 10

#hotbar items
var hotbar = []
var hotbar_size = 6

# custom signal
signal inventory_updated
signal hotbar_updated

#inventory slot reference
@onready var inventory_slot_scene = preload("res://scenes/inventory_Slot.tscn")
@onready var hotbar_slot_scene = preload("res://scenes/hotbar_slot.tscn")


func _ready():
	# this will fix the inventory size to inventory_size
	inventory.resize(inventory_size)
	hotbar.resize(hotbar_size)

#inventory items management functions
func add_item(item):
	for i in range(inventory_size):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false

func remove_item(item):
	for i in range(inventory_size):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
	inventory_updated.emit()

#hotbar items management functions
func add_item_hotbar(item, slot):
	if hotbar[slot] == null:
		hotbar[slot] = item
		hotbar_updated.emit()
		remove_item(item)
	else:
		#add_item(hotbar[slot])
		#hotbar[slot] = item
		#hotbar_updated.emit()
		pass

func remove_item_hotbar(item):
	#add this item back to inventory and remove it from hotbar
	pass
