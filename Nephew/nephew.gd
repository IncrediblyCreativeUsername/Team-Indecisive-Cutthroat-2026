extends Node2D

@onready var sprite := $AnimatedSprite2D
@onready var detect := $Detect
@onready var eat := $Eat
@onready var eatParticles := $"Eat particles"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#sprite.play("default"), #testing non animated sprite
	
	for item in detect.get_overlapping_bodies():
		if item.is_in_group("edible"):
			#sprite.play("eat")
			item.wasGrabbed = true
			item.global_position += (eat.global_position - item.global_position).normalized() * 50
	
	for item in eat.get_overlapping_bodies():
		if item.is_in_group("edible"):
			Globals.hunger = min(100, Globals.hunger + item.hungerRestore)
			if item.has_method("victory"):
				item.victory()
			else:
				Globals.PhilipEatFlash = Globals.eatFlashMax
				eatParticles.emitting = true
				item.queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Globals.hungry = true
