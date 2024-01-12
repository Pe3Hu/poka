extends MarginContainer


@onready var pantheons = $Pantheons

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_pantheons()


func init_pantheons() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var pantheon = Global.scene.pantheon.instantiate()
		pantheons.add_child(pantheon)
		pantheon.set_attributes(input)
