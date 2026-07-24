class_name LightSource
extends ActionItem

@export var tv_path: NodePath
@export var light_energy: float = 1.2
@export var light_radius: float = 180.0
@export var tween_duration: float = 0.4

var is_on := false

@onready var tv: TV = get_node(tv_path)
@onready var sprite: Sprite2D = $Sprite
@onready var light: PointLight2D = $PointLight2D

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	light.energy = 0.0
	light.texture_scale = 0.0

func _on_interact(player: Node) -> void:
	is_on = not is_on
	# Now light source so not necessary
	#sprite.frame = 1 if is_on else 0
	#tv.set_on_off(is_on)
	
	if is_on: change_lighting(light_energy, light_radius)
	else: change_lighting(0, 0)

func change_lighting(new_energy: float, new_scale: float) -> void:
	if tween: tween.kill()
	tween = create_tween().set_parallel()
	
	tween.tween_property(light, "energy", new_energy, tween_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(light, "texture_scale", new_scale / 100.0, tween_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
