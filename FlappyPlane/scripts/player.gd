extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLY_SPEED : int = -500
const START_POS = Vector2(147, 218)

var flying : bool = false
var falling : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	animation.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			animation.play()
			
		elif falling:
			set_rotation(PI/2)
			animation.stop()
			
		move_and_collide(velocity * delta)

func fly_up():
	velocity.y = FLY_SPEED
