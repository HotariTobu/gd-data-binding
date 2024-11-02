extends GutTest

signal notified(property: StringName)

enum TargetSignal { INSTANCE, NAME, NONE }

const TestBaseBindingSource = preload("res://tests/test_base_binding_source.gd")

var _source_dict: Dictionary
var _sources: Array:
	get:
		return _source_dict.values()


func before_each():
	var data = TestBaseBindingSource.Data.new()

	var x2 = func(value): return value * 2

	var dict_source_with_wrapped_target = BindingSource.new(TestBaseBindingSource.dict_new())
	dict_source_with_wrapped_target.bind("single_value").using(x2).to(
		dict_source_with_wrapped_target, "double_value"
	)

	var dict = TestBaseBindingSource.dict_new()
	var dict_source_without_wrapped_target = BindingSource.new(dict)
	dict_source_without_wrapped_target.bind("single_value").using(x2).to(dict, "double_value")

	_source_dict = {
		"with_str_notification": BindingSource.new(TestBaseBindingSource.Data.new(), "notified"),
		"with_dir_notification": BindingSource.new(data, data.notified),
		"with_ext_notification": BindingSource.new(TestBaseBindingSource.Data.new(), notified),
		"without_notification": BindingSource.new(TestBaseBindingSource.Data.new()),
		"dict_with_wrapped_target": dict_source_with_wrapped_target,
		"dict_without_wrapped_target": dict_source_without_wrapped_target,
	}

	for source in _sources:
		source.int_var = 1
		source.str_var = "2"

		source.int_prop = 3
		source.str_prop = "4"

		source.single_value = 5


func test_access_src(source: BindingSource = use_parameters(_sources)):
	assert_eq(source.int_var, 1)
	assert_eq(source.str_var, "2")

	assert_eq(source.int_prop, 3)
	assert_eq(source.str_prop, "4")

	assert_eq(source.single_value, 5)
	assert_eq(source.double_value, 10)


func test_init_target_value(
	param: Dictionary = use_parameters(_get_params_for_test_init_target_value())
):
	var source_key = param["source_key"]
	var target_signal = param["target_signal"]

	var source = _source_dict[source_key]
	var target_objects = _create_bound_target_objects(source, target_signal)

	assert_eq(target_objects["data_int_var"].int_var, 1)
	assert_eq(target_objects["data_int_var"].str_var, "1")
	assert_eq(target_objects["data_int_var"].int_prop, 1)
	assert_eq(target_objects["data_int_var"].str_prop, "1")
	assert_eq(target_objects["data_int_var"].single_value, 1)
	assert_eq(target_objects["data_int_var"].double_value, 2)

	assert_eq(target_objects["data_str_var"].int_var, 2)
	assert_eq(target_objects["data_str_var"].str_var, "2")
	assert_eq(target_objects["data_str_var"].int_prop, 2)
	assert_eq(target_objects["data_str_var"].str_prop, "2")
	assert_eq(target_objects["data_str_var"].single_value, 2)
	assert_eq(target_objects["data_str_var"].double_value, 4)

	assert_eq(target_objects["data_int_prop"].int_var, 3)
	assert_eq(target_objects["data_int_prop"].str_var, "3")
	assert_eq(target_objects["data_int_prop"].int_prop, 3)
	assert_eq(target_objects["data_int_prop"].str_prop, "3")
	assert_eq(target_objects["data_int_prop"].single_value, 3)
	assert_eq(target_objects["data_int_prop"].double_value, 6)

	assert_eq(target_objects["data_str_prop"].int_var, 4)
	assert_eq(target_objects["data_str_prop"].str_var, "4")
	assert_eq(target_objects["data_str_prop"].int_prop, 4)
	assert_eq(target_objects["data_str_prop"].str_prop, "4")
	assert_eq(target_objects["data_str_prop"].single_value, 4)
	assert_eq(target_objects["data_str_prop"].double_value, 8)

	assert_eq(target_objects["data_single_value"].int_var, 5)
	assert_eq(target_objects["data_single_value"].str_var, "5")
	assert_eq(target_objects["data_single_value"].int_prop, 5)
	assert_eq(target_objects["data_single_value"].str_prop, "5")
	assert_eq(target_objects["data_single_value"].single_value, 5)
	assert_eq(target_objects["data_single_value"].double_value, 10)

	assert_eq(target_objects["data_double_value"].int_var, 10)
	assert_eq(target_objects["data_double_value"].str_var, "10")
	assert_eq(target_objects["data_double_value"].int_prop, 10)
	assert_eq(target_objects["data_double_value"].str_prop, "10")
	assert_eq(target_objects["data_double_value"].single_value, 10)
	assert_eq(target_objects["data_double_value"].double_value, 20)

	assert_eq(target_objects["dict_int_var"].int_var, 1)
	assert_eq(target_objects["dict_int_var"].str_var, "1")
	assert_eq(target_objects["dict_int_var"].int_prop, 1)
	assert_eq(target_objects["dict_int_var"].str_prop, "1")
	assert_eq(target_objects["dict_int_var"].single_value, 1)

	assert_eq(target_objects["dict_str_var"].int_var, 2)
	assert_eq(target_objects["dict_str_var"].str_var, "2")
	assert_eq(target_objects["dict_str_var"].int_prop, 2)
	assert_eq(target_objects["dict_str_var"].str_prop, "2")
	assert_eq(target_objects["dict_str_var"].single_value, 2)

	assert_eq(target_objects["dict_int_prop"].int_var, 3)
	assert_eq(target_objects["dict_int_prop"].str_var, "3")
	assert_eq(target_objects["dict_int_prop"].int_prop, 3)
	assert_eq(target_objects["dict_int_prop"].str_prop, "3")
	assert_eq(target_objects["dict_int_prop"].single_value, 3)

	assert_eq(target_objects["dict_str_prop"].int_var, 4)
	assert_eq(target_objects["dict_str_prop"].str_var, "4")
	assert_eq(target_objects["dict_str_prop"].int_prop, 4)
	assert_eq(target_objects["dict_str_prop"].str_prop, "4")
	assert_eq(target_objects["dict_str_prop"].single_value, 4)

	assert_eq(target_objects["dict_single_value"].int_var, 5)
	assert_eq(target_objects["dict_single_value"].str_var, "5")
	assert_eq(target_objects["dict_single_value"].int_prop, 5)
	assert_eq(target_objects["dict_single_value"].str_prop, "5")
	assert_eq(target_objects["dict_single_value"].single_value, 5)

	assert_eq(target_objects["dict_double_value"].int_var, 10)
	assert_eq(target_objects["dict_double_value"].str_var, "10")
	assert_eq(target_objects["dict_double_value"].int_prop, 10)
	assert_eq(target_objects["dict_double_value"].str_prop, "10")
	assert_eq(target_objects["dict_double_value"].single_value, 10)


