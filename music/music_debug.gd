extends Control
class_name MusicPlayerDebug

const EPS := 0.001

@onready var pl: MusicPlayer = $MusicPlayer
@onready var start_edit: LineEdit = $VBoxContainer/LoopStartContainer/LoopStartEdit
@onready var end_edit: LineEdit = $VBoxContainer/LoopEndContainer/LoopEndEdit
@onready var delta_edit: LineEdit = $VBoxContainer/FineTuneContainer/StepEdit
@onready var reset_btn: Button = $VBoxContainer/FineTuneContainer/ResetBtn
@onready var s_rush_btn: Button = $VBoxContainer/StartTune/StartRushBtn
@onready var s_drag_btn: Button = $VBoxContainer/StartTune/StartDragBtn
@onready var e_rush_btn: Button = $VBoxContainer/EndTune/EndRushBtn
@onready var e_drag_btn: Button = $VBoxContainer/EndTune/EndDragBtn
@onready var play_btn: Button = $VBoxContainer/ButtonsContainer/PlayButton
@onready var test_btn: Button = $VBoxContainer/ButtonsContainer/TestLoopButton
@onready var time_lbl: Label = $VBoxContainer/ProgressContainer/TimeLabel

var s_lo: float
var s_hi: float
var e_lo: float
var e_hi: float

func _ready() -> void:
	_sync_fields()
	_connect_ui()
	_reset_search()

func _process(_d: float) -> void:
	_update_progress()

# binary search
func _reset_search() -> void:
	var d  = abs(delta_edit.text.to_float())
	var s0 = start_edit.text.to_float()
	var e0 = end_edit.text.to_float()
	s_lo = s0 - d;  s_hi = s0 + d
	e_lo = e0 - d;  e_hi = e0 + d
	_apply_midpoints()
	pl.test_loop()

func _apply_midpoints() -> void:
	pl.current_song.loop_start = (s_lo + s_hi) * 0.5
	pl.current_song.loop_end   = (e_lo + e_hi) * 0.5
	_sync_fields()
	_disable_when_done()

func _s_rush(): s_lo = (s_lo + s_hi) * 0.5; _apply_midpoints(); pl.test_loop()
func _s_drag(): s_hi = (s_lo + s_hi) * 0.5; _apply_midpoints(); pl.test_loop()
func _e_rush(): e_lo = (e_lo + e_hi) * 0.5; _apply_midpoints(); pl.test_loop()
func _e_drag(): e_hi = (e_lo + e_hi) * 0.5; _apply_midpoints(); pl.test_loop()

func _disable_when_done() -> void:
	var s_done = (s_hi - s_lo) < EPS
	var e_done = (e_hi - e_lo) < EPS
	s_rush_btn.disabled = s_done
	s_drag_btn.disabled = s_done
	e_rush_btn.disabled = e_done
	e_drag_btn.disabled = e_done

# ui helpers
func _sync_fields() -> void:
	start_edit.text = str(pl.current_song.loop_start)
	end_edit.text   = str(pl.current_song.loop_end)

func _connect_ui() -> void:
	start_edit.text_changed.connect(_on_start_changed)
	end_edit.text_changed.connect(_on_end_changed)
	delta_edit.text_changed.connect(_on_delta_changed)
	play_btn.pressed.connect(pl.play)
	test_btn.pressed.connect(pl.test_loop)
	reset_btn.pressed.connect(_reset_search)
	s_rush_btn.pressed.connect(_s_rush)
	s_drag_btn.pressed.connect(_s_drag)
	e_rush_btn.pressed.connect(_e_rush)
	e_drag_btn.pressed.connect(_e_drag)

func _on_start_changed(t: String) -> void:
	pl.current_song.loop_start = t.to_float()

func _on_end_changed(t: String) -> void:
	pl.current_song.loop_end = t.to_float()
	
func _on_delta_changed(t: String) -> void:
	_reset_search()

# progress bar
func _update_progress() -> void:
	if not pl.is_playing():
		time_lbl.text = "--:-- / --:--"
		return
	var pos = pl.get_position()
	var len = pl.get_length()
	if len <= 0:
		time_lbl.text = "--:-- / --:--"
		return
	time_lbl.text = "%02d:%02d / %02d:%02d" % [
		int(pos / 60), int(pos) % 60,
		int(len / 60), int(len) % 60
	]
