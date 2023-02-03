extends Node2D

func _ready():
	Global.connect("click", self, "click")

func _process(delta):
	Input.set_custom_mouse_cursor($"AnimatedSprite".frames.get_frame($"AnimatedSprite".animation, $"AnimatedSprite".frame), Input.CURSOR_ARROW, Vector2($"AnimatedSprite".frames.get_frame($"AnimatedSprite".animation, $"AnimatedSprite".frame).get_width(), $"AnimatedSprite".frames.get_frame($"AnimatedSprite".animation, $"AnimatedSprite".frame).get_height()) / 2)

func click():
	$"AnimatedSprite".animation = "click"
	yield($"AnimatedSprite", "animation_finished")
	$"AnimatedSprite".animation = "idle"
