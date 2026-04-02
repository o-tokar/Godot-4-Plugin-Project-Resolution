@tool
class_name ResolutionGroupsCollection extends Resource

@export var title: String
@export var __preset_groups: Array[ResolutionPresetsGroup] = []

var __presets: Dictionary[String, ResolutionPresetsGroup]
var __active_preset: ResolutionPresetsGroup

var groups: Array[ResolutionPresetsGroup]:
	get:
		return __presets.values()


func refresh():
	__presets.clear()
	for preset in __preset_groups:
		__presets[preset.preset_name] = preset

func get_preset_by_name(_preset_name: String) -> ResolutionPresetsGroup:
	__active_preset = __presets[_preset_name]
	return __presets[_preset_name]

func get_preset_by_index(idx: int) -> ResolutionPresetsGroup:
	return __presets.values()[idx]


func get_active_preset_resolution_by_index(idx: int) -> DeviceResolution:
	return __active_preset.resolutions[idx]
