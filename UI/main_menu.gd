extends Node2D

@onready var hatLabel := $HatNumLabel

var lpf : AudioEffectLowPassFilter

func _ready() -> void:
	Globals.hungry = false
	lpf = AudioServer.get_bus_effect(0, 0)
	lpf.cutoff_hz = 20000.0
	hatLabel.text = "Hat:\n#" + str(Globals.playerHatNum)
	if Globals.smootheCam:
		$SmootheCam.text = "Smoothe Camera: ON"
	else:
		$SmootheCam.text = "Smoothe Camera: OFF"
	if Globals.screenShake:
		$ScreenShake.text = "Screen Shake: ON"
	else:
		$ScreenShake.text = "Screen Shake: OFF"
	if Globals.screenFlash:
		$ScreenFlash.text = "Screen Flashes: ON"
	else:
		$ScreenFlash.text = "Screen Flashes: OFF"
	$"Volume Slider".value = (AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))*3)+75

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(Globals.gameScene)
	Globals.resetValues()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_volume_slider_value_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (value-75)/3)

func _on_prev_hat_pressed() -> void:
	if Globals.playerHatNum == 0:
		Globals.playerHatNum = Globals.hatCount-1
	else:
		Globals.playerHatNum -= 1
	hatLabel.text = "Hat:\n#" + str(Globals.playerHatNum)

func _on_next_hat_pressed() -> void:
	if Globals.playerHatNum == Globals.hatCount-1:
		Globals.playerHatNum = 0
	else:
		Globals.playerHatNum += 1
	hatLabel.text = "Hat:\n#" + str(Globals.playerHatNum)

func _on_screen_shake_pressed() -> void:
	Globals.screenShake = !Globals.screenShake
	if Globals.screenShake:
		$ScreenShake.text = "Screen Shake: ON"
	else:
		$ScreenShake.text = "Screen Shake: OFF"

func _on_smooth_cam_pressed() -> void:
	Globals.smootheCam = !Globals.smootheCam
	if Globals.smootheCam:
		$SmootheCam.text = "Smoothe Camera: ON"
	else:
		$SmootheCam.text = "Smoothe Camera: OFF"


func _on_screen_flash_pressed() -> void:
	Globals.screenFlash = !Globals.screenFlash
	if Globals.screenFlash:
		$ScreenFlash.text = "Screen Flashes: ON"
	else:
		$ScreenFlash.text = "Screen Flashes: OFF"
