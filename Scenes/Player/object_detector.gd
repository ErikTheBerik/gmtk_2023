extends Area2D
var objects : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Interact():
	for object in objects:
		if object.has_method("Interact"):
			object.Interact();


func _on_area_entered(area):
	var parent = area.get_parent();
	if (objects.find(parent) == -1):
		objects.push_back(parent)


func _on_area_exited(area):
	var parent = area.get_parent();
	var index = objects.find(parent)
	if (index != -1):
		objects.remove_at(index)
