extends Node2D

signal lever_changed(value)
signal pick_up(value)
signal deactivate()

signal toggle_shake(value, axis)

signal update_hud(item, val)

signal set_camera_offset(pos)
signal play_camera_anim(anim)

signal fade_volume(direction)

signal click()

signal popup(text)

func lever_changed(string):
	emit_signal("lever_changed", string)

func pick_up(item):
	emit_signal("pick_up", item)

func toggle_shake(amt=1, axis=0):
	emit_signal("toggle_shake", amt, axis)

func update_hud(item, val):
	emit_signal("update_hud", item, val)

func set_camera_offset(pos):
	emit_signal("set_camera_offset", pos)

func play_camera_anim(anim):
	emit_signal("play_camera_anim", anim)

func click():
	emit_signal("click")

func fade_volume(direction):
	emit_signal("fade_volume", direction)

func popup(text):
	emit_signal("popup", text)
	
func deactivate():
	emit_signal("deactivate")
