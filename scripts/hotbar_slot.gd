extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/slot_key
#slot item
var item = null

#instantiating functions
func set_empty():
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(new_item["quantity"])
