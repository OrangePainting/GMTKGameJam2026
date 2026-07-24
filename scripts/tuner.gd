class_name AntennaTuner
extends Node2D

signal tuned

@export var move_speed : float = 220.0
@export var radius: float = 25.0
@export var hold_time: float = 0.4
@export var bounds_area: Rect2 = Rect2(140, 100, 1000, 520)

@onready var cursor: Sprite2D = $Cursor
@onready var target: Sprite2D = $Target

var hold_timer := 0.0
var solved := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target.position = Vector2(randf_range(bounds_area.position.x, bounds_area.position.x + bounds_area.size.x),
							  randf_range(bounds_area.position.y, bounds_area.position.y + bounds_area.size.y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if solved: return
	move_cursor(delta)
	check_target(delta)

func move_cursor(delta: float) -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	cursor.position += dir * move_speed * delta
	cursor.position.x = clamp(cursor.position.x, bounds_area.position.x, bounds_area.position.x + bounds_area.size.x)
	cursor.position.y = clamp(cursor.position.y, bounds_area.position.y, bounds_area.position.y + bounds_area.size.y)


func check_target(delta: float) -> void:
	if cursor.position.distance_to(target.position) <= radius:
		hold_timer += delta
		if hold_timer >= hold_time: solve()
	else: hold_timer = 0.0

func solve() -> void:
	solved = true
	await get_tree().create_timer(0.4).timeout
	tuned.emit()
