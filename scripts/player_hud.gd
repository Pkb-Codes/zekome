extends CanvasLayer


@onready var hud = $"."
#update path accordingly later
@onready var hotbar_grid = $hotbar/GridContainer
@onready var health_fill = $"player health bar/health_BG/health_fill"

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.connect("player_health_changed", _on_health_changed)
		_on_health_changed(player.max_health, player.max_health)
	Global_Inventory.hotbar_updated.connect(_on_hotbar_updated)
	_on_hotbar_updated()

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		hud.visible = !hud.visible

#health bar functions
func _on_health_changed(current_health, max_health):
	var ratio = float(current_health) / max_health
	health_fill.scale.x = ratio

#hotbar functions
func _on_hotbar_updated():
	clear_grid()
	#repopulate the items in the hotbar
	for item in Global_Inventory.hotbar:
		var slot = Global_Inventory.hotbar_slot_scene.instantiate()
		hotbar_grid.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

func clear_grid():
	while hotbar_grid.get_child_count() > 0:
		var child = hotbar_grid.get_child(0)
		hotbar_grid.remove_child(child)
		child.queue_free()
