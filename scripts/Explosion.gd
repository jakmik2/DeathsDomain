extends Node2D

var supplied_pos

func _ready():
	self.global_position = supplied_pos
	self.global_position = Vector2(2 * self.global_position.x - $"Sprite".global_position.x, 2 * self.global_position.y - $"Sprite".global_position.y)
	$"AnimationPlayer".play("explosion")
	yield ($"AnimationPlayer", "animation_finished")
	queue_free()
