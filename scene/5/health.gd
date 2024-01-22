extends MarginContainer


#region vars
@onready var vigor = $HBox/Indicators/Vigor
@onready var standard = $HBox/Indicators/Standard
@onready var fatigue = $HBox/Indicators/Fatigue
@onready var index = $HBox/Index
@onready var indicators = $HBox/Indicators

var god = null
var value = {}
var state = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_index()
	value.total = int(input_.total)
	value.current = int(input_.total)
	init_states(input_)


func init_index() -> void:
	var input = {}
	input.type = "god"
	input.subtype = Global.num.index.god
	index.set_attributes(input)
	Global.num.index.god += 1


func init_states(input_: Dictionary) -> void:
	for type in Global.arr.state:
		var indicator = get(type)
		
		var input = {}
		input.health = self
		input.type = type
		input.max = input_.limits[type] * value.total
		indicator.set_attributes(input)
	
	state = Global.arr.state.front()
#endregion


func change_integrity(integrity_: int) -> void:
	var indicator = get(state)
	value.current += integrity_
	indicator.update_value("current", integrity_)

