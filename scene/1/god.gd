extends MarginContainer


#region vars
@onready var vastness = $HBox/Vastness
@onready var gameboard = $HBox/VBox/Gameboard
@onready var health = $HBox/VBox/Health

var pantheon = null
var table = null
var combo = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	#vastness.set_attributes(input)
	gameboard.set_attributes(input)
	
	input.limits = {}
	input.limits.vigor = 0.25
	input.limits.standard = 0.5
	input.limits.fatigue = 0.25
	input.total = 100
	health.set_attributes(input)
#endregion
