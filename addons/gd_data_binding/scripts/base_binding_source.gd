class_name BaseBindingSource

var _source_object: Object
var _target_dict = {}


func _init(source_object: Object = self, source_value_change_notify_signal = null):
	assert(
		source_object != self or BaseBindingSource != get_script(),
		"The source object must be passed unless the class inherits BindingSource."
	)
	assert(source_object != self, "Currently, initialize by self is not supported.")

	_source_object = source_object

	if (
		(
			source_value_change_notify_signal is String
			or source_value_change_notify_signal is StringName
		)
		and source_object.has_signal(source_value_change_notify_signal)
	):
		source_object.connect(source_value_change_notify_signal, _on_source_value_change_notified)
	elif source_value_change_notify_signal is Signal:
		source_value_change_notify_signal.connect(_on_source_value_change_notified)


func _get_property_list():
	assert(_source_object != self, "The extended class instance cannot be inspected in the editor")
	return _source_object.get_property_list()


func _property_can_revert(property):
	return _source_object.property_can_revert(property)


func _property_get_revert(property):
	return _source_object.property_get_revert(property)


func _get(property):
	return _source_object.get(property)


func _set(property, value):
	_source_object.set(property, value)
	_update_target(property, value)
	return true


func bind_to(
	source_property: StringName,
	target_object: Object,
	target_property: StringName,
	converter_pipeline: BindingConverterPipeline = null,
	target_value_change_signal = null
):
	var binding_dict = _target_dict.get_or_add(source_property, {}) as Dictionary
	var binding_key = _get_binding_key(target_object, target_property)

	assert(
		not binding_dict.has(binding_key),
		(
			"The source property %s has already been bound to the target property %s."
			% [source_property, target_property]
		)
	)

	var binding = BindingWithTargetSignal.new(
		self,
		source_property,
		target_object,
		target_property,
		converter_pipeline,
		target_value_change_signal
	)
	binding_dict[binding_key] = binding


func unbind_from(source_property: StringName, target_object: Object, target_property: StringName):
	assert(
		_target_dict.has(source_property),
		"The source property %s has not been bound to any target properties." % source_property
	)

	var binding_dict = _target_dict.get(source_property) as Dictionary
	var binding_key = _get_binding_key(target_object, target_property)

	assert(
		binding_dict.has(binding_key),
		(
			"The source property %s has not been bound to the target property %s."
			% [source_property, target_property]
		)
	)

	binding_dict.erase(binding_key)


func _on_source_value_change_notified(source_property: StringName):
	var source_value = _source_object.get(source_property)
	_update_target(source_property, source_value)


func _update_target(source_property: StringName, source_value: Variant):
	var binding_dict = _target_dict.get(source_property)
	if binding_dict == null:
		return

	for binding_key in binding_dict:
		var binding = binding_dict[binding_key] as Binding
		binding.pass_source_value(source_value)


static func _get_binding_key(target_object: Object, target_property: StringName):
	return "%s.%s" % [target_object.get_instance_id(), target_property]


class BindingWithTargetSignal:
	extends Binding

	func _init(
		source_object: Object,
		source_property: StringName,
		target_object: Object,
		target_property: StringName,
		converter_pipeline: BindingConverterPipeline,
		target_value_change_signal
	):
		super(source_object, source_property, target_object, target_property, converter_pipeline)

		var source_value = _source_object.get(source_property)
		pass_source_value(source_value)

		if target_value_change_signal is Signal:
			target_value_change_signal.connect(_on_target_value_changed)

	func _on_target_value_changed(target_value: Variant):
		pass_target_value(target_value)
