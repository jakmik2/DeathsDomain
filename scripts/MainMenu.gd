extends Control

func _ready():
	$"VBoxContainer/StartButton".grab_focus()


func _on_StartButton_pressed():
	Global.reset()
	Global.play_camera_anim("fade_to_black")
	yield(get_tree().create_timer(0.15), "timeout")
	get_tree().change_scene("res://scenes/Levels/Level_1.tscn")
	Global.play_camera_anim("fade_from_black")
	
func _on_OptionsButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_tree().quit()
