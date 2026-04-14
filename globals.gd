extends Node

var gameScene := "res://Game/Game.tscn"
#var gameScene := "res://Game/game2.tscn"
var mainMenuScene := "res://UI/MainMenu.tscn"
var deathScene := "res://UI/Death.tscn"
var playerHatNum := 0
var hatCount := 4
var hp := 3
var hunger := 100.0
var heldAnt := false
var player

func resetValues():
	hp = 3
	hunger = 100
	heldAnt = false

func hurt(damage):
	hp -= damage
	if hp <= 0:
		die()
		#get_tree().reload_current_scene()
		#resetValues()

func die():
	get_tree().change_scene_to_file(Globals.deathScene)

func _process(delta: float) -> void:
	hunger -= 1.0*delta
	if hunger <= 0:
		die()
		#get_tree().reload_current_scene()
		#resetValues()
