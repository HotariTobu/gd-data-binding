extends GutTest


func test_convert():
	var converter = InvertBoolBindingConverter.new()

	assert_true(converter.source_to_target(false))
	assert_false(converter.source_to_target(true))
	assert_true(converter.target_to_source(false))
	assert_false(converter.target_to_source(true))
