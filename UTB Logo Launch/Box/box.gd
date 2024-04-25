class_name Box extends Area2D

@onready var player = $"/root/Game/Background/Player" as Player
@onready var powerup_bar = $"/root/Game/Background/Player/PowerupBar" as PowerupBar
@onready var box_sprite = %BoxSprite as Sprite2D
@onready var box_collision_shape = %BoxCollisionShape as CollisionShape2D
@onready var powerup_collected_sound = $"/root/Game/PowerupCollectedSound" as AudioStreamPlayer

func _ready():
	player.collided_with_box.connect(_on_collided_with_box)

func _on_collided_with_box():
	await get_tree().create_timer(0.3).timeout
	
	box_collision_shape.disabled = true
	powerup_collected_sound.play()
	powerup_bar.get_random_powerup()
	
	queue_free()
