extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for item in $Detect.get_overlapping_bodies():
		if item.is_in_group("edible"):
			item.wasGrabbed = true
			item.global_position += ($Eat.global_position - item.global_position).normalized() * 50
	
	for item in $Eat.get_overlapping_bodies():
		if item.is_in_group("edible"):
			Globals.hunger = min(100, Globals.hunger + item.hungerRestore)
			item.queue_free()
