extends Node2D

@onready var enemies: Node = $Enemies
@onready var lofi_beat_for_game: AudioStreamPlayer = $Sounds/LofiBeatForGame

func _ready() -> void:
	for enemy in enemies.get_children():
		if enemy is Enemy:
			enemy.overworld_start()
	lofi_beat_for_game.play()
