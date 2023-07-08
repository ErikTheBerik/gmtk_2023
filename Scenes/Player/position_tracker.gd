extends Node2D

var TrackedData : Array[tracked_data] = []
var created_ghost = null
@export var GhostScene : PackedScene
var shouldInteract = false
	
func TrackData():
	var data : tracked_data = tracked_data.new()
	data.position = global_position
	data.interact = shouldInteract
	
	shouldInteract = false
	
	TrackedData.push_back(data)

func _physics_process(delta):
	TrackData()
	
func _process(delta):		
	if (Input.is_action_just_pressed("ui_text_completion_accept")):
		get_parent().global_position = TrackedData[0].position
		CreateGhost();
		Restart();
		
func CreateGhost():
	if created_ghost != null:
		created_ghost.queue_free()
	
	created_ghost = GhostScene.instantiate()
	get_tree().current_scene.add_child(created_ghost)
	created_ghost.get_node("PlaybackController").TrackedData = TrackedData
	created_ghost.Restart()
	
func Restart():
	get_tree().call_group("RestartNode", "Restart")

func Interact():
	shouldInteract = true
