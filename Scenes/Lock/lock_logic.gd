extends Window

# Exported variables
@export var scene : PackedScene
# Variables
@onready var cam = $Camera2D
var child
var first_time := true
# Signals
signal on_unlock

# Methods
func on_close():
	child.exit()
	hide()

func _ready():
	if(scene != null):
		child = scene.instantiate()
		cam.add_child(child)
		child.position = cam.position
		child.on_opening_lock.connect(unlock)

func unlock():
	on_unlock.emit()
	on_close()

func _about_to_popup():
	print("test")
	if child != null:
		child.start()
