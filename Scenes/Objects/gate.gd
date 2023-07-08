extends StaticBody2D
@export var start_open : bool = true

var is_open = true
func _ready():
	$Animation.stop()
	$Animation.speed_scale = 1.0
	$Animation.frame = 0
	$Collision.disabled = !is_open
	if !start_open:
		Interact()
		
func Interact():
	is_open = !is_open
	$Collision.disabled = !is_open
	$Animation.speed_scale = 1.0 if !is_open else -1.0
	$Animation.play("activate")

