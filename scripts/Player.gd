extends KinematicBody2D

var speed = 100
var bullet_speed = 1000

var bullet = preload("res://scenes/Bullet.tscn")


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


func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("fire"):
		var bullet_instance = bullet.instance()
		bullet_instance.position = get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)

func _ready():
	pass
