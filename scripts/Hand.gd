extends Node2D

export var bullet_speed = 10
export var fire_rate = 0.2

var bullet = preload("res://scenes/Bullet.tscn")
var can_fire = true


func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("fire") and can_fire and self.get_owner().bullets > 0:
		var bullet_instance = bullet.instance()
		bullet_instance.originator = "player"
		bullet_instance.target_group = "Enemy"
		bullet_instance.supplied_pos = $HandBulletBox.global_position
		bullet_instance.supplied_rot = rotation
		get_tree().root.get_node("/root/Labyrinth/YSort").call_deferred("add_child", bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		self.get_owner().bullets -= 1
		can_fire = true
