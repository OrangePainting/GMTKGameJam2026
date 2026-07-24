class_name Bed
extends ActionItem

enum STATE { OPEN, NO_SHEET, SHEET_AWAKE, SHEET_ASLEEP}

var state: STATE = STATE.SHEET_ASLEEP

@onready var bed_sprite = $Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_interact(player: Node) -> void:
	pass

func change_state(new_state: STATE) -> void:
	state = new_state
	refresh_sprite()


func refresh_sprite() -> void:
	match state:
		STATE.OPEN: bed_sprite.play(&"empty")
		STATE.NO_SHEET: bed_sprite.play(&"no_sheet")
		STATE.SHEET_AWAKE: bed_sprite.play(&"sheet_awake")
		STATE.SHEET_ASLEEP: bed_sprite.play(&"sheet_asleep")
