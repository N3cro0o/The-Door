extends Resource
class_name SaveData

# Exported variables
@export var volume := 0.0
@export var mr_w_slider := 1.0
# Variables
const SAVE_DIR = "user://options.tres"

# Methods

func write_save_data():
	ResourceSaver.save(self, SAVE_DIR)

static func load_save_data():
	print("load")
	return ResourceLoader.load(SAVE_DIR)

static func check_if_save_exists():
	return ResourceLoader.exists(SAVE_DIR)
