class_name Spawner extends Node2D

@onready var top_left_corner = %TopLeftCorner
@onready var top_right_corner = %TopRightCorner
@onready var logo_spawn_timer = %LogoSpawnTimer
@onready var pop_sound = %PopSound as AudioStreamPlayer

var heart_scene: PackedScene = preload("res://Heart/heart.tscn")
var box_scene: PackedScene = preload("res://Box/box.tscn")
var logo_scene: PackedScene = preload("res://Logo/logo.tscn")

var base_interval = 1.5 
var interval_decrement = 0.2
var minimum_interval = 0.5
var game_time = 0

func spawn_heart():
	var heart = heart_scene.instantiate() as Heart
	heart.setup(randi_range(100, 300))
	heart.position.x = randf_range(top_left_corner.position.x, top_right_corner.position.x)
	heart.position.y = top_left_corner.position.y
	get_parent().call_deferred("add_child", heart)
	
func spawn_box():
	if get_tree().get_nodes_in_group("box").size() == 0:
		pop_sound.play()
		var box = box_scene.instantiate() as Box
		box.position.x = randf_range(top_left_corner.position.x, top_right_corner.position.x)
		box.position.y = get_viewport_rect().size.y - 80
		get_parent().call_deferred("add_child", box)
	
func spawn_logo():
	var logo = logo_scene.instantiate() as Logo
	logo.setup(randf_range(0, 1) < 0.7, randi_range(200, 400))
	logo.position.x = randf_range(top_left_corner.position.x, top_right_corner.position.x)
	logo.position.y = top_left_corner.position.y
	if logo.is_good:
		logo.connect("good_logo_despawned", Callable($"/root/Game", "_on_good_logo_despawned"))
	get_parent().call_deferred("add_child", logo)

func _on_logo_spawn_timer_timeout():
	spawn_logo()
	
	game_time += logo_spawn_timer.wait_time
	adjust_spawn_timer()
	
	print(logo_spawn_timer.wait_time)

	if randf_range(0, 1) < 0.01:
		spawn_heart()


func adjust_spawn_timer():
	var new_interval = max(minimum_interval, base_interval - game_time * interval_decrement / 60)
	logo_spawn_timer.wait_time = new_interval
