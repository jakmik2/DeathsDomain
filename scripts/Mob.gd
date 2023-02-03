extends KinematicBody2D

onready var anim = get_node("AnimationPlayer")
onready var sprite_body = get_node("Sprite")
onready var detection_radius = get_node("DetectionRadius")

export var health = 2

var speed = 75
var motion = Vector2.ZERO
var player = null
var alert_loc = Vector2.ZERO
var attacking = false
var resetting = false
var atk_rate = 0.1

var alive = true


var atk_pwr = 1

# AI
var strategy = "follow"

func _ready():
	anim.play("Idle")
	
func _process(delta):
	if health == 0 and alive:
		death()
	
func _physics_process(delta):
	motion = Vector2.ZERO
	
	if !alive:
		return
	
	if attacking:
		return
	
	if player and strategy == "reset":
		motion = position.direction_to(player.position) * speed * -1
	elif player:
		motion = position.direction_to(player.position) * speed
		strategy = "follow"
	elif strategy == "alerted":
		motion = position.direction_to(alert_loc) * speed
	
	if strategy == "reset" and !resetting:
		resetting = true
		yield(get_tree().create_timer(atk_rate * 2), "timeout")
		strategy = "follow"
		resetting = false
		
	if strategy == "alerted" and within_range():
		strategy = "follow"
	
	if abs(motion.x) > 0:
		sprite_body.scale.x = sign(motion.x) * 1
	
	move_and_slide(motion)
	
func hurt(dmg):
	if health > 0:
		#Global.toggle_shake(5, 0)
		health -= dmg
		anim.play("Hurt")
		yield(anim, "animation_finished")
		#Global.toggle_shake(2, 1)
		anim.play("Idle")

func death():
	anim.play("Death")
	alive = false
	$"HitBox/CollisionShape2D".disabled = true
	$"AttackRadius/CollisionShape2D".disabled = true
	$"TerrainCollider".disabled = true
	yield(anim, "animation_finished")
	anim.play("Dead")

func alert(p):
	strategy = "alerted"
	alert_loc = p
	
func within_range():
	return position.x  < alert_loc.x + 10 and position.x > alert_loc.x - 10 and position.y < alert_loc.y + 10 and position.y > alert_loc.y - 10

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
	strategy = "reset"

func _on_AttackRadius_body_exited(body):
	if body.name == "Player":
		yield(get_tree().create_timer(atk_rate), "timeout")	
		strategy = "follow"
