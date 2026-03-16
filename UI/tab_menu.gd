extends CanvasLayer

@onready var main_control: PanelContainer = $MainControl

@onready var bar_a: TextureProgressBar = $MainControl/HBoxContainer/BarsContainer/BarA
@onready var bar_b: TextureProgressBar = $MainControl/HBoxContainer/BarsContainer/BarB
	
func _ready() -> void:
	main_control.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_tab"):
		main_control.visible = not main_control.visible
	
	if main_control.visible:
		bar_a.value = GameManager.furnace_a_heat
		bar_b.value = GameManager.furnace_b_heat
