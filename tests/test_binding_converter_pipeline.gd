extends GutTest

var _converter_pipeline: BindingConverterPipeline

var _utils: Utils
var _invert_converter: InvertBoolBindingConverter


func before_all():
	register_inner_classes(get_script())


func before_each():
	_converter_pipeline = BindingConverterPipeline.new()

	_utils = double(Utils).new()
	stub(_utils, "to_int").to_call_super()
	stub(_utils, "to_str").to_call_super()
	stub(_utils, "double").to_call_super()

	_invert_converter = double(InvertBoolBindingConverter).new()
	stub(_invert_converter, "source_to_target").to_call_super()
	stub(_invert_converter, "target_to_source").to_call_super()


func test_copy():
	var copy = _converter_pipeline.copy()
	copy.append(_invert_converter)

	assert_ne(copy, _converter_pipeline)

	assert_true(_converter_pipeline.source_to_target(true))
	assert_false(_converter_pipeline.source_to_target(false))
	assert_true(_converter_pipeline.target_to_source(true))
	assert_false(_converter_pipeline.target_to_source(false))

	assert_true(copy.source_to_target(false))
	assert_false(copy.source_to_target(true))
	assert_true(copy.target_to_source(false))
	assert_false(copy.target_to_source(true))

	assert_call_count(_invert_converter, "source_to_target", 2)
	assert_call_count(_invert_converter, "target_to_source", 2)


func test_append_converter():
	_converter_pipeline.append(_invert_converter)

	assert_true(_converter_pipeline.source_to_target(false))
	assert_false(_converter_pipeline.source_to_target(true))
	assert_true(_converter_pipeline.target_to_source(false))
	assert_false(_converter_pipeline.target_to_source(true))

	assert_call_count(_invert_converter, "source_to_target", 2)
	assert_call_count(_invert_converter, "target_to_source", 2)


func test_append_callable():
	_converter_pipeline.append(_utils.to_int)

	assert_eq(_converter_pipeline.source_to_target(5), 5)
	assert_eq(_converter_pipeline.source_to_target("5"), 5)
	assert_eq(_converter_pipeline.target_to_source(5), 5)
	assert_eq(_converter_pipeline.target_to_source("5"), "5")

	assert_call_count(_utils, "to_int", 2)


func test_append_callable_array():
	_converter_pipeline.append([_utils.to_int, _utils.to_str])

	assert_eq(_converter_pipeline.source_to_target(5), 5)
	assert_eq(_converter_pipeline.source_to_target("5"), 5)
	assert_eq(_converter_pipeline.target_to_source(5), "5")
	assert_eq(_converter_pipeline.target_to_source("5"), "5")

	assert_call_count(_utils, "to_int", 2)
	assert_call_count(_utils, "to_str", 2)


func test_append_callable_arrays():
	_converter_pipeline.append([_utils.to_int, _utils.to_str])
	_converter_pipeline.append([_utils.double, _utils.double])

	assert_eq(_converter_pipeline.source_to_target(5), 10)
	assert_eq(_converter_pipeline.source_to_target("5"), 10)
	assert_eq(_converter_pipeline.target_to_source(5), "10")

	assert_call_count(_utils, "to_int", 2)
	assert_call_count(_utils, "to_str", 1)


class Utils:
	func to_int(value):
		return int(value)

	func to_str(value):
		return str(value)

	func double(value):
		return value * 2
