extends Node

#var gameScene := "res://Game/Game.tscn"
var gameScene := "res://Game/game2.tscn"
var mainMenuScene := "res://UI/MainMenu.tscn"
var deathScene := "res://UI/GameEnd.tscn"
var creditsScene := "res://UI/Credits.tscn"
var playerHatNum := 0
var hatCount := 10
var hp := 5
var hunger := 50.0
var heldAnt := false
var player
var invincibilityFrames = 40
var invincible = 0
var eatFlashMax := 10
var eatFlash := 0.
var PhilipEatFlash := 0.
var hungerDrain := 1.0
var hungry := false
var screenShake := true
var smootheCam := true
var screenFlash := true

func _ready():
	AudioServer.add_bus_effect(0,AudioEffectLowPassFilter.new(),0)

func resetValues():
	hp = 5
	hunger = 50
	heldAnt = false
	hungry = false

func hurt(damage):
	if invincible <= 0:
		invincible = invincibilityFrames
		hp -= damage
		player.cam.addShake(12, 0.1)
		if hp <= 0:
			die()
			#get_tree().reload_current_scene()
			#resetValues()

func die():
	get_tree().change_scene_to_file(Globals.deathScene)

func _process(delta: float) -> void:
	if hungry:
		hunger -= hungerDrain*delta
	if hunger <= 0:
		die()
		#get_tree().reload_current_scene()
		#resetValues()
	if invincible > 0:
		invincible -= 1
	if eatFlash > 0:
		eatFlash -= 1
	if PhilipEatFlash > 0:
		PhilipEatFlash -= 1
