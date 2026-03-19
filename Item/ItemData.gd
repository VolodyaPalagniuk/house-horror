class_name ItemData

enum Type { NONE, FIREWOOD, BURGER, ENERGY_DRINK }

const DATA = {
	Type.FIREWOOD: {
		"texture": preload("res://sprites/Game_House_wood.png"), # Ваш спрайт на 3 кадри
		"hframes": 1, # 1 колонка
		"vframes": 3, # 3 рядки (кадри йдуть вниз)
		"max_stack": 3
	},
	Type.BURGER: {
		"texture": preload("res://sprites/Game_House_burger.png"),       # Звичайна картинка
		"hframes": 1,
		"vframes": 1,
		"max_stack": 1
	},
	Type.ENERGY_DRINK: {
		"texture": preload("res://sprites/Game_House_energy.png"),       # Звичайна картинка
		"hframes": 1,
		"vframes": 1,
		"max_stack": 1
	}
}
