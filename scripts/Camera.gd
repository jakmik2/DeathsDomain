extends Camera2D

var shaking = false
var amt
var axis

var current_anim

func _ready():
	Global.connect("toggle_shake", self, "toggle_shake")
	Global.connect("set_camera_offset", self, "set_camera_offset")
	Global.connect("play_camera_anim", self, "play_anim")

	
	play_anim("idle")
	current_anim = "idle"
	$"ColorRect".visible = true

func _process(delta):
	if shaking:
		shake_camera()

func pulse(magnitude):
	set_zoom(Vector2(magnitude, magnitude))

func toggle_shake(amt_val, axis_val):
	shaking = !shaking
	amt = amt_val
	axis = axis_val

func shake_camera():
	var offset
	
	if axis == 0:
		offset = Vector2( \
			rand_range(-1.0, 1.0) * amt, \
			rand_range(-1.0, 1.0) * amt \
		)
	elif axis == 1:
		offset = Vector2( \
			rand_range(-1.0, 1.0) * amt, \
			rand_range(-0.1, 0.1) * amt \
		)
	elif axis == 2:
		offset = Vector2( \
			rand_range(-1.0, 1.0) * amt \
		)
	
	self.set_offset(offset)

func set_camera_offset(pos):
	self.global_position = pos

func play_anim(anim):
	$"ScreenAnimation".play(anim)
	yield($"ScreenAnimation", "animation_finished")
	$"ScreenAnimation".play("idle")


