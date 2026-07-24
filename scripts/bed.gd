class_name Bed
extends ActionItem

enum STATE { OPEN, NO_SHEET, SHEET_AWAKE, SHEET_ASLEEP}

var state: STATE = STATE.SHEET_ASLEEP

@export var person_path: NodePath
@onready var bed_sprite = $Sprite
@onready var person: Node = get_node_or_null(person_path)

func _ready() -> void:
	refresh_sprite()
	if person: person.returned_to_bed.connect(on_person_returned_to_bed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_interact(player: Node) -> void:
	if state != STATE.SHEET_ASLEEP or not person: return
	change_state(STATE.OPEN)
	person.begin_walk()


func change_state(new_state: STATE) -> void:
	state = new_state
	refresh_sprite()


func on_person_returned_to_bed() -> void:
	change_state(STATE.SHEET_ASLEEP)


func refresh_sprite() -> void:
	match state:
		STATE.OPEN: bed_sprite.play(&"empty")
		STATE.NO_SHEET: bed_sprite.play(&"no_sheet")
		STATE.SHEET_AWAKE: bed_sprite.play(&"sheet_awake")
		STATE.SHEET_ASLEEP: bed_sprite.play(&"sheet_asleep")
