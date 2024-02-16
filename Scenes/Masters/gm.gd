extends Node2D
class_name GM
static var instance : GM
# Exported variables
@export var locks:Array[Window]

# Variables
@onready var door = $Camera2D/DoorMain
@onready var cam = $Camera2D
@onready var time_start := Time.get_time_dict_from_system()
@onready var t_text := $Control/MarginContainer/Label

# Methods
func _ready():
	print(time_start)
	instance = self

func window_shower(id:int):
	if id == 0:
		$Camera2D/Lockpick.show()
	else:
		var x = locks[id - 1]
		x.show()
		x.child.start()

func window_unlock(id : int):
	match (id):
		1:
			door.check1 = true
		2:
			door.check2 = true
		3:
			door.check3 = true

func finish_time():
	var t := Time.get_time_dict_from_system()
	print(t)
	var h = t.hour - time_start.hour
	var m = t.minute - time_start.minute
	var s = t.second - time_start.second
	if s < 0:
		s += 60
		m -= 1
	if m < 10:
		m = "0" + str(m)
	if s < 10:
		s = "0" + str(s)
	t_text.text = "%s:%s:%s" % [h,m,s]

func _on_lock_1_focus_entered():
	door.write_on_blackboard("Cipa")

func _on_lock_2_focus_entered():
	door.write_on_blackboard("Cyce")

func _on_lock_3_focus_entered():
	door.write_on_blackboard("WADOWICE")