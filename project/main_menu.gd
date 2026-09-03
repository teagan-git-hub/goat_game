extends Node2D

@onready var fade: ColorRect = $fade
@onready var menu_music: AudioStreamPlayer2D = $"sounds/Menu Music"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_timer: Timer = $fade / fade_timer
var button_type = null
@onready var splash: AnimationPlayer = $Splash
@onready var button_click: AudioStreamPlayer2D = $"sounds/button click"

func _ready() -> void :
	menu_music.play()

func _on_start_pressed() -> void :
	button_click.play()
	get_tree().change_scene_to_file("")

func _on_version_notes_pressed() -> void :
	button_click.play()
	get_tree().change_scene_to_file("res://Scenes/versionnotes.tscn")

func _on_credits_pressed() -> void :
	button_click.play()
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
