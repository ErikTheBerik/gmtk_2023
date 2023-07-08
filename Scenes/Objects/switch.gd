extends Node2D

@export var ObjectPaths: Array[NodePath]

var Objects: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	for path in ObjectPaths:
		Objects.push_back(get_node(path))
		
	Restart()
	
func Restart():
	$Animation.stop()
	$Animation.speed_scale = -1
	$Animation.frame = 0
	for object in Objects:
		if object.has_method("Restart"):
			object.Restart() 

func Interact():
	$Animation.speed_scale *= -1
	$Animation.play("activate")
	for object in Objects:
		if object.has_method("Interact"):
			object.Interact()
