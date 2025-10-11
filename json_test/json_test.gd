extends Node

var dict_to_save: Dictionary[String, Dictionary] = {}
var big_dict: Dictionary[String, Variant] = {}

@export var file_name: TextEdit
@export var save_path: FileDialog
@export var load_file: FileDialog

func _ready() -> void:
	var new_dict: Dictionary[String, Array] = {}
	new_dict.set("value_1", [1, 2, 3, 5, 6])
	new_dict.set("value_2", [-2, 0, 34, 5.5])

	var new_dict_2: Dictionary[String, Array] = {}
	new_dict_2.set("value_1", [0, 0, 3.3, 5, 6.5])
	new_dict_2.set("value_2", [-2, 7, -1, 0.5])

	dict_to_save.set("subdict_1", new_dict)
	dict_to_save.set("sub_dict_2", new_dict_2)
	
	big_dict.set("v1",dict_to_save)
	big_dict.set("v2",[0.0,29.3,4.5,6.7])
	big_dict.set("v3",88)
	big_dict.set("v4", 0.283393093)
	big_dict.set("v5", false)
	big_dict.set("v6",PackedFloat32Array([0.002, 2023.4, 444.5]))
	big_dict.set("v6",PackedInt32Array([2, 4, 5, 6]))
	
	# Example usage:
	#_save_dict_as_json("data.json", "user://")
	#var loaded_dict = _load_dict_from_json("user://data.json")
	#print(loaded_dict)


func _save_dict_as_json(file_name: String, save_folder_path: String) -> void:
	var file_path = save_folder_path.path_join(file_name)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(big_dict, "\t") # Pretty formatted
		file.store_string(json_string)
		file.close()
		print("✅ Dictionary saved to:", file_path)
	else:
		push_error("❌ Could not open file for writing: " + file_path)


func _load_dict_from_json(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		push_error("❌ File does not exist: " + file_path)
		return {}

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()

		var json_result = JSON.parse_string(content)
		if typeof(json_result) == TYPE_DICTIONARY:
			print("✅ Dictionary loaded successfully")
			return json_result
		else:
			push_error("❌ Invalid JSON content in file: " + file_path)
			return {}
	else:
		push_error("❌ Could not open file for reading: " + file_path)
		return {}

	


func _on_load_file_file_selected(path: String) -> void:
	var loaded_dict = _load_dict_from_json(path)
	print(loaded_dict)


func _on_save_button_up() -> void:
	_save_dict_as_json(file_name.text, save_path.current_path)


func _on_directory_chose_pressed() -> void:
	save_path.visible = true


func _on_load_pressed() -> void:
	load_file.visible = true
