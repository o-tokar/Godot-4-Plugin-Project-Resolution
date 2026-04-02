@tool
class_name ArrayBtnsSignalGroup extends CanvasItem
@export var __btn_tscn: PackedScene
var __btns: Array[BaseButton]
var __btns_group = ButtonGroup.new()


func _exit_tree() -> void:
	for i in range(__btns.size()):
		var btn = __btns[i]
		Extras.disconnect_all(btn.pressed)
		btn.queue_free()


func add(data: ResolutionPresetsGroup, on_select_preset: Callable):
	var btn = __btn_tscn.instantiate()
	Extras.connect_once(btn.pressed, on_select_preset.bind(data.preset_name))
	add_child(btn)
	btn.button_group = __btns_group
	btn.toggle_mode = true
	btn.text = data.preset_name