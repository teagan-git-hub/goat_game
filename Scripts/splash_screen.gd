extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_splash_animation_finished(anim_name: StringName) -> void :
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
