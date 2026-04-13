extends Node

var gameScene := "res://Game/Game.tscn"
var mainMenuScene := "res://UI/MainMenu.tscn"
var deathScene := "res://UI/Death.tscn"
var playerHatNum := 0
var hatCount := 3
var hp := 3
var hunger := 100.0

func resetValues():
	hp = 3
	hunger = 100

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
