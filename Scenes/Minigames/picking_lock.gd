extends Node2D

# Exported variables
@export var speed := 50.0
# Variables
@onready var button = $Button
@onready var box = $Area2D
@onready var slider = $VSlider
var check1 := false
var check2 := false
var check3 := false
var m_check := false:
	set(b):
		m_check = b
var c_check := false
var time_stored := 0.0
var dir := Vector2(1,1)
var c_delay := 0.0
# Signals
signal on_unlock

# Methods
func _ready():
	randomize_movement()

func _process(delta):
	if c_check:
		c_delay += delta
		if(c_delay > .15):
			print("Sus move")
			change_dir()
			c_check = false
	else:
		c_delay = 0
	if(check1):
		var p = button.position
		button.position = Vector2(p.x + speed * delta * dir.x, p.y - speed * delta * dir.y)
	if(m_check):
		time_stored += delta
	else:
		if(time_stored <= 0):
			time_stored = 0
		else:
			time_stored -= delta / 2
	slider.value = time_stored
	if(time_stored > 3 and !check1):
		check1 = true
		speed /= 2
	if(time_stored > 10 and !check2):
		speed *= 2
		check2 = true
	if(time_stored > 18 and !check3):
		randomize()
		var x = randi_range(0,860)
		var y = randi_range(0,560)
		button.position = Vector2(x - 64 - 430, y - 280)
		speed *= 1.5
		dir.x *= -1
		dir.y *= -1
		check3 = true
	if(time_stored >= 20 or (OS.is_debug_build() and time_stored >= 1)):
		on_unlock.emit()
		speed = 0
		hide()

func randomize_movement():
	randomize()
	var f = randi_range(0, 100)
	print(f)
	if f < 25:
		dir = Vector2(1,1)
	elif f < 50:
		dir = Vector2(-1,1)
	elif f < 75:
		dir = Vector2(-1,-1)
	else:
		dir = Vector2(1,-1)

func change_dir():
	if(abs(button.position.y) > 290):
			dir.y *= -1
	if(button.position.x > 380 or button.position.x < -510):
			dir.x *= -1

func _on_area_2d_area_exited(area):
	if(area == button):
		c_check = true
		change_dir()

func _on_area_2d_area_entered(area):
	if(area == button):
		c_check = false

func mouse_check_inverter():
	m_check = !m_check
