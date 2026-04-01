@tool
class_name ResolutionPresets extends Resource

@export var __preset_groups: Array[ResolutionsGroupPreset] = []

var __presets: Dictionary[String, ResolutionsGroupPreset]
var __active_preset: ResolutionsGroupPreset

var groups: Array[ResolutionsGroupPreset]:
	get:
		return __presets.values()


func refresh():
	__presets.clear()
	for preset in __preset_groups:
		__presets[preset.preset_name] = preset

func get_preset_by_name(_preset_name: String) -> ResolutionsGroupPreset:
	__active_preset = __presets[_preset_name]
	return __presets[_preset_name]

func get_preset_by_index(idx: int) -> ResolutionsGroupPreset:
	return __presets.values()[idx]


func get_active_preset_resolution_by_index(idx: int) -> DeviceResolution:
	return __active_preset.resolutions[idx]
