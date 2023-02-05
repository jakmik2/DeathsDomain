extends Node2D

var current_health = 4
var bullets = 0
var bandages = 0

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

func reset():
	current_health = 4
	bullets = 0
	bandages = 0

func lever_changed(string):
	emit_signal("lever_changed", string)

func pick_up(item):
	emit_signal("pick_up", item)

func toggle_shake(amt=1, axis=0):
	emit_signal("toggle_shake", amt, axis)

func update_hud(item, val):
	emit_signal("update_hud", item, val)
	match item:
		"bandages":
			bandages = int(val)
			emit_signal("update_hud", item, val)	
		"bullets":
			bullets = int(val)
			emit_signal("update_hud", item, val)
		"health":
			match val:
				3, 4:
					emit_signal("update_hud", item, "FINE")
				1, 2:
					emit_signal("update_hud", item, "WOUNDED")
				0:
					emit_signal("update_hud", item, "DEAD")

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
