extends Node

signal lever_changed

func lever_changed():
	emit_signal("lever_changed")
