extends Node

var starting_day_num: int = 1
var day_num: int = 1 # goes from starting_day_num to day 0
var max_day_time := 100.0
var in_game_time := 0.0 # goes from 0.0 to 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	in_game_time += delta