func test_source_to_target(
	param: Dictionary = use_parameters(_get_params_for_test_source_to_target())
):
	var source_key = param["source_key"]
	var target_signal = param["target_signal"]

	var source = _source_dict[source_key]
	var target_objects = _create_bound_target_objects(source, target_signal)

	source.int_var = 6
	source.str_var = "7"

	source.int_prop = 8
	source.str_prop = "9"

	source.single_value = 10

	assert_eq(target_objects["data_int_var"].int_var, 6)
	assert_eq(target_objects["data_int_var"].str_var, "6")
	assert_eq(target_objects["data_int_var"].int_prop, 6)
	assert_eq(target_objects["data_int_var"].str_prop, "6")
	assert_eq(target_objects["data_int_var"].single_value, 6)
	assert_eq(target_objects["data_int_var"].double_value, 12)

	assert_eq(target_objects["data_str_var"].int_var, 7)
	assert_eq(target_objects["data_str_var"].str_var, "7")
	assert_eq(target_objects["data_str_var"].int_prop, 7)
	assert_eq(target_objects["data_str_var"].str_prop, "7")
	assert_eq(target_objects["data_str_var"].single_value, 7)
	assert_eq(target_objects["data_str_var"].double_value, 14)

	assert_eq(target_objects["data_int_prop"].int_var, 8)
	assert_eq(target_objects["data_int_prop"].str_var, "8")
	assert_eq(target_objects["data_int_prop"].int_prop, 8)
	assert_eq(target_objects["data_int_prop"].str_prop, "8")
	assert_eq(target_objects["data_int_prop"].single_value, 8)
	assert_eq(target_objects["data_int_prop"].double_value, 16)

	assert_eq(target_objects["data_str_prop"].int_var, 9)
	assert_eq(target_objects["data_str_prop"].str_var, "9")
	assert_eq(target_objects["data_str_prop"].int_prop, 9)
	assert_eq(target_objects["data_str_prop"].str_prop, "9")
	assert_eq(target_objects["data_str_prop"].single_value, 9)
	assert_eq(target_objects["data_str_prop"].double_value, 18)

	assert_eq(target_objects["data_single_value"].int_var, 10)
	assert_eq(target_objects["data_single_value"].str_var, "10")
	assert_eq(target_objects["data_single_value"].int_prop, 10)
	assert_eq(target_objects["data_single_value"].str_prop, "10")
	assert_eq(target_objects["data_single_value"].single_value, 10)
	assert_eq(target_objects["data_single_value"].double_value, 20)

	assert_eq(target_objects["dict_int_var"].int_var, 6)
	assert_eq(target_objects["dict_int_var"].str_var, "6")
	assert_eq(target_objects["dict_int_var"].int_prop, 6)
	assert_eq(target_objects["dict_int_var"].str_prop, "6")
	assert_eq(target_objects["dict_int_var"].single_value, 6)

	assert_eq(target_objects["dict_str_var"].int_var, 7)
	assert_eq(target_objects["dict_str_var"].str_var, "7")
	assert_eq(target_objects["dict_str_var"].int_prop, 7)
	assert_eq(target_objects["dict_str_var"].str_prop, "7")
	assert_eq(target_objects["dict_str_var"].single_value, 7)

	assert_eq(target_objects["dict_int_prop"].int_var, 8)
	assert_eq(target_objects["dict_int_prop"].str_var, "8")
	assert_eq(target_objects["dict_int_prop"].int_prop, 8)
	assert_eq(target_objects["dict_int_prop"].str_prop, "8")
	assert_eq(target_objects["dict_int_prop"].single_value, 8)

	assert_eq(target_objects["dict_str_prop"].int_var, 9)
	assert_eq(target_objects["dict_str_prop"].str_var, "9")
	assert_eq(target_objects["dict_str_prop"].int_prop, 9)
	assert_eq(target_objects["dict_str_prop"].str_prop, "9")
	assert_eq(target_objects["dict_str_prop"].single_value, 9)

	assert_eq(target_objects["dict_single_value"].int_var, 10)
	assert_eq(target_objects["dict_single_value"].str_var, "10")
	assert_eq(target_objects["dict_single_value"].int_prop, 10)
	assert_eq(target_objects["dict_single_value"].str_prop, "10")
	assert_eq(target_objects["dict_single_value"].single_value, 10)

	_unbind_target_objects(source, target_objects)

	source.int_var = 11
	source.str_var = "12"

	source.int_prop = 13
	source.str_prop = "14"

	source.single_value = 15

	assert_eq(source.int_var, 11)
	assert_eq(source.str_var, "12")

	assert_eq(source.int_prop, 13)
	assert_eq(source.str_prop, "14")

	assert_eq(source.single_value, 15)
	assert_eq(source.double_value, 30)

	assert_eq(target_objects["data_int_var"].int_var, 6)
	assert_eq(target_objects["data_int_var"].str_var, "6")
	assert_eq(target_objects["data_int_var"].int_prop, 6)
	assert_eq(target_objects["data_int_var"].str_prop, "6")
	assert_eq(target_objects["data_int_var"].single_value, 6)
	assert_eq(target_objects["data_int_var"].double_value, 12)

	assert_eq(target_objects["data_str_var"].int_var, 7)
	assert_eq(target_objects["data_str_var"].str_var, "7")
	assert_eq(target_objects["data_str_var"].int_prop, 7)
	assert_eq(target_objects["data_str_var"].str_prop, "7")
	assert_eq(target_objects["data_str_var"].single_value, 7)
	assert_eq(target_objects["data_str_var"].double_value, 14)

	assert_eq(target_objects["data_int_prop"].int_var, 8)
	assert_eq(target_objects["data_int_prop"].str_var, "8")
	assert_eq(target_objects["data_int_prop"].int_prop, 8)
	assert_eq(target_objects["data_int_prop"].str_prop, "8")
	assert_eq(target_objects["data_int_prop"].single_value, 8)
	assert_eq(target_objects["data_int_prop"].double_value, 16)

	assert_eq(target_objects["data_str_prop"].int_var, 9)
	assert_eq(target_objects["data_str_prop"].str_var, "9")
	assert_eq(target_objects["data_str_prop"].int_prop, 9)
	assert_eq(target_objects["data_str_prop"].str_prop, "9")
	assert_eq(target_objects["data_str_prop"].single_value, 9)
	assert_eq(target_objects["data_str_prop"].double_value, 18)

	assert_eq(target_objects["data_single_value"].int_var, 10)
	assert_eq(target_objects["data_single_value"].str_var, "10")
	assert_eq(target_objects["data_single_value"].int_prop, 10)
	assert_eq(target_objects["data_single_value"].str_prop, "10")
	assert_eq(target_objects["data_single_value"].single_value, 10)
	assert_eq(target_objects["data_single_value"].double_value, 20)

	assert_eq(target_objects["dict_int_var"].int_var, 6)
	assert_eq(target_objects["dict_int_var"].str_var, "6")
	assert_eq(target_objects["dict_int_var"].int_prop, 6)
	assert_eq(target_objects["dict_int_var"].str_prop, "6")
	assert_eq(target_objects["dict_int_var"].single_value, 6)

	assert_eq(target_objects["dict_str_var"].int_var, 7)
	assert_eq(target_objects["dict_str_var"].str_var, "7")
	assert_eq(target_objects["dict_str_var"].int_prop, 7)
	assert_eq(target_objects["dict_str_var"].str_prop, "7")
	assert_eq(target_objects["dict_str_var"].single_value, 7)

	assert_eq(target_objects["dict_int_prop"].int_var, 8)
	assert_eq(target_objects["dict_int_prop"].str_var, "8")
	assert_eq(target_objects["dict_int_prop"].int_prop, 8)
	assert_eq(target_objects["dict_int_prop"].str_prop, "8")
	assert_eq(target_objects["dict_int_prop"].single_value, 8)

	assert_eq(target_objects["dict_str_prop"].int_var, 9)
	assert_eq(target_objects["dict_str_prop"].str_var, "9")
	assert_eq(target_objects["dict_str_prop"].int_prop, 9)
	assert_eq(target_objects["dict_str_prop"].str_prop, "9")
	assert_eq(target_objects["dict_str_prop"].single_value, 9)

	assert_eq(target_objects["dict_single_value"].int_var, 10)
	assert_eq(target_objects["dict_single_value"].str_var, "10")
	assert_eq(target_objects["dict_single_value"].int_prop, 10)
	assert_eq(target_objects["dict_single_value"].str_prop, "10")
	assert_eq(target_objects["dict_single_value"].single_value, 10)


