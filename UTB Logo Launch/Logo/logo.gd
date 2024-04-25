class_name Logo extends Area2D

signal good_logo_despawned

@onready var logo_sprite = %LogoSprite
@onready var logo_collision_shape = $LogoCollisionShape

var is_good: bool
var fall_speed: int
var rotation_speed: float
var size: int

const good_logo_image: String = "res://Logo/utb.png"
const bad_logo_image: String = "res://Logo/vut.png"

func _ready():
	if is_good:
		logo_sprite.texture = load(good_logo_image)
	else:
		logo_sprite.texture = load(bad_logo_image)
	
	size = randi_range(50, 100)	
	logo_sprite.scale = Vector2(size, size) / logo_sprite.texture.get_size()

func _physics_process(delta):
	position.y += fall_speed * delta
	rotation += rotation_speed * delta
	
	if position.y + size / 2.5 > get_viewport_rect().size.y:
		if self.is_good:
			good_logo_despawned.emit()
			set_physics_process(false)
			logo_sprite.texture = load("res://Heart/heart_broken.png")
			logo_sprite.scale = Vector2(50, 50) / logo_sprite.texture.get_size()
			rotation = 0
			await get_tree().create_timer(0.6).timeout
		queue_free()

func setup(is_good: bool, fall_speed: int):
	self.is_good = is_good
	self.fall_speed = fall_speed
	self.rotation_speed = fall_speed / 50
