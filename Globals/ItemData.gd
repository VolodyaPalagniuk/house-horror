extends Node

enum Type {
	NONE,
	FIREWOOD,
	BURGER,
	ENERGY_DRINK,
	BEER,
	ROTTEN_BURGER
}

# Словник з характеристиками кожного предмета
const DATA = {
	Type.NONE: {
		"name": "Порожні руки",
		"max_stack": 0,
		"texture": null,
		"hframes": 1,
		"vframes": 1
	},
	Type.FIREWOOD: {
		"name": "Дрова",
		"max_stack": 3,
		"texture": preload("res://sprites/Game_House_wood.png"),
		"hframes": 1,
		"vframes": 3
	},
	Type.BURGER: {
		"name": "Бургер",
		"max_stack": 1,
		"texture": preload("res://sprites/Game_House_burger.png"),
		"hframes": 1,
		"vframes": 1
	},
	Type.ENERGY_DRINK: {
		"name": "Енергетик",
		"max_stack": 1,
		"texture": preload("res://sprites/Game_House_energy.png"),
		"hframes": 1,
		"vframes": 1
	},
	Type.BEER: {
		"name": "Пиво",
		"max_stack": 1,
		"texture": preload("res://sprites/Game_House_Beer.png"),
		"hframes": 1,
		"vframes": 1
	},
	Type.ROTTEN_BURGER: {
		"name": "Гнилий Бургер",
		"max_stack": 1,
		"texture": preload("res://sprites/Game_House_Rotten_Burger.png"),
		"hframes": 1,
		"vframes": 1
	}
}
