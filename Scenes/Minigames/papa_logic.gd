extends Control

# Exported variables
@export var password : String
# Variables
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var timer := $Timer
@onready var image := $TextureRect
# Signals
signal on_opening_lock
# Methods
func start():
	label.text = "_ _:_ _"
	image.hide()
	timer.start(60)

func exit():
	pass

func button_logic(num:int):
	set_text(str(num))

func set_text(s:String = ""):
	if(label.text.length() >= password.length()):
		label.text = ""
	label.text += s
	if(label.text == password):
		on_opening_lock.emit()

func image_shower():
	var r = 240
	image.show()
	var a = image.modulate.a
	image.modulate = Color("ffffff00")
	for x in r:
		await get_tree().process_frame
		image.modulate = Color(Color.WHITE, image.modulate.a + a/r)

func on_timeout():
	image_shower()
	timer.stop()
