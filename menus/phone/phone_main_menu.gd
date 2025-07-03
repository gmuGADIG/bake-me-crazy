extends Control

@onready var money_count: Label = $MoneyCount
@onready var time: Label = $DayDisplay/Time
@onready var days_left: Label = $DayDisplay/DaysLeft

func _ready() -> void:
	update_info()

func _on_visibility_changed() -> void:
	if visible: update_info()

func update_info() -> void:
	# get the time of the morning
	# note: the phone is currently only openable from the morning shift and lunch break,
	# so we don't need to worry about naming the other times of day.
	# if that changes, this method will need to be changed.
	var is_morning = PlayerData.data.day_phase == SaveTemplate.DayPhase.EXPLORE
	var time_string = "Morning" if is_morning else "Afternoon"
	time.text = time_string
	
	# days till festival
	var day_string = "Festival in %d Days!" % [14 - PlayerData.data.day]
	days_left.text = day_string
	
	# money
	money_count.text = "$%d" % PlayerData.data.money
