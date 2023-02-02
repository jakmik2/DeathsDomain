extends Node2D


func _process(delta):
	look_at(get_global_mouse_position())
	Global.set_camera_offset($"Pointer".global_position)
