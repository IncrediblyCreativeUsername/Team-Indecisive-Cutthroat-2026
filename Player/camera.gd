extends Camera2D

@onready var shaking := false
@onready var flipped := false
var smoothedPosition := Vector2(0, 150)
@export var smoothSpeed := 6.0

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

func flip(newFlipped):
	if newFlipped != flipped:
		flipped = newFlipped
		if flipped:
			smoothedPosition.x = -400
		else:
			smoothedPosition.x = 400

func _process(delta: float) -> void:
	if smoothedPosition != position:
		if position.distance_to(smoothedPosition) > smoothSpeed*delta*60:
			position += position.direction_to(smoothedPosition)*smoothSpeed*delta*60
		else:
			position = smoothedPosition
