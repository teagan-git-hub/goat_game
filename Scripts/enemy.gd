class_name Enemy
extends Node2D

signal on_damaged(amount: float, remaining_health: float)
signal defeated

@export var enemy_name: String = "Dummy"
@export var max_health: float = 100.0
@export var attack_damage: float = 10.0

@onready var animated_sprite: AnimatedSprite2D = $"AnimatedSprite2D-overworld"

var health: float


func _ready() -> void:
	health = max_health
	animated_sprite.visible = true
	animated_sprite.flip_h = false


func overworld_start() -> void:
	animated_sprite.visible = true
	animated_sprite.play("eat")
	animated_sprite.flip_h = false


func battle_start() -> void:
	animated_sprite.visible = true
	animated_sprite.play("eat")
	animated_sprite.flip_h = true


func take_damage(amount: float) -> void:
	if health <= 0.0:
		return

	health = max(health - amount, 0.0)
	on_damaged.emit(amount, health)

	if health == 0.0:
		defeated.emit()
		queue_free()


func is_alive() -> bool:
	return health > 0.0
