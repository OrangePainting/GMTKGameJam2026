class_name Desktop
extends ActionItem

enum STATE { BOXES, EMPTY, DESKTOP }

@export var password_minigame_scnee: PackedScene

var state: STATE = STATE.BOXES
var password_solved := false

@onready var desktop_sprite = $Sprite
@onready var minigame_layer = $MinigameLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_sprite()

func _on_interact(player: Node) -> void:
	match state:
		STATE.BOXES: change_state(STATE.EMPTY)
		STATE.EMPTY: change_state(STATE.DESKTOP)
		STATE.DESKTOP: play_password_minigame()

func change_state(new_state: STATE) -> void:
	state = new_state
	refresh_sprite()

func play_password_minigame() -> void:
	if password_solved: return
	if not password_minigame_scnee: return
	var minigame: Node = password_minigame_scnee.instantiate()
	minigame_layer.add_child(minigame)
	minigame.unlocked.connect(on_password_unlocked.bind(minigame))

func on_password_unlocked(minigame: Node) -> void:
	password_solved = true
	minigame.queue_free()
	# show password trigger

func refresh_sprite() -> void:
	match state:
		STATE.BOXES: desktop_sprite.play(&"boxes")
		STATE.EMPTY: desktop_sprite.play(&"empty")
		STATE.DESKTOP: desktop_sprite.play(&"computer")
