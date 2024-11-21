extends HBoxContainer

var _data = BindingSource.new(Data.new())


func _ready():
	_data.bind(&"binary_state").using(BoolToOnOff.new()).to_label($Col1/DisplayRow/BinaryStateLabel)

	_data.bind(&"binary_state").to_toggle_button($Col1/Button)
	_data.bind(&"binary_state").to_check_box($Col1/CheckBox)
	_data.bind(&"binary_state").to_check_button($Col1/CheckButton)

	var invert_converter = InvertBoolBindingConverter.new()
	_data.bind(&"binary_state").using(invert_converter).to_toggle_button($Col1/InvertedButton)
	_data.bind(&"binary_state").using(invert_converter).to_check_box($Col1/InvertedCheckBox)
	_data.bind(&"binary_state").using(invert_converter).to_check_button($Col1/InvertedCheckButton)

	_data.bind(&"color").using(ColorToCode.new()).to_label($Col2/DisplayRow/ColorLabel)
	_data.bind(&"color").to_color_picker_button($Col2/ColorPickerButton)
	_data.bind(&"color").to_color_rect($Col2/ColorRect)

	_data.bind(&"option_index").using(str).to_label($Col3/DisplayRow/OptionIndexLabel)
	_data.bind(&"option_index").to_option_button($Col3/OptionButton)

	# gdlint:ignore = constant-name
	const Mode = Data.TravelMode
	var get_mode_key = func(mode: Mode): return Mode.find_key(mode)
	# gdlint:ignore = function-variable-name,
	var Case = CaseBindingConverter
	_data.bind(&"travel_mode").using(get_mode_key).to_label($Col4/DisplayRow/RadioValueLabel)
	_data.bind(&"travel_mode").using(Case.new(Mode.DRIVING)).to_check_box($Col4/DrivingCheckBox)
	_data.bind(&"travel_mode").using(Case.new(Mode.TRANSIT)).to_check_box($Col4/TransitCheckBox)
	_data.bind(&"travel_mode").using(Case.new(Mode.WALKING)).to_check_box($Col4/WalkingCheckBox)
	_data.bind(&"travel_mode").using(Case.new(Mode.CYCLING)).to_check_box($Col4/CyclingCheckBox)
	_data.bind(&"travel_mode").using(Case.new(Mode.FLIGHTS)).to_check_box($Col4/FlightsCheckBox)


func _on_on_button_pressed():
	_data.binary_state = true


func _on_off_button_pressed():
	_data.binary_state = false


func _on_select_button_pressed(option_index):
	_data.option_index = option_index


func _on_deselect_button_pressed():
	_data.option_index = -1


func _on_color_button_pressed(color):
	_data.color = color


class Data:
	enum TravelMode { DRIVING, TRANSIT, WALKING, CYCLING, FLIGHTS }

	var binary_state = false

	var color = Color.RED

	var option_index: int = -1

	var travel_mode: TravelMode = TravelMode.DRIVING


class BoolToOnOff:
	extends BindingConverter

	func source_to_target(source_value: Variant) -> Variant:
		return "On" if source_value else "Off"


class ColorToCode:
	extends BindingConverter

	func source_to_target(source_value: Variant) -> Variant:
		var color = source_value as Color
		return color.to_html()
