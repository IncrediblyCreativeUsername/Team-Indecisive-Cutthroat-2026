extends Node2D

func _ready() -> void:
	updateHat()

func updateHat():
	for x in Globals.hatCount:
		get_child(x).visible = x == Globals.playerHatNum
