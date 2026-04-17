extends CanvasLayer

@onready var hp := $Health
@onready var hunger := $Hunger
@onready var heldAnt := $HeldAnt

var lifetime := 0.
var hpOffsetScale := 0.
var hpOffset := Vector2.ZERO
var hpPos : Vector2

func _ready() -> void:
	hpPos = hp.global_position

func _process(_delta: float) -> void:
	lifetime += _delta
	
	hp.size.x = 128 * Globals.hp
	hunger.value = Globals.hunger
	heldAnt.visible = Globals.heldAnt
	
	if hpOffsetScale > 0:
		hpOffsetScale -= _delta
		hpOffset = Vector2(sin(lifetime * 20),sin(lifetime * 50)) * hpOffsetScale * 10.
	
	hp.position = hpPos + hpOffset
	$Health2.position = hpPos + hpOffset


func _on_health_resized() -> void:
	hpOffsetScale = 0.5
	
