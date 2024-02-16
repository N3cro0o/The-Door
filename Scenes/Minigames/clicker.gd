extends Node2D

# Exported variables
@export_category("Upgrades")
@export var button_data : Array[ButtonData]
#@export var button_data = {"picklock": "Used to break the lock\nCost:100000"}
@export_category("Button")

# Variables
const info_text := "Inputs Per Second: %d, Inputs Per Click: %d\n\n%s\n\nCompleted Tasks%s"
@onready var score := $Score/MarginContainer/Label
@onready var upgr_window := $Upgrades
@onready var click_window := $Cookie
@onready var upgrades := $Upgrades/UpgradeControl
@onready var button := $Cookie/ButtonControl
var parent
var completed_tasks := ""
var active_task_id := 0
var dps := 0:
	set(i):
		dps += i
		print(dps)
		button.dps = dps
var dpc := 1:
	set(i):
		dpc += i
		print(dpc)
		button.dpc = dpc
var f_check := true

# Signals
signal on_opening_lock

# Methods
func start():
	score.text = "Brackeys Game Jam 2024.1\nN3cro0o. Remember to share it with everybody!\nor_else\n\n"
	if(f_check):
		if(GM.instance != null):
			parent = GM.instance.locks[1]
			parent.cam.enabled = false
		upgrades.parent = self
		upgrades.buttons_data = button_data
		button.parent = self
		f_check = false
	score.text += info_text % [dps, dpc, "Please choose the next task", completed_tasks]
	click_window.hide()
	upgr_window.show()

func start_clicker_part(id):
	button.set_process(true)
	click_window.show()
	upgr_window.hide()
	button.cost = button_data[id].cost
	active_task_id = id

func update_cost_string(cost):
	score.text = info_text % [dps, dpc,"Cost: %d" % cost , completed_tasks]

func end_clicker_part():
	completed_tasks += "_" + button_data[active_task_id].name.capitalize()
	dps = button_data[active_task_id].dps
	dpc = button_data[active_task_id].dpc
	if(button_data[active_task_id].lock):
		on_opening_lock.emit()
	
	upgrades.remove_button(active_task_id)
	click_window.hide()
	upgr_window.show()
	button.set_process(false)
	await get_tree().process_frame
	if(button_data[active_task_id].jp2):
		score.text ="No 264. Changed the world\n\n" + info_text % [dps, dpc, "Please choose the next task", completed_tasks]
	else:
		score.text = info_text % [dps, dpc, "Please choose the next task", completed_tasks]

func exit():
	button.set_process(false)
	await get_tree().process_frame
	
	button.cost = 2 * button.cost + 2137
	click_window.hide()
	upgr_window.hide()

func _on_task_close_requested():
	button.set_process(false)
	button.cost = 2 * button.cost + 2137
	click_window.hide()
	upgr_window.show()
	score.text = info_text % [dps, dpc, "Task cancelled. Please choose the next task", completed_tasks]
