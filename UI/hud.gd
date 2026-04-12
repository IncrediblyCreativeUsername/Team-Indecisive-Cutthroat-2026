extends CanvasLayer

@onready var hp := $Health
@onready var hunger := $Hunger

func _process(delta: float) -> void:
	hp.size.x = 128 * Globals.hp
	hunger.value = Globals.hunger
