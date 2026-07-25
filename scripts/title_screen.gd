extends Control

@onready var start_button: TextureButton = $StartButton 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_mouse_entered() -> void:
	create_tween().tween_property(start_button, "scale", Vector2.ONE * 1.1, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _on_start_button_mouse_exited() -> void:
	create_tween().tween_property(start_button, "scale", Vector2.ONE, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/day_one.tscn")
