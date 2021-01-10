extends Control


onready var buttonGrid = $GridContainer
onready var SGButton = $SGButton
onready var NGButton = $NGButton

func _ready():
	
	#Index for image paths
	var index = 0
	
	for button in buttonGrid.get_children():
		#Get Tileset and add the name of each tile to path
		var tiles = get_parent().get_node("First")
		var path = "res://Assets/Tiles/PNG/Library tiles/" + str(tiles.tile_set.tile_get_name(index)) + ".png"
		
		#Set button icon with path
		button.set_button_icon(load(path))
		
		#Button click callback
		button.connect("pressed", self, "_button_pressed", [button])
		
		#Next tile image (skip all rotations)
		index+= 4
	
	NGButton.connect("pressed", self,"_new_game_on_click")
	SGButton.connect("pressed", self,"_SaveGameOnClick")
	

func _new_game_on_click():
	$"../../World".clear_map()

func _SaveGameOnClick():
	var serializer = $"../Serializer"	
	serializer.save_to_file()
	

func _button_pressed(target):
	print(buttonGrid.get_children().find(target, 0))
	var sendToLogic = get_parent()
	sendToLogic.pick_object(buttonGrid.get_children().find(target, 0))
	
