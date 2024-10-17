extends GutTest

signal notified(property: StringName)

var _source_dict: Dictionary
var _sources: Array:
	get:
		return _source_dict.values()


func before_all():
	var data = Data.new()

	_source_dict = {
		"with_str_notification": BaseBindingSource.new(Data.new(), "notified"),
		"with_dir_notification": BaseBindingSource.new(data, data.notified),
		"with_ext_notification": BaseBindingSource.new(Data.new(), notified),
		"without_notification": BaseBindingSource.new(Data.new()),
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
	assert_eq(target_objects["int_var"].int_var, 1)
	assert_eq(target_objects["int_var"].str_var, "1")
	assert_eq(target_objects["int_var"].int_prop, 1)
	assert_eq(target_objects["int_var"].str_prop, "1")
	assert_eq(target_objects["int_var"].single_value, 1)
	assert_eq(target_objects["int_var"].double_value, 2)

	assert_eq(target_objects["str_var"].int_var, 2)
	assert_eq(target_objects["str_var"].str_var, "2")
	assert_eq(target_objects["str_var"].int_prop, 2)
	assert_eq(target_objects["str_var"].str_prop, "2")
	assert_eq(target_objects["str_var"].single_value, 2)
	assert_eq(target_objects["str_var"].double_value, 4)

	assert_eq(target_objects["int_prop"].int_var, 3)
	assert_eq(target_objects["int_prop"].str_var, "3")
	assert_eq(target_objects["int_prop"].int_prop, 3)
	assert_eq(target_objects["int_prop"].str_prop, "3")
	assert_eq(target_objects["int_prop"].single_value, 3)
	assert_eq(target_objects["int_prop"].double_value, 6)

	assert_eq(target_objects["str_prop"].int_var, 4)
	assert_eq(target_objects["str_prop"].str_var, "4")
	assert_eq(target_objects["str_prop"].int_prop, 4)
	assert_eq(target_objects["str_prop"].str_prop, "4")
	assert_eq(target_objects["str_prop"].single_value, 4)
	assert_eq(target_objects["str_prop"].double_value, 8)

	assert_eq(target_objects["single_value"].int_var, 5)
	assert_eq(target_objects["single_value"].str_var, "5")
	assert_eq(target_objects["single_value"].int_prop, 5)
	assert_eq(target_objects["single_value"].str_prop, "5")
	assert_eq(target_objects["single_value"].single_value, 5)
	assert_eq(target_objects["single_value"].double_value, 10)

	assert_eq(target_objects["double_value"].int_var, 10)
	assert_eq(target_objects["double_value"].str_var, "10")
	assert_eq(target_objects["double_value"].int_prop, 10)
	assert_eq(target_objects["double_value"].str_prop, "10")
	assert_eq(target_objects["double_value"].single_value, 10)
	assert_eq(target_objects["double_value"].double_value, 20)


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

	assert_eq(target_objects["int_var"].int_var, 6)
	assert_eq(target_objects["int_var"].str_var, "6")
	assert_eq(target_objects["int_var"].int_prop, 6)
	assert_eq(target_objects["int_var"].str_prop, "6")
	assert_eq(target_objects["int_var"].single_value, 6)
	assert_eq(target_objects["int_var"].double_value, 12)

	assert_eq(target_objects["str_var"].int_var, 7)
	assert_eq(target_objects["str_var"].str_var, "7")
	assert_eq(target_objects["str_var"].int_prop, 7)
	assert_eq(target_objects["str_var"].str_prop, "7")
	assert_eq(target_objects["str_var"].single_value, 7)
	assert_eq(target_objects["str_var"].double_value, 14)

	assert_eq(target_objects["int_prop"].int_var, 8)
	assert_eq(target_objects["int_prop"].str_var, "8")
	assert_eq(target_objects["int_prop"].int_prop, 8)
	assert_eq(target_objects["int_prop"].str_prop, "8")
	assert_eq(target_objects["int_prop"].single_value, 8)
	assert_eq(target_objects["int_prop"].double_value, 16)

	assert_eq(target_objects["str_prop"].int_var, 9)
	assert_eq(target_objects["str_prop"].str_var, "9")
	assert_eq(target_objects["str_prop"].int_prop, 9)
	assert_eq(target_objects["str_prop"].str_prop, "9")
	assert_eq(target_objects["str_prop"].single_value, 9)
	assert_eq(target_objects["str_prop"].double_value, 18)

	assert_eq(target_objects["single_value"].int_var, 10)
	assert_eq(target_objects["single_value"].str_var, "10")
	assert_eq(target_objects["single_value"].int_prop, 10)
	assert_eq(target_objects["single_value"].str_prop, "10")
	assert_eq(target_objects["single_value"].single_value, 10)
	assert_eq(target_objects["single_value"].double_value, 20)

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

	assert_eq(target_objects["int_var"].int_var, 6)
	assert_eq(target_objects["int_var"].str_var, "6")
	assert_eq(target_objects["int_var"].int_prop, 6)
	assert_eq(target_objects["int_var"].str_prop, "6")
	assert_eq(target_objects["int_var"].single_value, 6)
	assert_eq(target_objects["int_var"].double_value, 12)

	assert_eq(target_objects["str_var"].int_var, 7)
	assert_eq(target_objects["str_var"].str_var, "7")
	assert_eq(target_objects["str_var"].int_prop, 7)
	assert_eq(target_objects["str_var"].str_prop, "7")
	assert_eq(target_objects["str_var"].single_value, 7)
	assert_eq(target_objects["str_var"].double_value, 14)

	assert_eq(target_objects["int_prop"].int_var, 8)
	assert_eq(target_objects["int_prop"].str_var, "8")
	assert_eq(target_objects["int_prop"].int_prop, 8)
	assert_eq(target_objects["int_prop"].str_prop, "8")
	assert_eq(target_objects["int_prop"].single_value, 8)
	assert_eq(target_objects["int_prop"].double_value, 16)

	assert_eq(target_objects["str_prop"].int_var, 9)
	assert_eq(target_objects["str_prop"].str_var, "9")
	assert_eq(target_objects["str_prop"].int_prop, 9)
	assert_eq(target_objects["str_prop"].str_prop, "9")
	assert_eq(target_objects["str_prop"].single_value, 9)
	assert_eq(target_objects["str_prop"].double_value, 18)

	assert_eq(target_objects["single_value"].int_var, 10)
	assert_eq(target_objects["single_value"].str_var, "10")
	assert_eq(target_objects["single_value"].int_prop, 10)
	assert_eq(target_objects["single_value"].str_prop, "10")
	assert_eq(target_objects["single_value"].single_value, 10)
	assert_eq(target_objects["single_value"].double_value, 20)


func test_source_to_target_double_value_with_str_notification():
	var param: Dictionary = await _get_param_for_test_source_to_target_double_value(
		"with_str_notification"
	)
	var source = param["source"]
	var with_signal = param["with_signal"]
	var without_signal = param["without_signal"]

	source.single_value = 10

	assert_eq(with_signal["double_value"].int_var, 20)
	assert_eq(with_signal["double_value"].str_var, "20")
	assert_eq(with_signal["double_value"].int_prop, 20)
	assert_eq(with_signal["double_value"].str_prop, "20")
	assert_eq(with_signal["double_value"].single_value, 20)
	assert_eq(with_signal["double_value"].double_value, 40)

	assert_eq(without_signal["double_value"].int_var, 20)
	assert_eq(without_signal["double_value"].str_var, "20")
	assert_eq(without_signal["double_value"].int_prop, 20)
	assert_eq(without_signal["double_value"].str_prop, "20")
	assert_eq(without_signal["double_value"].single_value, 20)
	assert_eq(without_signal["double_value"].double_value, 40)

	_unbind_target_objects(source, with_signal)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal["double_value"].int_var, 20)
	assert_eq(with_signal["double_value"].str_var, "20")
	assert_eq(with_signal["double_value"].int_prop, 20)
	assert_eq(with_signal["double_value"].str_prop, "20")
	assert_eq(with_signal["double_value"].single_value, 20)
	assert_eq(with_signal["double_value"].double_value, 40)

	assert_eq(without_signal["double_value"].int_var, 20)
	assert_eq(without_signal["double_value"].str_var, "20")
	assert_eq(without_signal["double_value"].int_prop, 20)
	assert_eq(without_signal["double_value"].str_prop, "20")
	assert_eq(without_signal["double_value"].single_value, 20)
	assert_eq(without_signal["double_value"].double_value, 40)


