extends Node2D
var bullet = preload("res://scenes/Bullet.tscn")
var triggers = []
var can_fire = false

func _ready():
	triggers = get_node("Triggers").get_children()
	Global.connect("lever_changed", self, "shoot")

func shoot(instance_id):
	for trigger in triggers:
		if trigger.get_instance_id() == instance_id and trigger.state == "1":
			can_fire = true
			
	if !can_fire:
		return
	
	var position = $".".get_global_position()
	position.x -= 20
	position.y -= 20
	
	var bullet_instance = bullet.instance()
	bullet_instance.originator = ""
	bullet_instance.target_group = "Injurable"
	bullet_instance.supplied_pos = position
	bullet_instance.supplied_rot = 27*PI/32
	get_tree().root.get_node("/root/Labyrinth/YSort").call_deferred("add_child", bullet_instance)
	can_fire = false
