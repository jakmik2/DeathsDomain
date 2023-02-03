extends Node2D

export var code = "0"
var status = "closed"
var code_from_levers = ""
var levers = []

onready var anim = get_node("AnimationPlayer")

func _ready():
	levers = get_node("Levers").get_children()
	$"StaticBody2D/CollisionPolygon2D".disabled = false
	
	Global.connect("lever_changed", self, "check_code")
	
func check_code(instance_id):
	var code_from_levers = ""
	var in_levers = false
	
	for lever in levers:
		code_from_levers += lever.state
		if lever.get_instance_id() == instance_id:
			in_levers = true
	
	if !in_levers:
		return

	if code == code_from_levers:
		$"StaticBody2D/CollisionPolygon2D".set_deferred("disabled", true)
		$"AudioStreamPlayer2D".play()
		anim.play("Open")
		status = "openned"
		yield(anim,"animation_finished")
		$"AudioStreamPlayer2D".stop()
	elif status == "openned":
		$"AudioStreamPlayer2D".play()
		anim.play("Close")
		status = "closed"
		yield(anim,"animation_finished")
		$"AudioStreamPlayer2D".stop()
		$"StaticBody2D/CollisionPolygon2D".set_deferred("disabled", false)
	else:
		$"StaticBody2D/CollisionPolygon2D".set_deferred("disabled", false)
