extends Node

# inventory items
var inventory = []
var inventory_size = 12

#hotbar items
var hotbar = []
var hotbar_size = 6

# custom signal
signal inventory_updated
signal hotbar_updated

#inventory slot reference
@onready var inventory_slot_scene = preload("res://scenes/inventory_minor_scenes/inventory_Slot.tscn")
@onready var hotbar_slot_scene = preload("res://scenes/inventory_minor_scenes/hotbar_slot.tscn")

#bolean to check if inventory is open
var inventory_open = false

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

#remove the item from inventory
func remove_item(item):
	for i in range(inventory_size):
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
	inventory_updated.emit()

#hotbar items management functions
func add_item_hotbar(item, slot):
	var new_item = item.duplicate(true)
	if hotbar[slot] == null:
		hotbar[slot] = new_item
		hotbar_updated.emit()
		remove_item(item)
	else:
		remove_item(item)
		add_item(hotbar[slot])
		hotbar[slot] = new_item
		hotbar_updated.emit()

func remove_item_hotbar(item):
	#add this item back to inventory and remove it from hotbar
	for i in range(hotbar_size):
		if item != null and item == hotbar[i]:
			add_item(hotbar[i])
			hotbar[i] = null
			hotbar_updated.emit()
			break

func adjust_drop_pos(position):
	var drop_radius = 100
	var nearby_items = get_tree().get_nodes_in_group("inventory_items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < drop_radius:
			var random_offset = Vector2(randf_range(-drop_radius, drop_radius),randf_range(-drop_radius, drop_radius))
			position += random_offset
			break
	return position

func drop_item(item):
	var player = get_tree().get_first_node_in_group("player")
	var drop_offset = Vector2(0, 50)
	drop_offset = drop_offset.rotated(player.rotation)
	var drop_pos = player.global_position + drop_offset
	var item_scene = load(item["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item)
	drop_pos = adjust_drop_pos(drop_pos)
	item_instance.global_position = drop_pos
	get_tree().current_scene.add_child(item_instance)
