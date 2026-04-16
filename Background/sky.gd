extends Node2D

@export var sky_color := Color(0,0,0)
@export var cloud_color := Color(0,0,0)

@export var mountains := true
@export var mountain_color1 := Color(0,0,0)
@export var mountain_color2 := Color(0,0,0)
@export var mountain_color3 := Color(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !mountains:
		$Mountains.queue_free()
	

func _process(delta: float) -> void:
	$Sky/Sky.material.set_shader_parameter("skyColor",sky_color)
	$Sky/Sky.material.set_shader_parameter("cloudColor",cloud_color)
	if mountains:
		$Mountains/Mountains1/Mountains.material.set_shader_parameter("mountainColor",mountain_color1)
		$Mountains/Mountains2/Mountains.material.set_shader_parameter("mountainColor",mountain_color2)
		$Mountains/Mountains3/Mountains.material.set_shader_parameter("mountainColor",mountain_color3)

func _physics_process(delta: float) -> void:
	pass#texture.noise.offset.y += 0.001
