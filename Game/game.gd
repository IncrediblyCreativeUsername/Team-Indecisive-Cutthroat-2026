extends Node2D

@export var hungerDrain := 1.0

func _ready() -> void:
	Globals.hungerDrain = hungerDrain
