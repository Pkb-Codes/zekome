extends CanvasLayer

@onready var inventory_ui = $"."
@onready var grid_container = $ColorRect/Inventory_UI/GridContainer
@onready var slot_wheel = $ColorRect/slot_wheel_background/slots_wheel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global_Inventory.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	Global_Inventory.hotbar_updated.connect(_update_slot_wheel)
	_update_slot_wheel()
	

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = ! inventory_ui.visible
		Global_Inventory.inventory_open = inventory_ui.visible
		#pause game if needed..............
		#get_tree().paused = !get_tree().paused

#Update Inventory UI
func _on_inventory_updated():
	clear_grid_container()
	#add slots in the inventory grid
	for item in Global_Inventory.inventory:
		var slot = Global_Inventory.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

#Clear Inventory UI grid	
func clear_grid_container():
	while grid_container.get_child_count()>0:
		var child =grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

#update the slot wheel
func _update_slot_wheel():
	for i in range(Global_Inventory.hotbar_size):
		var slot = slot_wheel.get_child(i)
		var item = Global_Inventory.hotbar[i]
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
