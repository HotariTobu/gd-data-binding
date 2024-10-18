extends HBoxContainer

const ReturnButton = preload("res://examples/components/return_button.tscn")

static var _return_button: BaseButton

static var _tree: SceneTree:
	get:
		return Engine.get_main_loop()


func _ready():
	if _return_button == null:
		_return_button = ReturnButton.instantiate()
		_return_button.pressed.connect(_change_scene_to.bind("main"))
		_tree.root.add_child.call_deferred(_return_button)

	_return_button.hide()


static func _change_scene_to(scene_name: String):
	var path = "res://examples/%s.tscn" % scene_name
	_tree.change_scene_to_file(path)

	_return_button.show()
