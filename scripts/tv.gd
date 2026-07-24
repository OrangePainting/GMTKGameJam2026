class_name TV
extends ActionItem

# TV turns on, and then while the antenna is being tuned, the static animation plays.
# Then, the remote needs to be found, and once the remote is interacted with, the news plays.

enum STATE { OFF, STATIC, CYCLING, NEWS }

signal state_changed(new_state: STATE)
signal news_found

@export var antenna_tuning_scene: PackedScene
@export var news_channel: int = 2
@export var channel_num: int = 5



var state := STATE.OFF
var is_on := false
var remote_found := false
var tuned := false
var current_channel: int = 0

@onready var screen = $Screen
@onready var tuning_layer = $TuningLayer

func set_on_off(value: bool) -> void:
	var turning_on := value and not is_on
	is_on = value
	if turning_on:
		screen.play(&"startup")
		await screen.animation_finished
	refresh_state()

func set_remote_found(value: bool) -> void:
	remote_found = value
	refresh_state()

func refresh_state() -> void:
	if state == STATE.NEWS: return
	if not is_on: set_state(STATE.OFF)
	if tuned: set_state(STATE.CYCLING)
	else: set_state(STATE.STATIC)


func set_state(new_state: STATE) -> void:
	if new_state == state: return
	state = new_state
	state_changed.emit(state)
	match state:
		STATE.OFF: screen.play(&"off")
		STATE.STATIC: screen.play(&"static")
		STATE.NEWS: screen.play(&"talking")
		STATE.CYCLING: screen.play(&"cycling")


func _on_interact(player: Node) -> void: # override in sub classes
	match state:
		STATE.OFF: set_on_off(true)
		STATE.STATIC: if not tuned: open_antenna_tuning()
		STATE.NEWS: pass
		STATE.CYCLING: cycle_channel()


func open_antenna_tuning() -> void:
	if not antenna_tuning_scene: return
	var tuner: Node = antenna_tuning_scene.instantiate()
	tuning_layer.add_child(tuner)
	tuner.tuned.connect(on_antenna_tuned.bind(tuner))


func on_antenna_tuned(tuner: Node) -> void:
	tuned = true
	tuner.queue_free()
	refresh_state()


func cycle_channel() -> void:
	if not remote_found: return
	current_channel = (current_channel + 1) % channel_num
	if current_channel == news_channel:
		set_state(STATE.NEWS)
		news_found.emit()
		#HappinessManager.add_happiness(1)


func _ready() -> void:
	screen.play(&"off")
