class_name BattleManager
extends Node

signal turn_changed(player_turn: bool)
signal battle_won
signal battle_lost

@export var player_attack_damage: float = 25.0
@export var player_max_health: float = 100.0

var player_health: float
var enemies: Array[Enemy] = []
var player_turn := true


func setup(new_enemies: Array[Enemy]) -> void:
	enemies = new_enemies
	player_health = player_max_health

	for enemy in enemies:
		enemy.defeated.connect(_on_enemy_defeated.bind(enemy))

	player_turn = true
	turn_changed.emit(player_turn)


func player_attack() -> void:
	if not player_turn:
		return

	var target := _first_living_enemy()
	if target == null:
		return

	target.take_damage(player_attack_damage)
	print(target.enemy_name, " health: ", target.health)

	if _first_living_enemy() == null:
		player_turn = false
		print("Victory")
		battle_won.emit()
		return

	player_turn = false
	turn_changed.emit(player_turn)
	await get_tree().create_timer(0.5).timeout

	_enemy_turn()
	player_turn = player_health > 0.0
	turn_changed.emit(player_turn)


func _enemy_turn() -> void:
	var attacker := _first_living_enemy()
	if attacker == null:
		return

	player_health = max(player_health - attacker.attack_damage, 0.0)
	print("Player health: ", player_health)

	if player_health == 0.0:
		print("Defeat")
		battle_lost.emit()


func _first_living_enemy() -> Enemy:
	for enemy in enemies:
		if enemy.is_alive():
			return enemy

	return null


func _on_enemy_defeated(enemy: Enemy) -> void:
	enemies.erase(enemy)
