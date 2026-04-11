extends Node2D



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(Globals.gameScene)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (75-value))
