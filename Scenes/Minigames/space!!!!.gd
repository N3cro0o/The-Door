extends Node2D
# Exported variables
@export var color_finish :Color
# Variables
@onready var mc := $SpaceMan
@onready var finish := $Finish
var c_check := false
var parent : Window

# Signals
signal on_opening_lock

# Methods
func start():
	if(GM.instance != null):
		parent = GM.instance.locks[1]
		parent.cam.enabled = false
		window_movement()
	finish.get_child(0).set_deferred("disabled", true)
	mc.move_ready = true

func exit():
	mc.velocity = Vector2.ZERO
	mc.audio_player.stop()
	mc.move_ready = false

func on_mc_move():
	if(DoorLogic.instance != null and DoorLogic.instance.check1):
		finish.get_child(0).set_deferred("disabled", false)
		c_check = true
		queue_redraw()

func _draw():
	if(c_check):
		draw_rect(Rect2(finish.position - Vector2(50, 50), Vector2(100, 100)),color_finish)

func window_movement():
	while true:
		parent.position = mc.position
		await get_tree().process_frame

func _on_finish_body_entered(body):
	if body == mc:
		if c_check:
			on_opening_lock.emit()
		else:
			$Label4.show()


func _on_finish_body_exited(body):
	$Label4.hide()
