extends Node
class_name MusicScanner

var root_path: String = "res://music/"
var sound_files: Array[Resource] = []

# Recursively scan `root_path` and fill `sound_files`
func index_all_sound_files_in_root_directory() -> void:
	sound_files.clear()
	_scan_folder(root_path)

func _scan_folder(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("MusicScanner: failed to open directory '%s'" % path)
		return

	# skip navigation entries ('.' and '..') and hidden files
	dir.list_dir_begin()
	var name: String = dir.get_next()
	while name != "":
		if dir.current_is_dir():
			# recurse into subfolder
			_scan_folder(path.path_join(name) + "/")
		else:
			if _is_sound_file(name):
				var file_path = path.path_join(name)
				var res: Resource = ResourceLoader.load(file_path)
				if res:
					sound_files.append(res)
				else:
					push_warning("MusicScanner: could not load '%s'" % file_path)
		name = dir.get_next()
	dir.list_dir_end()

# Helper to filter by extension
func _is_sound_file(name: String) -> bool:
	var ext := name.get_extension().to_lower()
	return ext in ["wav", "ogg", "mp3", "tres"]
