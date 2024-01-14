extends MarginContainer


#region vars
@onready var mirages = $Mirages

var vastness = null
var sky = null
var subsoil = null
#endregion

#region init
func set_attributes(input_: Dictionary) -> void:
	vastness = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	sky = vastness.horizon.sky
	subsoil = vastness.soil.subsoil
	init_mirages()


func init_mirages() -> void:
	var fusion = subsoil.fusions.get_child(0)
	
	for socket in sky.slots.available:
		for flips in Global.num.mirage.flips:
			for turns in Global.num.mirage.turns:
				var input = {}
				input.oasis = self
				input.fusion = fusion
				input.socket = socket
				input.flips = flips
				input.turns = turns
			
				var mirage = Global.scene.mirage.instantiate()
				mirages.add_child(mirage)
				mirage.set_attributes(input)
