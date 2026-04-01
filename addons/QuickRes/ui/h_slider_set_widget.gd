@tool
class_name HSliderSetWidget extends Control

@export var __slider: Slider
@export var __bounds: Vector2 = Vector2(1.0, 3.6)
@export var __range_label: Label

signal value_changed_signal(v: float)
var _range: Vector2
## min./max range property.
var range:
	get:
		return Vector2(__slider.min_value, __slider.max_value)
	set(rg):
		_range = rg
		__slider.min_value = rg.x
		__slider.max_value = rg.y
		__slider.value = rg.x


signal on_set_viewport_dpr_signal(dpr: float)
signal on_set_window_override_dpr_signal(dpr: float)

func _ready():
	range = __bounds
	Extras.connect_once(__slider.value_changed, __on_value_changed)


func __on_value_changed(dpr: float):
	var _dpr = snapped(dpr, 0.01)
	value_changed_signal.emit(_dpr)
	__range_label.text = "{dpr}".format({"dpr": _dpr})

func _exit_tree():
	Extras.disconnect_all(__slider.value_changed)
