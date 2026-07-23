extends Node

signal happiness_changed(total_happiness: float, happiness_change: float)

var happiness: float = 0.0

func add_happiness(amount: float) -> void:
	happiness += amount
	happiness_changed.emit(happiness, amount)
