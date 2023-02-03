extends Node2D

export var state = "0"
export var permanence = false

var stream_len

func _ready():
	$"Sprite".set_frame(0)
	stream_len = $"AudioStreamPlayer2D".stream.get_length()

func _on_Area2D_body_entered(body):
	if body.name == "Player" and state == "0":
		$"AudioStreamPlayer2D".play()
		$"Sprite".set_frame(1)
		state = "1"
		Global.lever_changed(self.get_instance_id())
		yield(get_tree().create_timer(stream_len), "timeout")
		if $"AudioStreamPlayer2D".playing:
			$"AudioStreamPlayer2D".stop()

func _on_Area2D_body_exited(body):
	if body.name == "Player" and state == "1":
		if !permanence:
			$"Sprite".set_frame(0)
			state = "0"
			Global.lever_changed(self.get_instance_id())
