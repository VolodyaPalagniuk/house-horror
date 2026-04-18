extends Node

enum Type {
	NONE,
	PILE_FIREWOOD,
	FURNACE_A,
	FURNACE_B,
	CAMPFIRE,
	DRESSER,
	DRESSER_MIMIC
}

const DATA = {
	Type.PILE_FIREWOOD: {
		"scene_path": "res://Objects/Dresser.tscn", # Шлях до сцени (яку ми створимо пізніше)
	},
	Type.DRESSER: {
		"scene_path": "res://Objects/Dresser.tscn", # Шлях до сцени (яку ми створимо пізніше)
		"is_mimic": false
	},
	Type.DRESSER_MIMIC: {
		"scene_path": "res://Objects/Dresser.tscn", # Використовує ТУ САМУ сцену!
		"is_mimic": true
	},
	Type.CAMPFIRE: {
		"scene_path": "res://Objects/MiniCampfire.tscn"
	},
	Type.FURNACE_A: {
		"scene_path": "res://Objects/Furnace.tscn",
		"is_furnace_a": true
	},
	Type.FURNACE_B: {
		"scene_path": "res://Objects/Furnace.tscn",
		"is_furnace_a": false
	}
}
