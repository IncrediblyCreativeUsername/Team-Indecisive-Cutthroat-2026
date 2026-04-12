extends CanvasLayer

var menu_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PAUSE") && menu_open:
		_on_return_to_game_pressed()
	else:
		#prevent closing of pause menu on first frame
		menu_open = true


func _on_return_to_game_pressed() -> void:
	menu_open = false
	visible = false
	get_parent().find_child("Hud").visible = true
	get_tree().paused = false


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(Globals.mainMenuScene)


func _on_volume_slider_value_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (value-75)/3)
