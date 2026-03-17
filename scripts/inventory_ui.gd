extends Control
@onready var inventory_ui = $"."
@onready var grid_container = $Inventory_UI/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = ! inventory_ui.visible
		#get_tree().paused = !get_tree().paused

#Update Inventory UI
func _on_inventory_updated():
	clear_grid_container()

#Clear Inventory UI grid	
func clear_grid_container():
	while grid_container.get_child_count()>0:
		var child =grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
	
	
