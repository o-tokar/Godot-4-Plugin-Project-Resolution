@tool
class_name DisplaySettingsSizeWidget extends Control

@export var __settings_prop_prefix: String
@export var __set_check_box: CheckBox
@export var __set_btn: BaseButton
@export var __drp_slider: HSliderSetWidget

var resolution: Vector2i:
	set(res):
		__resolution = res
		update_value(1)

var __resolution: Vector2i
var __dpr: float

signal set_resolution_size_signal(v2i: Vector2i)

func _enter_tree() -> void:
	Extras.connect_once(__set_check_box.toggled, __on_check_box_toggled)
	Extras.connect_once(__set_btn.pressed, __on_set_pressed)

func __on_check_box_toggled(toggle: bool):
	if toggle:
		Extras.connect_once(__drp_slider.value_changed_signal, update_value)
	else:
		Extras.disconnect_once(__drp_slider.value_changed_signal, update_value)


func _exit_tree():
	Extras.disconnect_all(__set_btn.pressed)
	Extras.disconnect_all(__set_check_box.toggled)

func __on_set_pressed():
	set_resolution_size_signal.emit(__rand_v2i(__resolution, __dpr))

func update_value(dpr: float):
	__dpr = dpr
	var res = __rand_v2i(__resolution, dpr)
	if __set_check_box.button_pressed:
		__set_check_box.text = __settings_prop_prefix+"[ {w} x {h} ]".format({"w": res.x, "h": res.y})

func __rand_v2i(v2i: Vector2i, v: float) -> Vector2i:
	return Vector2i(roundi(v2i.x / v), roundi(v2i.y / v))
