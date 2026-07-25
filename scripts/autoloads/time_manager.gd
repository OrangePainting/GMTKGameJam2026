extends Node

var starting_day_num: int = 1
var day_num: int = 1 # goes from starting_day_num to day 0
var max_day_time := 100.0
var in_game_time := 0.0 # goes from 0.0 to 100.0
var day_ended := false

signal day_over
signal reset

func reset_day() -> void:
	in_game_time = 0
	day_ended = false
	reset.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if day_ended: return
	in_game_time += delta
	if in_game_time > max_day_time:
		day_ended = true
		day_over.emit()
