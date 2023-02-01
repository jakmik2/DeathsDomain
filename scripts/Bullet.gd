extends RigidBody2D

export var atk_pwr = 1

var explosion = preload("res://scenes/Explosion.tscn")

var bullet_speed = 1200

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
	var explosion_instance = explosion.instance()
	explosion_instance.supplied_pos = $"BulletSprite".global_position
	get_tree().root.get_node("/root/Labyrinth/YSort").add_child(explosion_instance)
	queue_free()

func _on_BulletCollider_body_entered(body):
	# Handle HitBox
	if !body.is_in_group(originator) and body.name != "TM-Walls":
		destroy()
		
	if body.is_in_group(target_group) and !body.is_in_group(originator):
		# Access enemy script and apply damage
		body.get_owner().hurt(atk_pwr)

func _on_TerrainCollider_body_entered(body):
	if body.name == "TM-Walls":
		destroy()
