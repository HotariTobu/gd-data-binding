extends VBoxContainer

var _data = Data.new()


func _ready():
	_update_label_text()


func _on_button_pressed():
	_data.count += 1
	_update_label_text()


func _update_label_text():
	$Label.text = "Count: %s" % _data.count


class Data:
	var count: int = 0
