extends Node2D

signal show_text

@onready var TV: TV = $Furniture/TV

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TV.news_found.connect(func(): show_text.emit())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
