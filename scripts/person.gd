extends Node2D


signal walk_finished
signal walk_failed
signal returned_to_bed

@onready var player_sprite = $AnimatedSprite2D

@export var tv_path: NodePath
@export var desktop_path: NodePath
@export var light_paths: Array[NodePath] = []

@export var waypoints_manager: NodePath

var waypoint_facings: Array[Vector2] = \
	[Vector2.UP, Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.RIGHT]


@onready var tv: TV = get_node_or_null(tv_path)
@onready var desktop: Desktop = get_node_or_null(desktop_path)
var lights : Array[LightSource] = []

var faced_direction := Vector2.RIGHT
var player_tween: Tween
var player_speed := 80.0

var start_position: Vector2
var waypoints: Array[Vector2] = []
var current_step := -1
var is_walking := false
var should_fail := false
var walk_num := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for l in light_paths:
		if get_node_or_null(l) as LightSource: lights.append(get_node_or_null(l) as LightSource)
	hide()
	start_position = global_position
	update_animation(false)

func begin_walk() -> void:
	show()
	if is_walking: return
	store_waypoints()
	if waypoints.is_empty(): return
	is_walking = true
	should_fail = false
	current_step = 0
	walk_num += 1
	walk_step(walk_num)


func fail_walk() -> void:
	if not is_walking: return
	should_fail = true


func check_failure(index: int) -> bool: # true = failed, false = passed
	print(index)
	match index:
		0: return desktop and desktop.state != Desktop.STATE.DESKTOP
		1: return not light_on(1)
		2: return not light_on(2)
		3: return not light_on(0)
		4: return not light_on(3)
		5: return not light_on(4)
		6: return tv and tv.state == TV.STATE.OFF
		_: return false # passed

func light_on(index: int) -> bool:
	return index < len(lights) and lights[index].is_on

func store_waypoints() -> void:
	waypoints.clear()
	if waypoints_manager.is_empty(): return
	var manager_node := get_node(waypoints_manager)
	for child in manager_node.get_children():
		if child is Node2D: waypoints.append(child.global_position)


func move_towards(pos: Vector2) -> void:
	if player_tween: player_tween.kill()
	player_tween = create_tween()
	player_tween.tween_property(self, "global_position", pos, (pos - global_position).length() / player_speed if player_speed > 1.0 else 1.0)


func walk_step(index: int) -> void:
	if index != walk_num: return
	if should_fail:
		start_return_to_bed(index)
		return
	if current_step >= waypoints.size():
		finish_walk()
		return
	
	var goal_pos: Vector2 = waypoints[current_step]
	face_and_move(goal_pos)
	await player_tween.finished
	if index != walk_num: return
	
	if should_fail or check_failure(current_step):
		start_return_to_bed(index)
		return
	
	player_sprite.play("walk_" + get_direction_string(waypoint_facings[current_step]))
	player_sprite.frame = 0
	player_sprite.stop()
	await get_tree().create_timer(1).timeout
	current_step += 1
	walk_step(index)

func start_return_to_bed(index: int) -> void:
	walk_failed.emit()
	face_and_move(start_position)
	await player_tween.finished
	if index != walk_num: return
	is_walking = false
	should_fail = false
	update_animation(false)
	returned_to_bed.emit()
	hide()


func finish_walk() -> void:
	is_walking = false
	update_animation(false)
	walk_finished.emit()


func face_and_move(goal: Vector2) -> void:
	faced_direction = goal - global_position
	update_animation(true)
	move_towards(goal)

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
