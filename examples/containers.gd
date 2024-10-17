extends HBoxContainer

var _data = BindingSource.new(Data.new())


func _ready():
	_data.bind("split_offset").using(str).to_label($Col1/DisplayRow/SplitOffsetLabel)
	_data.bind("split_offset").to_split_container($Col1/HSplitContainer)
	_data.bind("split_offset").to_split_container($Col1/VSplitContainer)

	_data.bind("tab_index").using(_get_tab_name).to_label($Col2/DisplayRow/TabLabel)
	_data.bind("tab_index").to_tab_container($Col2/TabContainer)


func _get_tab_name(index: int) -> String:
	var tab = $Col2/TabContainer.get_child(index)
	return tab.name


class Data:
	var split_offset: int = 20

	var tab_index: int = 0
