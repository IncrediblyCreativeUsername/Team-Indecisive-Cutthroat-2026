extends Node2D

@onready var currentHat = get_child(0)

func _ready() -> void:
	updateHat()

func updateHat():
	for x in Globals.hatCount:
		get_child(x).visible = x == Globals.playerHatNum
		
		if (x == Globals.playerHatNum):
			currentHat = get_child(x)
			

func updateAnim(animName):
	currentHat.play(animName)
