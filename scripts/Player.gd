extends KinematicBody2D

var speed = 100

func _physics_process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_and_slide(velocity, Vector2(0, -1))


func _ready():
	pass
