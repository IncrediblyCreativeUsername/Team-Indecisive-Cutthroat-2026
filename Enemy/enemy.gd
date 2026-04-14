extends CharacterBody2D

@export var gravity : int = 100
@export var speed : int = 600
@export var damage : int = 1
@export var knockback : int = 2000
@export var hungerRestore : int = 30
@export var damageCooldownMax : int = 30

@onready var player = Globals.player
@onready var visibility := $VisibleOnScreenEnabler2D

@onready var sprite = $Sprite2D
@export var wasGrabbed := false
var damageCooldown = 0

func _ready() -> void:
	var index = randi_range(0,2);
	if(1 ==index):
		sprite.play("alt");
	
	

func _physics_process(_delta: float) -> void:
	if damageCooldown > 0:
		damageCooldown -= 1
	if damageCooldown <= 0 && $DamageArea.monitoring == false:
		$DamageArea.set_deferred("monitoring",true)
		
	
	#only execute code if onscreen
	if visibility.is_on_screen():
		#X movement
		velocity.x = 0
		if !wasGrabbed:
			#failsafe to leave head of player -- NO LONGER NEEDED (NO COLLISONS)
			#if abs(player.global_position.x - global_position.x) < 128 &&  player.global_position.y - global_position.y > 64:
			#	velocity.x += 1
			#	sprite.flip_h = true
			#standard targeting
			if abs(player.global_position.x - global_position.x) > 10:
				if player.global_position.x >= global_position.x:
					velocity.x += 1
					sprite.flip_h = true
				if player.global_position.x <= global_position.x:
					velocity.x -= 1
					sprite.flip_h = false
			
			if is_on_wall():
				if player.global_position.y <= self.global_position.x:
					velocity.y = -(speed / 2.0)
			
			velocity.x *= speed
		
		if !is_on_floor():
			velocity.y += gravity*60*_delta
		elif !is_on_wall():
			velocity.y = 0
		
		animate()
		#move according to velocity and delta
		move_and_slide()

func animate():
	##rotate sprite for wall climb
	#if is_on_wall():
		#if player.global_position.x <= self.global_position.x:
			#sprite.rotation = PI / 2
		#if player.global_position.x >= self.global_position.x:
			#sprite.rotation = -PI / 2
	#else:
		#sprite.rotation = 0
	#
	if wasGrabbed:
		sprite.flip_v = true
		sprite.position.y = 128

func grabbed(_grabOrigin : Vector2):
	wasGrabbed = true


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if !wasGrabbed:
			Globals.hurt(damage)
			$DamageArea.set_deferred("monitoring",false)
			damageCooldown = damageCooldownMax
			if velocity.x > 0:
				body.velocity.x += knockback
			else:
				body.velocity.x -= knockback
		else:
			sprite.flip_v = true
			sprite.position.y = 128
