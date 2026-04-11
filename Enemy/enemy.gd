extends CharacterBody2D

@export var gravity : int = 100
@export var speed : int = 400

@onready var player = get_parent().find_child("Player")

func _physics_process(_delta: float) -> void:
	#X movement
	velocity.x = 0
	
	if abs(player.global_position.x - self.global_position.x) > 10:
		if player.global_position.x >= self.global_position.x:
			velocity.x += 1
		if player.global_position.x <= self.global_position.x:
			velocity.x -= 1
	
	if is_on_wall():
		if player.global_position.y <= self.global_position.x:
			velocity.y = -(speed / 2.0) - gravity
	
	velocity.x *= speed
	
	velocity.y += gravity
	
	
	#move according to velocity and delta
	move_and_slide()
