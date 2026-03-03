extends Node

# inventory items
var inventory = []
var inventory_size = 10

# custom signal
signal inventory_updated

# will add player reference if actually needed
#var player_node: Node = null

func _ready():
	# this will fix the inventory size to inventory_size
	inventory.resize(inventory_size)

func add_item():
	inventory_updated.emit()

func remove_item():
	inventory_updated.emit()

#func set_player_reference(player):
	# have to set player reference from player script to make it work
	#player_node = player
