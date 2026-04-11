extends CharacterBody2D

@export var speed : int = 700
@export var jumpForce : int = 2000
@export var gravity : int = 100
@export var coyoteTime : int = 15
@export var friction : int = 500
@export var tongueForce : float = 2.0

var coyoteTimer = 0
@export var tongueExtending := false
@onready var tongueAnimator := $Tongue/TongueAnim
@onready var tonguePivot := $Tongue
@onready var tongueTip := $Tongue/Area2D
var grabbedObject

func _physics_process(_delta: float) -> void:
	#friction
	if velocity.x > 0:
		velocity.x = clamp(velocity.x-friction, 0, velocity.x-friction)
	if velocity.x < 0:
		velocity.x = clamp(velocity.x+friction, velocity.x+friction, 0)
	
	#X movement
	
	if Input.is_action_pressed("MOVE_RIGHT") && !tongueExtending && velocity.x < speed:
		velocity.x += speed
	if Input.is_action_pressed("MOVE_LEFT") && !tongueExtending && velocity.x > -speed:
		velocity.x -= speed
	
	#coyote time resets while on floor
	if is_on_floor():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= 1
	
	#Y movement
	if Input.is_action_pressed("JUMP") && !tongueExtending:
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
	
	#shoot out tongue
	if !tongueExtending && Input.is_action_just_pressed("GRAPPLE"):
		tonguePivot.look_at(get_global_mouse_position())
		tongueAnimator.play("Extend")
	
	#move grabbed object
	if grabbedObject != null && tongueExtending:
		grabbedObject.global_position = $Tongue/Area2D.global_position
	else:
		grabbedObject = null
	
	#move according to velocity and delta
	move_and_slide()

#tongue fully extends
func _on_tongue_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Extend":
		tongueAnimator.play("Retract")

#tongue hit something
func _on_area_2d_body_entered(body: Node2D) -> void:
	var startTime = 1-tongueAnimator.current_animation_position
	velocity = Vector2(tongueForce/get_process_delta_time(), 0).rotated(tonguePivot.rotation)
	tongueTip.set_deferred("monitoring", false)
	tongueAnimator.play("Retract")
	tongueAnimator.seek(startTime)
	
	#grab object
	if body.is_in_group("grabbable"):
		grabbedObject = body