func test_source_to_target_double_value_with_dir_notification():
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"with_dir_notification"
	)
	var source = param["source"]
	var with_signal = param["with_signal"]
	var without_signal = param["without_signal"]

	source.single_value = 10

	assert_eq(with_signal["double_value"].int_var, 20)
	assert_eq(with_signal["double_value"].str_var, "20")
	assert_eq(with_signal["double_value"].int_prop, 20)
	assert_eq(with_signal["double_value"].str_prop, "20")
	assert_eq(with_signal["double_value"].single_value, 20)
	assert_eq(with_signal["double_value"].double_value, 40)

	assert_eq(without_signal["double_value"].int_var, 20)
	assert_eq(without_signal["double_value"].str_var, "20")
	assert_eq(without_signal["double_value"].int_prop, 20)
	assert_eq(without_signal["double_value"].str_prop, "20")
	assert_eq(without_signal["double_value"].single_value, 20)
	assert_eq(without_signal["double_value"].double_value, 40)

	_unbind_target_objects(source, with_signal)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal["double_value"].int_var, 20)
	assert_eq(with_signal["double_value"].str_var, "20")
	assert_eq(with_signal["double_value"].int_prop, 20)
	assert_eq(with_signal["double_value"].str_prop, "20")
	assert_eq(with_signal["double_value"].single_value, 20)
	assert_eq(with_signal["double_value"].double_value, 40)

	assert_eq(without_signal["double_value"].int_var, 20)
	assert_eq(without_signal["double_value"].str_var, "20")
	assert_eq(without_signal["double_value"].int_prop, 20)
	assert_eq(without_signal["double_value"].str_prop, "20")
	assert_eq(without_signal["double_value"].single_value, 20)
	assert_eq(without_signal["double_value"].double_value, 40)


