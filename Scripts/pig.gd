extends Node2D

@onready var text: Label = $Label

func _on_area_2d_body_entered(body: Node2D) -> void:
	text.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	text.visible = false
