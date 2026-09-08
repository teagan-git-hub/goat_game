extends Node2D
@onready var attack: Button = $Control/attack
@onready var items: Button = $Control/items
@onready var retreat: Button = $Control/retreat
@onready var button_click: AudioStreamPlayer2D = $"button click"

func _on_attack_pressed() -> void:
	button_click.play()

func _on_items_pressed() -> void:
	button_click.play()

func _on_retreat_pressed() -> void:
	button_click.play()
