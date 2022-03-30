tool
extends TileMap

export (float) var height = -192.0 setget update_height
var offset = Vector2(0.0, height)

export(bool) var UpdateOffsets setget _update_offsets

func _ready():
	_update_offsets(true)
	
func update_height(new):
	print("set: ", new)
	self.offset = Vector2(0.0, new)

func _update_offsets(new):
	for tile_id in tile_set.get_tiles_ids():
		tile_set.tile_set_texture_offset(tile_id, offset)
