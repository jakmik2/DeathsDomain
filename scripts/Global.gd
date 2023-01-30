extends Node2D

signal lever_changed(value)

func lever_changed(string):
	emit_signal("lever_changed", string)
