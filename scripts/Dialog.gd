extends CanvasLayer

onready var window_dialog = get_node("DialogTex")
onready var window_text = get_node("DialogTex/RichTextLabel")

var queue = []
var ptr = 0

func _ready():
	Global.connect("popup", self, "popup")
	self.visible = false

func popup(text):
	queue = text.split("{split}")
	window_text.text = queue[ptr]
	Global.deactivate()
	if !self.visible:
		self.visible = true
	ptr += 1

func _on_Button_pressed():
	if ptr > len(queue) - 1:
		Global.deactivate()
		self.visible = false
	else:
		window_text.text = queue[ptr]
		ptr += 1
