extends Node

# =============================================
# GAME MANAGER
# Додай у Project > Autoloads як "GameManager"
# =============================================

var dawn_timer: float = 300.0
const DAWN_DURATION: float = 300.0

var furnace_a: Node = null
var furnace_b: Node = null
var player: Node = null

signal dawn_reached


func _process(delta: float) -> void:
	if furnace_a == null or furnace_b == null:
		return

	var a_out: bool = furnace_a.fuel_time <= 0.0
	var b_out: bool = furnace_b.fuel_time <= 0.0
	var a_dying: bool = furnace_a.fuel_time <= furnace_a.dying_threshold and not a_out
	var b_dying: bool = furnace_b.fuel_time <= furnace_b.dying_threshold

	# --- Таймер світанку ---
	# Заморожується якщо хоча б одна пічка повністю згасла
	if not a_out and not b_out:
		dawn_timer -= delta
		if dawn_timer <= 0.0:
			dawn_timer = 0.0
			emit_signal("dawn_reached")

	# --- Ефект пічки А: ковзання ---
	if player:
		player.is_slippery = (a_dying or a_out)

	# --- Ефект пічки Б: дух ---
	# TODO: логіка духа
	if b_dying or b_out:
		pass # _spawn_ghost() / _handle_ghost()

	# --- HUD ---
	# TODO: оновлення інтерфейсу
	pass


# --- Допоміжні геттери для майбутнього HUD ---

func get_dawn_progress() -> float:
	return dawn_timer / DAWN_DURATION

func is_dawn_frozen() -> bool:
	if furnace_a == null or furnace_b == null:
		return false
	return furnace_a.fuel_time <= 0.0 or furnace_b.fuel_time <= 0.0
