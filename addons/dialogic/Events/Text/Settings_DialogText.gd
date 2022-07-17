tool
extends HBoxContainer

func refresh():
	$'%DefaultSpeed'.value = DialogicUtil.get_project_setting('dialogic/text/speed', 0.01)
	$'%Skippable'.pressed = DialogicUtil.get_project_setting('dialogic/text/skippable', true)
	$'%Autocontinue'.pressed = DialogicUtil.get_project_setting('dialogic/text/autocontinue', false)
	$'%Autocontinue'.pressed = DialogicUtil.get_project_setting('dialogic/text/autocolor_names', false)
	$'%AutocontinueDelay'.value = DialogicUtil.get_project_setting('dialogic/text/autocontinue_delay', 1)
	$'%InputAction'.resource_icon = get_icon("Mouse", "EditorIcons")
	$'%InputAction'.set_value(DialogicUtil.get_project_setting('dialogic/text/input_action', 'dialogic_default_action'))
	$'%InputAction'.get_suggestions_func = [self, 'suggest_actions']


func _on_AutocontinueDelay_value_changed(value):
	ProjectSettings.set_setting('dialogic/text/autocontinue_delay', value)


func _on_Autocontinue_toggled(button_pressed):
	ProjectSettings.set_setting('dialogic/text/autocontinue', button_pressed)


func _on_Skippable_toggled(button_pressed):
	ProjectSettings.set_setting('dialogic/text/skippable', button_pressed)


func _on_DefaultSpeed_value_changed(value):
	ProjectSettings.set_setting('dialogic/text/speed', value)


func _on_InputAction_value_changed(property_name, value):
	ProjectSettings.set_setting('dialogic/text/input_action', value)

func suggest_actions(search):
	var suggs = {}
	for prop in ProjectSettings.get_property_list():
		if prop.name.begins_with('input/') and (!search or search.to_lower() in prop.name.trim_prefix('input/')):
			suggs[prop.name.trim_prefix('input/')] = prop.name.trim_prefix('input/')
	return suggs


func _on_AutocolorNames_toggled(button_pressed):
	ProjectSettings.set_setting('dialogic/text/autocolor_names', button_pressed)