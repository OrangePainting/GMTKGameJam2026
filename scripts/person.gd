extends Node2D

@onready var player_sprite = $AnimatedSprite2D

var faced_direction := Vector2.RIGHT
var player_tween: Tween
var player_speed := 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_animation(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_towards(pos: Vector2) -> void:
	if player_tween: player_tween.kill()
	player_tween = create_tween()
	player_tween.tween_property(self, "position", pos, player_speed * (pos - position).length())

func update_animation(is_moving: bool) -> void:
	var dir_string = get_direction_string(faced_direction)
	var anim_anme = "walk_" + dir_string
	
	if is_moving: player_sprite.play(anim_anme)
	else:
		player_sprite.animation = anim_anme
		player_sprite.stop()
		player_sprite.frame = 0

func get_direction_string(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y): return "right" if dir.x > 0 else "left"
	else: return "down" if dir.y > 0 else "up"
