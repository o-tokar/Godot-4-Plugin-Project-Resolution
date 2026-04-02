@tool
class_name QuickResolutionEditorUI extends Control

@export var __groups_btns: ArrBtnGroupGroup
@export var __preset_name_label: Label
@export var __device_preset_model_label: Label
@export var __viewport_settings_display_label: Label
@export var __window_override_settings_display_label: Label
@export var __resolutions_options_display: OptionButton
@export var __orientation_check_box: CheckBox
@export var __use_override_check_box: CheckBox
@export var __res: ResolutionGroupsCollection

const __size_viewport_w: String = QuickResConst.Settings.SIZE_VIEWPORT_WIDTH
const __size_viewport_h: String = QuickResConst.Settings.SIZE_VIEWPORT_HEIGHT
const __size_override_w: String = QuickResConst.Settings.SIZE_OVERRIDE_WIDTH
const __size_override_h: String = QuickResConst.Settings.SIZE_OVERRIDE_HEIGHT

var __plugin: EditorPlugin

var __active_res_preset: ActiveDeviceResolution


func _exit_tree() -> void:
	Extras.disconnect_all(__orientation_check_box.toggled)
	Extras.disconnect_all(__use_override_check_box.toggled)
	Extras.disconnect_all(__resolutions_options_display.item_selected)


func _enter_tree() -> void:
	__active_res_preset = load(QuickResConst.Paths.ACTIVE_RESOLUTION)
	__res.refresh()
	__preset_name_label.text = "Presets collection: {name}".format({"name":__res.title})

	__display_saved_settings()

	Extras.connect_once(__use_override_check_box.toggled, __set_use_override_window_size)
	Extras.connect_once(__orientation_check_box.toggled, __switch_orientation)
	__resolutions_options_display.clear()

	for gr in __res.groups:
		__groups_btns.add(gr, __preset_selected)


func init(plugin: EditorPlugin):
	__plugin = plugin


func __preset_selected(_preset_name: String):
	__display_resolutions_list(__res.get_preset_by_name(_preset_name).resolutions)

func __display_resolutions_list(resolutions: Array[DeviceResolution]):
	__resolutions_options_display.clear()

	for res in resolutions:
		var _wh = "[ {width}x{height} ]".format({"width": res.screen_resolution.x, "height": res.screen_resolution.y})
		__resolutions_options_display.add_item(res.model + " - " + _wh)

	Extras.connect_once(__resolutions_options_display.item_selected, __select_resolution)


func __select_resolution(idx: int):
	var data = __res.get_active_preset_resolution_by_index(idx)

	__active_res_preset.model = data.model
	__active_res_preset.release_year = data.release_year
	__active_res_preset.screen_resolution = data.screen_resolution

	if __active_res_preset.use_override:
		__active_res_preset.override_resolution_size = data.override_resolution_size

	__refresh_resolution()

func __set_resolution(resolution: Vector2i, prop_width: String, prop_height: String):

	var width = resolution.x if not __active_res_preset.is_landscape else resolution.y
	var height = resolution.y if not __active_res_preset.is_landscape else resolution.x

	ProjectSettings.set_setting(prop_width, width)
	ProjectSettings.set_setting(prop_height, height)

func __set_use_override_window_size(use_override: bool):
	__active_res_preset.use_override = use_override
	__refresh_resolution()


func __switch_orientation(is_landscape: bool):
	__active_res_preset.is_landscape = is_landscape
	__refresh_resolution()


func __refresh_resolution():
	__set_resolution(__active_res_preset.screen_resolution, __size_viewport_w, __size_viewport_h)
	__set_resolution(__active_res_preset.override_resolution_size, __size_override_w, __size_override_h)

	ProjectSettings.save()
	Extras.serialize_resource(__active_res_preset, QuickResConst.Paths.ACTIVE_RESOLUTION)

	__plugin.refresh_2d_editor_view()
	__display_saved_settings()


func __display_saved_settings():

	__active_res_preset = load(QuickResConst.Paths.ACTIVE_RESOLUTION)

	var viewport_w = ProjectSettings.get_setting(__size_viewport_w)
	var viewport_h = ProjectSettings.get_setting(__size_viewport_h)
	var override_w = ProjectSettings.get_setting(__size_override_w)
	var override_h = ProjectSettings.get_setting(__size_override_h)

	__orientation_check_box.button_pressed = __active_res_preset.is_landscape
	__use_override_check_box.button_pressed = __active_res_preset.use_override

	__device_preset_model_label.text = "model: {model} - {y}".format({"model": __active_res_preset.model, "y": __active_res_preset.release_year})
	__viewport_settings_display_label.text = "size_viewport_[{width} x {height}]".format({
		"width": viewport_w, "height": viewport_h})

	__window_override_settings_display_label.text = "size_override_[{width} x {height}]".format({
		"width": override_w, "height": override_h})
