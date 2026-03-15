extends Panel

@onready var buttons = $button_container
@onready var audio_page = $page_container/Audio_page
@onready var video_page = $page_container/Video_page
@onready var key_page = $page_container/Key_binds_page

func _ready():
	for page in $page_container.get_children():
		page.connect("go_back", _back_to_menu)

func show_page(active_page):
	# hide the buttons
	buttons.visible = false
	#hide all pages
	for page in $page_container.get_children():
		page.visible = false
	#make the active page visible
	active_page.visible = true

func _back_to_menu():
	#hide all pages
	for page in $page_container.get_children():
		page.visible = false
	#shoe buttons
	buttons.visible = true

func _on_key_binds_button_pressed() -> void:
	show_page(key_page)


func _on_video_button_pressed() -> void:
	show_page(video_page)


func _on_audio_button_pressed() -> void:
	show_page(audio_page)


func _on_back_button_pressed() -> void:
	queue_free() #closes the options menu
