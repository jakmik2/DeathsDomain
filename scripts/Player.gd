extends KinematicBody2D

enum {DEAD, WOUNDED, FINE, SICK}

# Player Statistics
var max_speed = 100
var current_speed = 100
var max_health = 4
var current_health = 4
var status = FINE

# Player Inventory
export var bandages = 0
export var bullets = 5

# For Conditions
var limp_timer = 0
var pulse_timer = 0

# Necessary Nodes
onready var camera = get_node("PlayerCam")
onready var camera_anim = get_node("PlayerCam/ScreenAnimation")
onready var health_node = get_node("PlayerCam/HUD/Health/Status")

# Inventory Tracker
onready var bandage_node = get_node("PlayerCam/HUD/Bandages/Count")
onready var bullets_node = get_node("PlayerCam/HUD/Bullets/Count")

func _ready():
	$"AnimationPlayer".play("idle")
	Global.connect("pick_up", self, "pick_up")

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
	
	eval_status(delta)
	update_inventory()

func _physics_process(delta):
	var velocity = Vector2()
	
	if status == WOUNDED:
		limp_timer += delta
		
	if Input.is_action_just_pressed("heal") and current_health < max_health and bandages > 0:
		$"AnimationPlayer".play("heal")
		yield ($"AnimationPlayer", "animation_finished")
		bandages -= 1
		current_health += 1
		$"AnimationPlayer".play("idle")
		return
	
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
		elif limp_timer > 0.8:
			current_speed = max_speed
			limp_timer = 0

		velocity = velocity.normalized() * current_speed

		move_and_slide(velocity, Vector2(0, -1))

func update_inventory():
	bandage_node.text = str(bandages)
	bullets_node.text = str(bullets)

func pick_up(item):
	match item:
		{"bandage": var x}:
			bandages += x
		{"bullets": var x}:
			bullets += x

func pulse(magnitude):
	camera.set_zoom(Vector2(magnitude, magnitude))

func shake_camera(amt=2):
	camera.set_offset(Vector2( \
		rand_range(-1.0, 1.0) * amt, \
		rand_range(-1.0, 1.0) * amt \
	))

func eval_status(delta):
	match status:
		FINE:
			health_node.text = "FINE"
		WOUNDED:
			# Set camera to wounded state
			pulse_timer += delta
			if pulse_timer > 0.6 and pulse_timer < 1:
				pulse(1 - (0.8 - pulse_timer) / 20)
				camera_anim.play("Pain")
			elif pulse_timer > 1:
				pulse(1)
				pulse_timer = 0
			health_node.text = "WOUNDED"
		SICK:
			pass # Set camera to sick state sick state
		DEAD:
			pass # Activate dead process

func hurt(dmg):
	current_health -= dmg
