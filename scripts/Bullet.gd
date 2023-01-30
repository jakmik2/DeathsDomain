extends RigidBody2D

export var atk_pwr = 1

var explosion = preload("res://scenes/Explosion.tscn")

var originator
var target_group

func init(from, target):
	originator = from
	target_group = target

func _on_Bullet_body_entered(body):
	print(body.name)
	if body.name != originator:
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		
	if body.is_in_group(target_group):
		# Access enemy script and apply damage
		body.get_owner().hurt(atk_pwr)
