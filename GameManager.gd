extends Node

var furnace_a_heat: float = 100.0
var furnace_b_heat: float = 100.0

var max_heat: float = 100.0
var burn_rate: float = 3.0

var furnace_a_pause: float = 0.0
var furnace_b_pause: float = 0.0
const PAUSE_DURATION: float = 7.0

func _process(delta: float) -> void:
	# --- ПІЧ А ---
	if furnace_a_pause > 0:
		furnace_a_pause -= delta
	else:
		if furnace_a_heat > 0:
			furnace_a_heat -= burn_rate * delta
		else:
			furnace_a_heat = 0
			
	# --- ПІЧ Б ---
	if furnace_b_pause > 0:
		furnace_b_pause -= delta
	else:
		if furnace_b_heat > 0:
			furnace_b_heat -= burn_rate * delta
		else:
			furnace_b_heat = 0
		
	# TODO: Тут можна додати перевірку на Game Over (якщо обидві = 0)
