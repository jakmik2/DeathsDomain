extends Node2D

signal lever_changed

func lever_changed():
	emit_signal("lever_changed")
