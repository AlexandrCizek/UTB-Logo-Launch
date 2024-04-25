class_name Player extends Area2D

signal collided_with_logo
signal collided_with_box
signal collided_with_heart

@onready var game: Game = $"/root/Game" as Game
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite as AnimatedSprite2D
@onready var health_bar: HealthBar = $"/root/Game/Background/Player/HealthBar" as HealthBar
@onready var fire_collision_shape = %FireCollisionShape as CollisionShape2D
@onready var attack_sound = $"/root/Game/AttackSound" as AudioStreamPlayer
@onready var jump_sound = $"/root/Game/JumpSound" as AudioStreamPlayer
@onready var powerup_bar = $"/root/Game/Background/Player/PowerupBar" as PowerupBar

const SPEED: int = 1600
const GRAVITY: int = 40
const JUMP_FORCE: int = -22
const PLUS_POINTS_LABEL = preload("res://Logo/plus_points_label.tscn")

var velocity: Vector2 = Vector2.ZERO
var is_on_ground: bool = false
var attack_animation_is_playing: bool = false
var jumps: int = 2
var streak: int = 0

func _ready():
	health_bar.player_died.connect(_on_player_died)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	game.streak_changed.connect(_on_streak_changed)
	fire_collision_shape.disabled = true
	
func _physics_process(delta):
	velocity.x = 0
	
	if attack_animation_is_playing:
		return
	
	if Input.is_action_pressed("attack") and is_on_ground:
		if not attack_animation_is_playing:
			attack_sound.play()
			attack_animation_is_playing = true
			animated_sprite.play("attack")
			fire_collision_shape.disabled = false
		return

	fire_collision_shape.disabled = true
	
	if Input.is_action_pressed("use_ability_bomb"):
		powerup_bar.use_powerup(Global.Powerup.BOMB)
	elif Input.is_action_pressed("use_ability_magnet"):
		powerup_bar.use_powerup(Global.Powerup.MAGNET)
	elif Input.is_action_pressed("use_ability_shield"):
		powerup_bar.use_powerup(Global.Powerup.SHIELD)	
		
	if Input.is_action_pressed("move_left"):
		if not animated_sprite.flip_h:
			animated_sprite.flip_h = true
			flip_fire_collision_shape()
		if is_on_ground:
			animated_sprite.play("run")
		velocity.x -= SPEED * delta
	elif Input.is_action_pressed("move_right"):
		if animated_sprite.flip_h:
			animated_sprite.flip_h = false
			flip_fire_collision_shape()
		if is_on_ground:
			animated_sprite.play("run")
		velocity.x += SPEED * delta
	else:
		if is_on_ground:
			animated_sprite.play("idle")
		
	if Input.is_action_just_pressed("jump"):
		if is_on_ground or jumps < 2:
			jump_sound.play()
			velocity.y = JUMP_FORCE
			is_on_ground = false
			jumps += 1
			animated_sprite.play("jump")
	
	velocity.y += GRAVITY * delta
	position += velocity
	
	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, 0, screen_width)
	
	if position.y >= get_viewport_rect().size.y - 58:
		velocity.y = 0
		is_on_ground = true
		jumps = 0
		position.y = get_viewport_rect().size.y - 58
		
		if velocity.x == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

func flip_fire_collision_shape():
	fire_collision_shape.position.x = -fire_collision_shape.position.x
		
func _on_area_entered(area):
	if area.is_in_group("logo"):
		collided_with_logo.emit(area.is_good)
		area.set_physics_process(false)
		if area.is_good:
			area.queue_free()
			var points_label = PLUS_POINTS_LABEL.instantiate() as Label
			points_label.text = "+" + str(streak)
			points_label.position = area.position
			get_parent().add_child(points_label)
			await get_tree().create_timer(0.3).timeout
			points_label.queue_free()
		else:
			area.logo_sprite.texture = load("res://Heart/heart_broken.png")
			area.logo_sprite.scale = Vector2(50, 50) / area.logo_sprite.texture.get_size()
			area.rotation = 0
			await get_tree().create_timer(0.6).timeout
			if is_instance_valid(area):
				area.queue_free()	
			
	elif area.is_in_group("box"):
		collided_with_box.emit()
	elif area.is_in_group("heart"):
		collided_with_heart.emit()
		area.queue_free()

func _on_player_died():
	set_physics_process(false)
	position.y = get_viewport_rect().size.y - 58
	animated_sprite.play("death")

func _on_animation_finished():
	if animated_sprite.animation == "death":
		get_tree().paused = true
	elif animated_sprite.animation == "attack":
		attack_animation_is_playing = false

func _on_streak_changed(streak: int):
	self.streak = streak
		
		
