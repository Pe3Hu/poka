extends Node


@onready var sketch = $Sketch


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	#Global.rng.randomize()
	#var random = Global.rng.randi_range(0, 1)
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					sketch.casino.tables.get_child(0).croupier.follow_stage()
					#sketch.casino.tables.get_child(0).gods.get_child(0).vastness.oasis.choose_best()
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					sketch.cradle.pantheons.get_child(0).gods.get_child(0).vastness.soil.subsoil.shift_axises_index(-1)
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					sketch.cradle.pantheons.get_child(0).gods.get_child(0).vastness.soil.subsoil.shift_axises_index(1)
			KEY_Q:
				if event.is_pressed() && !event.is_echo():
					sketch.cradle.pantheons.get_child(0).gods.get_child(0).vastness.soil.subsoil.turn_fusion(-1)
			KEY_E:
				if event.is_pressed() && !event.is_echo():
					sketch.cradle.pantheons.get_child(0).gods.get_child(0).vastness.soil.subsoil.turn_fusion(1)
			KEY_F:
				if event.is_pressed() && !event.is_echo():
					sketch.cradle.pantheons.get_child(0).gods.get_child(0).vastness.soil.subsoil.flip_fusion()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
