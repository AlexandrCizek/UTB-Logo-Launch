class_name Heart extends Area2D

var fall_speed: int

func _physics_process(delta):
	position.y += fall_speed * delta
	
	if position.y > get_viewport_rect().size.y:
		queue_free()

func setup(fall_speed: int):
	self.fall_speed = fall_speed
