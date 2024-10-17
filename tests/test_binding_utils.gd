extends GutTest


func test_to_int():
	assert_eq(BindingUtils.to_int(5), 5)
	assert_eq(BindingUtils.to_int(5.0), 5)
	assert_eq(BindingUtils.to_int("5"), 5)
	assert_eq(BindingUtils.to_int("5.0"), 5)
	assert_eq(BindingUtils.to_int("3.14"), 3)


func test_to_float():
	assert_eq(BindingUtils.to_float(5), 5.0)
	assert_eq(BindingUtils.to_float(5.0), 5.0)
	assert_eq(BindingUtils.to_float("5"), 5.0)
	assert_eq(BindingUtils.to_float("5.0"), 5.0)
	assert_eq(BindingUtils.to_float("3.14"), 3.14)
