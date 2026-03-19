extends Area2D

@export var item_type: ItemData.Type = ItemData.Type.FIREWOOD
@export var amount: int = 3 
@export var is_infinite: bool = false

@onready var sprite = $Sprite2D

func _ready():
	if item_type != ItemData.Type.NONE:
		var info = ItemData.DATA[item_type]
		sprite.texture = info["texture"]
		
		sprite.hframes = info["hframes"]
		sprite.vframes = info["vframes"]
		
		if item_type == ItemData.Type.FIREWOOD:
			if is_infinite or amount >= 3:
				sprite.frame = 2
			else:
				sprite.frame = amount - 1

func pick_up(take_amount: int) -> int:
	# Якщо це нескінченна купа з холу — просто віддаємо скільки просять!
	if is_infinite:
		return take_amount 

	# Звичайна логіка: віддаємо стільки, скільки просять, але не більше, ніж є
	var taken = min(take_amount, amount)
	amount -= taken
	
	if amount <= 0:
		queue_free() # Зникає, якщо все забрали
	elif item_type == ItemData.Type.FIREWOOD:
		sprite.frame = amount - 1 # Зменшуємо картинку купи
		
	return taken
