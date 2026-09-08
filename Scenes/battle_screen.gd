extends Node2D
@export var attack: Button
@export var items: Button
@export var retreat: Button
@export var button_click: AudioStreamPlayer2D

<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
func _on_attack_pressed() -> void:
	button_click.play()

func _on_items_pressed() -> void:
	button_click.play()

func _on_retreat_pressed() -> void:
	button_click.play()
