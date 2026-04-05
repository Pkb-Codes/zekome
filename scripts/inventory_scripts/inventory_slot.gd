extends Control

#scene tree references
@onready var drop_panel = $drop_Panel
@onready var details_panel = $DetailsPanel
@onready var equip_panel = $EquipSelectPanel

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity

@onready var item_name_label = $DetailsPanel/ItemName
@onready var item_type_label = $DetailsPanel/ItemType

#slot item
var item = null

#mouse interaction functions
func _on_item_button_pressed() -> void:
	if item != null:
		details_panel.visible = false
		drop_panel.visible = true
		if item["type"] == "weapon":
			equip_panel.visible = true

func _on_item_button_mouse_entered() -> void:
	if item != null:
		drop_panel.visible = false
		equip_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false
	if drop_panel.visible == true:
		await get_tree().create_timer(1).timeout
		equip_panel.visible = false
		drop_panel.visible = false

func _on_drop_button_pressed() -> void:
	drop_panel.visible = false
	equip_panel.visible = false
	details_panel.visible = false
	Global_Inventory.remove_item(item)
	Global_Inventory.drop_item(item)


#equip buttons interaction
func _on_button_1_pressed() -> void:
	if item != null:
		Global_Inventory.add_item_hotbar(item, 0)

func _on_button_2_pressed() -> void:
	if item != null:
		Global_Inventory.add_item_hotbar(item, 1)

func _on_button_3_pressed() -> void:
	if item != null:
		Global_Inventory.add_item_hotbar(item, 2)

func _on_button_4_pressed() -> void:
	if item != null:
		Global_Inventory.add_item_hotbar(item, 3)

func _on_button_5_pressed() -> void:
	if item != null:
		Global_Inventory.add_item_hotbar(item, 4)

func _on_button_6_pressed() -> void:
	if item != null:
		Global_Inventory.add_item_hotbar(item, 5)


#instantiating functions
func set_empty():
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(new_item["quantity"])
	item_name_label.text = str(new_item["name"])
	item_type_label.text = str(new_item["type"])
