extends CanvasLayer

onready var SGButton = $SGButton
onready var NGButton = $NGButton

onready var otherCat = $CatButton

onready var UpFloorButton =$UpFloorButton
onready var DownFloorButton =$DownFloorButton

onready var resources = "res://Assets/Tiles/PNG/Library tiles/"
onready var root = get_node("/root/World")

func _ready():
	NGButton.connect("pressed", self,"_new_game_on_click")
	SGButton.connect("pressed", self,"_SaveGameOnClick")
	UpFloorButton.connect("pressed", self, "_upFloorOnClick")
	DownFloorButton.connect("pressed", self, "_downFloorOnClick")
	otherCat.connect("pressed", self, "_switchCat", [otherCat])

func _new_game_on_click():
	root.clear_map()

func _SaveGameOnClick():
	var serializer = root.get_node("Serializer")
	serializer.save_to_file()
	

func _upFloorOnClick():
	print("floor up!")
	root.change_floor(1)

func _downFloorOnClick():
	print("floor down!")
	root.change_floor(-1)

func _switchCat(button : Button):
	root.swtich_buildable(button.text)
