extends Node2D
class_name DoorLogic
static var instance : DoorLogic
# Export variables
@export var sprites: Array[Texture2D]
# Variables
var check1 := false:
	set(b):
		check1 = b
		bttn1.visible = !b
		num_check += 2
		all_check_checker()
var check2 := false:
	set(b):
		check2 = b
		bttn2.visible = !b
		num_check += 4
		all_check_checker()
var check3 := false:
	set(b):
		check3 = b
		bttn3.visible = !b
		num_check += 8
		all_check_checker()
var num_check = 0:
	set(i):
		num_check = i
		match num_check:
			2:
				sprite2d.texture = sprites[1]
			6:
				sprite2d.texture = sprites[2]
			8:
				sprite2d.texture = sprites[3]
			10:
				sprite2d.texture = sprites[4]
			14:
				sprite2d.texture = sprites[5]
@onready var sprite2d := $Sprite2D
@onready var bttn0 := $Buttons/Button0
@onready var bttn1 := $Buttons/Button1
@onready var bttn2 := $Buttons/Button2
@onready var bttn3 := $Buttons/Button3
@onready var blackboard := $Control/MarginContainer/Label
@onready var audio_player = $AudioStreamPlayer
@onready var main_menu_button := $MMButton

# Signals
## Signal used to show windows, 'locks'.
signal activate_lock(id:int)
signal open_menu
signal all_done()

# Methods
func all_check_checker(): # The stupidest name I have come up ever
	if check1 and check2 and check3:
		all_done.emit()
	else:
		audio_player.play()

func _ready():
	instance = self
	bttn1.hide()
	bttn2.hide()
	bttn3.hide()
	main_menu_button.hide()

func phase2():
	sprite2d.texture = sprites[0]
	var t := "It seems there're more locks and to open them you have to do something different"
	write_on_blackboard(t)
	bttn0.hide()
	bttn1.show()
	bttn2.show()
	bttn3.show()
	main_menu_button.show()
	audio_player.play()

func window_shower(id : int):
	activate_lock.emit(id)

func write_on_blackboard(text):
	blackboard.text = text

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			open_menu.emit()
	
