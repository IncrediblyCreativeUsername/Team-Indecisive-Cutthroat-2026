extends CharacterBody2D

@export var speed : int = 1000
@export var jumpForce : int = 2200
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
@onready var tongueTexture := $Tongue/TextureRect
@onready var animSprite := $PlayerSprite
@onready var Hats := $Hats
@onready var mouseCast := $MouseCast
var grabbedObject
var isGrappling : bool = false
var paused : bool = false
var grappleCooldownMax = 15
var grappleCooldown = 0

@onready var droppedAnt = preload("res://Enemy/Enemy.tscn")

func _ready():
	animSprite.play("stand")
	Hats.updateAnim("stand")
	Globals.player = self

func _physics_process(delta: float) -> void:
	#Preventing a strange bug where the retract animation is interrupted from causing a softlock. I'm still not sure why
	if !tongueAnimator.is_playing():
		isGrappling = false
	
	#pause
	if Input.is_action_just_pressed("PAUSE"):
		get_parent().find_child("Pause").visible = true
		get_parent().find_child("Pause").pauseAudio()
		get_parent().find_child("Hud").visible = false
		get_tree().paused = true
	
	#grapple
	if isGrappling:
		var grappleDirection : Vector2 = (grapplePoint - self.global_position).normalized()
		#move_and_collide(delta * grappleDirection * 10)
		velocity += grappleDirection * (grappleSpeed/1.5 + 1000)
	else:
		if grappleCooldown > 0:
			grappleCooldown -= 1
	
	#eat
	if Input.is_action_just_pressed("EAT"):
		if Globals.heldAnt && Globals.hp < 5:
			Globals.heldAnt = false
			speed = 1000
			Globals.hp = min(5, Globals.hp + 2)
		else:
			for item in $Eat.get_overlapping_bodies():
				if item.is_in_group("edible") && item.wasGrabbed:
					Globals.heldAnt = true
					speed = 660
					item.queue_free()
	#drop held ant
	if Input.is_action_just_pressed("DROP"):
		if Globals.heldAnt:
			Globals.heldAnt = false
			speed = 1000
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
			Hats.currentHat.flip_h = false
			if self.is_on_floor():
				animSprite.play("walk")
				Hats.updateAnim("walk")
		if Input.is_action_pressed("MOVE_LEFT") && velocity.x > -speed:
			velocity.x -= speed*60*delta
			
			animSprite.flip_h = true
			Hats.currentHat.flip_h = true
			if self.is_on_floor() && !tongueExtending:
				animSprite.play("walk")
				Hats.updateAnim("walk")
			
		if velocity.x == 0 && animSprite.animation != "stand_tongue":
			if self.is_on_floor() && !tongueExtending:
				animSprite.play("stand")
				Hats.updateAnim("stand")
		
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
				Hats.updateAnim("jump")
		else:
			#shorter jump if not held
			if velocity.y < 0:
				velocity.y /= 1.3
		
		#air time
		if !isGrappling:
			if velocity.y < 0:
				if velocity.y > 100:
					velocity.y -= gravity * 0.8
			
			velocity.y += gravity
		#shoot out tongue
		if !tongueExtending && Input.is_action_just_pressed("GRAPPLE") && grappleCooldown <= 0:
			mouseCast.look_at(get_global_mouse_position())
			await get_tree().process_frame
			if mouseCast.is_colliding():
				tonguePivot.look_at(mouseCast.get_collision_point())
			else:
				tonguePivot.look_at(get_global_mouse_position())
			tongueAnimator.play("Extend")
			animSprite.play("stand_tongue")
			Hats.updateAnim("stand_tongue")
			if (get_global_mouse_position() - global_position).rotated(PI / 2).angle() > 0:
				flip(false)
				
			else:
				flip(true)
		
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
			await get_tree().process_frame
			grabbedObject = body
			grabbedObject.grabbed(global_position)
		#grapple otherwise
		else:
			await get_tree().process_frame
			grapplePoint = tongueCast.get_collision_point() + Vector2(64,0).rotated(tonguePivot.rotation)
			grappleSpeed = self.global_position.distance_to(grapplePoint)
			if grapplePoint.y < self.global_position.y:
				if velocity.y > 0:
					velocity.y = 0
			elif grapplePoint.y > self.global_position.y:
				if velocity.y < 0:
					velocity.y = 0
			isGrappling = true
			grappleCooldown = grappleCooldownMax
			velocity = Vector2.ZERO

func flip(flipped):
	if flipped:
		animSprite.flip_h = true
		Hats.currentHat.flip_h = true
		tonguePivot.position.x = -180
	else:
		animSprite.flip_h = false
		Hats.currentHat.flip_h = false
		tonguePivot.position.x = 115
