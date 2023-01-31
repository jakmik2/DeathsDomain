extends Node2D

export var state = "0"
export var permanence = false

func _ready():
	$"Sprite".set_frame(0)

func _on_Area2D_body_entered(body):
	if body.name == "Player" and state == "0":
		$"Sprite".set_frame(1)
		state = "1"
		Global.lever_changed(self.get_instance_id())


func _on_Area2D_body_exited(body):
	if body.name == "Player" and state == "1":
		if !permanence:
			$"Sprite".set_frame(0)
			state = "0"
			Global.lever_changed(self.get_instance_id())
