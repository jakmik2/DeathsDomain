extends Node2D

export var state = "0"

var player = false

func _ready():
	if state == "0":
		$Sprite.set_frame(0)
	else:
		$Sprite.set_frame(1)
		
	

func _process(delta):
	if player and Input.is_action_just_pressed("use"):
		$"AudioStreamPlayer2D".play()
		if state == "0":
			state = "1"
		else:
			state = "0"
		Global.lever_changed(self.get_instance_id())
		yield(get_tree().create_timer($"AudioStreamPlayer2D".stream.get_length()), "timeout")
		if $"AudioStreamPlayer2D".playing:
			$"AudioStreamPlayer2D".stop()
	if state == "1":
		$Sprite.set_frame(0)
	else:
		$Sprite.set_frame(1)



func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = false

