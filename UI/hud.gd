extends CanvasLayer

@onready var hp := $Health
@onready var hunger := $Hunger
@onready var heldAnt := $HeldAnt

func _process(_delta: float) -> void:
	hp.size.x = 128 * Globals.hp
	hunger.value = Globals.hunger
	heldAnt.visible = Globals.heldAnt
