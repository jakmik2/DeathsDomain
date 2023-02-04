extends Node2D

export var nextLevel = ""

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Global.play_camera_anim("fade_to_black")
		Global.fade_volume("out")
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://scenes/Levels/" + nextLevel + ".tscn")
