extends Node2D

func to_main():
	get_tree().change_scene_to_file("res://Scenes/mainmenu/main_menu.tscn")

func _on_splash_animation_finished(anim_name: StringName) -> void :
	to_main()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.physical_keycode == KEY_SPACE:
			to_main()
