extends CanvasLayer

onready var SGButton = $OptionsContainer/SGButton
onready var NGButton = $OptionsContainer/NGButton
onready var UpFloorButton =$UpFloorButton
onready var DownFloorButton =$DownFloorButton
onready var categoryGrid = $CategoriesContainer

onready var resources = "res://Assets/Tiles/PNG/Library tiles/"
onready var root = get_node("/root/World")

func _ready():
	NGButton.connect("pressed", self,"_new_game_on_click")
	SGButton.connect("pressed", self,"_SaveGameOnClick")
	UpFloorButton.connect("pressed", self, "_upFloorOnClick")
	DownFloorButton.connect("pressed", self, "_downFloorOnClick")

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


func setCategories(catNames):
	for category in catNames:
		var button = Button.new()
		button.text = String(category.name)
		button.connect("pressed", self, "_switchCat", [button])
		button.set_custom_minimum_size(Vector2(75, 50))
		button.set_h_size_flags(button.SIZE_EXPAND_FILL)
		categoryGrid.add_child(button)

func _switchCat(button : Button):
	root.swtich_buildable(button.text)
