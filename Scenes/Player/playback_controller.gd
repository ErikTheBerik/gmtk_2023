extends Node2D

@export var player_path : NodePath
@onready var player = get_node_or_null(player_path)

var TrackedData: Array[tracked_data]

var is_playing = false
var index = 0
var playbackDirection = 0
var playbackTimer = 0.0;
var playbackRate = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if (!is_playing):
		return;
	
	var currentData = TrackedData[index];
	if (currentData.interact):
		get_parent().get_node("ObjectDetector").Interact();
		
	playbackTimer += delta * playbackRate
	get_parent().global_position = lerp(get_parent().global_position, currentData.position, playbackTimer/delta)
	
	# physics are run at a fixed delta
	if (playbackTimer >= delta):
		index += playbackDirection
		playbackTimer -= delta
		
	if (index <= 0 && playbackDirection == -1):
		playbackDirection = 1
		index = 0
	elif (index >= TrackedData.size()-1 && playbackDirection == 1):
		playbackDirection = -1
		index = TrackedData.size()-1

func Playback():
	is_playing = true
	index = TrackedData.size() - 1
	playbackDirection = -1
	playbackTimer = 0
	get_parent().global_position = TrackedData[index].position
