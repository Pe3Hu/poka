extends MarginContainer


#region vars
@onready var bg = $BG
@onready var horizon = $VBox/HBox/Horizon
@onready var soil = $VBox/HBox/Soil
@onready var oasis = $VBox/HBox/Oasis

var god = null
#endregion


func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.vastness = self
	horizon.set_attributes(input)
	soil.set_attributes(input)
	oasis.set_attributes(input)
