extends Control
@onready var menu_music: AudioStreamPlayer2D = $"Menu Music"

func _ready() -> void :
	menu_music.play()
	
func _on_button_pressed() -> void :
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
