extends AnimatedSprite2D

var going_up : bool = true
var moving : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    play("idle")
    connect("animation_finished", Callable(self, "OnAnimationFinished"))

func OnAnimationFinished():
    if (animation == "start_jump"):
        if going_up:
            play("air_up")
        else:
            play("air_down")
    elif (animation == "land"):
        if !moving:
            play("idle")
        else:
            play("walk")

func _process(delta):
    moving = get_parent().velocity.x != 0.0
    if (get_parent().velocity.x > 5.0):
        flip_h = false
    elif (get_parent().velocity.x < -5.0):
        flip_h = true

func OnLand():
    frame = 0
    play("land")

func OnStartJump():
    pass;

func OnGoingUp():
    going_up = true
    if (animation == "start_jump"):
        return;
    
    frame = 0
    play("air_up")
    
func OnGoingDown():
    going_up = false
    if (animation == "start_jump"):
        return;
        
    frame = 0
    play("air_down")
    
func OnStoped():
    if (animation == "land"):
        return;
    
    play("idle")

func OnStartMove():
    play("walk")
