extends Node2D

signal lever_changed(value)

signal pick_up(value)

func lever_changed(string):
	emit_signal("lever_changed", string)

func pick_up(item):
	emit_signal("pick_up", item)
