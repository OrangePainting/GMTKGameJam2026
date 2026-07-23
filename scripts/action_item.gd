class_name ActionItem # template class for any item that can be interacted with
extends Area2D

@export var action_prompt: String = "test"
@export var enabled := true

func interact(player: Node) -> void:
	if not enabled: return
	_on_interact(player)

func _on_interact(player: Node) -> void: # override in sub classes
	pass
