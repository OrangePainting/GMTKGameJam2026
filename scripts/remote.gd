class_name Remote
extends ActionItem

@export var tv_path: NodePath

var collected := false

@onready var tv: TV = get_node(tv_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_interact(player: Node) -> void:
	if collected: return
	collected = true
	tv.set_remote_found(true)
	# Happiness manager?
	queue_free()
