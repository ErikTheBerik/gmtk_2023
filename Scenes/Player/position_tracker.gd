extends Node2D

var TrackedData : Array[tracked_data] = []
@export var GhostScene : PackedScene

func TrackData():
	var data : tracked_data = tracked_data.new()
	data.position = global_position
	
	TrackedData.push_back(data)

func _physics_process(delta):
	TrackData()
	
func _process(delta):		
	if (Input.is_action_just_pressed("ui_text_completion_accept")):
		get_parent().global_position = TrackedData[0].position
		CreateGhost();
		Reset();
		
func CreateGhost():
	var ghost = GhostScene.instantiate()
	get_tree().current_scene.add_child(ghost)
	ghost.get_node("PlaybackController").TrackedData = TrackedData
	ghost.get_node("PlaybackController").Playback()
	
func Reset():
	TrackedData = [];
