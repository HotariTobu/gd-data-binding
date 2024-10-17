extends HBoxContainer

var _data = BindingSource.new(Data.new())


func _ready():
	_data.bind("value").using(str).to_label($Col1/DisplayRow/ValueLabel)
	_data.bind("value").to_slider($Col1/HSlider)
	_data.bind("value").to_slider($Col1/VSlider)
	_data.bind("value").to_progress_bar($Col1/ProgressBar)
	_data.bind("value").to_spin_box($Col1/SpinBox)


class Data:
	var value: float = 0
