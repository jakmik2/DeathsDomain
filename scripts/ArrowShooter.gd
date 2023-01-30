extends Node2D
var bullet = preload("res://scenes/Bullet.tscn")
var triggers = []
var bullet_speed = 200
var can_fire = false

func _ready():
	triggers = get_node("Triggers").get_children()
	Global.connect("lever_changed", self, "shoot")

func shoot(instance_id):
	for trigger in triggers:
		if trigger.get_instance_id() == instance_id:
			can_fire = true
			
	if !can_fire:
		return
	
	var position = self.get_global_position()
	position.x -= 18
	position.y -= 35
	
	var bullet_instance = bullet.instance()
	bullet_instance.init("TM-Walls", "Injurable")
	bullet_instance.position = position
	bullet_instance.rotation = -PI/4
	# bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(PI-.48))
	get_tree().get_root().add_child(bullet_instance)
	can_fire = false
