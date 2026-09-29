extends Node2D

@onready var enemies: Node = $Enemies

func _ready() -> void:
	for enemy in enemies.get_children():
		if enemy is Enemy:
			enemy.overworld_start()