func test_source_to_target_double_value_with_str_notification():
	var source = _source_dict["with_str_notification"]
	var with_signal_instance = _create_bound_target_objects(source, TargetSignal.INSTANCE)
	var with_signal_name = _create_bound_target_objects(source, TargetSignal.NAME)
	var without_signal = _create_bound_target_objects(source, TargetSignal.NONE)

	source.single_value = 10

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)

	_unbind_target_objects(source, with_signal_instance)
	_unbind_target_objects(source, with_signal_name)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)


func test_source_to_target_double_value_with_dir_notification():
	var source = _source_dict["with_dir_notification"]
	var with_signal_instance = _create_bound_target_objects(source, TargetSignal.INSTANCE)
	var with_signal_name = _create_bound_target_objects(source, TargetSignal.NAME)
	var without_signal = _create_bound_target_objects(source, TargetSignal.NONE)

	source.single_value = 10

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)

	_unbind_target_objects(source, with_signal_instance)
	_unbind_target_objects(source, with_signal_name)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)


func test_source_to_target_double_value_with_ext_notification():
	var source = _source_dict["with_ext_notification"]
	var with_signal_instance = _create_bound_target_objects(source, TargetSignal.INSTANCE)
	var with_signal_name = _create_bound_target_objects(source, TargetSignal.NAME)
	var without_signal = _create_bound_target_objects(source, TargetSignal.NONE)

	source.single_value = 10
	notified.emit("double_value")

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)

	_unbind_target_objects(source, with_signal_instance)
	_unbind_target_objects(source, with_signal_name)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20
	notified.emit("double_value")

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)


func test_source_to_target_double_value_without_notification():
	var source = _source_dict["without_notification"]
	var with_signal_instance = _create_bound_target_objects(source, TargetSignal.INSTANCE)
	var with_signal_name = _create_bound_target_objects(source, TargetSignal.NAME)
	var without_signal = _create_bound_target_objects(source, TargetSignal.NONE)

	source.single_value = 10

	assert_eq(with_signal_instance["data_double_value"].int_var, 10)
	assert_eq(with_signal_instance["data_double_value"].str_var, "10")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["data_double_value"].single_value, 10)
	assert_eq(with_signal_instance["data_double_value"].double_value, 20)

	assert_eq(with_signal_name["data_double_value"].int_var, 10)
	assert_eq(with_signal_name["data_double_value"].str_var, "10")
	assert_eq(with_signal_name["data_double_value"].int_prop, 10)
	assert_eq(with_signal_name["data_double_value"].str_prop, "10")
	assert_eq(with_signal_name["data_double_value"].single_value, 10)
	assert_eq(with_signal_name["data_double_value"].double_value, 20)

	assert_eq(without_signal["data_double_value"].int_var, 10)
	assert_eq(without_signal["data_double_value"].str_var, "10")
	assert_eq(without_signal["data_double_value"].int_prop, 10)
	assert_eq(without_signal["data_double_value"].str_prop, "10")
	assert_eq(without_signal["data_double_value"].single_value, 10)
	assert_eq(without_signal["data_double_value"].double_value, 20)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "10")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 10)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 10)
	assert_eq(with_signal_name["dict_double_value"].str_var, "10")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_name["dict_double_value"].single_value, 10)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 10)
	assert_eq(without_signal["dict_double_value"].str_var, "10")
	assert_eq(without_signal["dict_double_value"].int_prop, 10)
	assert_eq(without_signal["dict_double_value"].str_prop, "10")
	assert_eq(without_signal["dict_double_value"].single_value, 10)
	assert_eq(without_signal["dict_double_value"].double_value, 0)

	_unbind_target_objects(source, with_signal_instance)
	_unbind_target_objects(source, with_signal_name)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal_instance["data_double_value"].int_var, 10)
	assert_eq(with_signal_instance["data_double_value"].str_var, "10")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["data_double_value"].single_value, 10)
	assert_eq(with_signal_instance["data_double_value"].double_value, 20)

	assert_eq(with_signal_name["data_double_value"].int_var, 10)
	assert_eq(with_signal_name["data_double_value"].str_var, "10")
	assert_eq(with_signal_name["data_double_value"].int_prop, 10)
	assert_eq(with_signal_name["data_double_value"].str_prop, "10")
	assert_eq(with_signal_name["data_double_value"].single_value, 10)
	assert_eq(with_signal_name["data_double_value"].double_value, 20)

	assert_eq(without_signal["data_double_value"].int_var, 10)
	assert_eq(without_signal["data_double_value"].str_var, "10")
	assert_eq(without_signal["data_double_value"].int_prop, 10)
	assert_eq(without_signal["data_double_value"].str_prop, "10")
	assert_eq(without_signal["data_double_value"].single_value, 10)
	assert_eq(without_signal["data_double_value"].double_value, 20)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "10")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 10)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 10)
	assert_eq(with_signal_name["dict_double_value"].str_var, "10")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_name["dict_double_value"].single_value, 10)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 10)
	assert_eq(without_signal["dict_double_value"].str_var, "10")
	assert_eq(without_signal["dict_double_value"].int_prop, 10)
	assert_eq(without_signal["dict_double_value"].str_prop, "10")
	assert_eq(without_signal["dict_double_value"].single_value, 10)
	assert_eq(without_signal["dict_double_value"].double_value, 0)


func test_source_to_target_double_value_dict_with_wrapped_target():
	var source = _source_dict["dict_with_wrapped_target"]
	var with_signal_instance = _create_bound_target_objects(source, TargetSignal.INSTANCE)
	var with_signal_name = _create_bound_target_objects(source, TargetSignal.NAME)
	var without_signal = _create_bound_target_objects(source, TargetSignal.NONE)

	source.single_value = 10

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)

	_unbind_target_objects(source, with_signal_instance)
	_unbind_target_objects(source, with_signal_name)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal_instance["data_double_value"].int_var, 20)
	assert_eq(with_signal_instance["data_double_value"].str_var, "20")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["data_double_value"].single_value, 20)
	assert_eq(with_signal_instance["data_double_value"].double_value, 40)

	assert_eq(with_signal_name["data_double_value"].int_var, 20)
	assert_eq(with_signal_name["data_double_value"].str_var, "20")
	assert_eq(with_signal_name["data_double_value"].int_prop, 20)
	assert_eq(with_signal_name["data_double_value"].str_prop, "20")
	assert_eq(with_signal_name["data_double_value"].single_value, 20)
	assert_eq(with_signal_name["data_double_value"].double_value, 40)

	assert_eq(without_signal["data_double_value"].int_var, 20)
	assert_eq(without_signal["data_double_value"].str_var, "20")
	assert_eq(without_signal["data_double_value"].int_prop, 20)
	assert_eq(without_signal["data_double_value"].str_prop, "20")
	assert_eq(without_signal["data_double_value"].single_value, 20)
	assert_eq(without_signal["data_double_value"].double_value, 40)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "20")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 20)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 20)
	assert_eq(with_signal_name["dict_double_value"].str_var, "20")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 20)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "20")
	assert_eq(with_signal_name["dict_double_value"].single_value, 20)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 20)
	assert_eq(without_signal["dict_double_value"].str_var, "20")
	assert_eq(without_signal["dict_double_value"].int_prop, 20)
	assert_eq(without_signal["dict_double_value"].str_prop, "20")
	assert_eq(without_signal["dict_double_value"].single_value, 20)
	assert_eq(without_signal["dict_double_value"].double_value, 0)


