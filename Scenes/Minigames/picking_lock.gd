extends Node2D

# Exported variables
@export var speed := 50.0
@export var slider_gradient := GradientTexture1D
# Variables
@onready var speed_base = speed
@onready var button = $Button
@onready var key := $Button/Main
@onready var shadow1 := $Shadow1
@onready var shadow2 := $Shadow2
@onready var shadow3 := $Shadow3
@onready var box = $Area2D
@onready var slider = $VSlider
@onready var audio_bounce = $AudioBoince
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
	# Mouse position check
	var p = button.position
	var r = 35
	if (p - get_local_mouse_position()).length() <= r and visible:
		m_check = true
	else:
		m_check = false
	# Out of bounds logic
	if c_check:
		c_delay += delta
		if(c_delay > .15):
			print("Sus move")
			change_dir(false)
			c_check = false
	else:
		c_delay = 0
	if(check1): # Move button
		button.position = Vector2(p.x + speed * delta * dir.x, p.y - speed * delta * dir.y)
		key.rotate(PI/180 * speed / 40)
		shadow_movement(button.position, key.rotation)
	if(m_check):
		time_stored += delta
	else:
		if(time_stored <= 0):
			time_stored = 0
		else:
			time_stored -= delta / 2
	slider.value = time_stored
	# Checks
	if(time_stored > 3 and !check1):
		check1 = true
		speed /= 2
		shadow1.show()
	if(time_stored > 10 and !check2):
		speed *= 2
		check2 = true
		shadow2.show()
	if(time_stored > 18 and !check3):
		randomize()
		var x = randi_range(0,860)
		var y = randi_range(0,560)
		button.position = Vector2(x - 64 - 430, y - 280)
		speed *= 1.3
		dir.x *= -1
		dir.y *= -1
		check3 = true
		shadow3.show()
	if(time_stored >= 20):
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

func change_dir(play:bool):
	if(abs(button.position.y) > 290):
			dir.y *= -1
	if(button.position.x > 380 or button.position.x < -510):
			dir.x *= -1
	if play:
		audio_bounce.play()

func shadow_movement(pos, rot):
	for x in 2:
		await get_tree().process_frame
	shadow1.position = pos
	shadow1.rotation = rot
	for x in 2:
		await get_tree().process_frame
	shadow2.position = pos
	shadow2.rotation = rot
	for x in 1:
		await get_tree().process_frame
	shadow3.position = pos
	shadow3.rotation = rot

func _on_area_2d_area_exited(area):
	if(area == button):
		c_check = true
		change_dir(true)

func _on_area_2d_area_entered(area):
	if(area == button):
		c_check = false

