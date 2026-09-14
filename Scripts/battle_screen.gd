extends Node2D
@export var attack: Button
@export var items: Button
@export var retreat: Button
@onready var button_click: AudioStreamPlayer2D = $"button click"

func _on_attack_pressed() -> void:
	button_click.play()
	await get_tree().create_timer(0.05).timeout

func _on_items_pressed() -> void:
	button_click.play()
	await get_tree().create_timer(0.05).timeout

func _on_retreat_pressed() -> void:
	button_click.play()
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://Scenes/openworld.tscn")
