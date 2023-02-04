extends Node2D

export var fire_rate = 0.2

var bullet = preload("res://scenes/Bullet.tscn")
var can_fire = true

var enemies_in_range = []

var rot_coef = 0
var pos

onready var anim = get_node("AnimationPlayer")

func _ready():
	anim.play("idle")
	pos = $"HandBulletBox-L".global_position

func _process(delta):
	look_at(get_global_mouse_position())
	
	if fmod(abs(rotation_degrees), 360) > 85 and fmod(abs(rotation_degrees), 360) <= 275:
		rotation += PI
		rot_coef = PI
		pos = $"HandBulletBox-L".global_position
		$"HandSprite".flip_h = false
	else:
		$"HandSprite".flip_h = true
		rot_coef = 0
		pos = $"HandBulletBox-R".global_position
	
	if Input.is_action_pressed("fire") and can_fire and self.get_owner().bullets > 0:
		$"GunSound".play()
		anim.play("recoil")
		Global.play_camera_anim("recoil")
		Global.click()
		for enemy in enemies_in_range:
			enemy.alert(get_owner().global_position)
		
		var bullet_instance = bullet.instance()
		bullet_instance.originator = "player"
		bullet_instance.target_group = "Enemy"
		bullet_instance.supplied_pos = pos
		bullet_instance.supplied_rot = rotation - rot_coef
		get_tree().root.get_node("/root/Labyrinth/YSort").call_deferred("add_child", bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		#yield(anim, "animation_finished")
		self.get_owner().bullets -= 1
		yield(anim, "animation_finished")
		can_fire = true
		if $"GunSound".playing == true:
			$"GunSound".stop()
		anim.play("idle")

func _on_GunshotAlertRange_body_entered(body):
	if body.is_in_group("Enemy"):
		enemies_in_range.append(body.get_owner())

func _on_GunshotAlertRange_body_exited(body):
	if body.is_in_group("Enemy"):
		enemies_in_range.erase(body.get_owner())
