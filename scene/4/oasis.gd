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


func init_mirages() -> void:
	reset()
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
	
	init_mirages_checks()


func reset() -> void:
	while mirages.get_child_count() > 0:
		var mirage = mirages.get_child(0)
		mirages.remove_child(mirage)
		mirage.queue_free()


func init_mirages_checks() -> void:
	for _i in mirages.get_child_count():
		if _i >= mirages.get_child_count():
			break
		
		var mirage_a = mirages.get_child(_i)
		
		for _j in range(mirages.get_child_count()-1, _i, -1):
			var mirage_b = mirages.get_child(_j)
			
			if mirage_a.socket == mirage_b.socket:
				if mirage_a.repetition_check(mirage_b):
					kick(mirage_b)
	
	for _i in range(mirages.get_child_count()-1, -1, -1):
		var mirage = mirages.get_child(_i)
		
		if !mirage.compliance_check():
			kick(mirage)
#endregion


func kick(mirage_: MarginContainer) -> void:
	mirages.remove_child(mirage_)
	mirage_.queue_free()
