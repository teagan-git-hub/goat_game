class_name GameModeManager
extends Node

signal boss_match 

enum GameMode {
	Overworld,
	Battle
}

static var instance: GameModeManager = null

const COW_SCENE := preload("res://Scenes/overworld/cow.tscn")
const COW_BOSS_SCENE := preload("res://Scenes/overworld/boss.tscn")

var _mode: GameMode = GameMode.Overworld
var active_encounter: Array[Dictionary] = []

@onready var _overworld: Node2D = $"../Game"
@onready var _battle_screen: Node2D = $"../BattleScreen"
@onready var _battle_layer: CanvasLayer = $"../BattleScreen/BattleLayer"


func _ready() -> void:
	instance = self
	set_mode(GameMode.Overworld)


func set_mode(mode: GameMode) -> void:
	_mode = mode

	var overworld_active := mode == GameMode.Overworld
	var battle_active := mode == GameMode.Battle

	_overworld.visible = overworld_active
	_overworld.process_mode = (
		Node.PROCESS_MODE_INHERIT
		if overworld_active
		else Node.PROCESS_MODE_DISABLED
	)

	var overworld_canvas := _overworld.get_node("CanvasLayer") as CanvasLayer
	overworld_canvas.visible = overworld_active

	_battle_screen.visible = battle_active
	_battle_screen.process_mode = (
		Node.PROCESS_MODE_INHERIT
		if battle_active
		else Node.PROCESS_MODE_DISABLED
	)

	_battle_layer.visible = battle_active
	_battle_layer.process_mode = (
		Node.PROCESS_MODE_INHERIT
		if battle_active
		else Node.PROCESS_MODE_DISABLED
	)

func leave_battle() -> void:
	set_mode(GameMode.Overworld)

func enter_battle(enemy: Enemy) -> void:
	if _mode == GameMode.Battle:
		return

	if not is_instance_valid(enemy):
		return
	
	var enemy_health = enemy.max_health
	var enemy_attack = enemy.attack_damage
	var enemy_name = enemy.enemy_name
	var enemy_scene = COW_SCENE
	var enemy_scale = 4.0
	
	if enemy.name == "Boss":
		enemy_health = 200
		enemy_attack = 15
		enemy_name = "Boss"
		enemy_scene = COW_BOSS_SCENE
		enemy_scale = 5.0
		
		boss_match.emit()
	else:
		enemy_health = 100
		enemy_attack = 10
	
	active_encounter = [
		{
			"scene": enemy_scene,
			"enemy_name": enemy_name,
			"max_health": enemy_health,
			"attack_damage": enemy_attack,
			"enemy_scale": enemy_scale
		},
		{
			"scene": enemy_scene,
			"enemy_name": enemy.enemy_name,
			"max_health": enemy.max_health,
			"attack_damage": enemy.attack_damage,
			"enemy_scale": enemy_scale
		}
	]

	enemy.queue_free()

	set_mode(GameMode.Battle)
	_battle_screen.start_battle(active_encounter)
