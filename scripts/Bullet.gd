extends RigidBody2D

export var atk_pwr = 1

var explosion = preload("res://scenes/Explosion.tscn")

var bullet_speed = 2000

var originator
var target_group
var supplied_pos
var supplied_rot

func _ready():
	global_position = supplied_pos
	rotation = supplied_rot
	self.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(supplied_rot))
	
	# Offest bullet location
	self.global_position = Vector2(2 * self.global_position.x - $"BulletSprite".global_position.x, 2 * self.global_position.y - $"BulletSprite".global_position.y)	
	# Offset Terrain Collider
	$"TerrainCollider".global_position = Vector2($"BulletSprite".global_position.x, $"BulletSprite".global_position.y + 15)

func destroy():
	queue_free()

func _on_BulletCollider_body_entered(body):
	# Handle HitBox
	if body.name == "Player":
		return
	
	if !body.is_in_group(originator) and body.name != "TM-Walls":
		destroy()
		
	if body.is_in_group(target_group) and !body.is_in_group(originator) and !body.is_in_group("cannot_damage"):
		# Access enemy script and apply damage
		body.get_owner().hurt(atk_pwr)

func _on_TerrainCollider_body_entered(body):
	if body.name == "TM-Walls":
		destroy()
