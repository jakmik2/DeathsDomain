extends Node2D

export var fire_rate = 0.2

var bullet = preload("res://scenes/Bullet.tscn")
var can_fire = true

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
	
	# Remove Camera shaking at transition
	if fmod(abs(rotation_degrees), 360) < 265 or fmod(abs(rotation_degrees), 360) > 285:
		Global.set_camera_offset(pos)
	
	
	if Input.is_action_pressed("fire") and can_fire and self.get_owner().bullets > 0:
		anim.play("recoil")
		Global.play_camera_anim("recoil")
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
		anim.play("idle")
	
	
