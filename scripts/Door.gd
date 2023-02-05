extends Node2D

export var code = "0"
var status = "closed"
var changing = false
var code_from_levers = ""
var levers = []

var evaluating_response = false

onready var anim = get_node("AnimationPlayer")

func _ready():
	levers = get_node("Levers").get_children()
	$"StaticBody2D/CollisionPolygon2D".disabled = false
	
	Global.connect("lever_changed", self, "check_code")
	
func check_code(instance_id):
	if evaluating_response:
		return
	evaluating_response = true
	var code_from_levers = ""
	var in_levers = false
	
	for lever in levers:
		code_from_levers += lever.state
		if lever.get_instance_id() == instance_id:
			in_levers = true
	
	if !in_levers:
		return

	if code == code_from_levers:
		changing = true		
		$"StaticBody2D/CollisionPolygon2D".set_deferred("disabled", true)
		status = "openned"
		$"AudioStreamPlayer2D".play()
		anim.play("Open")
		yield(anim,"animation_finished")
		$"AudioStreamPlayer2D".stop()
		changing = false
	elif status == "openned":
		changing = true
		status = "closed"
		$"AudioStreamPlayer2D".play()
		anim.play("Close")
		yield(anim,"animation_finished")
		$"AudioStreamPlayer2D".stop()
		$"StaticBody2D/CollisionPolygon2D".set_deferred("disabled", false)
		changing = false
	else:
		$"StaticBody2D/CollisionPolygon2D".set_deferred("disabled", false)
		
	evaluating_response = false
