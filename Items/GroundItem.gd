extends Area2D

# Експортуємо змінні, щоб ви могли зручно налаштовувати предмети прямо в Інспекторі Godot
@export var item_type: int = 1 # 1 = Дрова (за замовчуванням)
@export var amount: int = 1

@onready var sprite = $Sprite2D

func _ready() -> void:
	# Щойно предмет з'являється у світі, він бере свою картинку зі словника
	if item_type != ItemData.Type.NONE:
		var item_info = ItemData.DATA[item_type]
		sprite.texture = item_info["texture"]
		sprite.hframes = item_info["hframes"]
		sprite.vframes = item_info["vframes"]
		_update_frame(item_info) 

# Цю функцію викликає Player.gd, коли гравець тисне кнопку взаємодії ("E")
func pick_up(space_left: int) -> int:
	var amount_to_give = min(amount, space_left)
	
	amount -= amount_to_give

	if amount <= 0:
		queue_free()
	else:
		var item_info = ItemData.DATA[item_type]
		_update_frame(item_info) 
		
	return amount_to_give

func _update_frame(item_info: Dictionary) -> void:
	if item_info["vframes"] <= 1:
		return
		
	sprite.frame = clamp(amount - 1, 0, item_info["vframes"] - 1)
	
