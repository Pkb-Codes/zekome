extends CanvasLayer

@export var save_slots_scene: PackedScene
@export var settings_scene: PackedScene

func _on_start_button_pressed() -> void:
	if save_slots_scene:
		get_tree().change_scene_to_packed(save_slots_scene)

func _on_options_button_pressed() -> void:
	if settings_scene:
		get_tree().change_scene_to_packed(settings_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
