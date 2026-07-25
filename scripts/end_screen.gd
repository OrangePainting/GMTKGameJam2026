extends Control

@onready var end_button: TextureButton = $EndButton
@onready var end_title: Label = $EndTitle
@onready var end_label: Label = $EndButton/EndLabel

@export var main: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeManager.day_over.connect(show_end_screen)


func show_end_screen() -> void:
	if main.win:
		end_title.text = "YOU DID IT!"
		end_label.text = "Credits"
		
	else:
		end_button.hide()
		end_label.show()
		end_label.text = "CREDITS:
			Font by NOW IN TIME: https://nowintime.itch.io/macintosh-sysfont-chicago-pixel-art-gameboy-font
			Person by GibbonGL: https://gibbongl.itch.io/8-directional-gameboy-character-template
			Tileset by MonkeyImage: https://monkeyimage.itch.io/home-interior-tilesheet-gameboy-styled
			"

func _on_end_button_mouse_entered() -> void:
	create_tween().tween_property(end_button, "scale", Vector2.ONE * 1.1, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _on_end_button_mouse_exited() -> void:
	create_tween().tween_property(end_button, "scale", Vector2.ONE, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _on_end_button_pressed() -> void:
	if not main.win:
		TimeManager.reset_day()
