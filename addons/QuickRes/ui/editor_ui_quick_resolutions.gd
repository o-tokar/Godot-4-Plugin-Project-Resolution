@tool
class_name QuickResolutionEditorUI extends Control

@export var __groups_btns: ArrayBtnsSignalGroup
@export var __viewport_settings_display_label: Label
@export var __window_override_settings_display_label: Label
@export var __resolutions_options_display: OptionButton
@export var __check_box_orientation: CheckBox
@export var __res: ResolutionPresets
@export var __save_resolution: ActiveResolutionData

@export var __display_viewport_size_widget: DisplaySettingsSizeWidget
@export var __display_override_size_widget: DisplaySettingsSizeWidget


var __plugin: EditorPlugin
var __is_landscape: bool

var __active_resolution: Vector2i = Vector2i.ZERO


func _exit_tree() -> void:
	Extras.disconnect_all(__check_box_orientation.pressed)
	Extras.disconnect_all(__resolutions_options_display.item_selected)
	Extras.disconnect_all(__display_viewport_size_widget.set_resolution_size_signal)
	Extras.disconnect_all(__display_override_size_widget.set_resolution_size_signal)


func _enter_tree() -> void:
	__res.refresh()

	__display_saved_settings()
	Extras.connect_once(__display_viewport_size_widget.set_resolution_size_signal, __set_viewport_size)
	Extras.connect_once(__display_override_size_widget.set_resolution_size_signal, __set_window_size_override)

	__is_landscape = __active_resolution.x > __active_resolution.y
	__check_box_orientation.button_pressed = __is_landscape

	Extras.connect_once(__check_box_orientation.toggled, __switch_orientation)
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
	var resolution = __res.get_active_preset_resolution_by_index(idx).screen_resolution
	__active_resolution = resolution
	__display_viewport_size_widget.resolution = resolution
	__display_override_size_widget.resolution = resolution

func __set_viewport_size(v2i: Vector2i):
	__set_resolution(v2i, Const.Settings.SIZE_VIEWPORT_WIDTH, Const.Settings.SIZE_VIEWPORT_HEIGHT)


func __set_window_size_override(v2i: Vector2i):
	__set_resolution(v2i, Const.Settings.SIZE_OVERRIDE_WIDTH, Const.Settings.SIZE_OVERRIDE_HEIGHT)


func __set_resolution(v2i: Vector2i, prop_width: String, prop_height: String):
	var resolution = v2i

	if resolution == Vector2i.ZERO:
		return

	var width = resolution.x if not __is_landscape else resolution.y
	var height = resolution.y if not __is_landscape else resolution.x

	ProjectSettings.set_setting(prop_width, width)
	ProjectSettings.set_setting(prop_height, height)

	ProjectSettings.save()
	__display_saved_settings()
	__plugin.refresh_2d_editor_view()


func __switch_orientation(is_landscape: bool):
	__is_landscape = is_landscape
	# todo: update resolution.

func __display_saved_settings():
	__viewport_settings_display_label.text = "size_viewport_[{width} x {height}]".format({
		"width": ProjectSettings.get_setting(Const.Settings.SIZE_VIEWPORT_WIDTH),
		"height": ProjectSettings.get_setting(Const.Settings.SIZE_VIEWPORT_HEIGHT)})

	__window_override_settings_display_label.text = "size_override_[{width} x {height}]".format({
		"width": ProjectSettings.get_setting(Const.Settings.SIZE_OVERRIDE_WIDTH),
		"height": ProjectSettings.get_setting(Const.Settings.SIZE_OVERRIDE_HEIGHT)})
