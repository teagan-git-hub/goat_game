extends Node2D

func _ready() -> void :
	pass

func _process(delta: float) -> void :
	pass

func _on_start_pressed() -> void :
	get_tree().change_scene_to_file("")

func _on_version_notes_pressed() -> void :
	get_tree().change_scene_to_file("")

func _on_credits_pressed() -> void :
	get_tree().change_scene_to_file("")
