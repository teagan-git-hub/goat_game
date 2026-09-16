class_name Enemy
extends CharacterBody2D

signal on_damaged(amount:float, remaining_health:float)
signal defeated

@export var enemy_name: String = "Dummy";
@export var max_health: float = 100.0;
@export var attack_damage: float = 10.0;
@export var overworld_animator: AnimatedSprite2D = null;
@export var battle_animator: AnimatedSprite2D = null;
@onready var cow: Enemy = $"."

var health: float;

func overworld_start() -> void:
	if overworld_animator:
		overworld_animator.visible = true
		overworld_animator.play("default")

	if battle_animator:
		battle_animator.visible = false


func battle_start() -> void:
	if overworld_animator:
		overworld_animator.visible = false

	if battle_animator:
		battle_animator.visible = true
		battle_animator.play("default")

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
