extends CanvasLayer

signal go_back

func _on_back_button_pressed() -> void:
	go_back.emit()

func _on_reset_button_pressed() -> void:
	pass # Replace with function body.
