extends Node2D

@onready var hatLabel := $HatNumLabel

func _ready() -> void:
	hatLabel.text = "Hat:\n#" + str(Globals.playerHatNum)
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
