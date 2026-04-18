extends Interactable

@export var give_amount: int = 1

func interact(player) -> void:
	
	var item_type = ItemData.Type.FIREWOOD
	var max_stack = ItemData.DATA[item_type]["max_stack"]
	
	if player.held_item_type != ItemData.Type.NONE and player.held_item_type != item_type:
		# мейбі якісь прінт чи виведення на екран "не можу взяти"
		return
	
	var space_left = max_stack - player.held_item_count
	if space_left <= 0:
		return
	
	player.held_item_type = item_type
	player.held_item_count = max_stack
	player.update_item_visuals()
