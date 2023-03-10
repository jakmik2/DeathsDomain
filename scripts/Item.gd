extends Node2D

export var item_name = "Default"
export var count = 1

var player = false

var activated = false

func _process(delta):
	if player and Input.is_action_just_pressed("use") and !activated:
		activated = true
		$"PickUpSound".play()
		Global.pick_up({item_name : self.count})
		yield ($"PickUpSound", "finished")
		queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = false

