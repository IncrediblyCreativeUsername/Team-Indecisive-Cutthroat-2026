extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.hp <= 0:
		$Title.text = "You Died"
	else:
		$Title.text = "Your Nephew Starved"
	Globals.resetValues()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(Globals.mainMenuScene)


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file(Globals.gameScene)
