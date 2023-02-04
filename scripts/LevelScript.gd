extends Node2D

func _ready():
	$"CanvasModulate".visible = true
	Global.play_camera_anim("fade_from_black")
	Global.fade_volume("in")
