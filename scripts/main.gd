extends Node2D

signal show_text
signal game_won
signal game_lost

@onready var tv: TV = $Furniture/TV
@onready var person: Node = $Person

var game_over := false
var win = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tv.news_found.connect(func(): show_text.emit())
	person.walk_finished.connect(on_win)
	TimeManager.day_over.connect(on_lost)
	TimeManager.reset.connect(reset)
	$EndScreen.hide()
	$CanvasModulate.show()

func on_win() -> void:
	if game_over: return
	game_over = true
	win = true
	game_won.emit()
	$CanvasModulate.hide()
	$EndScreen.show()

func on_lost() -> void:
	if game_over: return
	game_over = true
	win = false
	game_lost.emit()
	$CanvasModulate.hide()
	$EndScreen.show()

func reset() -> void:
	$CanvasModulate.show()
	$EndScreen.hide()
	win = false
	get_tree().reload_current_scene()
