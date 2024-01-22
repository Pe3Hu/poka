extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var casino = $HBox/Casino


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	casino.set_attributes(input)
