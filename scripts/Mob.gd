extends KinematicBody2D

onready var anim = get_node("AnimationPlayer")
onready var sprite_body = get_node("Sprite")
onready var detection_radius = get_node("DetectionRadius")
onready var navigation_agent = get_node("NavigationAgent2D")

export var health = 2

var speed = 75
var player = null
var alert_loc = Vector2.ZERO
var attacking = false
var resetting = false
var atk_rate = 0.3

var reset_time = 0

var alive = true

var atk_pwr = 1

# AI
var strategy = "follow"

# Sounds
onready var idle_stream = get_node("Sounds/Idle")

func _ready():
	anim.play("Idle")
	idle_stream.play()
	navigation_agent.set_target_location(global_position)
	
func _process(delta):
	if health == 0 and alive:
		death()
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished() or !alive or attacking:
		return
	
	var targetpos = navigation_agent.get_next_location()
	var direction = global_position.direction_to(targetpos)
	var velocity = direction * speed
	
	if strategy == "reset":
		reset_time += delta
		velocity *= -1
		if reset_time > 0.5:
			strategy = "follow"
			reset_time = 0
			resetting = false
	
	if velocity. x < 0:
		$"Sprite".scale.x = -1
	else:
		$"Sprite".scale.x = 1
	
	if abs(velocity.x) > 0:
		$"AnimationPlayer".play("walk")
	
	move_and_slide(velocity)
	
func hurt(dmg):
	if health > 0:
		health -= dmg
		anim.play("Hurt")
		yield(anim, "animation_finished")
		anim.play("Idle")

func death():
	anim.play("Death")
	alive = false
	$"HitBox/CollisionShape2D".disabled = true
	$"AttackRadius/CollisionShape2D".disabled = true
	$"TerrainCollider".disabled = true
	$"Sprite/HurtBox/CollisionShape2D".disabled
	yield(anim, "animation_finished")
	anim.play("Dead")
	idle_stream.stop()

func alert(pos):
	strategy = "alerted"
	navigation_agent.set_target_location(pos)
	
func within_range():
	return navigation_agent.is_navigation_finished()

func _on_Detection_radius_body_entered(body):
	if body.name == "Player":
		navigation_agent.set_target_location(body.global_position)

func _on_Detection_radius_body_exited(body):
	if body.name == "Player":
		navigation_agent.set_target_location(global_position)

func _on_AttackRadius_body_entered(body):
	if body.name == "Player":
		attacking = true
		anim.play("Attack")
		yield(anim, "animation_finished")
		attacking = false
		anim.play("Idle")

func _on_HurtBox_body_entered(body):
	get_node("Sprite/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	if body.name == "Player" and alive:
		body.hurt(atk_pwr)
		strategy = "reset"
		
func _on_AttackRadius_body_exited(body):
	if body.name == "Player":
		yield(get_tree().create_timer(atk_rate), "timeout")
		resetting = false
		strategy = "follow"
