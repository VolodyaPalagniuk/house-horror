extends CharacterBody2D

const GroundItemScene = preload("res://Item/ground_item.tscn")
const SPEED = 350.0

@onready var body_anim = $BodyAnim
@onready var arms_anim = $ArmsAnim
@onready var visuals = $Visuals

@onready var held_sprite = $ItemHolder/HeldItemSprite
@onready var pickup_zone = $PickupZone

var held_item_type: ItemData.Type = ItemData.Type.NONE
var held_item_count: int = 0
var hp = 3

func _ready() -> void:
	arms_anim.play("nothing")
	

func _physics_process(delta: float) -> void:
	
	var current_scale = abs(visuals.scale.x)
	var direction := Input.get_vector("left","right", "up", "down")
	
	if direction:
		velocity = direction * SPEED
		
		body_anim.play("run")
		
		if direction.x < 0:
			visuals.scale.x = -current_scale
		elif direction.x > 0:
			visuals.scale.x = current_scale
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
		body_anim.play("stand")

	move_and_slide()
	handle_inventory_input()

func handle_inventory_input():
	# E - Підібрати
	if Input.is_action_just_pressed("interact"):
		try_interact()
		
	# R - Викинути
	elif Input.is_action_just_pressed("drop"):
		drop_item()
		
	# Space - Використати (з'їсти/випити)
	elif Input.is_action_just_pressed("use"):
		use_item()

func try_interact():
	# Отримуємо всі предмети, які лежать в радіусі PickupZone
	var areas = pickup_zone.get_overlapping_areas()
	
	for area in areas:
		# Перевіряємо, чи це саме GroundItem (чи має він функцію pick_up)
		if area.has_method("pick_up"):
			
			# Перевіряємо, чи руки порожні, або чи там такий самий предмет
			if held_item_type == ItemData.Type.NONE or held_item_type == area.item_type:
				
				var max_stack = ItemData.DATA[area.item_type]["max_stack"]
				var space_left = max_stack - held_item_count
				
				if space_left > 0:
					var taken = area.pick_up(space_left)
					held_item_type = area.item_type
					held_item_count += taken
					update_item_visuals()
					break # Беремо тільки один об'єкт за раз і виходимо з циклу

func drop_item():
	if held_item_type != ItemData.Type.NONE:
		# 1. Створюємо копію сцени предмета
		var dropped_item = GroundItemScene.instantiate()
		
		# 2. Передаємо йому дані (що це і скільки)
		dropped_item.item_type = held_item_type
		dropped_item.amount = held_item_count
		dropped_item.is_infinite = false # Викидаємо звичайну купу, не нескінченну!
		
		# 3. Додаємо предмет у світ (не в гравця, бо інакше він буде бігати за нами!)
		get_tree().current_scene.add_child(dropped_item)
		
		# 4. Ставимо предмет туди, де зараз стоїть гравець
		dropped_item.global_position = self.global_position + Vector2(0, 100)
		
		# 5. Очищаємо руки
		held_item_type = ItemData.Type.NONE
		held_item_count = 0
		update_item_visuals()

func use_item():
	if held_item_type == ItemData.Type.BURGER:
		print("З'їв бургер! +HP")
		# Додаємо HP
		consume_held_item()

	elif held_item_type == ItemData.Type.ENERGY_DRINK:
		print("Випив енергетик! +Швидкість")
		# Збільшуємо швидкість
		consume_held_item()

	elif held_item_type == ItemData.Type.FIREWOOD:
		var areas = pickup_zone.get_overlapping_areas()
		var furnace_found = false
		
		# 2. Шукаємо серед них піч
		for area in areas:
			if area.has_method("add_fuel"):
				area.add_fuel()
				consume_held_item()         
				furnace_found = true
				break 
				
		# 3. Якщо печі поруч немає
		if not furnace_found:
			print("Тут немає куди кидати дрова!")

# Допоміжна функція для знищення предмета після використання
func consume_held_item():
	held_item_count -= 1
	if held_item_count <= 0:
		held_item_type = ItemData.Type.NONE
	update_item_visuals()

func update_item_visuals():
	if held_item_type == ItemData.Type.NONE or held_item_count <= 0:
		held_sprite.visible = false
		held_item_type = ItemData.Type.NONE
		held_item_count = 0
		arms_anim.play("nothing")
		return
		
	var item_info = ItemData.DATA[held_item_type]
	
	# Жорстко задаємо всі параметри з нашого словника
	held_sprite.texture = item_info["texture"]
	held_sprite.hframes = item_info["hframes"]
	held_sprite.vframes = item_info["vframes"]
	
	# Вибираємо кадр
	held_sprite.frame = held_item_count - 1 
	held_sprite.visible = true
	arms_anim.play("hold")
