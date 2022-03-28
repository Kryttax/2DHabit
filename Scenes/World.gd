extends Node2D

onready var groundTiles = $Ground
onready var firstTiles = $First
onready var serializer = $Serializer
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
	
	var loaded_map = serializer.load_from_file()
	if(loaded_map != null):
		for tile in loaded_map.size():
			firstTiles.set_cellv(loaded_map[tile]["position"], loaded_map[tile]["id"])
		dic = loaded_map

func clear_map():
	dic.clear()
	firstTiles.clear()

func _unhandled_input (event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			var pos = get_local_mouse_position()
			var tile_pos = groundTiles.world_to_map(pos)
			
			if event.button_index == BUTTON_LEFT and PLACEMENT_MODE:
				#var tile_id = firstTiles.tile_set.find_tile_by_name("longTable_S")
				var tile_id = picked_obj_index
				print("Adding one tile...")
				#var p=groundTiles.world_to_map(pos)+Vector2(0,-1)
				firstTiles.set_cellv(tile_pos, tile_id)
				objectsPlaced.append(tile_pos)
				dic.append({"position": tile_pos, "id" : tile_id})
				recent_placed_tile_pos = tile_pos
				
			if event.button_index == BUTTON_RIGHT:
				picked_obj_index_INITIAL = -1
				picked_obj_index = -1
				PLACEMENT_MODE = false
				if(tile_pos != recent_placed_tile_pos):
					firstTiles.set_cellv(tile_pos, -1)
					dic.append({"position": tile_pos, "id" : -1})
		else:
			if event.button_index == BUTTON_WHEEL_UP and PLACEMENT_MODE:
				rotate_object_backwards()
			if event.button_index == BUTTON_WHEEL_DOWN and PLACEMENT_MODE:
				rotate_object_forward()
	
	
	
	if event is InputEventMouseMotion:
		
		#Get mouse position relative to camera offset
		var pos = get_local_mouse_position()
		current_tile_pos = groundTiles.world_to_map(pos)
		print(current_tile_pos)
		#Check if cell is empty
		if (PLACEMENT_MODE):
			if(groundTiles.get_cellv(current_tile_pos) == -1 and recent_placed_tile_pos == null):
				firstTiles.set_cellv(prev_tile_pos, -1)
			if (firstTiles.get_cellv(current_tile_pos) == -1 and groundTiles.get_cellv(current_tile_pos) != -1):
				if (prev_tile_pos != current_tile_pos):
					if(recent_placed_tile_pos == prev_tile_pos):
						print("Object recently placed in previous position.")
						prev_tile_pos = current_tile_pos
						recent_placed_tile_pos = null
					else:
						#Get hand object (from tile at the moment)
						var tile_id = picked_obj_index
						
						firstTiles.set_cellv(prev_tile_pos, -1)
						firstTiles.set_cellv(current_tile_pos, tile_id)
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
#		if(firstTiles.get_cellv(current_tile_pos) == picked_obj_index_INITIAL):
#			firstTiles.set_cellv(current_tile_pos, picked_obj_index)
	else:
		picked_obj_index += 1
		#Update picked object with new tile sprite
#		if(firstTiles.get_cellv(current_tile_pos) == picked_obj_index - 1):
#			firstTiles.set_cellv(current_tile_pos, picked_obj_index)
	if(search_for_object_at(current_tile_pos) == -1):
		firstTiles.set_cellv(current_tile_pos, picked_obj_index)
	else:
		print("Object already placed. Cannot rotate.")
		

		
func rotate_object_backwards():
	var end_obj_rot = picked_obj_index_INITIAL + 3
	if(picked_obj_index == picked_obj_index_INITIAL):
		#Start from the end
		picked_obj_index = end_obj_rot
	else:
		picked_obj_index -= 1
		
	if(search_for_object_at(current_tile_pos) == -1):
		firstTiles.set_cellv(current_tile_pos, picked_obj_index)
	else:
		print("Object already placed. Cannot rotate.")
