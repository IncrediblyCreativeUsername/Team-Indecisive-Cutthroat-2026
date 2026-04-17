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
	
	#health shake effect
	var iFramesRatio = float(Globals.invincible)/float(Globals.invincibilityFrames)
	hpOffset = Vector2(sin(lifetime * 20),sin(lifetime * 50)) * iFramesRatio * 5.
	hp.self_modulate = Color(1,1-iFramesRatio,1-iFramesRatio)
	$Health2.self_modulate = Color(1,1-iFramesRatio,1-iFramesRatio)
	hp.position = hpPos + hpOffset
	$Health2.position = hpPos + hpOffset
	
	#flash white
	var hpFlash = max(iFramesRatio,Globals.eatFlash/Globals.eatFlashMax)
	hp.material.set_shader_parameter("flash",hpFlash * 0.5)
	
	#hunger flash white
	var hungerFlash = Globals.PhilipEatFlash/Globals.eatFlashMax
	hunger.material.set_shader_parameter("flash",hungerFlash * 0.5)
