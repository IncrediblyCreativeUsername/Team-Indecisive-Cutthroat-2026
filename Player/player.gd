extends CharacterBody2D

@export var speed : int = 200
@export var jumpForce : int = 1000
@export var gravity : int = 100


func _physics_process(delta: float) -> void:
	velocity.x = 0
	
	if Input.is_action_pressed("MOVE_RIGHT"):
		velocity.x += 1
	if Input.is_action_pressed("MOVE_LEFT"):
		velocity.x -= 1
	
	velocity.x *= speed
	
	if Input.is_action_just_pressed("JUMP"):
		if is_on_floor():
			velocity.y -= jumpForce
	
	velocity.y += gravity
	
	move_and_slide()
