extends Control

@export var main: Node2D

@onready var day_night_clock = %DayNightClock
@onready var news_label = %NewsInfo

var news_text = "DIRE NEWS:
METEOR STRIKE
AT YOUR HOUSE"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	news_label.hide()
	main.show_text.connect(display_text_animation)

func display_text_animation() -> void:
	news_label.text = ""
	news_label.show()
	create_tween().tween_method(update_news_label, 0, len(news_text), 8.0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	day_night_clock.rotation = PI * (TimeManager.in_game_time / TimeManager.max_day_time)

func update_news_label(index) -> void:
	news_label.text = news_text.substr(0, index)


func _on_mouse_mask_mouse_entered() -> void:
	modulate = Color(1, 1, 1, 0.5)


func _on_mouse_mask_mouse_exited() -> void:
	modulate = Color(1, 1, 1, 1)
