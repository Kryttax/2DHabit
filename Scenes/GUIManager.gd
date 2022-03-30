extends CanvasLayer


onready var buttonGrid = $GridContainer
onready var SGButton = $SGButton
onready var NGButton = $NGButton

onready var UpFloorButton =$UpFloorButton
onready var DownFloorButton =$DownFloorButton

onready var resources = "res://Assets/Tiles/PNG/Library tiles/"
onready var root = get_node("/root/World")

func _ready():
	
	#Index for image paths
	var index = 0
	
	for button in buttonGrid.get_children():
		#Get Tileset and add the name of each tile to path
#		var tiles = root.get_node("First")
#		var path = "res://Assets/Tiles/PNG/Library tiles/" + str(tiles.tile_set.tile_get_name(index)) + ".png"
		
		var currentLevel = root.get_buildable_floor()
		var path = resources + str(currentLevel.tile_set.tile_get_name(index)) + ".png"
		
		#Set button icon with path
		button.set_button_icon(load(path))
		button.expand_icon = true
		
		#Button click callback
		button.connect("pressed", self, "_button_pressed", [button])
		
		#Next tile image (skip all rotations)
		index+= 4
	
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

func _button_pressed(target):
	print(buttonGrid.get_children().find(target, 0))
	root.pick_object(buttonGrid.get_children().find(target, 0))
	
