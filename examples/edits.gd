extends HBoxContainer

var _data = BindingSource.new(Data.new())


func _ready():
	_data.bind("line").to_label($Col1/GridContainer/LineLabel)
	_data.bind("line").to_line_edit(
		$Col1/GridContainer/OnSubmittedLineEdit, BindingSource.LineEditTrigger.ON_SUBMITTED
	)
	_data.bind("line").to_line_edit($Col1/GridContainer/OnFocusExitedLineEdit)
	_data.bind("line").to_line_edit(
		$Col1/GridContainer/OnChangedLineEdit, BindingSource.LineEditTrigger.ON_CHANGED
	)

	_data.bind("text").to_text_edit($Col2/TextEdit, BindingSource.TextEditTrigger.ON_CHANGED)
	_data.bind("text").to_label($Col2/ScrollContainer/TextLabel)


class Data:
	var line = "Hello_World!"

	# gdlint:ignore = max-line-length
	var text = "The cat sat on the mat, staring intently at the tiny mouse hole. It had been waiting patiently for hours, hoping to catch a glimpse of its prey. Suddenly, the mouse darted out, unaware of the danger lurking nearby. The cat pounced, its claws extended, and captured the mouse in its grasp. Victorious, the cat returned to its mat, satisfied with its successful hunt."
