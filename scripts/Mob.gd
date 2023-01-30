extends KinematicBody2D

onready var anim = get_node("AnimationPlayer")
onready var body = get_node("Sprite")

var speed = 25
var motion = Vector2.ZERO
var player = null
var attacking = false

var atk_pwr = 1

onready var detection_radius = get_node("DetectionRadius")

func _ready():
	anim.play("Idle")

func _physics_process(delta):
	motion = Vector2.ZERO
	if player and !attacking:
		motion = position.direction_to(player.position) * speed
		
	if abs(motion.x) > 0:
		body.scale.x = sign(motion.x) * 1
	
	move_and_slide(motion)

func _on_Detection_radius_body_entered(body):
	if body.name == "Player":
		player = body

func _on_Detection_radius_body_exited(body):
	if body.name == "Player":
		player = null

func _on_AttackRadius_body_entered(body):
	if body.name == "Player":
		attacking = true
		anim.play("Attack")
		yield(anim, "animation_finished")
		attacking = false
		anim.play("Idle")

func _on_HurtBox_body_entered(body):
	get_node("Sprite/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	if body.name == "Player":
		body.hurt(atk_pwr)
		
