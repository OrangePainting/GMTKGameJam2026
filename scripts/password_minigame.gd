class_name PasswordMinigame
extends Node2D

signal unlocked

enum DIRECTION { UP, DOWN, LEFT, RIGHT }

@export var sequence_length: int = 6
@export var flash_time: float = 0.35
@export var gap_time: float = 0.25
@export var start_delay: float = 0.6
@export var fail_delay: float = 0.6

@onready var down_button: TextureButton = $DownButton
@onready var up_button: TextureButton = $UpButton
@onready var right_button: TextureButton = $RightButton
@onready var left_button: TextureButton = $LeftButton
@onready var status_label: Label = $StatusLabel

var buttons: Dictionary = {}
var sequence: Array[DIRECTION] = []
var input_index := 0
var input_phase := false
var solved := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = {DIRECTION.UP: up_button,
			   DIRECTION.DOWN: down_button,
			   DIRECTION.LEFT: left_button,
			   DIRECTION.RIGHT: right_button,
	}
	up_button.pressed.connect(func(): on_direction_pressed(DIRECTION.UP))
	down_button.pressed.connect(func(): on_direction_pressed(DIRECTION.DOWN))
	left_button.pressed.connect(func(): on_direction_pressed(DIRECTION.LEFT))
	right_button.pressed.connect(func(): on_direction_pressed(DIRECTION.RIGHT))
	start_round()

func start_round() -> void:
	generate_sequence()
	await replay_sequence()

func generate_sequence() -> void:
	sequence.clear()
	var dirs: Array[DIRECTION] = [DIRECTION.UP, DIRECTION.DOWN, DIRECTION.LEFT, DIRECTION.RIGHT]
	for i in sequence_length: sequence.append(dirs[randi() % len(dirs)])

func replay_sequence() -> void:
	if solved: return
	input_phase = false
	input_index = 0
	set_status("LOOK")
	await get_tree().create_timer(start_delay).timeout
	for dir in sequence:
		if solved: return
		await flash_button(dir)
		await get_tree().create_timer(gap_time).timeout
	if solved: return
	set_status("YOUR TURN")
	input_phase = true

func on_direction_pressed(dir: DIRECTION) -> void:
	if not input_phase or solved: return
	if dir == sequence[input_index]:
		input_index += 1 # correct button pressed
		if input_index >= len(sequence): solve()
	else: fail_input()

func solve() -> void:
	solved = true
	input_phase = false
	set_status("CORRECT")
	await get_tree().create_timer(0.5).timeout
	unlocked.emit()


func fail_input() -> void:
	input_phase = false
	set_status("TRY AGAIN")
	await get_tree().create_timer(fail_delay).timeout
	await replay_sequence()

func set_status(text: String) -> void:
	status_label.text = text


func flash_button(dir: DIRECTION) -> void:
	var button: TextureButton = buttons[dir]
	var tween := create_tween()
	tween.tween_property(button, "modulate", Color(0.0, 0.576, 0.0, 1.0), flash_time * 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(button, "modulate", Color(1, 1, 1, 1), flash_time * 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tween.finished
