extends Area2D

@export var is_furnace_a: bool = true
@onready var furnace_a = $Sprite_furnace_a
@onready var furnace_b = $Sprite_furnace_b

func _ready() -> void:
	if is_furnace_a:
		furnace_a.show()
		furnace_b.hide()
	else:
		furnace_b.show()
		furnace_a.hide()
		
func add_fuel() -> void:
	if is_furnace_a:
		GameManager.furnace_a_heat += 30.0
		GameManager.furnace_a_heat = clamp(GameManager.furnace_a_heat, 0, GameManager.max_heat)
		GameManager.furnace_a_pause = GameManager.PAUSE_DURATION
		print("Піч А нагріта: ", round(GameManager.furnace_a_heat))
	else:
		GameManager.furnace_b_heat += 30.0
		GameManager.furnace_b_heat = clamp(GameManager.furnace_b_heat, 0, GameManager.max_heat)
		GameManager.furnace_b_pause = GameManager.PAUSE_DURATION
		print("Піч Б нагріта: ", round(GameManager.furnace_b_heat))
