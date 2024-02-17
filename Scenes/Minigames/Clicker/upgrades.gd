extends Control
# Exported variables
@export var theme_button:Theme
# Variables
const label := "%s\nCost: %s inputs"
const debug := "debug_id"
@onready var tooltip := $Tooltip
@onready var timer := $Timer
@onready var audio_player = $AudioStreamPlayer
var buttons : Array[Button]
var buttons_data:
	set(bttn):
		buttons_data = bttn
		for x in bttn:
			create_bttn(x)
var parent
# Signals

# Methods
func create_bttn(bttn_new:ButtonData):
	var bttn = Button.new()
	bttn.theme = theme_button
	bttn.flat = true
	bttn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	buttons.push_back(bttn)
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(bttn)
	
	bttn.text = str(bttn_new.index) + "_" + bttn_new.name.capitalize()
	bttn.set_meta(debug, bttn_new.index)
	var desc = label % [bttn_new.description, bttn_new.cost]
	bttn.mouse_entered.connect(Callable(show_tooltip).bind(desc))
	bttn.mouse_exited.connect(hide_tooltip)
	
	bttn.connect("pressed", Callable(parent.start_clicker_part).bind(bttn_new.index))

func _process(delta):
	tooltip.position = get_global_mouse_position() + Vector2(25 + get_parent().position.x, 25 + get_parent().position.y)

func show_tooltip(text):
	audio_player.play()
	tooltip.text.text = text
	timer.start(.8)

func hide_tooltip():
	timer.stop()
	tooltip.hide()

func remove_button(id:int):
	for x in buttons:
		if x.has_meta(debug):
			if x.get_meta(debug) == id:
				x.hide()
				return

func _on_timer_timeout():
	tooltip.position = get_global_mouse_position() + Vector2(25 + get_parent().position.x, 25 + get_parent().position.y)
	tooltip.show()
