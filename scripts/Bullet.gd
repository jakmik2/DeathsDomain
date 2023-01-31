extends RigidBody2D

export var atk_pwr = 1

var explosion = preload("res://scenes/Explosion.tscn")

var originator
var target_group

func init(from, target):
	originator = from
	target_group = target
	
func _ready():
	$"TerrainCollider".global_position = Vector2(self.global_position.x, self.global_position.y + 15)

func destroy():
	var explosion_instance = explosion.instance()
	explosion_instance.position = get_global_position()
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
