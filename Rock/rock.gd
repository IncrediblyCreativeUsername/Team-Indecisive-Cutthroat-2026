extends CharacterBody2D

@export var gravity : int = 10000

@onready var player = get_parent().find_child("Player")
@onready var visibility := $VisibleOnScreenEnabler2D

@onready var sprite = $Sprite2D
var wasGrabbed := false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	#only execute code if onscreen
	if visibility.is_on_screen() && wasGrabbed:
		if !is_on_floor():
			velocity.y += gravity * _delta
		else:
			velocity.y = 0
		#move according to velocity and delta
		move_and_slide()

func grabbed(_grabOrigin : Vector2):
	wasGrabbed = true
