class_name Game extends Node2D

signal streak_changed(streak: int)

@onready var player = %Player as Player
@onready var health_bar = %HealthBar as HealthBar
@onready var score_label = %ScoreLabel as Label
@onready var streak_amount_label = %StreakAmountLabel as Label
@onready var streak_label = %StreakLabel as Label
@onready var streak_logo_image = %StreakLogoImage as Sprite2D
@onready var spawner = %Spawner as Spawner
@onready var powerup_bar = %PowerupBar as PowerupBar
@onready var background_music = %BackgroundMusic as AudioStreamPlayer
@onready var score_up_sound = %ScoreUpSound as AudioStreamPlayer
@onready var wrong_sound = %WrongSound as AudioStreamPlayer
@onready var death_sound = %DeathSound as AudioStreamPlayer
@onready var shield_equipped_sound = %ShieldEquippedSound as AudioStreamPlayer
@onready var player_shield = %PlayerShield as Sprite2D

var score: int = 0
var streak: int = 0
const STREAK_FOR_BOX: int = 10
var shield_health: int = 0

const gameover_scene: PackedScene = preload("res://game_over_screen.tscn")
var gameover_over_screen: GameOverScreen

func _ready():
	player.collided_with_logo.connect(_on_collided_with_logo)
	health_bar.player_died.connect(_on_player_died)
	powerup_bar.shield_used.connect(_on_shield_used)
	
	if Global.music_is_on:
		background_music.play()

func _on_collided_with_logo(is_good: bool):
	if is_good:
		score_up_sound.play()
		increase_streak(1)
		score += streak
		score_label.text = str(score)
	else:
		if shield_health == 0:
			if health_bar.health != 1:
				wrong_sound.play()
			health_bar.decrease()
		else:
			shield_health -= 1
			update_shield_hearts()
			shield_equipped_sound.play()
			if shield_health == 0:
				player_shield.visible = false

func _on_good_logo_despawned():
	if shield_health == 0:
		if health_bar.health != 1:
			wrong_sound.play()
		health_bar.decrease()
	else:
		shield_health -= 1
		update_shield_hearts()
		shield_equipped_sound.play()
		if shield_health == 0:
			player_shield.visible = false
	reset_streak()

func _on_player_died():
	background_music.stop()
	death_sound.play()
	player_shield.visible = false
	score_label.visible = false
	streak_label.visible = false
	streak_amount_label.visible = false
	streak_logo_image.visible = false
	despawn_logos()
	despawn_boxes()
	despawn_hearts()
	hide_powerup_bar()
	
	await get_tree().create_timer(2).timeout
	if not gameover_over_screen:
		gameover_over_screen = gameover_scene.instantiate() as GameOverScreen
		add_child(gameover_over_screen)
		gameover_over_screen.set_score_label(score)
		
		var current_high_score = Global.save_data.high_score
	
		if score > current_high_score:
			Global.save_data.high_score = score
			Global.save_data.save()
			gameover_over_screen.set_high_score_label(score)
			gameover_over_screen.toggle_high_score_banner(true)
		else:
			gameover_over_screen.set_high_score_label(current_high_score)
			gameover_over_screen.toggle_high_score_banner(false)
		
		
func _on_shield_used():
	player_shield.get_child(0).visible = true
	shield_health = 1

func despawn_logos():
	spawner.logo_spawn_timer.stop()
	for logo in get_tree().get_nodes_in_group("logo"):
		logo.queue_free()

func despawn_boxes():
	for box in get_tree().get_nodes_in_group("box"):
		box.queue_free()

func despawn_hearts():
	for heart in get_tree().get_nodes_in_group("heart"):
		heart.queue_free()

func hide_powerup_bar():
	powerup_bar.visible = false

func increase_streak(by: int):
	streak += by
	update_streak_label()
	
func reset_streak():
	streak = 0
	update_streak_label()	

func update_streak_label():
	streak_changed.emit(streak)
	streak_amount_label.text = str(streak)
	if streak % STREAK_FOR_BOX == 0 and streak != 0 and powerup_bar.current_powerups.size() != powerup_bar.all_powerups.size():
		spawner.spawn_box()

func update_shield_hearts():
	var hearts = player_shield.get_children()
	for i in range(hearts.size()):
		hearts[i].visible = i < shield_health
		
