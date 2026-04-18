extends CharacterBody2D

const BASE_SPEED = 350.0

const GroundItemScene = preload("res://Items/GroundItem.tscn")

@onready var body_anim = $BodyAnim
@onready var arms_anim = $ArmsAnim
@onready var visuals = $Visuals

@onready var held_sprite = $ItemHolder/HeldItemSprite
@onready var pickup_zone = $PickupZone

# --- Стан Гравця ---
var hp: float = 100.0
var held_item_type = ItemData.Type.NONE
var held_item_count: int = 0

# --- Таймери ефектів (у секундах) ---
var invert_controls_timer: float = 0.0
var speed_modifier: float = 0.0
var speed_modifier_timer: float = 0.0

func _ready() -> void:
	arms_anim.play("nothing")
	held_sprite.visible = false

func _physics_process(delta: float) -> void:
	# 1. Оновлюємо таймери ефектів
	if invert_controls_timer > 0:
		invert_controls_timer -= delta

	if speed_modifier_timer > 0:
		speed_modifier_timer -= delta
	else:
		speed_modifier = 0.0  # скидаємо бонус/штраф коли час вийшов

	# 2. Швидкість
	var current_speed = BASE_SPEED
	
	# Штраф за дрова (припустимо, що тип Дрова = 1, пізніше підв'яжемо під ItemData)
	if held_item_type == ItemData.Type.FIREWOOD:
		var penalty = held_item_count * 0.15
		current_speed *= (1.0 - penalty)
		
	current_speed += speed_modifier
	current_speed = max(current_speed, 50.0)

	# 3. Читаємо введення (Input)
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Інверсія керування
	if invert_controls_timer > 0:
		direction = -direction
	
	var current_scale = abs(visuals.scale.x)
	
	# 4. Рух та Анімації
	if direction:
		velocity = direction * current_speed
		body_anim.play("run")
		
		# Повертаємо модельку
		if velocity.x < 0:
			visuals.scale.x = -current_scale
		elif velocity.x > 0:
			visuals.scale.x = current_scale
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)
		body_anim.play("stand")

	move_and_slide()
	handle_inventory_input()


func handle_inventory_input():
	if Input.is_action_just_pressed("interact"):
		try_interact()
	elif Input.is_action_just_pressed("drop"):
		drop_item()
	elif Input.is_action_just_pressed("use"):
		use_item()


func try_interact():
	var areas = pickup_zone.get_overlapping_areas()
	for area in areas:
		if area.has_method("pick_up"):
			
			# Якщо руки порожні, АБО в руках такий самий предмет
			if held_item_type == ItemData.Type.NONE or held_item_type == area.item_type:
				
				var max_stack = ItemData.DATA[area.item_type]["max_stack"]
				var space_left = max_stack - held_item_count
				
				# Якщо є вільне місце в руках
				if space_left > 0:
					var taken = area.pick_up(space_left) # Беремо предмет!
					held_item_type = area.item_type
					held_item_count += taken
					update_item_visuals()
					break


func drop_item():
	if held_item_count <= 0:
		return

	var dropped_item = GroundItemScene.instantiate()
	dropped_item.item_type = held_item_type   # передаємо тип
	dropped_item.amount   = held_item_count   # передаємо кількість

	get_tree().current_scene.add_child(dropped_item)
	dropped_item.global_position = self.global_position + Vector2(0, 40)

	# Скидаємо руки
	held_item_count = 0
	held_item_type = ItemData.Type.NONE
	update_item_visuals()

func use_item():
	match held_item_type:

		ItemData.Type.BURGER:
			# Відновлює здоров'я на максимум
			hp = 100.0
			consume_held_item()

		ItemData.Type.ROTTEN_BURGER:
			# Відновлює здоров'я на максимум, але штраф -100 до швидкості
			hp = 100.0
			speed_modifier = -100.0
			speed_modifier_timer = 8.0
			consume_held_item()

		ItemData.Type.ENERGY_DRINK:
			# +200 до швидкості
			speed_modifier = 200.0
			speed_modifier_timer = 8.0
			consume_held_item()

		ItemData.Type.BEER:
			# +100 до швидкості, але інвертує керування
			speed_modifier = 100.0
			speed_modifier_timer = 6.0
			invert_controls_timer = 6.0
			consume_held_item()

		ItemData.Type.FIREWOOD:
			# Використовується тільки біля каміну — через окрему зону
			# try_use_firewood()
			pass


func consume_held_item(amount: int = 1):
	held_item_count -= amount
	if held_item_count <= 0:
		held_item_count = 0
		# held_item_type = ItemData.Type.NONE
	update_item_visuals()


func update_item_visuals():
	if held_item_count <= 0 or held_item_type == ItemData.Type.NONE:
		held_sprite.visible = false
		arms_anim.play("nothing")
		return

	var item_info = ItemData.DATA[held_item_type]

	# Встановлюємо текстуру
	held_sprite.texture = item_info["texture"]
	held_sprite.hframes = item_info["hframes"]
	held_sprite.vframes = item_info["vframes"]

	if item_info["vframes"] > 1:
		held_sprite.frame = clamp(held_item_count - 1, 0, item_info["vframes"] - 1)
	else:
		held_sprite.frame = 0

	held_sprite.visible = true
	arms_anim.play("hold")
