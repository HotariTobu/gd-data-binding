extends GutTest

signal notified(property: StringName)

enum TargetSignal { INSTANCE, NAME, NONE }

var _source_dict: Dictionary
var _sources: Array:
	get:
		return _source_dict.values()


func before_all():
	var data = Data.new()

	var x2 = func(value): return value * 2

	var dict_source_with_wrapped_target = BaseBindingSource.new(_dict_new())
	dict_source_with_wrapped_target.bind_to(
		"single_value",
		dict_source_with_wrapped_target,
		"double_value",
		BindingConverterPipeline.new([x2])
	)

	var dict = _dict_new()
	var dict_source_without_wrapped_target = BaseBindingSource.new(dict)
	dict_source_without_wrapped_target.bind_to(
		"single_value", dict, "double_value", BindingConverterPipeline.new([x2])
	)

	_source_dict = {
		"with_str_notification": BaseBindingSource.new(Data.new(), "notified"),
		"with_dir_notification": BaseBindingSource.new(data, data.notified),
		"with_ext_notification": BaseBindingSource.new(Data.new(), notified),
		"without_notification": BaseBindingSource.new(Data.new()),
		"dict_with_wrapped_target": dict_source_with_wrapped_target,
		"dict_without_wrapped_target": dict_source_without_wrapped_target,
	}


func before_each():
	for source in _sources:
		source.int_var = 1
		source.str_var = "2"

		source.int_prop = 3
		source.str_prop = "4"

		source.single_value = 5


func test_access_src(source: BaseBindingSource = use_parameters(_sources)):
	assert_eq(source.int_var, 1)
	assert_eq(source.str_var, "2")

	assert_eq(source.int_prop, 3)
	assert_eq(source.str_prop, "4")

	assert_eq(source.single_value, 5)
	assert_eq(source.double_value, 10)


func test_init_target_value(
	target_objects: Dictionary = use_parameters(_get_params_for_test_init_target_value())
):
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
	var source = param["source"]
	var target_objects = param["target_objects"]

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
	var param: Dictionary = await _get_param_for_test_source_to_target_double_value(
		"with_str_notification"
	)
	var source = param["source"]
	var with_signal_instance = param["with_signal_instance"]
	var with_signal_name = param["with_signal_name"]
	var without_signal = param["without_signal"]

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
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"with_dir_notification"
	)
	var source = param["source"]
	var with_signal_instance = param["with_signal_instance"]
	var with_signal_name = param["with_signal_name"]
	var without_signal = param["without_signal"]

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
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"with_ext_notification"
	)
	var source = param["source"]
	var with_signal_instance = param["with_signal_instance"]
	var with_signal_name = param["with_signal_name"]
	var without_signal = param["without_signal"]

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
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"without_notification"
	)
	var source = param["source"]
	var with_signal_instance = param["with_signal_instance"]
	var with_signal_name = param["with_signal_name"]
	var without_signal = param["without_signal"]

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
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"dict_with_wrapped_target"
	)
	var source = param["source"]
	var with_signal_instance = param["with_signal_instance"]
	var with_signal_name = param["with_signal_name"]
	var without_signal = param["without_signal"]

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
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"dict_without_wrapped_target"
	)
	var source = param["source"]
	var with_signal_instance = param["with_signal_instance"]
	var with_signal_name = param["with_signal_name"]
	var without_signal = param["without_signal"]

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
	var source = param["source"]
	var target_objects = param["target_objects"]

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
	var params = []

	for source in _sources:
		var with_signal_instance = _bind_target_objects(source, TargetSignal.INSTANCE)
		var with_signal_name = _bind_target_objects(source, TargetSignal.NAME)
		var without_signal = _bind_target_objects(source, TargetSignal.NONE)

		params.append(with_signal_instance)
		params.append(with_signal_name)
		params.append(without_signal)

	return params


func _get_params_for_test_source_to_target():
	var params = []

	for source in _sources:
		var with_signal_instance = _bind_target_objects(source, TargetSignal.INSTANCE)
		var with_signal_name = _bind_target_objects(source, TargetSignal.NAME)
		var without_signal = _bind_target_objects(source, TargetSignal.NONE)

		var with_signal_instance_param = {
			"source": source,
			"target_objects": with_signal_instance,
		}
		var with_signal_name_param = {
			"source": source,
			"target_objects": with_signal_name,
		}
		var without_signal_param = {
			"source": source,
			"target_objects": without_signal,
		}

		params.append(with_signal_instance_param)
		params.append(with_signal_name_param)
		params.append(without_signal_param)

	return params


func _get_param_for_test_source_to_target_double_value(type: String):
	var source = _source_dict[type]

	var param = {
		"source": source,
		"with_signal_instance": _bind_target_objects(source, TargetSignal.INSTANCE),
		"with_signal_name": _bind_target_objects(source, TargetSignal.NAME),
		"without_signal": _bind_target_objects(source, TargetSignal.NONE),
	}

	return param


func _get_params_for_test_target_to_source():
	var params = []

	for source in _sources:
		var with_signal_instance = _bind_target_objects(source, TargetSignal.INSTANCE)
		var with_signal_name = _bind_target_objects(source, TargetSignal.NAME)

		var with_signal_instance_param = {
			"source": source,
			"target_objects": with_signal_instance,
		}
		var with_signal_name_param = {
			"source": source,
			"target_objects": with_signal_name,
		}

		params.append(with_signal_instance_param)
		params.append(with_signal_name_param)

	return params


