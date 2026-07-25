class_name ActionItem # template class for any item that can be interacted with
extends Area2D

@export var action_prompt: String = "test"
@export var enabled := true

var flash_tween: Tween

func interact(player: Node) -> void:
	if not enabled: return
	_on_interact(player)

func _on_interact(player: Node) -> void: # override in sub classes
	pass

func flash_red(duration: float = 0.5, flashes: int = 2) -> void:
	if flash_tween: flash_tween.kill()
	modulate = Color(1, 1, 1)
	flash_tween = create_tween()
	for i in flashes:
		flash_tween.tween_property(self, "modulate", Color(1, 0.3, 0.3, 0.5), duration / 2.0)
		flash_tween.tween_property(self, "modulate", Color(1, 1, 1), duration / 2.0)
	
