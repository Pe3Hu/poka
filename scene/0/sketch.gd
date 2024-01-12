extends MarginContainer


@onready var cradle = $HBox/Cradle


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
