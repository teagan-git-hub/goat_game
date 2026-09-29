extends Node2D

@onready var fade: ColorRect = $fade
@onready var menu_music: AudioStreamPlayer2D = $"sounds/Menu Music"
@onready var fade_timer: Timer = $fade / fade_timer
var button_type = null
@onready var splash: AnimationPlayer = $Splash
@onready var button_click: AudioStreamPlayer2D = $"sounds/button click"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.physical_keycode == KEY_SPACE:
			_on_start_pressed()

func _ready() -> void :
	menu_music.play()

func _on_start_pressed() -> void :
	button_click.play()
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_version_notes_pressed() -> void :
	button_click.play()
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://Scenes/mainmenu/versionnotes.tscn")

func _on_credits_pressed() -> void :
	button_click.play()
	await get_tree().create_timer(0.05).timeout
	get_tree().change_scene_to_file("res://Scenes/mainmenu/credits.tscn")
