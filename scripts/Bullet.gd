extends Node2D

export var atk_pwr = 1

var explosion = preload("res://scenes/Explosion.tscn")

var originator
var target_group

func init(from, target):
	originator = from
	target_group = target


func _on_BulletCollider_area_entered(area):
	print(area.name)
	if area.name != originator and area.name != "BulletCollider":
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		
	if area.is_in_group(target_group) and !area.get_owner().is_in_group(originator):
		# Access enemy script and apply damage
		area.get_owner().hurt(atk_pwr)
