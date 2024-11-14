extends VBoxContainer

var _data = BindingSource.new(Data.new())


func _ready():
	_data.bind(&"count").using(_get_label).to_label($Label)


func _on_button_pressed():
	_data.count += 1


static func _get_label(count: int):
	return "Count: %s" % count


class Data:
	var count: int = 0