func test_source_to_target_double_value_dict_without_wrapped_target():
	var source = _source_dict["dict_without_wrapped_target"]
	var with_signal_instance = _create_bound_target_objects(source, TargetSignal.INSTANCE)
	var with_signal_name = _create_bound_target_objects(source, TargetSignal.NAME)
	var without_signal = _create_bound_target_objects(source, TargetSignal.NONE)

	source.single_value = 10

	assert_eq(with_signal_instance["data_double_value"].int_var, 10)
	assert_eq(with_signal_instance["data_double_value"].str_var, "10")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["data_double_value"].single_value, 10)
	assert_eq(with_signal_instance["data_double_value"].double_value, 20)

	assert_eq(with_signal_name["data_double_value"].int_var, 10)
	assert_eq(with_signal_name["data_double_value"].str_var, "10")
	assert_eq(with_signal_name["data_double_value"].int_prop, 10)
	assert_eq(with_signal_name["data_double_value"].str_prop, "10")
	assert_eq(with_signal_name["data_double_value"].single_value, 10)
	assert_eq(with_signal_name["data_double_value"].double_value, 20)

	assert_eq(without_signal["data_double_value"].int_var, 10)
	assert_eq(without_signal["data_double_value"].str_var, "10")
	assert_eq(without_signal["data_double_value"].int_prop, 10)
	assert_eq(without_signal["data_double_value"].str_prop, "10")
	assert_eq(without_signal["data_double_value"].single_value, 10)
	assert_eq(without_signal["data_double_value"].double_value, 20)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "10")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 10)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 10)
	assert_eq(with_signal_name["dict_double_value"].str_var, "10")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_name["dict_double_value"].single_value, 10)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 10)
	assert_eq(without_signal["dict_double_value"].str_var, "10")
	assert_eq(without_signal["dict_double_value"].int_prop, 10)
	assert_eq(without_signal["dict_double_value"].str_prop, "10")
	assert_eq(without_signal["dict_double_value"].single_value, 10)
	assert_eq(without_signal["dict_double_value"].double_value, 0)

	_unbind_target_objects(source, with_signal_instance)
	_unbind_target_objects(source, with_signal_name)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal_instance["data_double_value"].int_var, 10)
	assert_eq(with_signal_instance["data_double_value"].str_var, "10")
	assert_eq(with_signal_instance["data_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["data_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["data_double_value"].single_value, 10)
	assert_eq(with_signal_instance["data_double_value"].double_value, 20)

	assert_eq(with_signal_name["data_double_value"].int_var, 10)
	assert_eq(with_signal_name["data_double_value"].str_var, "10")
	assert_eq(with_signal_name["data_double_value"].int_prop, 10)
	assert_eq(with_signal_name["data_double_value"].str_prop, "10")
	assert_eq(with_signal_name["data_double_value"].single_value, 10)
	assert_eq(with_signal_name["data_double_value"].double_value, 20)

	assert_eq(without_signal["data_double_value"].int_var, 10)
	assert_eq(without_signal["data_double_value"].str_var, "10")
	assert_eq(without_signal["data_double_value"].int_prop, 10)
	assert_eq(without_signal["data_double_value"].str_prop, "10")
	assert_eq(without_signal["data_double_value"].single_value, 10)
	assert_eq(without_signal["data_double_value"].double_value, 20)

	assert_eq(with_signal_instance["dict_double_value"].int_var, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_var, "10")
	assert_eq(with_signal_instance["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_instance["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_instance["dict_double_value"].single_value, 10)
	assert_eq(with_signal_instance["dict_double_value"].double_value, 0)

	assert_eq(with_signal_name["dict_double_value"].int_var, 10)
	assert_eq(with_signal_name["dict_double_value"].str_var, "10")
	assert_eq(with_signal_name["dict_double_value"].int_prop, 10)
	assert_eq(with_signal_name["dict_double_value"].str_prop, "10")
	assert_eq(with_signal_name["dict_double_value"].single_value, 10)
	assert_eq(with_signal_name["dict_double_value"].double_value, 0)

	assert_eq(without_signal["dict_double_value"].int_var, 10)
	assert_eq(without_signal["dict_double_value"].str_var, "10")
	assert_eq(without_signal["dict_double_value"].int_prop, 10)
	assert_eq(without_signal["dict_double_value"].str_prop, "10")
	assert_eq(without_signal["dict_double_value"].single_value, 10)
	assert_eq(without_signal["dict_double_value"].double_value, 0)


func test_target_to_source(
	param: Dictionary = use_parameters(_get_params_for_test_target_to_source())
):
	var source_key = param["source_key"]
	var target_signal = param["target_signal"]

	var source = _source_dict[source_key]
	var target_objects = _create_bound_target_objects(source, target_signal)

	target_objects["data_int_var"].int_var_changed.emit(6)
	assert_eq(source.int_var, 6)
	target_objects["data_int_var"].str_var_changed.emit("7")
	assert_eq(source.int_var, 7)
	target_objects["data_int_var"].int_prop_changed.emit(8)
	assert_eq(source.int_var, 8)
	target_objects["data_int_var"].str_prop_changed.emit("9")
	assert_eq(source.int_var, 9)
	target_objects["data_int_var"].single_value_changed.emit(10)
	assert_eq(source.int_var, 10)

	target_objects["data_str_var"].int_var_changed.emit(6)
	assert_eq(source.str_var, "6")
	target_objects["data_str_var"].str_var_changed.emit("7")
	assert_eq(source.str_var, "7")
	target_objects["data_str_var"].int_prop_changed.emit(8)
	assert_eq(source.str_var, "8")
	target_objects["data_str_var"].str_prop_changed.emit("9")
	assert_eq(source.str_var, "9")
	target_objects["data_str_var"].single_value_changed.emit(10)
	assert_eq(source.str_var, "10")

	target_objects["data_int_prop"].int_var_changed.emit(6)
	assert_eq(source.int_prop, 6)
	target_objects["data_int_prop"].str_var_changed.emit("7")
	assert_eq(source.int_prop, 7)
	target_objects["data_int_prop"].int_prop_changed.emit(8)
	assert_eq(source.int_prop, 8)
	target_objects["data_int_prop"].str_prop_changed.emit("9")
	assert_eq(source.int_prop, 9)
	target_objects["data_int_prop"].single_value_changed.emit(10)
	assert_eq(source.int_prop, 10)

	target_objects["data_str_prop"].int_var_changed.emit(6)
	assert_eq(source.str_prop, "6")
	target_objects["data_str_prop"].str_var_changed.emit("7")
	assert_eq(source.str_prop, "7")
	target_objects["data_str_prop"].int_prop_changed.emit(8)
	assert_eq(source.str_prop, "8")
	target_objects["data_str_prop"].str_prop_changed.emit("9")
	assert_eq(source.str_prop, "9")
	target_objects["data_str_prop"].single_value_changed.emit(10)
	assert_eq(source.str_prop, "10")

	target_objects["data_single_value"].int_var_changed.emit(6)
	assert_eq(source.single_value, 6)
	target_objects["data_single_value"].str_var_changed.emit("7")
	assert_eq(source.single_value, 7)
	target_objects["data_single_value"].int_prop_changed.emit(8)
	assert_eq(source.single_value, 8)
	target_objects["data_single_value"].str_prop_changed.emit("9")
	assert_eq(source.single_value, 9)
	target_objects["data_single_value"].single_value_changed.emit(10)
	assert_eq(source.single_value, 10)

	_unbind_target_objects(source, target_objects)

	target_objects["data_int_var"].int_var_changed.emit(11)
	assert_eq(source.int_var, 10)
	target_objects["data_int_var"].str_var_changed.emit("12")
	assert_eq(source.int_var, 10)
	target_objects["data_int_var"].int_prop_changed.emit(13)
	assert_eq(source.int_var, 10)
	target_objects["data_int_var"].str_prop_changed.emit("14")
	assert_eq(source.int_var, 10)
	target_objects["data_int_var"].single_value_changed.emit(15)
	assert_eq(source.int_var, 10)

	target_objects["data_str_var"].int_var_changed.emit(11)
	assert_eq(source.str_var, "10")
	target_objects["data_str_var"].str_var_changed.emit("12")
	assert_eq(source.str_var, "10")
	target_objects["data_str_var"].int_prop_changed.emit(13)
	assert_eq(source.str_var, "10")
	target_objects["data_str_var"].str_prop_changed.emit("14")
	assert_eq(source.str_var, "10")
	target_objects["data_str_var"].single_value_changed.emit(15)
	assert_eq(source.str_var, "10")

	target_objects["data_int_prop"].int_var_changed.emit(11)
	assert_eq(source.int_prop, 10)
	target_objects["data_int_prop"].str_var_changed.emit("12")
	assert_eq(source.int_prop, 10)
	target_objects["data_int_prop"].int_prop_changed.emit(13)
	assert_eq(source.int_prop, 10)
	target_objects["data_int_prop"].str_prop_changed.emit("14")
	assert_eq(source.int_prop, 10)
	target_objects["data_int_prop"].single_value_changed.emit(15)
	assert_eq(source.int_prop, 10)

	target_objects["data_str_prop"].int_var_changed.emit(11)
	assert_eq(source.str_prop, "10")
	target_objects["data_str_prop"].str_var_changed.emit("12")
	assert_eq(source.str_prop, "10")
	target_objects["data_str_prop"].int_prop_changed.emit(13)
	assert_eq(source.str_prop, "10")
	target_objects["data_str_prop"].str_prop_changed.emit("14")
	assert_eq(source.str_prop, "10")
	target_objects["data_str_prop"].single_value_changed.emit(15)
	assert_eq(source.str_prop, "10")

	target_objects["data_single_value"].int_var_changed.emit(11)
	assert_eq(source.single_value, 10)
	target_objects["data_single_value"].str_var_changed.emit("12")
	assert_eq(source.single_value, 10)
	target_objects["data_single_value"].int_prop_changed.emit(13)
	assert_eq(source.single_value, 10)
	target_objects["data_single_value"].str_prop_changed.emit("14")
	assert_eq(source.single_value, 10)
	target_objects["data_single_value"].single_value_changed.emit(15)
	assert_eq(source.single_value, 10)


func _get_params_for_test_init_target_value():
	return _get_params_for_test_source_to_target()


func _get_params_for_test_source_to_target():
	var params = []

	for source_key in _source_dict:
		for target_signal in TargetSignal.values():
			var param = {"source_key": source_key, "target_signal": target_signal}
			params.append(param)

	return params


func _get_params_for_test_target_to_source():
	var params = []

	for source_key in _source_dict:
		for target_signal in [TargetSignal.INSTANCE, TargetSignal.NAME]:
			var param = {"source_key": source_key, "target_signal": target_signal}
			params.append(param)

	return params


func _create_bound_target_objects(source: BindingSource, target_signal: TargetSignal):
	var target_objects = TestBaseBindingSource.create_target_objects()
	_bind_target_objects(source, target_objects, target_signal)
	return target_objects


func _bind_target_objects(
	source: BindingSource, target_objects: Dictionary, target_signal: TargetSignal
):
	_bind_int(source, "int_var", target_objects["data_int_var"], target_signal)
	_bind_str(source, "str_var", target_objects["data_str_var"], target_signal)

	_bind_int(source, "int_prop", target_objects["data_int_prop"], target_signal)
	_bind_str(source, "str_prop", target_objects["data_str_prop"], target_signal)

	_bind_int(source, "single_value", target_objects["data_single_value"], target_signal)
	_bind_int(source, "double_value", target_objects["data_double_value"], target_signal)

	_bind_int(source, "int_var", target_objects["dict_int_var"], TargetSignal.NONE)
	_bind_str(source, "str_var", target_objects["dict_str_var"], TargetSignal.NONE)

	_bind_int(source, "int_prop", target_objects["dict_int_prop"], TargetSignal.NONE)
	_bind_str(source, "str_prop", target_objects["dict_str_prop"], TargetSignal.NONE)

	_bind_int(source, "single_value", target_objects["dict_single_value"], TargetSignal.NONE)
	_bind_int(source, "double_value", target_objects["dict_double_value"], TargetSignal.NONE)


func _unbind_target_objects(source: BindingSource, target_objects: Dictionary):
	_unbind(source, "int_var", target_objects["data_int_var"])
	_unbind(source, "str_var", target_objects["data_str_var"])

	_unbind(source, "int_prop", target_objects["data_int_prop"])
	_unbind(source, "str_prop", target_objects["data_str_prop"])

	_unbind(source, "single_value", target_objects["data_single_value"])
	_unbind(source, "double_value", target_objects["data_double_value"])

	_unbind(source, "int_var", target_objects["dict_int_var"])
	_unbind(source, "str_var", target_objects["dict_str_var"])

	_unbind(source, "int_prop", target_objects["dict_int_prop"])
	_unbind(source, "str_prop", target_objects["dict_str_prop"])

	_unbind(source, "single_value", target_objects["dict_single_value"])
	_unbind(source, "double_value", target_objects["dict_double_value"])


func _bind_int(
	source: BindingSource,
	source_property: StringName,
	target_object,
	target_signal: TargetSignal
):
	var converter = [str, BindingUtils.to_int]

	match target_signal:
		TargetSignal.INSTANCE:
			source.bind(source_property).to(target_object, "int_var", target_object.int_var_changed)
			source.bind(source_property).using(converter).to(
				target_object, "str_var", target_object.str_var_changed
			)

			source.bind(source_property).to(
				target_object, "int_prop", target_object.int_prop_changed
			)
			source.bind(source_property).using(converter).to(
				target_object, "str_prop", target_object.str_prop_changed
			)

			source.bind(source_property).to(
				target_object, "single_value", target_object.single_value_changed
			)

		TargetSignal.NAME:
			source.bind(source_property).to(target_object, "int_var", "int_var_changed")
			source.bind(source_property).using(converter).to(
				target_object, "str_var", "str_var_changed"
			)

			source.bind(source_property).to(target_object, "int_prop", "int_prop_changed")
			source.bind(source_property).using(converter).to(
				target_object, "str_prop", "str_prop_changed"
			)

			source.bind(source_property).to(target_object, "single_value", "single_value_changed")

		TargetSignal.NONE:
			source.bind(source_property).to(target_object, "int_var")
			source.bind(source_property).using(converter).to(target_object, "str_var")

			source.bind(source_property).to(target_object, "int_prop")
			source.bind(source_property).using(converter).to(target_object, "str_prop")

			source.bind(source_property).to(target_object, "single_value")


func _bind_str(
	source: BindingSource,
	source_property: StringName,
	target_object,
	target_signal: TargetSignal
):
	var converter = [BindingUtils.to_int, str]

	match target_signal:
		TargetSignal.INSTANCE:
			source.bind(source_property).using(converter).to(
				target_object, "int_var", target_object.int_var_changed
			)
			source.bind(source_property).to(target_object, "str_var", target_object.str_var_changed)

			source.bind(source_property).using(converter).to(
				target_object, "int_prop", target_object.int_prop_changed
			)
			source.bind(source_property).to(
				target_object, "str_prop", target_object.str_prop_changed
			)

			source.bind(source_property).using(converter).to(
				target_object, "single_value", target_object.single_value_changed
			)

		TargetSignal.NAME:
			source.bind(source_property).using(converter).to(
				target_object, "int_var", "int_var_changed"
			)
			source.bind(source_property).to(target_object, "str_var", "str_var_changed")

			source.bind(source_property).using(converter).to(
				target_object, "int_prop", "int_prop_changed"
			)
			source.bind(source_property).to(target_object, "str_prop", "str_prop_changed")

			source.bind(source_property).using(converter).to(
				target_object, "single_value", "single_value_changed"
			)

		TargetSignal.NONE:
			source.bind(source_property).using(converter).to(target_object, "int_var")
			source.bind(source_property).to(target_object, "str_var")

			source.bind(source_property).using(converter).to(target_object, "int_prop")
			source.bind(source_property).to(target_object, "str_prop")

			source.bind(source_property).using(converter).to(target_object, "single_value")


func _unbind(source: BindingSource, source_property: StringName, target_object):
	source.unbind(source_property).from(target_object, "int_var")
	source.unbind(source_property).from(target_object, "str_var")

	source.unbind(source_property).from(target_object, "int_prop")
	source.unbind(source_property).from(target_object, "str_prop")

	source.unbind(source_property).from(target_object, "single_value")


# gdlint:ignore = max-public-methods
class TestBinder:
	extends GutTest

	var _root_viewport: SubViewport
	var _source: BindingSource

	func before_each():
		_root_viewport = add_child_autofree(SubViewport.new())
		_root_viewport.gui_embed_subwindows = true

		_source = BindingSource.new(Data.new())
		_source.bool_var = false
		_source.color_var = Color.WHITE
		_source.int_var = 0
		_source.str_var = ""

		#var sprite: Sprite2D = add_child_autofree(Sprite2D.new())
		#sprite.texture = _root_viewport.get_texture()
		#sprite.centered = false

	func test_toggle_button():
		var toggle_button = Button.new()
		toggle_button.toggle_mode = true
		_add_and_focus(toggle_button)

		_source.bind("bool_var").to_toggle_button(toggle_button)

		_source.bool_var = true
		assert_true(toggle_button.button_pressed)

		_accept()
		assert_false(_source.bool_var)

		_source.unbind("bool_var").from_toggle_button(toggle_button)

		_source.bool_var = true
		assert_false(toggle_button.button_pressed)

		_source.bool_var = false
		_accept()
		assert_false(_source.bool_var)
		assert_true(toggle_button.button_pressed)

	func test_check_box():
		var check_box = CheckBox.new()
		_add_and_focus(check_box)

		_source.bind("bool_var").to_check_box(check_box)

		_source.bool_var = true
		assert_true(check_box.button_pressed)

		_accept()
		assert_false(_source.bool_var)

		_source.unbind("bool_var").from_check_box(check_box)

		_source.bool_var = true
		assert_false(check_box.button_pressed)

		_source.bool_var = false
		_accept()
		assert_false(_source.bool_var)
		assert_true(check_box.button_pressed)

	func test_check_button():
		var check_button = CheckButton.new()
		_add_and_focus(check_button)

		_source.bind("bool_var").to_check_button(check_button)

		_source.bool_var = true
		assert_true(check_button.button_pressed)

		_accept()
		assert_false(_source.bool_var)

		_source.unbind("bool_var").from_check_button(check_button)

		_source.bool_var = true
		assert_false(check_button.button_pressed)

		_source.bool_var = false
		_accept()
		assert_false(_source.bool_var)
		assert_true(check_button.button_pressed)

	func test_color_picker_button():
		var color_picker_button = ColorPickerButton.new()
		_add_and_focus(color_picker_button)

		_source.bind("color_var").to_color_picker_button(color_picker_button)

		_source.color_var = Color.BLACK
		assert_eq(color_picker_button.color, Color.BLACK)

		_accept()
		await wait_frames(1)
		_push_unicode_input("f")
		_key(KEY_ENTER)
		assert_eq(_source.color_var, Color.WHITE)

		_source.unbind("color_var").from_color_picker_button(color_picker_button)

		_source.color_var = Color.BLACK
		assert_eq(color_picker_button.color, Color.WHITE)

		await wait_frames(1)
		_accept()
		await wait_frames(1)
		_push_unicode_input("red")
		_key(KEY_ENTER)
		assert_eq(_source.color_var, Color.BLACK)
		assert_eq(color_picker_button.color, Color.RED)

	func test_option_button():
		var option_button = OptionButton.new()
		option_button.add_item("")
		option_button.add_item("")
		_add_and_focus(option_button)

		_source.bind("int_var").to_option_button(option_button)

		_source.int_var = -1
		assert_eq(option_button.selected, -1)

		_accept()
		_accept()
		assert_eq(_source.int_var, 0)

		_source.unbind("int_var").from_option_button(option_button)

		_source.int_var = -1
		assert_eq(option_button.selected, 0)

		_accept()
		_key(KEY_DOWN)
		_accept()
		assert_eq(_source.int_var, -1)
		assert_eq(option_button.selected, 1)

	func test_color_rect():
		var color_rect = ColorRect.new()
		_add_and_focus(color_rect)

		_source.bind("color_var").to_color_rect(color_rect)

		_source.color_var = Color.BLACK
		assert_eq(color_rect.color, Color.BLACK)

		_source.unbind("color_var").from_color_rect(color_rect)

		_source.color_var = Color.WHITE
		assert_eq(color_rect.color, Color.BLACK)

	func test_color_picker():
		var color_picker = ColorPicker.new()
		_add_and_focus(color_picker)

		var line_edits = color_picker.find_children("", "LineEdit", true, false)
		line_edits[-1].grab_focus()

		_source.bind("color_var").to_color_picker(color_picker)

		_source.color_var = Color.BLACK
		assert_eq(color_picker.color, Color.BLACK)

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("f")
		_key(KEY_ENTER)
		assert_eq(_source.color_var, Color.WHITE)

		_source.unbind("color_var").from_color_picker(color_picker)

		_source.color_var = Color.BLACK
		assert_eq(color_picker.color, Color.WHITE)

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("red")
		_key(KEY_ENTER)
		assert_eq(_source.color_var, Color.BLACK)
		assert_eq(color_picker.color, Color.RED)

	func test_split_container():
		var split_container = SplitContainer.new()
		split_container.size = Vector2(100, 100)
		split_container.add_child(Control.new())
		split_container.add_child(Control.new())
		_add_and_focus(split_container)

		_source.bind("int_var").to_split_container(split_container)

		_source.int_var = 50
		assert_eq(split_container.split_offset, 50)

		await wait_frames(1)
		_drag(Vector2(50, 50))
		assert_eq(_source.int_var, 0)

		_source.unbind("int_var").from_split_container(split_container)

		_source.int_var = 100
		assert_eq(split_container.split_offset, 0)

		await wait_frames(1)
		_drag(Vector2.ZERO, Vector2(50, 50))
		assert_eq(_source.int_var, 100)
		assert_eq(split_container.split_offset, 50)

	func test_tab_container():
		var tab_container = TabContainer.new()
		tab_container.add_child(Control.new())
		tab_container.add_child(Control.new())
		tab_container.add_child(Control.new())
		_add_and_focus(tab_container)

		var tab_bar = tab_container.get_tab_bar()
		tab_bar.grab_focus()

		_source.bind("int_var").to_tab_container(tab_container)

		_source.int_var = 1
		assert_eq(tab_container.current_tab, 1)

		_key(KEY_LEFT)
		assert_eq(_source.int_var, 0)

		_source.unbind("int_var").from_tab_container(tab_container)

		_source.int_var = 1
		assert_eq(tab_container.current_tab, 0)

		_key(KEY_RIGHT)
		_key(KEY_RIGHT)
		assert_eq(_source.int_var, 1)
		assert_eq(tab_container.current_tab, 2)

	func test_label():
		var label = Label.new()
		_add_and_focus(label)

		_source.bind("str_var").to_label(label)

		_source.str_var = "Hello"
		assert_eq(label.text, "Hello")

		_source.unbind("str_var").from_label(label)

		_source.str_var = "Hi"
		assert_eq(label.text, "Hello")

	func test_line_edit_on_submitted():
		var line_edit = LineEdit.new()
		_add_and_focus(line_edit)

		_source.bind("str_var").to_line_edit(line_edit, BindingSource.LineEditTrigger.ON_SUBMITTED)

		_source.str_var = "Hello"
		assert_eq(line_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		_key(KEY_ENTER)
		assert_eq(_source.str_var, "Hi")

		_source.unbind("str_var").from_line_edit(line_edit)

		_source.str_var = "Hello"
		assert_eq(line_edit.text, "Hi")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		_key(KEY_ENTER)
		assert_eq(_source.str_var, "Hello")
		assert_eq(line_edit.text, "Bye")

	func test_line_edit_on_focus_exited():
		var line_edit = LineEdit.new()
		_add_and_focus(line_edit)

		_source.bind("str_var").to_line_edit(line_edit)

		_source.str_var = "Hello"
		assert_eq(line_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		line_edit.release_focus()
		assert_eq(_source.str_var, "Hi")
		line_edit.grab_focus()

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		Input.action_press("ui_cancel")
		line_edit.release_focus()
		assert_eq(_source.str_var, "Hi")
		Input.action_release("ui_cancel")
		line_edit.grab_focus()

		_source.unbind("str_var").from_line_edit(line_edit)

		_source.str_var = "Hello"
		assert_eq(line_edit.text, "Bye")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		line_edit.release_focus()
		assert_eq(_source.str_var, "Hello")
		assert_eq(line_edit.text, "Hi")
		line_edit.grab_focus()

	func test_line_edit_on_changed():
		var line_edit = LineEdit.new()
		_add_and_focus(line_edit)

		_source.bind("str_var").to_line_edit(line_edit, BindingSource.LineEditTrigger.ON_CHANGED)

		_source.str_var = "Hello"
		assert_eq(line_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		await wait_frames(1)
		assert_eq(_source.str_var, "Hi")

		_source.unbind("str_var").from_line_edit(line_edit)

		_source.str_var = "Hello"
		assert_eq(line_edit.text, "Hi")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		assert_eq(_source.str_var, "Hello")
		assert_eq(line_edit.text, "Bye")

	func test_progress_bar():
		var progress_bar = ProgressBar.new()
		_add_and_focus(progress_bar)

		_source.bind("float_var").to_progress_bar(progress_bar)

		_source.float_var = 100.0
		assert_eq(progress_bar.value, 100.0)

		_source.unbind("float_var").from_progress_bar(progress_bar)

		_source.float_var = 0.0
		assert_eq(progress_bar.value, 100.0)

	func test_h_slider():
		var h_slider = HSlider.new()
		h_slider.size = Vector2(100, 0)
		_add_and_focus(h_slider)

		_source.bind("float_var").to_slider(h_slider)

		_source.float_var = 100.0
		assert_eq(h_slider.value, 100.0)

		_drag(Vector2(95, 5))
		assert_eq(_source.float_var, 0.0)

		_source.unbind("float_var").from_slider(h_slider)

		_source.float_var = 50.0
		assert_eq(h_slider.value, 0.0)

		_drag(Vector2(5, 5), Vector2(95, 5))
		assert_eq(_source.float_var, 50.0)
		assert_eq(h_slider.value, 100.0)

	func test_v_slider():
		var v_slider = VSlider.new()
		v_slider.size = Vector2(0, 100)
		_add_and_focus(v_slider)

		_source.bind("float_var").to_slider(v_slider)

		_source.float_var = 100.0
		assert_eq(v_slider.value, 100.0)

		_drag(Vector2(5, 5), Vector2(5, 95))
		assert_eq(_source.float_var, 0.0)

		_source.unbind("float_var").from_slider(v_slider)

		_source.float_var = 50.0
		assert_eq(v_slider.value, 0.0)

		_drag(Vector2(5, 95), Vector2(5, 5))
		assert_eq(_source.float_var, 50.0)
		assert_eq(v_slider.value, 100.0)

	func test_spin_box():
		var spin_box = SpinBox.new()
		_add_and_focus(spin_box)

		var line_edit = spin_box.get_line_edit()
		line_edit.grab_focus()

		_source.bind("float_var").to_spin_box(spin_box)

		_source.float_var = 100.0
		assert_eq(spin_box.value, 100.0)

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("0")
		_key(KEY_ENTER)
		await wait_frames(1)
		assert_eq(_source.float_var, 0.0)

		_source.unbind("float_var").from_spin_box(spin_box)

		_source.float_var = 50.0
		assert_eq(spin_box.value, 0.0)

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("100")
		_key(KEY_ENTER)
		await wait_frames(1)
		assert_eq(_source.float_var, 50.0)
		assert_eq(spin_box.value, 100.0)

	func test_texture_progress_bar():
		var texture_progress_bar = TextureProgressBar.new()
		_add_and_focus(texture_progress_bar)

		_source.bind("float_var").to_texture_progress_bar(texture_progress_bar)

		_source.float_var = 100.0
		assert_eq(texture_progress_bar.value, 100.0)

		_source.unbind("float_var").from_texture_progress_bar(texture_progress_bar)

		_source.float_var = 0.0
		assert_eq(texture_progress_bar.value, 100.0)

	func test_tab_bar():
		var tab_bar = TabBar.new()
		tab_bar.add_tab()
		tab_bar.add_tab()
		tab_bar.add_tab()
		_add_and_focus(tab_bar)

		_source.bind("int_var").to_tab_bar(tab_bar)

		_source.int_var = 1
		assert_eq(tab_bar.current_tab, 1)

		_key(KEY_LEFT)
		assert_eq(_source.int_var, 0)

		_source.unbind("int_var").from_tab_bar(tab_bar)

		_source.int_var = 1
		assert_eq(tab_bar.current_tab, 0)

		_key(KEY_RIGHT)
		_key(KEY_RIGHT)
		assert_eq(_source.int_var, 1)
		assert_eq(tab_bar.current_tab, 2)

	func test_text_edit_on_focus_exited():
		var text_edit = TextEdit.new()
		_add_and_focus(text_edit)

		_source.bind("str_var").to_text_edit(text_edit)

		_source.str_var = "Hello"
		assert_eq(text_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		text_edit.release_focus()
		assert_eq(_source.str_var, "Hi")
		text_edit.grab_focus()

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		Input.action_press("ui_cancel")
		text_edit.release_focus()
		assert_eq(_source.str_var, "Hi")
		Input.action_release("ui_cancel")
		text_edit.grab_focus()

		_source.unbind("str_var").from_text_edit(text_edit)

		_source.str_var = "Hello"
		assert_eq(text_edit.text, "Bye")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		text_edit.release_focus()
		assert_eq(_source.str_var, "Hello")
		assert_eq(text_edit.text, "Hi")
		text_edit.grab_focus()

	func test_text_edit_on_changed():
		var text_edit = TextEdit.new()
		_add_and_focus(text_edit)

		_source.bind("str_var").to_text_edit(text_edit, BindingSource.TextEditTrigger.ON_CHANGED)

		_source.str_var = "Hello"
		assert_eq(text_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		await wait_frames(1)
		assert_eq(_source.str_var, "Hi")

		_source.unbind("str_var").from_text_edit(text_edit)

		_source.str_var = "Hello"
		assert_eq(text_edit.text, "Hi")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		assert_eq(_source.str_var, "Hello")
		assert_eq(text_edit.text, "Bye")

	func test_code_edit_on_focus_exited():
		var code_edit = CodeEdit.new()
		_add_and_focus(code_edit)

		_source.bind("str_var").to_code_edit(code_edit)

		_source.str_var = "Hello"
		assert_eq(code_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		code_edit.release_focus()
		assert_eq(_source.str_var, "Hi")
		code_edit.grab_focus()

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		Input.action_press("ui_cancel")
		code_edit.release_focus()
		assert_eq(_source.str_var, "Hi")
		Input.action_release("ui_cancel")
		code_edit.grab_focus()

		_source.unbind("str_var").from_code_edit(code_edit)

		_source.str_var = "Hello"
		assert_eq(code_edit.text, "Bye")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		code_edit.release_focus()
		assert_eq(_source.str_var, "Hello")
		assert_eq(code_edit.text, "Hi")
		code_edit.grab_focus()

	func test_code_edit_on_changed():
		var code_edit = CodeEdit.new()
		_add_and_focus(code_edit)

		_source.bind("str_var").to_code_edit(code_edit, BindingSource.TextEditTrigger.ON_CHANGED)

		_source.str_var = "Hello"
		assert_eq(code_edit.text, "Hello")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Hi")
		await wait_frames(1)
		assert_eq(_source.str_var, "Hi")

		_source.unbind("str_var").from_code_edit(code_edit)

		_source.str_var = "Hello"
		assert_eq(code_edit.text, "Hi")

		_key(KEY_A | KEY_MASK_CMD_OR_CTRL)
		_push_unicode_input("Bye")
		assert_eq(_source.str_var, "Hello")
		assert_eq(code_edit.text, "Bye")

	func _add_and_focus(control: Control):
		_root_viewport.add_child(control)
		if control.focus_mode != Control.FOCUS_NONE:
			control.grab_focus()

	func _push_input(event: InputEvent):
		_root_viewport.push_input(event)

	func _push_unicode_input(text: String):
		for index in range(len(text)):
			var unicode = text.unicode_at(index)
			_unicode(unicode)

	func _accept():
		var press_event = InputEventAction.new()
		press_event.action = "ui_accept"
		press_event.pressed = true

		var release_event = InputEventAction.new()
		release_event.action = "ui_accept"
		release_event.pressed = false

		_push_input(press_event)
		_push_input(release_event)

	func _key(key: int):
		var keycode = key & KEY_CODE_MASK

		var alt_pressed = key & KEY_MASK_ALT != 0
		var command_or_control_autoremap = key & KEY_MASK_CMD_OR_CTRL != 0
		var ctrl_pressed = key & KEY_MASK_CTRL != 0
		var meta_pressed = key & KEY_MASK_META != 0
		var shift_pressed = key & KEY_MASK_SHIFT != 0

		var press_event = InputEventKey.new()
		press_event.keycode = keycode
		press_event.key_label = keycode
		press_event.physical_keycode = keycode
		press_event.pressed = true

		press_event.alt_pressed = alt_pressed
		press_event.ctrl_pressed = ctrl_pressed
		press_event.meta_pressed = meta_pressed
		press_event.command_or_control_autoremap = command_or_control_autoremap
		press_event.shift_pressed = shift_pressed

		var release_event = InputEventKey.new()
		release_event.keycode = keycode
		release_event.key_label = keycode
		release_event.physical_keycode = keycode
		release_event.pressed = false

		release_event.alt_pressed = alt_pressed
		release_event.ctrl_pressed = ctrl_pressed
		release_event.meta_pressed = meta_pressed
		release_event.command_or_control_autoremap = command_or_control_autoremap
		release_event.shift_pressed = shift_pressed

		_push_input(press_event)
		_push_input(release_event)

	func _unicode(unicode: int):
		var press_event = InputEventKey.new()
		press_event.pressed = true
		press_event.unicode = unicode

		var release_event = InputEventKey.new()
		release_event.pressed = false
		release_event.unicode = unicode

		_push_input(press_event)
		_push_input(release_event)

	func _drag(from: Vector2 = Vector2.ZERO, to: Vector2 = Vector2.ZERO):
		var press_event = InputEventMouseButton.new()
		press_event.button_index = MOUSE_BUTTON_LEFT
		press_event.pressed = true
		press_event.button_mask = MOUSE_BUTTON_MASK_LEFT
		press_event.position = from

		var move_event = InputEventMouseMotion.new()
		move_event.relative = to - from
		move_event.position = to

		var release_event = InputEventMouseButton.new()
		release_event.button_index = MOUSE_BUTTON_LEFT
		release_event.pressed = false
		release_event.position = to

		_push_input(press_event)
		_push_input(move_event)
		_push_input(release_event)

	class Data:
		var bool_var: bool
		var color_var: Color
		var int_var: int
		var str_var: String
		var float_var: float

# gdlint:ignore = max-file-lines
