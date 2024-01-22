extends MarginContainer


#region vars
@onready var bg = $BG
@onready var performer = $Performer
@onready var rank = $Rank

var card = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	card = input_.card
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.type = "performer"
	input.subtype = card.performer
	performer.set_attributes(input)
	
	input.type = "number"
	input.subtype = card.rank
	rank.set_attributes(input)
	
	custom_minimum_size = performer.custom_minimum_size + rank.custom_minimum_size * 0.6
#endregion
