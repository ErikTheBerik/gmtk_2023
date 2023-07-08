extends Node2D

func Remove():
	$Animation.visible = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
func Restart():
	$Animation.visible = true
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$PlaybackController.Playback()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
