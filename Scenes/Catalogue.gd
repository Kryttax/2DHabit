extends ScrollContainer


onready var buttonGrid = $GridContainer

onready var resources = "res://Assets/dungeon/Icons/"
onready var root = get_node("/root/World")

func _ready():
	var index = 0
	var currentLevel = root.get_buildable_floor()
	var totalCount = currentLevel.tile_set.get_tiles_ids()
	var furniCount = totalCount.size() / 4
	
	for i in furniCount:
		var button = Button.new()
		var path = resources + str(currentLevel.tile_set.tile_get_name(index)) + ".png"
		button.set_button_icon(load(path))
		button.set_expand_icon(true)
		button.connect("pressed", self, "_button_pressed", [button])
		button.set_custom_minimum_size(Vector2(75, 50))
		button.set_h_size_flags(button.SIZE_EXPAND_FILL)
		buttonGrid.add_child(button)
		#Next tile image (skip all rotations)
		index+= 4


func changeCatalogue(category):
	var currentLevel = category
	
	if(currentLevel != null):
		updateCatalogue(currentLevel)
		
func updateCatalogue(current):
	
	for n in buttonGrid.get_children():
		n.queue_free()
	
	var index = 0
	var totalCount = current.tile_set.get_tiles_ids()
	var furniCount = totalCount.size() / 4
	
	for i in furniCount:
		var button = Button.new()
		var path = resources + str(current.tile_set.tile_get_name(index)) + ".png"
		button.set_button_icon(load(path))
		button.set_expand_icon(true)
		button.connect("pressed", self, "_button_pressed", [button])
		button.set_custom_minimum_size(Vector2(75, 50))
		button.set_h_size_flags(button.SIZE_EXPAND_FILL)
		buttonGrid.add_child(button)
		#Next tile image (skip all rotations)
		index+= 4

func _button_pressed(target):
#	print(buttonGrid.get_children().find(target, 0))
	root.pick_object(buttonGrid.get_children().find(target, 0))
	
