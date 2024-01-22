extends MarginContainer


#region vars
@onready var tables = $Tables

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_tables()


func init_tables() -> void:
	for _i in 1:
		var input = {}
		input.casino = self
	
		var table = Global.scene.table.instantiate()
		tables.add_child(table)
		table.set_attributes(input)
		
		for pantheon in sketch.cradle.pantheons.get_children():
			for god in pantheon.gods.get_children():
				table.add_god(god)
		
		table.croupier.commence()
#endregion
