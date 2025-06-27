extends Resource
## Holds "auxilary" save data, i.e. save data that is NOT associated with any
## particular game save. This is primarily settings like audio volumes, which
## should not change as you swap between different saves.
class_name AuxilarySaveData

## Map of bus names to volume values. This seems like the least bad way to do it.
@export var volume_map: Dictionary

## Returns linear volume.
func get_volume(bus_name: String) -> float:
	return volume_map.get_or_add(bus_name, 1.0)
	
## Sets linear volume.
func set_volume(bus_name: String, value: float) -> void:
	volume_map[bus_name] = value
	
## Called when this is first loaded. Restores settings values to their state
## in the engine. In particular, restores volume values to the AudioServer.
func restore_settings() -> void:
	for key in volume_map:
		var idx := AudioServer.get_bus_index(key)
		if idx == -1: continue
		
		var vol = volume_map[key]
		if vol is float:
			AudioServer.set_bus_volume_db(idx, linear_to_db(vol))
