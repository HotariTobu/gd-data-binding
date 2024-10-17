extends GutTest

var _data: Data

var _double_converter: DoubleConverter
var _int_to_str_converter: IntToStrConverter


func before_all():
	register_inner_classes(get_script())


func before_each():
	_data = Data.new()

	_double_converter = double(DoubleConverter).new()
	stub(_double_converter, "source_to_target").to_call_super()
	stub(_double_converter, "target_to_source").to_call_super()

	_int_to_str_converter = double(IntToStrConverter).new()
	stub(_int_to_str_converter, "source_to_target").to_call_super()
	stub(_int_to_str_converter, "target_to_source").to_call_super()


func test_pass_value_with_one_converter():
	var converter_pipeline = BindingConverterPipeline.new()
	converter_pipeline.append(_int_to_str_converter)

	var binding = Binding.new(_data, "int_var", _data, "str_var", converter_pipeline)

	binding.pass_source_value(5)
	binding.pass_target_value("2")

	assert_eq(_data.int_var, 2)
	assert_eq(_data.str_var, "5")

	assert_call_count(_double_converter, "source_to_target", 0)
	assert_call_count(_double_converter, "target_to_source", 0)
	assert_call_count(_int_to_str_converter, "source_to_target", 1)
	assert_call_count(_int_to_str_converter, "target_to_source", 1)


func test_pass_value_with_two_converters():
	var converter_pipeline = BindingConverterPipeline.new()
	converter_pipeline.append(_double_converter)
	converter_pipeline.append(_int_to_str_converter)

	var binding = Binding.new(_data, "int_var", _data, "str_var", converter_pipeline)

	binding.pass_source_value(5)
	binding.pass_target_value("2")

	assert_eq(_data.int_var, 1)
	assert_eq(_data.str_var, "10")

	assert_call_count(_double_converter, "source_to_target", 1)
	assert_call_count(_double_converter, "target_to_source", 1)
	assert_call_count(_int_to_str_converter, "source_to_target", 1)
	assert_call_count(_int_to_str_converter, "target_to_source", 1)


func test_pass_value_without_converter():
	var binding = Binding.new(_data, "int_var", _data, "str_var")

	binding.pass_source_value("5")
	binding.pass_target_value(2)

	assert_eq(_data.int_var, 2)
	assert_eq(_data.str_var, "5")

	assert_call_count(_double_converter, "source_to_target", 0)
	assert_call_count(_double_converter, "target_to_source", 0)
	assert_call_count(_int_to_str_converter, "source_to_target", 0)
	assert_call_count(_int_to_str_converter, "target_to_source", 0)


class Data:
	var int_var: int
	var str_var: String


class DoubleConverter:
	extends BindingConverter

	func source_to_target(source_value: Variant) -> Variant:
		return source_value * 2

	func target_to_source(target_value: Variant) -> Variant:
		return target_value / 2


class IntToStrConverter:
	extends BindingConverter

	func source_to_target(source_value: Variant) -> Variant:
		return str(source_value)

	func target_to_source(target_value: Variant) -> Variant:
		return int(target_value)
