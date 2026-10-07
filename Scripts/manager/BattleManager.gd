class_name BattleManager
extends Node

signal health_changed(player_health: float)
signal turn_changed(player_turn: bool)
signal battle_won
signal battle_lost

@export var player_max_health: float = 100.0
@onready var player_healthbar: ProgressBar = $"../BattleLayer/Control/ProgressBar"
@onready var battle_player: CharacterBody2D = $"../BattleLayer/BattlePlayer"
@onready var enemy_damage_label: Label = $"../BattleLayer/Control/EnemyDamageLabel"
@onready var result_label: Label = $"../BattleLayer/Control/ResultLabel"
@onready var goat_take_damage: AudioStreamPlayer = $"../Sounds/GoatTakeDamage"
@onready var death: AudioStreamPlayer = $"../Sounds/Death"
@onready var start_up_music: AudioStreamPlayer = $"../Sounds/StartUpMusic"
@onready var cow_take_damage: AudioStreamPlayer = $"../Sounds/CowTakeDamage"

var player_health: float
var enemies: Array[Enemy] = []
var player_turn := true
var times_fleed: int = 0
var rng = RandomNumberGenerator.new()
var health_bar: ProgressBar

func setup(new_enemies: Array[Enemy]) -> void:
	enemies = new_enemies
	player_health = player_max_health

	for enemy in enemies:
		enemy.defeated.connect(_on_enemy_defeated.bind(enemy))

	player_turn = true
	player_healthbar.value = 100
	player_healthbar.visible = true
	turn_changed.emit(player_turn)
	start_up_music.play()
	await get_tree().create_timer(2)
	start_up_music.stop()

func player_attack() -> void:
	if not player_turn:
		return

	var target := _first_living_enemy()
	if target == null:
		return
		
	var player_attack_damage = rng.randi_range(20,40);

	cow_take_damage.play()
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
	
func player_heal() -> void:
	if not player_turn:
		return
		
	var heal_value = rng.randi_range(15,35);

	player_health = min(player_health + heal_value, 100)
	print("Player health: ", player_health)
	health_changed.emit(player_health)
	player_healthbar.value = player_health
	enemy_damage_label.text = "+%.0f" % heal_value
	enemy_damage_label.position = battle_player.position - Vector2(25, 150)
	enemy_damage_label.visible = true

	await get_tree().create_timer(0.5).timeout
	enemy_damage_label.visible = false
	
	player_turn = false
	turn_changed.emit(player_turn)
	await get_tree().create_timer(0.5).timeout

	_enemy_turn()
	player_turn = player_health > 0.0
	turn_changed.emit(player_turn)

func player_flee() -> void:
	if not player_turn:
		return

	var escape_chance = rng.randi_range(0,100)
	if escape_chance > 80:
		times_fleed = 0
		GameModeManager.instance.leave_battle()
	else:
		result_label.visible = true
		result_label.text = "Flee Failed!"
		times_fleed += 1
		print(times_fleed)
		
		player_turn = false
		turn_changed.emit(player_turn)
		await get_tree().create_timer(0.5).timeout
		result_label.visible = false
		
		_enemy_turn()
		player_turn = player_health > 0.0
		turn_changed.emit(player_turn)
		
func _enemy_turn() -> void:
	var attacker := _first_living_enemy()
	if attacker == null:
		return
		
	var min_damage: int = attacker.attack_damage + times_fleed
	var enemy_damage: int = rng.randi_range(min_damage, min_damage + 10)
	enemy_damage_label.text = "-%.0f" % enemy_damage
	enemy_damage_label.position = battle_player.position - Vector2(25, 150)
	goat_take_damage.play()
	enemy_damage_label.visible = true

	await get_tree().create_timer(0.5).timeout
	enemy_damage_label.visible = false
	
	player_health = max(player_health - enemy_damage, 0.0)
	print("Player health: ", player_health)
	health_changed.emit(player_health)
	player_healthbar.value = player_health

	if player_health == 0.0:
		print("Defeat")
		death.play()
		battle_lost.emit()
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()

func _first_living_enemy() -> Enemy:
	for enemy in enemies:
		if enemy.is_alive():
			return enemy
	return null

func _on_enemy_defeated(enemy: Enemy) -> void:
	enemies.erase(enemy)
