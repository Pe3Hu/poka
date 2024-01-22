extends MarginContainer


#region vars
@onready var gods = $VBox/Gods
@onready var croupier = $VBox/Croupier

var casino = null
var winner = null
var loser = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	casino = input_.casino
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.table = self
	croupier.set_attributes(input)


func add_god(god_: MarginContainer) -> void:
	god_.pantheon.gods.remove_child(god_)
	gods.add_child(god_)
	
	#if gods.is_empty():
	#	gods.move_child(god_, 0)
	
	#gods.append(god_)
	god_.table = self
#endregion


func set_loser(loser_: MarginContainer) -> void:
	loser = loser_
	
	for god in gods:
		if god != loser:
			winner = god
			break
