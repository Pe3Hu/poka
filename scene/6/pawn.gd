extends MarginContainer


#region vars
@onready var power = $Power
@onready var border = $Border

var combo = null
var card = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	combo = input_.combo
	card = input_.card
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.type = "number"
	input.subtype = card.rank
	power.set_attributes(input)
	
	input.type = "border"
	input.subtype = "incomplete"
	border.set_attributes(input)
	
	combo.update_amount(power.get_number())
#endregion
