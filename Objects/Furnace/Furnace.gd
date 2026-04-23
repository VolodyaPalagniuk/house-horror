extends Interactable

# =============================================
# FURNACE — пічка
# Гравець підходить і тисне E з дровами в руках
# Кожне поліно додає fuel_per_log секунд
# =============================================

@export var is_furnace_a: bool = true         # true = пічка А, false = пічка Б
@export var fuel_per_log: float = 40.0        # секунд за одне поліно
@export var max_fuel: float = 120.0           # максимум палива (2 хвилини)
@export var dying_threshold: float = 30.0     # "гасне" коли < 30 секунд

var fuel_time: float = 60.0  # починаємо з 1 хвилини

@onready var sprite: Sprite2D = $Sprite2D

# Спрайти для кожного типу пічки
const TEXTURE_A = preload("res://sprites/Game_House_furnace_A.png")
const TEXTURE_B = preload("res://sprites/Game_House_furnace_B.png")


func _ready() -> void:
	# Встановлюємо спрайт залежно від типу пічки
	if is_furnace_a:
		sprite.texture = TEXTURE_A
		GameManager.furnace_a = self
	else:
		sprite.texture = TEXTURE_B
		GameManager.furnace_b = self


func _process(delta: float) -> void:
	if fuel_time > 0.0:
		fuel_time -= delta
		fuel_time = max(fuel_time, 0.0)

	_update_sprite()


func interact(player) -> void:
	if player.held_item_type != ItemData.Type.FIREWOOD:
		return  # TODO: показати повідомлення "потрібні дрова"

	var space_in_fuel: float = max_fuel - fuel_time
	if space_in_fuel <= 0.0:
		return  # пічка вже повна

	var logs_can_fit: int = int(ceil(space_in_fuel / fuel_per_log))
	var logs_to_use: int = min(player.held_item_count, logs_can_fit)

	if logs_to_use <= 0:
		return

	fuel_time += logs_to_use * fuel_per_log
	fuel_time = min(fuel_time, max_fuel)

	player.consume_held_item(logs_to_use)


func _update_sprite() -> void:
	sprite.vframes = 3
	sprite.hframes = 1
	# Згасла = 0 (зверху), жевріє = 1 (середина), горить = 2 (знизу)
	if fuel_time <= 0.0:
		sprite.frame = 0
	elif fuel_time <= dying_threshold:
		sprite.frame = 1
	else:
		sprite.frame = 2


# --- Геттери для майбутнього HUD ---

func get_fuel_percent() -> float:
	return fuel_time / max_fuel

func is_out() -> bool:
	return fuel_time <= 0.0

func is_dying() -> bool:
	return fuel_time <= dying_threshold and fuel_time > 0.0
