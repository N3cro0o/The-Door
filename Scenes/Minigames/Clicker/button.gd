extends Control

# Exported variables

# Variables
var cost := 0.0
var parent
var dpc := 1
var dps := 0

# Signals
signal task_done
signal current_cost(cost)

# Methods
func _ready():
	set_process(false)

func _process(delta):
	cost -= dps * delta
	if cost <= 0:
		print(Time.get_time_dict_from_system(),"Task done")
		task_done.emit()
	current_cost.emit(round(cost))

func _on_button_pressed():
	cost -= dpc
