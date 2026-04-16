extends Camera2D

@onready var shaking := false

func addShake(strength, duration):
	if !shaking:
		shaking = true
		shake(strength)
		await get_tree().create_timer(duration).timeout
		shaking = false

func shake(strength):
	offset = Vector2(randf_range(-strength/2, strength/2), randf_range(-strength/2, strength/2))
	if Globals.hp > 0:
		await get_tree().process_frame
		if shaking:
			shake(strength)
