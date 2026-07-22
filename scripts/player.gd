extends Node2D

const VELOCITY_THRESHOLD := 100.0

@export var max_speed: float = 250.0
@export var chase_speed: float = 6.0
@export var float_up_down: float = 8.0
@export var float_speed: float = 0.1 # per sec
@export var appear_time: float = 2.0

@onready var ghost_sprite = %GhostSprite

var velocity := Vector2.ZERO
var total_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghost_sprite.hide()
	ghost_appearing_animation()

func ghost_appearing_animation() -> void:
	ghost_sprite.modulate = Color(0, 0, 0, 0)
	ghost_sprite.show()
	var t := create_tween()
	t.tween_property(ghost_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), appear_time)
	t.set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_towards_player(delta)
	apply_ghost_float(delta)
	set_animation(velocity.length()) # speed

func move_towards_player(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var difference_vector := mouse_pos - position
	var distance: float = difference_vector.length()
	
	var goal_velocity = Vector2.ZERO
	if distance > VELOCITY_THRESHOLD: goal_velocity = (difference_vector / distance) * max_speed
	
	velocity = velocity.lerp(goal_velocity, 1.0 - exp(-chase_speed * delta))
	position += velocity * delta


func apply_ghost_float(delta: float) -> void:
	total_time += delta
	ghost_sprite.position = Vector2(
		sin(total_time * TAU * float_speed * 0.7),
		sin(total_time * TAU * float_speed)
	) * float_up_down

func set_animation(speed: float):
	if speed > VELOCITY_THRESHOLD:
		ghost_sprite.play("movement")
		ghost_sprite.flip_h = velocity.x < 0.0
	else: ghost_sprite.play("idle")
