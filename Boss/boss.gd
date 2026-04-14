extends CharacterBody2D

@export var health : int = 10
@export var gravity : int = 0
@export var speed : int = 600
@export var speedMod : int = 1
@export var damage : int = 1
@export var knockback : int = 2000
@export var damageCooldownMax : int = 30

@onready var player = Globals.player
@onready var visibility := $VisibleOnScreenEnabler2D

@onready var sprite = $Sprite2D
@onready var bossbar = $Bossbar
var lifetime : float = 0
var damageCooldown = 0

var spawnpoint : Vector2

@onready var spawnedAnt = preload("res://Enemy/Enemy.tscn")

func _ready() -> void:
	spawnpoint = global_position
	bossbar.maxHealth = health
	bossbar.health = health

func _physics_process(_delta: float) -> void:
	bossbar.health = health
	if health <= 0:
		queue_free()
	elif health <= 5:
		speedMod = 2
	
	if damageCooldown > 0:
		damageCooldown -= 1
	if damageCooldown <= 0 && $DamageArea.monitoring == false:
		$DamageArea.set_deferred("monitoring",true)
	
	#only execute code if onscreen
	if visibility.is_on_screen():
		bossbar.visible = true
		lifetime += _delta
		velocity.y = cos(lifetime * speedMod * PI) * speed * speedMod
		velocity.x = cos(lifetime * speedMod * PI * 0.25) * speed * speedMod
		move_and_slide()
		
		if velocity.x > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

func grabbed(_grabOrigin : Vector2):
	damageCooldown = damageCooldownMax
	$DamageArea.set_deferred("monitoring",false)
	health -= 1
	var ant = spawnedAnt.instantiate()
	ant.global_position = global_position
	get_parent().add_child(ant)
	#wasGrabbed = true


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Globals.hurt(damage)
		$DamageArea.set_deferred("monitoring",false)
		damageCooldown = damageCooldownMax
		if velocity.x > 0:
			body.velocity.x += knockback
		else:
			body.velocity.x -= knockback


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	bossbar.visible = false
