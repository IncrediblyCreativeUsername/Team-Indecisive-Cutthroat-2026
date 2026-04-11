extends CharacterBody2D

@export var speed : int = 700
@export var jumpForce : int = 2000
@export var gravity : int = 100
@export var coyoteTime : int = 15

var coyoteTimer = 0

func _physics_process(_delta: float) -> void:
	#X movement
	velocity.x = 0
	
	if Input.is_action_pressed("MOVE_RIGHT"):
		velocity.x += 1
	if Input.is_action_pressed("MOVE_LEFT"):
		velocity.x -= 1
	
	velocity.x *= speed
	
	#coyote time resets while on floor
	if is_on_floor():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= 1
	
	#Y movement
	if Input.is_action_pressed("JUMP"):
		#base jump force
		if is_on_floor() or coyoteTimer > 0:
			coyoteTimer = 0
			velocity.y = 0
			velocity.y -= jumpForce
	else:
		#shorter jump if not held
		if velocity.y < 0:
			velocity.y /= 1.3
	
	#air time
	if velocity.y < 0:
		if velocity.y > 100:
			velocity.y -= gravity * 0.8
	
	velocity.y += gravity
	
	#move according to velocity and delta
	move_and_slide()
