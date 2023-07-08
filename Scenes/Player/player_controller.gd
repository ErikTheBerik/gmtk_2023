extends Node2D

@export var player_path : NodePath
# Movement
@export var max_speed : int = 2000

@export var max_acceleration = 8000
@export var max_deceleration = 6000
@export var max_turn_speed = 18000

@export var max_air_acceleration = 5000
@export var max_air_deceleration = 5000
@export var max_air_turn_speed = 20000

# Jump
@export var max_jump_count : int = 2

@export var gravity : float = 8000
@export var first_jump_force : int = 2500
@export var extra_jump_force : int = 2000
@export var jump_stop_force : int = 1000

# Jump Buffers
@export var jump_buffer_time : float  = 0.2
@export var coyote_time : float = 0.1


@onready var body = get_node_or_null(player_path)

signal StartJump
signal StartUp
signal StartDown
signal Land
signal Stoped
signal StartMove

var jump_buffer_counter : float = 0.0
var coyote_counter : float = 0.0
var current_jumps : int = max_jump_count

var last_velocity : Vector2 = Vector2.ZERO
		
func _physics_process(delta):
	if (!body):
		return;
		
	HandleJump(delta)
	HandleMove(delta)
	
	if (Input.is_action_just_pressed("interact")):
		get_parent().get_node("PlayerTracker").Interact()
		get_parent().get_node("ObjectDetector").Interact()
	
	if (sign(last_velocity.y) != sign(body.velocity.y)):
		if (body.velocity.y < 0.0):
			StartUp.emit()
		elif (body.velocity.y > 0.0):
			StartDown.emit();
		else:
			Land.emit()
			
	if (sign(last_velocity.x) != sign(body.velocity.x)):
		if (body.velocity.x == 0.0):
			Stoped.emit()
		else:
			StartMove.emit()
	
	last_velocity = body.velocity
	body.move_and_slide()

func HandleMove(delta):
	var directionX = Input.get_axis("move_left", "move_right")
	var desiredVelocity = max_speed * directionX

	var acceleration = max_acceleration if body.is_on_floor() else max_air_acceleration
	var deceleration = max_deceleration if body.is_on_floor() else max_air_deceleration
	var turnSpeed = max_turn_speed if body.is_on_floor() else max_air_turn_speed
	
	var maxSpeedChange = 0
	
	if (directionX):
		if (body.velocity.x && sign(directionX) != sign(body.velocity.x)):
			maxSpeedChange = turnSpeed * delta
		else:
			maxSpeedChange = acceleration * delta
	else:
		maxSpeedChange = deceleration * delta
		
	body.velocity.x = move_toward(body.velocity.x, desiredVelocity, maxSpeedChange)

func HandleJump(delta):
	if (body.is_on_floor()):
		current_jumps = max_jump_count
		coyote_counter = coyote_time
	
	if ((body.is_on_floor() && jump_buffer_counter > 0) || Input.is_action_just_pressed("jump")):
		Jump()
		
	if Input.is_action_just_released("jump"):
		if body.velocity.y < 0:
			body.velocity.y = min(0.0, body.velocity.y + jump_stop_force)
	
	if body.is_on_floor():
		jump_buffer_counter = 0
	else:
		body.velocity.y += gravity * delta
		if jump_buffer_counter > 0:
			jump_buffer_counter -= delta
		if coyote_counter > 0:
			coyote_counter -= delta
			if coyote_counter <= 0:
				current_jumps -= 1

func Jump():
	if (current_jumps <= 0):
		jump_buffer_counter = jump_buffer_time
		return
	
	StartJump.emit()
	
	var jump_force = first_jump_force if current_jumps == max_jump_count else extra_jump_force
	body.velocity.y = -jump_force
	current_jumps -= 1
	jump_buffer_counter = 0
	coyote_counter = 0
