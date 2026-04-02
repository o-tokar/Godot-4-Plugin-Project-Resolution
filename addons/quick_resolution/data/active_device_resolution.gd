@tool
class_name ActiveDeviceResolution extends DeviceResolution

@export var is_landscape: bool

@export var use_override: bool:
	set(value):
		use_override = value
		if not value:
			override_resolution_size = Vector2i.ZERO
		else:
			override_resolution_size = __calc_override_resolution_size(screen_resolution, dpr)