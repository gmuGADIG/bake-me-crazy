extends Node
class_name MusicScanner

var root_path: String = "res://music/"
var sound_files: Array[Resource] = []
var song_dict: Dictionary = {}

func _ready() -> void:
	index_all_sound_files_in_root_directory()

# Recursively scan `root_path` and fill both sound_files and song_dict
func index_all_sound_files_in_root_directory() -> void:
	sound_files.clear()
	song_dict.clear()
	_scan_folder(root_path)

func _scan_folder(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("MusicScanner: failed to open directory '%s'" % path)
		return

	dir.list_dir_begin()
	var name: String = dir.get_next()
	while name != "":
		name = name.trim_suffix(".remap")
		var full_path = path.path_join(name)
		if dir.current_is_dir():
			_scan_folder(full_path + "/")
		else:
			if _is_sound_file(name):
				var res: Resource = ResourceLoader.load(full_path)
				if res:
					sound_files.append(res)
					# if it's a .tres and actually a Song, add to our song_dict
					if name.get_extension().to_lower() == "tres" and res is Song:
						song_dict[name] = res
				else:
					push_warning("MusicScanner: could not load '%s'" % full_path)
		name = dir.get_next()
	dir.list_dir_end()

# Helper to filter by extension
func _is_sound_file(name: String) -> bool:
	var ext := name.get_extension().to_lower()
	return ext in ["wav", "ogg", "mp3", "tres"]

# Public method to retrieve a Song by its filename (e.g. "example_song.tres")
func get_song_by_filename(filename: String) -> Song:
	return song_dict.get(filename, null) as Song
