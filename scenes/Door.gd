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

func check_code():
	var code_from_levers = ""
	for lever in levers:
		code_from_levers += lever.state

	if code == code_from_levers:
		$"StaticBody2D/CollisionPolygon2D".disabled = true
		anim.play("Open")
		status = "openned"
	elif status == "openned":
		anim.play("Close")
		status = "closed"
		$"StaticBody2D/CollisionPolygon2D".disabled = false
	else:
		$"StaticBody2D/CollisionPolygon2D".disabled = false
