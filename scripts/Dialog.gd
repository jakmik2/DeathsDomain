extends CanvasLayer

onready var window_dialog = get_node("DialogTex")
onready var window_text = get_node("DialogTex/RichTextLabel")

func _ready():
	Global.connect("popup", self, "popup")
	self.visible = false

func popup(text):
	window_text.text = text
	Global.deactivate()
	self.visible = true

func _on_Button_pressed():
	Global.deactivate()
	self.visible = false
