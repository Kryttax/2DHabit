extends Camera2D


var zoom_size = 0
var zoom_speed = 2
var zoom_max = 10
var zoom_min = -20
func _ready():
	zoom_max += self.zoom_size
	zoom_min += self.zoom_size
	
#func _input(event):
#	if event is InputEventMouseButton:
#		# zoom in
#		if event.button_index == BUTTON_WHEEL_UP and self.zoom_size >= zoom_min:
#			zoom(-zoom_speed)
#		# zoom out
#		if event.button_index == BUTTON_WHEEL_DOWN and self.zoom_size <= zoom_max:
#			#zoom_pos = get_global_mouse_position()
#			# call the zoom function
#			zoom(zoom_speed)
#
#func zoom(value):
#	print("Wheel moved!")
#	self.zoom_size += value
#	print (self.zoom_size)
