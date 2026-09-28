class_name GameModeManager
extends Node

enum GameMode {
	Overworld,
	Battle
};

## Singleton instance
static var instance: GameModeManager = null;

var _mode: GameMode = GameMode.Overworld;

@onready var _overworld: Node2D = $"../Game"
@onready var _battle_screen: Node2D = $"../BattleScreen"
@onready var _battle_layer: CanvasLayer = $"../BattleScreen/BattleLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self;
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

func enter_battle(
	enemy: Enemy
) -> void:
	print("Entering battle with ", enemy.enemy_name)
	set_mode(GameMode.Battle)
	print(enemy.name)
