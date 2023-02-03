extends KinematicBody2D

enum {DEAD, WOUNDED, FINE, SICK}

# Player Statistics
var max_speed = 100
var current_speed = 100
var max_health = 4
var current_health = 4

var atk_pwr = 1

var status = FINE

# Action statuses
var shaking = false
var healing = false
var swinging = false

# Player Inventory
export var bandages = 3
export var bullets = 50

# For Conditions
var limp_timer = 0
var pulse_timer = 0

onready var camera = get_node("PlayerCam")

func _ready():
	$"AnimationPlayer".play("idle")
	Global.connect("pick_up", self, "pick_up")

func _process(delta):	
	# Check Status of player
	if current_health > int(round(max_health / 2)):
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
	var velocity = Vector2.ZERO
	
	if status == WOUNDED:
		limp_timer += delta
	else:
		if shaking:
			apply_camera_shake()
		limp_timer = 0
		current_speed = max_speed
	
	if healing:
		return
		
	if swinging:
		return
	
	if Input.is_action_just_pressed("heal") and current_health < max_health and bandages > 0:
		healing = true
		if shaking:
			apply_camera_shake()
		$"AnimationPlayer".play("heal")
		yield ($"AnimationPlayer", "animation_finished")
		healing = false
		bandages -= 1
		current_health += 1
		$"AnimationPlayer".play("idle")
		
	if Input.is_action_just_pressed("melee_attack"):
		swinging = true
		if get_local_mouse_position().x < 0:
			$"PlayerSprite".scale.x = 1
		else:
			$"PlayerSprite".scale.x = -1
		$"AnimationPlayer".play("attack")
		yield($"AnimationPlayer", "animation_finished")
		swinging = false
		$"AnimationPlayer".play("idle")
		$"PlayerSprite".scale.x = 1
	
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
			if !shaking:
				apply_camera_shake()			
		elif limp_timer > 0.8:
			current_speed = max_speed
			if shaking:
				apply_camera_shake()			
			limp_timer = 0

		velocity = velocity.normalized() * current_speed

		move_and_slide(velocity, Vector2(0, -1))

func update_inventory():
	Global.update_hud("bandages", str(bandages))
	Global.update_hud("bullets", str(bullets))

func pick_up(item):
	match item:
		{"bandage": var x}:
			bandages += x
		{"bullets": var x}:
			bullets += x

func eval_status(delta):
	match status:
		FINE:
			Global.update_hud("health", "FINE")
		WOUNDED:
			# Set camera to wounded state
			#pulse_timer += delta
			#if pulse_timer > 0.6 and pulse_timer < 1:
				#$"PlayerCam".pulse(1 - (0.8 - pulse_timer) / 20)
				#camera_anim.play("Pain")
			#elif pulse_timer > 1:
				#$"PlayerCam".pulse(1)
				#pulse_timer = 0
			Global.update_hud("health", "WOUNDED")
		SICK:
			pass # Set camera to sick state sick state
		DEAD:
			pass # Activate dead process

func hurt(dmg):
	current_health -= dmg
	#Global.toggle_shake()
	$"AnimationPlayer".play("hurt")
	yield($"AnimationPlayer", "animation_finished")
	#Global.toggle_shake()
	$"AnimationPlayer".play("idle")

func apply_camera_shake(amt=1,axis=0):
	Global.toggle_shake(amt, axis)
	shaking = !shaking

func _on_HurtBox_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hurt(atk_pwr)
