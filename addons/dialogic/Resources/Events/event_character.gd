tool
extends DialogicEvent
class_name DialogicCharacterEvent

enum ActionTypes {Join, Leave, Update}

# DEFINE ALL PROPERTIES OF THE EVENT
var ActionType = ActionTypes.Join
var Character : DialogicCharacter
var Portrait = ""
var Position = 3
var Animation = ""

func _execute() -> void:
	print(ActionType, Character, Portrait)
	match ActionType:
		ActionTypes.Join:
			if Character and Portrait:
				dialogic_game_handler.update_portrait(Character, Portrait, Position)
		ActionTypes.Leave:
			if Character:
				dialogic_game_handler.remove_portrait(Character)
		ActionTypes.Update:
			if Character and Portrait:
				dialogic_game_handler.update_portrait(Character, Portrait, Position)
		
	finish()


################################################################################
## 						INITIALIZE
################################################################################

# SET ALL VALUES THAT SHOULD NEVER CHANGE HERE
func _init() -> void:
	event_name = "Character"
	event_icon = load("res://addons/dialogic/Editor/Images/Event Icons/Main Icons/character.svg")
	event_color = Color("#12b76a")
	event_category = Category.MAIN
	event_sorting_index = 2
	continue_at_end = true


################################################################################
## 						SAVING/LOADING
################################################################################

## THIS RETURNS A READABLE REPRESENTATION, BUT HAS TO CONTAIN ALL DATA (This is how it's stored)
func get_as_string_to_store() -> String:
	var result_string = ""
	
	match ActionType:
		ActionTypes.Join: result_string += "Join "
		ActionTypes.Leave: result_string += "Leave "
		ActionTypes.Update: result_string += "Update "
	
	if Character:
		result_string += Character.name
		result_string+= " ("+Portrait+")"
	
	if Position:
		result_string += " "+str(Position)
	
	return result_string


## THIS HAS TO READ ALL THE DATA FROM THE SAVED STRING (see above) 
func load_from_string_to_store(string:String):
	var regex = RegEx.new()
	regex.compile("(?<type>Join|Update|Leave) (?<character>[^()\\d\\n]*)( *\\((?<portrait>\\S*)\\))? ?((?<position>\\d*))?")
	
	var result = regex.search(string)
	
	match result.get_string('type'):
		"Join":
			ActionType = ActionTypes.Join
		"Leave":
			ActionType = ActionTypes.Leave
		"Update":
			ActionType = ActionTypes.Update
	
	if result.get_string('character').strip_edges():
		var char_guess = DialogicUtil.guess_resource('.dch', result.get_string('character').strip_edges())
		if char_guess:
			Character = load(char_guess)
	
	if result.get_string('portrait').strip_edges():
		Portrait = result.get_string('portrait').strip_edges()

	if result.get_string('position'):
		Position = int(result.get_string('position'))

# RETURN TRUE IF THE GIVEN LINE SHOULD BE LOADED AS THIS EVENT
static func is_valid_event_string(string:String):
	
	if string.begins_with("Join ") or string.begins_with("Leave ") or string.begins_with("Update "):
		return true
	return false


################################################################################
## 						EDITOR REPRESENTATION
################################################################################

func _get_property_list() -> Array:
	var p_list = []
	
	# fill the p_list with dictionaries like this one:
	p_list.append({
		"name":"ActionType", # Must be the same as the corresponding property that it edits!
		"type":TYPE_INT,	# Defines the type of editor (LineEdit, Selector, etc.)
		"location": Location.HEADER,	# Definest the location
		"usage":PROPERTY_USAGE_DEFAULT,	
		"dialogic_type":DialogicValueType.FixedOptionSelector,	# Additional information for value displays
		"selector_options":{"Join":ActionTypes.Join, "Leave":ActionTypes.Leave, "Update":ActionTypes.Update},
		"hint_string":"Action:"		# Text that will be displayed in front of the field
		})
	p_list.append({
		"name":"Character", # Must be the same as the corresponding property that it edits!
		"type":TYPE_OBJECT,	# Defines the type of editor (LineEdit, Selector, etc.)
		"location": Location.HEADER,	# Definest the location
		"usage":PROPERTY_USAGE_DEFAULT,	
		"dialogic_type":DialogicValueType.Character,	# Additional information for value displays
		"hint_string":"Character:"		# Text that will be displayed in front of the field
		})
	p_list.append({
		"name":"Portrait", # Must be the same as the corresponding property that it edits!
		"type":TYPE_OBJECT,	# Defines the type of editor (LineEdit, Selector, etc.)
		"location": Location.HEADER,	# Definest the location
		"usage":PROPERTY_USAGE_DEFAULT,	
		"dialogic_type":DialogicValueType.Portrait,	# Additional information for value displays
		"hint_string":"Portrait:"		# Text that will be displayed in front of the field
		})
	p_list.append({
		"name":"Position", # Must be the same as the corresponding property that it edits!
		"type":TYPE_INT,	# Defines the type of editor (LineEdit, Selector, etc.)
		"location": Location.HEADER,	# Definest the location
		"usage":PROPERTY_USAGE_DEFAULT,	
		"dialogic_type":DialogicValueType.Integer,	# Additional information for value displays
		"hint_string":"Position:"		# Text that will be displayed in front of the field
		})
	
	
	return p_list