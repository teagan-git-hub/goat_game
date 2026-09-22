class_name Enemy
extends Node2D

signal on_damaged(amount:float, remaining_health:float)
signal defeated

@export var enemy_name: String = "Dummy";
@export var max_health: float = 100.0;
@export var attack_damage: float = 10.0;
@onready var animated_sprite_2d_overworld: AnimatedSprite2D = $"AnimatedSprite2D-overworld"
@onready var cow: Enemy = $"."

var health: float;

func overworld_start() -> void:
	animated_sprite_2d_overworld.play("default")
	animated_sprite_2d_overworld.flip_h = false


func battle_start() -> void:
	animated_sprite_2d_overworld.flip_h = true

func _ready() -> void:
	health = max_health

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