func test_source_to_target_double_value_with_ext_notification():
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"with_ext_notification"
	)
	var source = param["source"]
	var with_signal = param["with_signal"]
	var without_signal = param["without_signal"]

	source.single_value = 10
	notified.emit("double_value")

	assert_eq(with_signal["double_value"].int_var, 20)
	assert_eq(with_signal["double_value"].str_var, "20")
	assert_eq(with_signal["double_value"].int_prop, 20)
	assert_eq(with_signal["double_value"].str_prop, "20")
	assert_eq(with_signal["double_value"].single_value, 20)
	assert_eq(with_signal["double_value"].double_value, 40)

	assert_eq(without_signal["double_value"].int_var, 20)
	assert_eq(without_signal["double_value"].str_var, "20")
	assert_eq(without_signal["double_value"].int_prop, 20)
	assert_eq(without_signal["double_value"].str_prop, "20")
	assert_eq(without_signal["double_value"].single_value, 20)
	assert_eq(without_signal["double_value"].double_value, 40)

	_unbind_target_objects(source, with_signal)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20
	notified.emit("double_value")

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal["double_value"].int_var, 20)
	assert_eq(with_signal["double_value"].str_var, "20")
	assert_eq(with_signal["double_value"].int_prop, 20)
	assert_eq(with_signal["double_value"].str_prop, "20")
	assert_eq(with_signal["double_value"].single_value, 20)
	assert_eq(with_signal["double_value"].double_value, 40)

	assert_eq(without_signal["double_value"].int_var, 20)
	assert_eq(without_signal["double_value"].str_var, "20")
	assert_eq(without_signal["double_value"].int_prop, 20)
	assert_eq(without_signal["double_value"].str_prop, "20")
	assert_eq(without_signal["double_value"].single_value, 20)
	assert_eq(without_signal["double_value"].double_value, 40)


