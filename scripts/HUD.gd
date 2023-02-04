extends CanvasLayer

onready var bandage_counter = get_node("Bandages/Count")
onready var bullets_counter = get_node("Bullets/Count")
onready var health_text = get_node("Health/Status")

func _ready():
	Global.connect("update_hud", self, "update_hud")

func update_hud(item, val):
	match item:
		"bandages":
			bandage_counter.text = val
		"bullets":
			bullets_counter.text = val
		"health":
			health_text.text = val
