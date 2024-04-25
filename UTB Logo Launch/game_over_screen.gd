class_name GameOverScreen extends CanvasLayer

@onready var score_label = %ScoreLabel
@onready var high_score_label = %HighScoreLabel
@onready var restart_button = %RestartButton
@onready var quit_button = %QuitButton
@onready var high_score_banner = %HighScoreBanner
@onready var toggle_music_button = %ToggleMusicButton
@onready var background_music = $"/root/Game/BackgroundMusic"

func _ready():
	if Global.music_is_on:
		toggle_music_button.icon = load("res://Assets/unmuted_icon.png")
	else:
		toggle_music_button.icon = load("res://Assets/muted_icon.png")
	
	var color = Color("#82BF78" if Global.music_is_on else "#F25E5E")
	toggle_music_button.add_theme_color_override("font_color", color)
	toggle_music_button.add_theme_color_override("font_pressed_color", color)
	toggle_music_button.add_theme_color_override("font_hover_color", color)
	toggle_music_button.add_theme_color_override("font_focus_color", color)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_toggle_music_button_pressed():
	Global.music_is_on = !Global.music_is_on
	
	background_music.stream_paused = !Global.music_is_on
	
	if Global.music_is_on:
		toggle_music_button.icon = load("res://Assets/unmuted_icon.png")
	else:
		toggle_music_button.icon = load("res://Assets/muted_icon.png")
	
func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false

func set_score_label(score: int):
	score_label.text = str(score)

func set_high_score_label(high_score: int):
	high_score_label.text = str(high_score)

func toggle_high_score_banner(show: bool):
	high_score_banner.visible = show
