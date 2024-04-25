class_name HealthBar extends HBoxContainer

signal player_died

@onready var player = %Player as Player
@onready var score_up_sound = %ScoreUpSound as AudioStreamPlayer

var heart_nodes: Array[Node]
var health: int
const MAX_HEALTH: int = 3

func _ready():
	player.collided_with_heart.connect(_on_collided_with_heart)
	heart_nodes = get_children()
	health = MAX_HEALTH
		
func _on_collided_with_heart():
	score_up_sound.play()
	increase()

func decrease():
	health -= 1
	update()

func increase():
	if health < MAX_HEALTH:
		health += 1
		update()
		
func update():
	for i in range(heart_nodes.size()):
		heart_nodes[i].visible = i < health
	
	if health == 0:
		player_died.emit()
		
		
