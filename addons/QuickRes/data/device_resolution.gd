@tool
class_name DeviceResolution extends Resource

## Device model name
@export var model: String:
	set(value):
		model = value

		# print("filename suggestion: "+
		# value.replace(".", "_")
		# .replace(" ", "_")
		# .replace("-", "_")
		# .replace("\"", "")
		# .replace("(", "")
		# .replace(")", "")
		# .replace("+", "_plus")
		# .replace("__", "_").to_lower())

## Viewport Size: The rendering resolution in logical pixels
@export var override_resolution_size: Vector2i

## The actual number of physical pixels on the device
@export var screen_resolution: Vector2i

## Device Pixel Ratio
@export var dpr: float = 1.00:
	set(value):
		dpr = value
		if screen_resolution == Vector2i.ZERO:
			return

		override_resolution_size = __calc_override_resolution_size(screen_resolution, snapped(dpr, 0.001))
		emit_changed()

func __calc_override_resolution_size(v2i: Vector2i, v: float) -> Vector2i:
	return Vector2i(roundi(v2i.x / v), roundi(v2i.y / v))

## Device release year
@export var release_year: int