func test_source_to_target_double_value_without_notification():
	var param: Dictionary = _get_param_for_test_source_to_target_double_value(
		"without_notification"
	)
	var source = param["source"]
	var with_signal = param["with_signal"]
	var without_signal = param["without_signal"]

	source.single_value = 10

	assert_eq(with_signal["double_value"].int_var, 10)
	assert_eq(with_signal["double_value"].str_var, "10")
	assert_eq(with_signal["double_value"].int_prop, 10)
	assert_eq(with_signal["double_value"].str_prop, "10")
	assert_eq(with_signal["double_value"].single_value, 10)
	assert_eq(with_signal["double_value"].double_value, 20)

	assert_eq(without_signal["double_value"].int_var, 10)
	assert_eq(without_signal["double_value"].str_var, "10")
	assert_eq(without_signal["double_value"].int_prop, 10)
	assert_eq(without_signal["double_value"].str_prop, "10")
	assert_eq(without_signal["double_value"].single_value, 10)
	assert_eq(without_signal["double_value"].double_value, 20)

	_unbind_target_objects(source, with_signal)
	_unbind_target_objects(source, without_signal)

	source.single_value = 20

	assert_eq(source.single_value, 20)
	assert_eq(source.double_value, 40)

	assert_eq(with_signal["double_value"].int_var, 10)
	assert_eq(with_signal["double_value"].str_var, "10")
	assert_eq(with_signal["double_value"].int_prop, 10)
	assert_eq(with_signal["double_value"].str_prop, "10")
	assert_eq(with_signal["double_value"].single_value, 10)
	assert_eq(with_signal["double_value"].double_value, 20)

	assert_eq(without_signal["double_value"].int_var, 10)
	assert_eq(without_signal["double_value"].str_var, "10")
	assert_eq(without_signal["double_value"].int_prop, 10)
	assert_eq(without_signal["double_value"].str_prop, "10")
	assert_eq(without_signal["double_value"].single_value, 10)
	assert_eq(without_signal["double_value"].double_value, 20)


