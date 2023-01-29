extends KinematicBody2D

enum {DEAD, WOUNDED, FINE, SICK}

var max_speed = 100
var current_speed = 100
var max_health = 4
var current_health = 4
var status = FINE

# For Conditions
var limp_timer = 0

onready var camera = get_node("Camera2D")

func _process(delta):
	# Check Status of player
	if current_health == max_health:
		status = FINE
		max_speed = 100
	elif current_health <= int(round(max_health / 2)):
		status = WOUNDED
		max_speed = 60
	elif current_health == 0:
		status = DEAD
		
func _physics_process(delta):
	var velocity = Vector2()
	
	if status == WOUNDED:
		limp_timer += delta
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		
	if velocity.length() > 0:
		if limp_timer > 0.4 and limp_timer < 0.8:
			current_speed = max_speed / 20
			shake_camera(0.5)
		elif limp_timer > 0.9:
			current_speed = max_speed
			limp_timer = 0

		velocity = velocity.normalized() * current_speed

		move_and_slide(velocity, Vector2(0, -1))

func shake_camera(amt=2):
	camera.set_offset(Vector2( \
		rand_range(-1.0, 1.0) * amt, \
		rand_range(-1.0, 1.0) * amt \
	))

func eval_status():
	match status:
		WOUNDED:
			pass # Set camera to wounded state
		SICK:
			pass # Set camera to sick state sick state
		DEAD:
			pass # Activate dead process

func _ready():
	pass