func _bind_target_objects(source: BaseBindingSource, target_signal: TargetSignal):
	var target_objects = {
		"data_int_var": Data.new(),
		"data_str_var": Data.new(),
		"data_int_prop": Data.new(),
		"data_str_prop": Data.new(),
		"data_single_value": Data.new(),
		"data_double_value": Data.new(),
		"dict_int_var": _dict_new(),
		"dict_str_var": _dict_new(),
		"dict_int_prop": _dict_new(),
		"dict_str_prop": _dict_new(),
		"dict_single_value": _dict_new(),
		"dict_double_value": _dict_new(),
	}

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

	return target_objects


func _unbind_target_objects(source: BaseBindingSource, target_objects: Dictionary):
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
	source: BaseBindingSource,
	source_property: StringName,
	target_object,
	target_signal: TargetSignal
):
	var pipe = BindingConverterPipeline.new([str], [BindingUtils.to_int])

	match target_signal:
		TargetSignal.INSTANCE:
			source.bind_to(
				source_property, target_object, "int_var", null, target_object.int_var_changed
			)
			source.bind_to(
				source_property, target_object, "str_var", pipe, target_object.str_var_changed
			)

			source.bind_to(
				source_property, target_object, "int_prop", null, target_object.int_prop_changed
			)
			source.bind_to(
				source_property, target_object, "str_prop", pipe, target_object.str_prop_changed
			)

			source.bind_to(
				source_property,
				target_object,
				"single_value",
				null,
				target_object.single_value_changed
			)

		TargetSignal.NAME:
			source.bind_to(source_property, target_object, "int_var", null, "int_var_changed")
			source.bind_to(source_property, target_object, "str_var", pipe, "str_var_changed")

			source.bind_to(source_property, target_object, "int_prop", null, "int_prop_changed")
			source.bind_to(source_property, target_object, "str_prop", pipe, "str_prop_changed")

			source.bind_to(
				source_property, target_object, "single_value", null, "single_value_changed"
			)

		TargetSignal.NONE:
			source.bind_to(source_property, target_object, "int_var", null)
			source.bind_to(source_property, target_object, "str_var", pipe)

			source.bind_to(source_property, target_object, "int_prop", null)
			source.bind_to(source_property, target_object, "str_prop", pipe)

			source.bind_to(source_property, target_object, "single_value", null)


func _bind_str(
	source: BaseBindingSource,
	source_property: StringName,
	target_object,
	target_signal: TargetSignal
):
	var pipe = BindingConverterPipeline.new([BindingUtils.to_int], [str])

	match target_signal:
		TargetSignal.INSTANCE:
			source.bind_to(
				source_property, target_object, "int_var", pipe, target_object.int_var_changed
			)
			source.bind_to(
				source_property, target_object, "str_var", null, target_object.str_var_changed
			)

			source.bind_to(
				source_property, target_object, "int_prop", pipe, target_object.int_prop_changed
			)
			source.bind_to(
				source_property, target_object, "str_prop", null, target_object.str_prop_changed
			)

			source.bind_to(
				source_property,
				target_object,
				"single_value",
				pipe,
				target_object.single_value_changed
			)

		TargetSignal.NAME:
			source.bind_to(source_property, target_object, "int_var", pipe, "int_var_changed")
			source.bind_to(source_property, target_object, "str_var", null, "str_var_changed")

			source.bind_to(source_property, target_object, "int_prop", pipe, "int_prop_changed")
			source.bind_to(source_property, target_object, "str_prop", null, "str_prop_changed")

			source.bind_to(
				source_property, target_object, "single_value", pipe, "single_value_changed"
			)

		TargetSignal.NONE:
			source.bind_to(source_property, target_object, "int_var", pipe)
			source.bind_to(source_property, target_object, "str_var", null)

			source.bind_to(source_property, target_object, "int_prop", pipe)
			source.bind_to(source_property, target_object, "str_prop", null)

			source.bind_to(source_property, target_object, "single_value", pipe)


func _unbind(source: BaseBindingSource, source_property: StringName, target_object):
	source.unbind_from(source_property, target_object, "int_var")
	source.unbind_from(source_property, target_object, "str_var")

	source.unbind_from(source_property, target_object, "int_prop")
	source.unbind_from(source_property, target_object, "str_prop")

	source.unbind_from(source_property, target_object, "single_value")


func _dict_new():
	return {
		"int_var": 0,
		"str_var": "",
		"int_prop": 0,
		"str_prop": "",
		"single_value": 0,
		"double_value": 0,
	}


class Data:
	signal notified(property: StringName)

	@warning_ignore("unused_signal")
	signal int_var_changed(new_value: int)
	@warning_ignore("unused_signal")
	signal str_var_changed(new_value: String)

	@warning_ignore("unused_signal")
	signal int_prop_changed(new_value: int)
	@warning_ignore("unused_signal")
	signal str_prop_changed(new_value: String)

	@warning_ignore("unused_signal")
	signal single_value_changed(new_value: int)

	var int_var: int
	var str_var: String

	var int_prop: int:
		get:
			return int_prop
		set(value):
			int_prop = value

	var str_prop: String:
		get:
			return str_prop
		set(value):
			str_prop = value

	var single_value: int:
		get:
			return single_value
		set(value):
			single_value = value
			notified.emit("double_value")

	var double_value: int:
		get:
			return single_value * 2

# gdlint:ignore = max-file-lines
