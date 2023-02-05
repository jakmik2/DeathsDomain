extends Node2D

var player = false

export var text_content = ""
# Multi container text can be sent delimited by {split} per container

export var automatic_trigger = false

export var deactivate_after_use = false

var deactivated = false

var triggered = false

func _process(delta):
	if player and (Input.is_action_pressed("use") or automatic_trigger) and !triggered and !deactivated:
		Global.popup(text_content)
		triggered = true
		if deactivate_after_use:
			deactivated = true


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = false
		triggered = false
