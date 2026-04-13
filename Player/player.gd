extends CharacterBody2D

@export var speed : int = 800
@export var jumpForce : int = 2000
@export var gravity : int = 100
@export var coyoteTime : int = 15
@export var friction : int = 500

var coyoteTimer = 0
var grapplePoint = Vector2.ZERO
@export var tongueExtending := false
@onready var tongueAnimator := $Tongue/TongueAnim
@onready var tonguePivot := $Tongue
@onready var tongueTip := $Tongue/Area2D
@onready var tongueCast := $Tongue/RayCast2D
@onready var animSprite := $PlayerSprite
var grabbedObject
var isGrappling : bool = false
var paused : bool = false

@onready var droppedAnt = preload("res://Enemy/Enemy.tscn")

func _ready():
	animSprite.play("stand")

func _physics_process(_delta: float) -> void:
	#pause
	if Input.is_action_just_pressed("PAUSE"):
		get_parent().find_child("Pause").visible = true
		get_parent().find_child("Hud").visible = false
		get_tree().paused = true
	
	#grapple
	if isGrappling:
		global_position = grapplePoint - (tongueTip.position+Vector2(64+9,0)).rotated(tonguePivot.rotation)
	
	#eat
	if Input.is_action_just_pressed("EAT"):
		if Globals.heldAnt:
			Globals.heldAnt = false
			speed = 800
			Globals.hp = min(3, Globals.hp + 1)
		else:
			for item in $Eat.get_overlapping_bodies():
				if item.is_in_group("edible") && item.wasGrabbed:
					Globals.heldAnt = true
					speed = 400
					item.queue_free()
	#drop held ant
	if Input.is_action_just_pressed("DROP"):
		if Globals.heldAnt:
			Globals.heldAnt = false
			speed = 800
			var ant = droppedAnt.instantiate()
			if animSprite.flip_h:
				ant.global_position = global_position + Vector2(-160,0)
			else:
				ant.global_position = global_position + Vector2(160,0)
			ant.grabbed(Vector2.ZERO)
			get_parent().add_child(ant)
	
	#movement
	else:
		#friction
		if velocity.x > 0:
			velocity.x = max(0, (velocity.x-friction)*60*_delta)
		if velocity.x < 0:
			velocity.x = min((velocity.x+friction)*60*_delta, 0)
		
		#X movement
		
		
		if Input.is_action_pressed("MOVE_RIGHT") && !tongueExtending && velocity.x < speed:
			velocity.x += speed*60*_delta
			
			animSprite.flip_h =false
			if self.is_on_floor():
				animSprite.play("walk")
		if Input.is_action_pressed("MOVE_LEFT") && !tongueExtending && velocity.x > -speed:
			velocity.x -= speed*60*_delta
			
			animSprite.flip_h = true
			if self.is_on_floor():
				animSprite.play("walk")
			
		if velocity.x == 0 && animSprite.animation != "stand_toungue":
			if self.is_on_floor():
				animSprite.play("stand")
		
		#coyote time resets while on floor
		if is_on_floor():
			coyoteTimer = coyoteTime
		else:
			coyoteTimer -= 1
		
		#Y movement
		if Input.is_action_pressed("JUMP") && !tongueExtending && !isGrappling:
			#base jump force
			if is_on_floor() or coyoteTimer > 0:
				coyoteTimer = 0
				velocity.y = 0
				velocity.y -= jumpForce
				animSprite.play("jump")
		else:
			#shorter jump if not held
			if velocity.y < 0:
				velocity.y /= 1.3
		
		#air time
		if velocity.y < 0:
			if velocity.y > 100:
				velocity.y -= gravity * 0.8
		
		velocity.y += gravity
		print((get_global_mouse_position() - global_position).rotated(PI / 2).angle())
		#shoot out tongue
		if !tongueExtending && Input.is_action_just_pressed("GRAPPLE"):
			tonguePivot.look_at(get_global_mouse_position())
			tongueAnimator.play("Extend")
			animSprite.play("stand_toungue")
			if (get_global_mouse_position() - global_position).rotated(PI / 2).angle() > 0:
				animSprite.flip_h = false
			else:
				animSprite.flip_h = true
		
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
	if anim_name == "Retract":
		isGrappling = false

#tongue hit something
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		var startTime = 1-tongueAnimator.current_animation_position
		tongueTip.set_deferred("monitoring", false)
		tongueAnimator.play("Retract")
		tongueAnimator.seek(startTime)
		
		#grab object
		if body.is_in_group("grabbable"):
			grabbedObject = body
			grabbedObject.grabbed(global_position)
		#grapple otherwise
		else:
			await get_tree().process_frame
			grapplePoint = tongueCast.get_collision_point() + Vector2(64,0).rotated(tonguePivot.rotation)
			isGrappling = true
			velocity = Vector2.ZERO
