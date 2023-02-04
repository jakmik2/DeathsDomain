extends Node2D

var player = false

export var text_content = "Placeholder Text"

export var automatic_trigger = false

var triggered = false

func _process(delta):
	if player and (Input.is_action_pressed("use") or automatic_trigger) and !triggered:
		Global.popup(text_content)
		triggered = true


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = false
		triggered = false
