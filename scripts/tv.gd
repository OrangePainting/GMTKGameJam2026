class_name TV
extends ActionItem

enum STATE { OFF, STATIC, NEWS }

signal state_changed(new_state: STATE)
signal news_found

@export var antenna_tuning_scene: PackedScene

var state := STATE.OFF
var is_on := false
var remote_found := false
var tuned := false

@onready var screen = $Screen
@onready var tuning_layer = $TuningLayer


func set_on_off(value: bool) -> void:
	is_on = value
	refresh_state()

func set_remote_found(value: bool) -> void:
	remote_found = value
	refresh_state()

func refresh_state() -> void:
	if state == STATE.NEWS: return
	if not is_on: set_state(STATE.OFF)
	if not tuned: set_state(STATE.STATIC)
	

func set_state(new_state: STATE) -> void:
	if new_state == state: return
	state = new_state
	state_changed.emit(state)
	screen.frame = state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
