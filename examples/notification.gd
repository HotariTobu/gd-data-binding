extends HBoxContainer

var _data = BindingSource.new(Data.new(), "notified")


func _ready():
	_data.bind("items").using(", ".join).to_label($Col1/DisplayRow/ItemsLabel)
	_data.bind("current_item").to_line_edit($Col1/ActionRow/ItemEdit)


func _on_item_edit_text_submitted(new_text):
	_data.add_item.call(new_text)
	_data.current_item = ""


func _on_add_button_pressed():
	_data.add_current_item.call()


class Data:
	signal notified(property: StringName)

	var items: Array[String] = ["Apple", "Banana"]
	var current_item = ""

	func add_item(item: String):
		if item == "":
			return

		items.append(item)
		notified.emit(&"items")

	func add_current_item():
		if current_item == "":
			return

		add_item(current_item)

		current_item = ""
		notified.emit(&"current_item")
