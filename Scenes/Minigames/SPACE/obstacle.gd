extends StaticBody2D

# Exported variables
@export var transparent := false
# Variables
@onready var collider := $CollisionShape2D
@onready var spirte := $Sprite2D
# Signals

# Methods
func _ready():
	if(transparent):
		spirte.modulate = Color(Color.WHITE, 0)
	else:
		spirte.modulate = Color(Color.WHITE, 1)
