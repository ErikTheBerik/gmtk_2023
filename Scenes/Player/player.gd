extends CharacterBody2D

@export var max_speed : int = 1000
@export var gravity : float = 55
@export var jump_force : int = 1600
@export var jump_stop_force : int = 500
@export var acceleration : int = 50
@export var jump_buffer_time : int  = 15
@export var coyote_time : int = 15

var jump_buffer_counter : int = 0
var coyote_counter : int = 0

func _physics_process(delta):
	
	if is_on_floor():
		coyote_counter = coyote_time
	else:
		if coyote_counter > 0:
			coyote_counter -= 1
		
		velocity.y += gravity * delta

	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x += acceleration * direction * delta
	else:
		velocity.x = lerp(velocity.x,0.0,0.2)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		coyote_counter = 0
	
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y += jump_stop_force
	
	move_and_slide()
