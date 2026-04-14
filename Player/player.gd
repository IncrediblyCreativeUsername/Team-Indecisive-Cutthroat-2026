extends CharacterBody2D

@export var speed : int = 800
@export var jumpForce : int = 2000
@export var gravity : int = 100
@export var coyoteTime : int = 15
@export var friction : int = 500

var coyoteTimer = 0
var grapplePoint = Vector2.ZERO
var grappleSpeed : float = 0.0;
@export var tongueExtending := false
@onready var tongueAnimator := $Tongue/TongueAnim
@onready var tonguePivot := $Tongue
@onready var tongueTip := $Tongue/Area2D
@onready var tongueCast := $Tongue/RayCast2D
@onready var animSprite := $PlayerSprite
var grabbedObject
var isGrappling : bool = false
var paused : bool = false
var grappleCooldownMax = 15
var grappleCooldown = 0

@onready var droppedAnt = preload("res://Enemy/Enemy.tscn")

func _ready():
	animSprite.play("stand")
	Globals.player = self

func _physics_process(delta: float) -> void:
	#Preventing a strange bug where the retract animation is interrupted from causing a softlock. I'm still not sure why
	if !tongueAnimator.is_playing():
		isGrappling = false
	
	#pause
	if Input.is_action_just_pressed("PAUSE"):
		get_parent().find_child("Pause").visible = true
		get_parent().find_child("Hud").visible = false
		get_tree().paused = true
	
	#grapple
	if isGrappling:
		var grappleDirection : Vector2 = (grapplePoint - self.global_position).normalized()
		#move_and_collide(delta * grappleDirection * 10)
		velocity += grappleDirection * (grappleSpeed + 600)
	else:
		if grappleCooldown > 0:
			grappleCooldown -= 1
	
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
			velocity.x = max(0, (velocity.x-friction)*60*delta)
		if velocity.x < 0:
			velocity.x = min((velocity.x+friction)*60*delta, 0)
		
		#X movement
		
		
		if Input.is_action_pressed("MOVE_RIGHT") && velocity.x < speed:
			velocity.x += speed*60*delta
			
			animSprite.flip_h =false
			if self.is_on_floor():
				animSprite.play("walk")
		if Input.is_action_pressed("MOVE_LEFT") && velocity.x > -speed:
			velocity.x -= speed*60*delta
			
			animSprite.flip_h = true
			if self.is_on_floor() && !tongueExtending:
				animSprite.play("walk")
			
		if velocity.x == 0 && animSprite.animation != "stand_toungue":
			if self.is_on_floor() && !tongueExtending:
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
		#shoot out tongue
		if !tongueExtending && Input.is_action_just_pressed("GRAPPLE") && grappleCooldown <= 0:
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
	elif anim_name == "Retract":
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
			grappleSpeed = self.global_position.distance_to(grapplePoint)
			if velocity.y > 0:
				velocity.y = 0
			isGrappling = true
			grappleCooldown = grappleCooldownMax
			velocity = Vector2.ZERO