func test_target_to_source(
	param: Dictionary = use_parameters(_get_params_for_test_target_to_source())
):
	var source = param["source"]
	var target_objects = param["target_objects"]

	target_objects["int_var"].int_var_changed.emit(6)
	assert_eq(source.int_var, 6)
	target_objects["int_var"].str_var_changed.emit("7")
	assert_eq(source.int_var, 7)
	target_objects["int_var"].int_prop_changed.emit(8)
	assert_eq(source.int_var, 8)
	target_objects["int_var"].str_prop_changed.emit("9")
	assert_eq(source.int_var, 9)
	target_objects["int_var"].single_value_changed.emit(10)
	assert_eq(source.int_var, 10)

	target_objects["str_var"].int_var_changed.emit(6)
	assert_eq(source.str_var, "6")
	target_objects["str_var"].str_var_changed.emit("7")
	assert_eq(source.str_var, "7")
	target_objects["str_var"].int_prop_changed.emit(8)
	assert_eq(source.str_var, "8")
	target_objects["str_var"].str_prop_changed.emit("9")
	assert_eq(source.str_var, "9")
	target_objects["str_var"].single_value_changed.emit(10)
	assert_eq(source.str_var, "10")

	target_objects["int_prop"].int_var_changed.emit(6)
	assert_eq(source.int_prop, 6)
	target_objects["int_prop"].str_var_changed.emit("7")
	assert_eq(source.int_prop, 7)
	target_objects["int_prop"].int_prop_changed.emit(8)
	assert_eq(source.int_prop, 8)
	target_objects["int_prop"].str_prop_changed.emit("9")
	assert_eq(source.int_prop, 9)
	target_objects["int_prop"].single_value_changed.emit(10)
	assert_eq(source.int_prop, 10)

	target_objects["str_prop"].int_var_changed.emit(6)
	assert_eq(source.str_prop, "6")
	target_objects["str_prop"].str_var_changed.emit("7")
	assert_eq(source.str_prop, "7")
	target_objects["str_prop"].int_prop_changed.emit(8)
	assert_eq(source.str_prop, "8")
	target_objects["str_prop"].str_prop_changed.emit("9")
	assert_eq(source.str_prop, "9")
	target_objects["str_prop"].single_value_changed.emit(10)
	assert_eq(source.str_prop, "10")

	target_objects["single_value"].int_var_changed.emit(6)
	assert_eq(source.single_value, 6)
	target_objects["single_value"].str_var_changed.emit("7")
	assert_eq(source.single_value, 7)
	target_objects["single_value"].int_prop_changed.emit(8)
	assert_eq(source.single_value, 8)
	target_objects["single_value"].str_prop_changed.emit("9")
	assert_eq(source.single_value, 9)
	target_objects["single_value"].single_value_changed.emit(10)
	assert_eq(source.single_value, 10)

	_unbind_target_objects(source, target_objects)

	target_objects["int_var"].int_var_changed.emit(11)
	assert_eq(source.int_var, 10)
	target_objects["int_var"].str_var_changed.emit("12")
	assert_eq(source.int_var, 10)
	target_objects["int_var"].int_prop_changed.emit(13)
	assert_eq(source.int_var, 10)
	target_objects["int_var"].str_prop_changed.emit("14")
	assert_eq(source.int_var, 10)
	target_objects["int_var"].single_value_changed.emit(15)
	assert_eq(source.int_var, 10)

	target_objects["str_var"].int_var_changed.emit(11)
	assert_eq(source.str_var, "10")
	target_objects["str_var"].str_var_changed.emit("12")
	assert_eq(source.str_var, "10")
	target_objects["str_var"].int_prop_changed.emit(13)
	assert_eq(source.str_var, "10")
	target_objects["str_var"].str_prop_changed.emit("14")
	assert_eq(source.str_var, "10")
	target_objects["str_var"].single_value_changed.emit(15)
	assert_eq(source.str_var, "10")

	target_objects["int_prop"].int_var_changed.emit(11)
	assert_eq(source.int_prop, 10)
	target_objects["int_prop"].str_var_changed.emit("12")
	assert_eq(source.int_prop, 10)
	target_objects["int_prop"].int_prop_changed.emit(13)
	assert_eq(source.int_prop, 10)
	target_objects["int_prop"].str_prop_changed.emit("14")
	assert_eq(source.int_prop, 10)
	target_objects["int_prop"].single_value_changed.emit(15)
	assert_eq(source.int_prop, 10)

	target_objects["str_prop"].int_var_changed.emit(11)
	assert_eq(source.str_prop, "10")
	target_objects["str_prop"].str_var_changed.emit("12")
	assert_eq(source.str_prop, "10")
	target_objects["str_prop"].int_prop_changed.emit(13)
	assert_eq(source.str_prop, "10")
	target_objects["str_prop"].str_prop_changed.emit("14")
	assert_eq(source.str_prop, "10")
	target_objects["str_prop"].single_value_changed.emit(15)
	assert_eq(source.str_prop, "10")

	target_objects["single_value"].int_var_changed.emit(11)
	assert_eq(source.single_value, 10)
	target_objects["single_value"].str_var_changed.emit("12")
	assert_eq(source.single_value, 10)
	target_objects["single_value"].int_prop_changed.emit(13)
	assert_eq(source.single_value, 10)
	target_objects["single_value"].str_prop_changed.emit("14")
	assert_eq(source.single_value, 10)
	target_objects["single_value"].single_value_changed.emit(15)
	assert_eq(source.single_value, 10)


func _get_params_for_test_init_target_value():
	var params = []

	for source in _sources:
		var with_signal = _bind_target_objects(source, true)
		var without_signal = _bind_target_objects(source, false)

		params.append(with_signal)
		params.append(without_signal)

	return params


