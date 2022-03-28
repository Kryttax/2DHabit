extends Node
var save_file = "user://map_save_game.save"

onready var Global = get_parent()
var ObjectsToSave = []
var ObjectsToLoad = null

func save_to_file():
	var file = File.new()
	file.open(save_file, File.WRITE)
	fillSerializer()
	file.store_var(ObjectsToSave, true)
	file.close()

func fillSerializer():
	var tileMapToSave = Global.get_node("First")
	#for tile in tileMapToSave.get_used_cells()
	var usedDic = Global.dic
#	var used_id = tileMapToSave.get_used_cells_by_id()
#	print(used[0], used_id[0])
	ObjectsToSave = Global.dic

func load_from_file():
	var file = File.new()
	if file.file_exists(save_file):
		print("File exists! Loading Game...")
		file.open(save_file, File.READ)
		ObjectsToLoad = file.get_var(true)
		file.close()
	else:
		print("File does not exist... Starting new Game")
		
	return ObjectsToLoad
