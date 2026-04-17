extends CanvasLayer

var maxAnger : int = 10
var anger : int = 0

@onready var angerbar := $Anger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().paused:
		visible = false
	angerbar.anchor_right = 0.05 + 0.45 * anger / maxAnger
