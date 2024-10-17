class_name Binding

var _source_object: Object
var _source_property: StringName

var _target_object: Object
var _target_property: StringName

var _converter_pipeline: BindingConverterPipeline


func _init(
	source_object: Object,
	source_property: StringName,
	target_object: Object,
	target_property: StringName,
	converter_pipeline: BindingConverterPipeline = null
):
	assert(source_object != null, "The source object must not be null.")
	assert(
		source_property in source_object,
		"The source property %s was not in the source object." % source_property
	)

	assert(target_object != null, "The target object must not be null.")
	assert(
		target_property in target_object,
		"The target property %s was not in the target object." % target_property
	)

	_source_object = source_object
	_source_property = source_property

	_target_object = target_object
	_target_property = target_property

	if converter_pipeline == null:
		_converter_pipeline = BindingConverterPipeline.new()
	else:
		_converter_pipeline = converter_pipeline


func pass_source_value(source_value: Variant):
	var prev_target_value = _target_object.get(_target_property)
	var next_target_value = _converter_pipeline.source_to_target(source_value)
	if prev_target_value == next_target_value:
		return

	_target_object.set(_target_property, next_target_value)


func pass_target_value(target_value: Variant):
	var prev_source_value = _source_object.get(_source_property)
	var next_source_value = _converter_pipeline.target_to_source(target_value)
	if prev_source_value == next_source_value:
		return

	_source_object.set(_source_property, next_source_value)
