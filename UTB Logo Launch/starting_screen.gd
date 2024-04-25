class_name StartingScreen extends TextureRect

@onready var toggle_music_button = %ToggleMusicButton
@onready var background_music = %BackgroundMusic
@onready var intro_animation = %IntroAnimation

func _ready():
	background_music.play()
	intro_animation.play("intro")

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_toggle_music_button_pressed():
	Global.music_is_on = !Global.music_is_on
	
	background_music.stream_paused = !Global.music_is_on
	
	if Global.music_is_on:
		toggle_music_button.icon = load("res://Assets/unmuted_icon.png")
	else:
		toggle_music_button.icon = load("res://Assets/muted_icon.png")
	
