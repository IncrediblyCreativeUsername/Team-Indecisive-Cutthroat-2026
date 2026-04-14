extends CanvasLayer

var maxHealth : int = 10
var health : int = maxHealth

@onready var healthbar := $Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().paused:
		visible = false
	healthbar.anchor_right = 0.05 + 0.9 * health / maxHealth
