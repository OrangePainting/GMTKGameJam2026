extends Control

@onready var day_night_clock = %DayNightClock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	day_night_clock.rotation = PI * (TimeManager.in_game_time / TimeManager.max_day_time)


func _on_mouse_mask_mouse_entered() -> void:
	modulate = Color(1, 1, 1, 0.5)


func _on_mouse_mask_mouse_exited() -> void:
	modulate = Color(1, 1, 1, 1)
