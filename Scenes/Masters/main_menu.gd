extends Sprite2D
class_name MainMenu

# Exported variables

# Variables
@onready var go_back_bttn := $Control/MarginContainer/HBoxContainer/Buttons/Continue
@onready var quit_bttn := $Control/MarginContainer/HBoxContainer/Buttons/Quit
@onready var master_sound_slider := $Control/MarginContainer/HBoxContainer/Sliders/Label/MasterS
@onready var mr_w_slider := $Control/MarginContainer/HBoxContainer/Sliders/Label2/MrW
@onready var master_bus := AudioServer.get_bus_index("Master")
@onready var player := $SamplePlayer

# Signals
signal end_menu
signal end_game

# Methods

func _on_continue():
	end_menu.emit()

func _on_quit():
	end_game.emit()

func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_sound_drag_ended(value_changed):
	player.play()

func _on_mr_w(value):
	GM.instance.lockpick.speed = GM.instance.lockpick.speed_base * value
