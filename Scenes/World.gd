extends Node2D

onready var serializer = $Serializer
onready var catalogue = get_node("CanvasLayer/Catalogue")
onready var canvas = $CanvasLayer

var current_floor = 0
var total_floors = 2

onready var level0 = get_current_floor()
onready var groundTiles = get_current_floor().get_node("Floor")
onready var furniTiles = groundTiles.get_node("Furni")

var prev_tile_pos = null
var recent_placed_tile_pos = null

var current_tile_pos = null

var picked_obj_index_INITIAL = -1
var picked_obj_index = -1

var PLACEMENT_MODE = false
var ROTATION_HAPPENING = false

var objectsPlaced = []
var dic = []

func _ready():
	var pos = get_local_mouse_position()
	var current_tile_pos = groundTiles.world_to_map(pos)
	prev_tile_pos = current_tile_pos
	
	# pre-save all map currently showed
#	var pre_used = furniTiles.get_used_cells()
#	for usedTile in pre_used.size():
#		dic.append({"position": usedTile, "id" : furniTiles.get_cellv(pre_used[usedTile])})
#		print(furniTiles.get_cellv(pre_used[usedTile]))
	
	var loaded_map = serializer.load_from_file()
	if(loaded_map != null):
		for tile in loaded_map.size():
			furniTiles.set_cellv(loaded_map[tile]["position"], loaded_map[tile]["id"])
			dic.append({"position": loaded_map[tile]["position"], "id" : loaded_map[tile]["id"]})
		dic = loaded_map
		
	canvas.setCategories(groundTiles.get_children())

func change_floor(sum):
	if(current_floor + sum >= 0 and current_floor + sum < total_floors):
		current_floor += sum
		setTilesRefs()
		
func setTilesRefs():
	groundTiles = get_current_floor().get_node("Floor")
	furniTiles = groundTiles.get_node("Furni")
	furniTiles._update_offsets(true)
	
func get_current_floor():
	return get_node("Level" + String(current_floor))
	
func get_buildable_floor():
	return get_current_floor().get_node("Floor").get_node("Furni")

func clear_map():
	dic.clear()
	furniTiles.clear()

func _unhandled_input (event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			var pos = get_local_mouse_position()
			var tile_pos = groundTiles.world_to_map(pos)
			
			if event.button_index == BUTTON_LEFT and PLACEMENT_MODE:
				#var tile_id = furniTiles.tile_set.find_tile_by_name("longTable_S")
				var tile_id = picked_obj_index
				print("Adding one tile...")
				furniTiles.set_cellv(tile_pos, tile_id)
				objectsPlaced.append(tile_pos)
				dic.append({"position": tile_pos, "id" : tile_id})
				recent_placed_tile_pos = tile_pos
				
			if event.button_index == BUTTON_RIGHT:
				picked_obj_index_INITIAL = -1
				picked_obj_index = -1
				PLACEMENT_MODE = false
				if(tile_pos != recent_placed_tile_pos):
					furniTiles.set_cellv(tile_pos, -1)
					dic.append({"position": tile_pos, "id" : -1})

	
	if (!Input.is_key_pressed(KEY_CONTROL)) and event.is_action_pressed("ui_wheel_up") and PLACEMENT_MODE:
		rotate_object_backwards()
	if !Input.is_key_pressed(KEY_CONTROL) and event.is_action_pressed("ui_wheel_down") and PLACEMENT_MODE:
		rotate_object_forward()
	
	
	
	if event is InputEventMouseMotion:
		
		#Get mouse position relative to camera offset
		var pos = get_local_mouse_position()
		current_tile_pos = groundTiles.world_to_map(pos)
		print(current_tile_pos)
		#Check if cell is empty
		if (PLACEMENT_MODE):
			if(groundTiles.get_cellv(current_tile_pos) == -1 and recent_placed_tile_pos == null):
				furniTiles.set_cellv(prev_tile_pos, -1)
			if (furniTiles.get_cellv(current_tile_pos) == -1 and groundTiles.get_cellv(current_tile_pos) != -1):
				if (prev_tile_pos != current_tile_pos):
					if(recent_placed_tile_pos == prev_tile_pos):
						print("Object recently placed in previous position.")
						prev_tile_pos = current_tile_pos
						recent_placed_tile_pos = null
					else:
						#Get hand object (from tile at the moment)
						var tile_id = picked_obj_index
						
						furniTiles.set_cellv(prev_tile_pos, -1)
						furniTiles.set_cellv(current_tile_pos, tile_id)
						prev_tile_pos = current_tile_pos
						recent_placed_tile_pos = null
			

func pick_object(var objectIndex : int):
	
	# E, N, S, W
	if(objectIndex != 0):
		objectIndex = (objectIndex * 3) + objectIndex
	picked_obj_index_INITIAL = objectIndex
	picked_obj_index = objectIndex
	
	PLACEMENT_MODE = true


func search_for_object_at(var position : Vector2) -> int:
	var found = objectsPlaced.find(position)
	return found

func rotate_object_forward():
	var end_obj_rot = picked_obj_index_INITIAL + 3
	var before_rot = picked_obj_index
	
	if(picked_obj_index == end_obj_rot):
		#Back to the beginning
		picked_obj_index = picked_obj_index_INITIAL
		#Update picked object with new tile sprite
#		if(furniTiles.get_cellv(current_tile_pos) == picked_obj_index_INITIAL):
#			furniTiles.set_cellv(current_tile_pos, picked_obj_index)
	else:
		picked_obj_index += 1
		#Update picked object with new tile sprite
#		if(furniTiles.get_cellv(current_tile_pos) == picked_obj_index - 1):
#			furniTiles.set_cellv(current_tile_pos, picked_obj_index)
	if(search_for_object_at(current_tile_pos) == -1 and can_place_object(current_tile_pos)):
		furniTiles.set_cellv(current_tile_pos, picked_obj_index)
	else:
		print("Cell occupied. Cannot rotate here.")
		

		
func rotate_object_backwards():
	var end_obj_rot = picked_obj_index_INITIAL + 3
	if(picked_obj_index == picked_obj_index_INITIAL):
		#Start from the end
		picked_obj_index = end_obj_rot
	else:
		picked_obj_index -= 1
		
	if(search_for_object_at(current_tile_pos) == -1 and can_place_object(current_tile_pos)):
		furniTiles.set_cellv(current_tile_pos, picked_obj_index)
	else:
		print("Cell occupied. Cannot rotate here.")

func can_place_object(var position : Vector2) -> bool:
		return (PLACEMENT_MODE and 
			groundTiles.get_cellv(position) != -1)
			

func swtich_buildable(level_name):
	if(groundTiles.has_node(level_name)):
		furniTiles = groundTiles.get_node(level_name)
		furniTiles._update_offsets(true)
		catalogue.changeCatalogue(furniTiles)
		
	return null
