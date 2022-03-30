tool
extends TileMap


var offset = Vector2(0.0, -172.0)

export(bool) var UpdateOffsets setget _update_offsets

func _ready():
	_update_offsets(true)

func _update_offsets(new):
	for tile_id in tile_set.get_tiles_ids():
		tile_set.tile_set_texture_offset(tile_id, offset)
