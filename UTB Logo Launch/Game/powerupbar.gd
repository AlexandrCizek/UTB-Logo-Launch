class_name PowerupBar extends Node2D

signal shield_used

@onready var player = %Player as Player
@onready var bomb = %Bomb as Sprite2D
@onready var magnet = %Magnet as Sprite2D
@onready var shield = %Shield as Sprite2D
@onready var player_shield = %PlayerShield as Sprite2D
@onready var bomb_sound = %BombSound as AudioStreamPlayer
@onready var magnet_sound = %MagnetSound as AudioStreamPlayer
@onready var shield_equipped_sound = %ShieldEquippedSound as AudioStreamPlayer

var all_powerups = Global.Powerup.values()
var current_powerups: Array[int] = []

func _ready():
	bomb.visible = false
	magnet.visible = false
	shield.visible = false
	player_shield.visible = false

func refresh_bar():
	bomb.visible = false
	magnet.visible = false
	shield.visible = false

	for powerup in current_powerups:
		match powerup:
			Global.Powerup.BOMB:
				bomb.visible = true
			Global.Powerup.MAGNET:
				magnet.visible = true
			Global.Powerup.SHIELD:
				shield.visible = true

func get_random_powerup():
	if current_powerups.size() >= all_powerups.size():
		return
	
	var available_powerups = []
	
	for powerup in all_powerups:
		if powerup not in current_powerups:
			available_powerups.append(powerup)
			
	current_powerups.append(available_powerups.pick_random())
	refresh_bar()

func use_bomb():
	bomb_sound.play()
	
	for logo in get_tree().get_nodes_in_group("logo"):
		logo.queue_free()
	
	bomb.visible = false

func use_magnet():
	magnet_sound.play()
	for logo in get_tree().get_nodes_in_group("logo"):
		if logo.is_good:
			logo.position.x = player.position.x
		else:
			if logo.position.x <= get_viewport_rect().size.x / 2:
				logo.position.x = 0 + logo.scale.x
			else:
				logo.position.x = get_viewport_rect().size.x - logo.scale.x
				
	for heart in get_tree().get_nodes_in_group("heart"):
		heart.position.x = player.position.x
					
	magnet.visible = false

func use_shield():
	shield_equipped_sound.play()
	player_shield.visible = true
	shield_used.emit()

func use_powerup(powerup: Global.Powerup):
	if not current_powerups.has(powerup):
		return
	
	current_powerups.erase(powerup)
	
	match powerup:
		Global.Powerup.BOMB:
			use_bomb()
		Global.Powerup.MAGNET:
			use_magnet()
		Global.Powerup.SHIELD:
			use_shield()
	
	refresh_bar()
