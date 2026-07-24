class_name Desktop
extends ActionItem

enum STATE { BOXES, EMPTY, DESKTOP }

var state: STATE = STATE.BOXES
@onready var desktop_sprite = $Sprite

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
	pass

func refresh_sprite() -> void:
	match state:
		STATE.BOXES: desktop_sprite.play(&"boxes")
		STATE.EMPTY: desktop_sprite.play(&"empty")
		STATE.DESKTOP: desktop_sprite.play(&"computer")
