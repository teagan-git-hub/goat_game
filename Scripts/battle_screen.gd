extends Node2D

@export var attack: Button
@export var items: Button
@export var retreat: Button
@onready var game_mode_manager: GameModeManager = %GameModeManager

@onready var button_click: AudioStreamPlayer2D = $"button click"
@onready var battle_manager: BattleManager = $BattleManager
@onready var enemies_root: Node2D = $BattleLayer/Enemies

@onready var player_turn_arrow: Sprite2D = $BattleLayer/Indicators/TurnArrows/PlayerTurnArrow
@onready var enemy_turn_arrow: Sprite2D = $BattleLayer/Indicators/TurnArrows/EnemyTurnArrow

@onready var attack_button: Button = $BattleLayer/Control/attack
@onready var heal_button: Button = $BattleLayer/Control/heal
@onready var flee_button: Button = $BattleLayer/Control/retreat

@onready var result_label: Label = $BattleLayer/Control/ResultLabel
@onready var damage_label: Label = $BattleLayer/Control/DamageLabel
@onready var healthbar: ProgressBar = $BattleLayer/Control/ProgressBar

var health_bar: ProgressBar

const ENEMY_SLOTS := [
	Vector2(716, 257),
	Vector2(973, 349),
	Vector2(850, 200)
]

func _ready() -> void:
	battle_manager.turn_changed.connect(_on_turn_changed)
	battle_manager.battle_won.connect(_on_battle_won)
	battle_manager.battle_lost.connect(_on_battle_lost)
	healthbar.visible = true	
	game_mode_manager.boss_match.connect(_on_boss_match)

func start_battle(encounter: Array[Dictionary]) -> void:
	_clear_battle_enemies()

	if encounter.size() > ENEMY_SLOTS.size():
		push_error("Encounter contains too many enemies")
		return

	result_label.visible = false
	damage_label.visible = false

	attack_button.disabled = false
	heal_button.disabled = false

	var battle_enemies: Array[Enemy] = []

	for index in encounter.size():
		var data := encounter[index]
		var enemy_scene: PackedScene = data["scene"]
		var enemy := enemy_scene.instantiate() as Enemy

		enemy.enemy_name = data["enemy_name"]
		enemy.max_health = data["max_health"]
		enemy.attack_damage = data["attack_damage"]
		
		enemies_root.add_child(enemy)

		enemy.position = ENEMY_SLOTS[index]
		enemy.scale = Vector2(4, 4)
	
		enemy.battle_start()
		enemy.on_damaged.connect(_show_damage.bind(enemy))

		battle_enemies.append(enemy)

	battle_manager.setup(battle_enemies)


func _clear_battle_enemies() -> void:
	for child in enemies_root.get_children():
		child.queue_free()

func _on_boss_match() -> void:
	flee_button.visible = false
	flee_button.disabled = true
	

func _on_turn_changed(player_turn: bool) -> void:
	player_turn_arrow.visible = player_turn
	enemy_turn_arrow.visible = not player_turn


func _on_attack_pressed() -> void:
	button_click.play()
	battle_manager.player_attack()

	await get_tree().create_timer(0.05).timeout

func _on_heal_pressed() -> void:
	button_click.play()
	battle_manager.player_heal()
	await get_tree().create_timer(0.05).timeout


func _on_retreat_pressed() -> void:
	button_click.play()
	battle_manager.player_flee()

	await get_tree().create_timer(0.05).timeout


func _on_battle_won() -> void:
	result_label.text = "Victory!"
	result_label.visible = true

	attack_button.disabled = true
	heal_button.disabled = true

	healthbar.visible = false
	GameModeManager.instance.leave_battle()


func _on_battle_lost() -> void:
	result_label.text = "Defeat!"
	result_label.visible = true

	attack_button.disabled = true
	heal_button.disabled = true
	
	healthbar.visible = false

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
