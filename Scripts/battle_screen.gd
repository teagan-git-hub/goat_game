extends Node2D
@export var attack: Button
@export var items: Button
@export var retreat: Button
@onready var button_click: AudioStreamPlayer2D = $"button click"

@onready var battle_manager: BattleManager = $BattleManager
@onready var enemies_root: Node2D = $BattleLayer/Enemies

@onready var player_turn_arrow: Label = $BattleLayer/Indicators/PlayerTurnArrow
@onready var enemy_turn_arrow: Label = $BattleLayer/Indicators/EnemyTurnArrow

@onready var attack_button: Button = $BattleLayer/Control/attack
@onready var items_button: Button = $BattleLayer/Control/items

@onready var result_label: Label = $BattleLayer/Control/ResultLabel
@onready var damage_label: Label = $BattleLayer/Control/DamageLabel

func _ready() -> void:
	var battle_enemies: Array[Enemy] = []

	for child in enemies_root.get_children():
		if child is Enemy:
			var enemy := child as Enemy
			enemy.battle_start()
			battle_enemies.append(enemy)
			enemy.on_damaged.connect(_show_damage.bind(enemy))

	battle_manager.turn_changed.connect(_on_turn_changed)

	battle_manager.setup(battle_enemies)

	battle_manager.battle_won.connect(_on_battle_won)
	battle_manager.battle_lost.connect(_on_battle_lost)

func _on_turn_changed(player_turn: bool) -> void:
	player_turn_arrow.visible = player_turn
	enemy_turn_arrow.visible = not player_turn

func _on_attack_pressed() -> void:
	button_click.play()
	battle_manager.player_attack()
	await get_tree().create_timer(0.05).timeout

func _on_items_pressed() -> void:
	button_click.play()
	await get_tree().create_timer(0.05).timeout

func _on_retreat_pressed() -> void:
	button_click.play()
	GameModeManager.instance.leave_battle()
	await get_tree().create_timer(0.05).timeout

func _on_battle_won() -> void:
	result_label.text = "Victory!"
	result_label.visible = true
	attack_button.disabled = true
	items_button.disabled = true

func _on_battle_lost() -> void:
	result_label.text = "Defeat!"
	result_label.visible = true
	attack_button.disabled = true
	items_button.disabled = true

func _show_damage(
	amount: float,
	_remaining_health: float,
	enemy: Enemy
) -> void:
	damage_label.text = "-%.0f" % amount
	damage_label.position = enemy.position - Vector2(25, 150)
	damage_label.visible = true

	await get_tree().create_timer(0.5).timeout
	damage_label.visible = false
