extends MarginContainer


#region vars
@onready var bar = $ProgressBar
@onready var value = $Value

var health = null
var type = null
#endregion


func set_attributes(input_: Dictionary) -> void:
	health = input_.health
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	update_value("maximum", input_.max)
	set_colors()
	custom_minimum_size = Vector2(Global.vec.size.state)
	custom_minimum_size.x *= bar.max_value / health.value.total


func set_colors() -> void:
	var keys = ["fill", "background"]
	bar.value = bar.max_value
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.state[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)


func update_value(value_: String, shift_: int) -> void:
	match value_:
		"current":
			bar.value += shift_
			value.visible = true
			
			if bar.value < 0:
				var _type = Global.dict.donor.state[type]
				
				if type == "fatigue":
					health.god.table.set_loser(health.god)
				elif _type != null:
					var state = health.get(_type)
					health.state = _type
					state.update_value("current", bar.value)
				
				bar.value = 0
				value.visible = false
			
			if bar.value > bar.max_value:
				var _type = Global.dict.chain.state[type]
				
				if _type != null:
					var state = health.get(_type)
					health.state = _type
					state.update_value("current", bar.value - bar.max_value)
				
				bar.value = bar.max_value
				value.visible = false
			
			value.text = str(health.value.current)
		"maximum":
			value.visible = bar.max_value != bar.value
			bar.max_value += shift_


func get_percentage() -> int:
	return floor(bar.value * 100 / bar.max_value)


func reset() -> void:
	bar.value = bar.max_value
