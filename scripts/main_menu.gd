extends CanvasLayer

@export var save_slots_scene: PackedScene
@export var options_scene: PackedScene

func _on_start_button_pressed() -> void:
	if save_slots_scene:
		get_tree().change_scene_to_packed(save_slots_scene)

func _on_options_button_pressed() -> void:
	var options_menu = options_scene.instantiate()
	add_child(options_menu)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
