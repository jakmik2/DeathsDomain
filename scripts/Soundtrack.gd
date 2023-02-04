extends AudioStreamPlayer2D

onready var tween_out = get_node("Tween")

var transition_duration = 1.0
var transition_type = 1 # TRANS_SINE

var actively_playing

func _ready():
	Global.connect("fade_volume", self, "fade_volume")
	fade_in()
	
func fade_volume(direction):
	if direction == "in":
		fade_in()
	if direction == "out":
		fade_out()
		
func fade_in():
	tween_out.interpolate_property(self, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

	actively_playing = true
	
func fade_out():
	tween_out.interpolate_property(self, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

	actively_playing = false

func _on_Tween_tween_completed(object, key):
	if !actively_playing:
		object.stop()
