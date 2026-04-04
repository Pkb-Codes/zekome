extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/slot_key
@onready var unequip_panel = $unequip_panel
@onready var icon_button = $InnerBorder/icon_button

#slot item
var item = null

#instantiating functions
func set_empty():
	item = null
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(new_item["quantity"])

func _process(_delta: float) -> void:
	if Global_Inventory.inventory_open == false:
		icon_button.visible = false
		unequip_panel.visible = false
	else:
		icon_button.visible = true

func _on_icon_button_mouse_entered() -> void:
	if Global_Inventory.inventory_open and item != null:
		unequip_panel.visible = true

func _on_icon_button_mouse_exited() -> void:
	if item != null:
		await get_tree().create_timer(1).timeout
		unequip_panel.visible = false

func _on_unequip_button_pressed() -> void:
	unequip_panel.visible = false
	Global_Inventory.remove_item_hotbar(item)
