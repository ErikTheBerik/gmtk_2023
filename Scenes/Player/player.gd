extends CharacterBody2D

var lastYSpeed = 0.0

func _process(delta):
	if is_on_floor() && lastYSpeed >= 3200:
		print("DEATH")
		
	lastYSpeed = velocity.y