func _get_params_for_test_source_to_target():
	var params = []

	for source in _sources:
		var with_signal = _bind_target_objects(source, true)
		var without_signal = _bind_target_objects(source, false)

		var with_signal_param = {
			"source": source,
			"target_objects": with_signal,
		}
		var without_signal_param = {
			"source": source,
			"target_objects": without_signal,
		}

		params.append(with_signal_param)
		params.append(without_signal_param)

	return params


func _get_param_for_test_source_to_target_double_value(type: String):
	var source = _source_dict[type]

	var param = {
		"source": source,
		"with_signal": _bind_target_objects(source, true),
		"without_signal": _bind_target_objects(source, false),
	}

	return param


func _get_params_for_test_target_to_source():
	var params = []

	for source in _sources:
		var with_signal = _bind_target_objects(source, true)

		var with_signal_param = {
			"source": source,
			"target_objects": with_signal,
		}

		params.append(with_signal_param)

	return params


func _bind_target_objects(source: BaseBindingSource, with_signal: bool):
	var target_objects = {
		"int_var": Data.new(),
		"str_var": Data.new(),
		"int_prop": Data.new(),
		"str_prop": Data.new(),
		"single_value": Data.new(),
		"double_value": Data.new(),
	}

	_bind_int(source, "int_var", target_objects["int_var"], with_signal)
	_bind_str(source, "str_var", target_objects["str_var"], with_signal)

	_bind_int(source, "int_prop", target_objects["int_prop"], with_signal)
	_bind_str(source, "str_prop", target_objects["str_prop"], with_signal)

	_bind_int(source, "single_value", target_objects["single_value"], with_signal)
	_bind_int(source, "double_value", target_objects["double_value"], with_signal)

	return target_objects


func _unbind_target_objects(source: BaseBindingSource, target_objects: Dictionary):
	_unbind(source, "int_var", target_objects["int_var"])
	_unbind(source, "str_var", target_objects["str_var"])

	_unbind(source, "int_prop", target_objects["int_prop"])
	_unbind(source, "str_prop", target_objects["str_prop"])

	_unbind(source, "single_value", target_objects["single_value"])
	_unbind(source, "double_value", target_objects["double_value"])


func _bind_int(
	source: BaseBindingSource, source_property: StringName, target_object: Data, with_signal: bool
):
	var pipe = BindingConverterPipeline.new([str], [BindingUtils.to_int])

	if with_signal:
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
			source_property, target_object, "single_value", null, target_object.single_value_changed
		)

	else:
		source.bind_to(source_property, target_object, "int_var", null)
		source.bind_to(source_property, target_object, "str_var", pipe)

		source.bind_to(source_property, target_object, "int_prop", null)
		source.bind_to(source_property, target_object, "str_prop", pipe)

		source.bind_to(source_property, target_object, "single_value", null)


func _bind_str(
	source: BaseBindingSource, source_property: StringName, target_object: Data, with_signal: bool
):
	var pipe = BindingConverterPipeline.new([BindingUtils.to_int], [str])

	if with_signal:
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
			source_property, target_object, "single_value", pipe, target_object.single_value_changed
		)

	else:
		source.bind_to(source_property, target_object, "int_var", pipe)
		source.bind_to(source_property, target_object, "str_var", null)

		source.bind_to(source_property, target_object, "int_prop", pipe)
		source.bind_to(source_property, target_object, "str_prop", null)

		source.bind_to(source_property, target_object, "single_value", pipe)


func _unbind(source: BaseBindingSource, source_property: StringName, target_object: Data):
	source.unbind_from(source_property, target_object, "int_var")
	source.unbind_from(source_property, target_object, "str_var")

	source.unbind_from(source_property, target_object, "int_prop")
	source.unbind_from(source_property, target_object, "str_prop")

	source.unbind_from(source_property, target_object, "single_value")


class Data:
	signal notified(property: StringName)

	signal int_var_changed(new_value: int)
	signal str_var_changed(new_value: String)

	signal int_prop_changed(new_value: int)
	signal str_prop_changed(new_value: String)

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
