extends CharacterBody2D
# Exported variables
@export var speed := 50
@export var circle_color := Color.WHITE
# Variables

# Signals
signal on_move
# Methods
func _physics_process(delta):
	var mouse := get_global_mouse_position()
	if (mouse - position).length() < 100 and (mouse - position).length() > 5:
		rotation = rotate_toward(rotation, (mouse - position).angle() - deg_to_rad(90), .06)
	var norm_vector = mouse - position
	norm_vector = Vector2(norm_vector.x / norm_vector.length(), norm_vector.y / norm_vector.length())
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		on_move.emit()
		velocity.x = speed * norm_vector.x
		velocity.y = speed * norm_vector.y
		if(mouse - position).length() > 100 or (mouse - position).length() < 5:
			velocity.x = 0
			velocity.y = 0
	move_and_slide()

func _draw():
	draw_circle(Vector2.ZERO, 100, circle_color)
