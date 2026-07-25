class_name AntennaTuner
extends Node2D

signal tuned

@export var acceleration: float = 500.0
@export var max_speed : float = 220.0
@export var start_speed: float = 140.0
@export var radius: float = 25.0
@export var hold_time: float = 0.4
@export var bounds_area: Rect2 = Rect2(102, 200, 800, 300)

@onready var cursor: Sprite2D = $Cursor
@onready var target: Sprite2D = $Target
@onready var down_button: TextureButton = $DownButton
@onready var up_button: TextureButton = $UpButton
@onready var right_button: TextureButton = $RightButton
@onready var left_button: TextureButton = $LeftButton

var velocity := Vector2.ZERO
var hold_timer := 0.0
var solved := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target.position = Vector2(randf_range(bounds_area.position.x, bounds_area.position.x + bounds_area.size.x),
							  randf_range(bounds_area.position.y, bounds_area.position.y + bounds_area.size.y))
	velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * start_speed # random direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if solved: return
	apply_force(delta)
	move_cursor(delta)
	check_target(delta)

func apply_force(delta: float) -> void:
	var dir := Vector2.ZERO
	if down_button.is_pressed(): dir += Vector2.DOWN
	elif up_button.is_pressed(): dir += Vector2.UP
	elif left_button.is_pressed(): dir += Vector2.LEFT
	elif right_button.is_pressed(): dir += Vector2.RIGHT
	if dir == Vector2.ZERO: return
	velocity += dir.normalized() * acceleration * delta
	velocity = velocity.limit_length(max_speed)

func move_cursor(delta: float) -> void:
	cursor.position += velocity * delta
	bounce_off_edges()

func bounce_off_edges() -> void:
	var min_pos := bounds_area.position
	var max_pos := bounds_area.position + bounds_area.size
	
	if cursor.position.x < min_pos.x:
		cursor.position.x = min_pos.x
		velocity.x = abs(velocity.x)
	
	if cursor.position.y < min_pos.y:
		cursor.position.y = min_pos.y
		velocity.y = abs(velocity.y)
	
	if cursor.position.x > max_pos.x:
		cursor.position.x = max_pos.x
		velocity.x = -abs(velocity.x)
	
	if cursor.position.y > max_pos.y:
		cursor.position.y = max_pos.y
		velocity.y = -abs(velocity.y)

func check_target(delta: float) -> void:
	if cursor.position.distance_to(target.position) <= radius:
		hold_timer += delta
		if hold_timer >= hold_time: solve()
	else: hold_timer = 0.0

func solve() -> void:
	solved = true
	await get_tree().create_timer(0.4).timeout
	tuned.emit()
