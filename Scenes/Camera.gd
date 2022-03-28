extends Camera2D


var zoom_size = 0
var zoom_amount = 1
var zoom_max = 10
var zoom_min = -20

var move_speed = 4

func _ready():
	zoom_max += self.zoom_size
	zoom_min += self.zoom_size
	
func _input(event):
#	if event is InputEventMouseButton:
#		# zoom in
#		if event.button_index == BUTTON_WHEEL_UP and self.zoom_size >= zoom_min:
#			zoom(-zoom_amount)
#		# zoom out
#		if event.button_index == BUTTON_WHEEL_DOWN and self.zoom_size <= zoom_max:
#			#zoom_pos = get_global_mouse_position()
#			# call the zoom function
#			zoom(zoom_amount)
	
	if Input.is_action_pressed("ui_right"):
		moveCamera(Vector2(move_speed, 0))
	if Input.is_action_pressed("ui_left"):
		moveCamera(Vector2(-move_speed, 0))
	if Input.is_action_pressed("ui_up"):
		moveCamera(Vector2(0, -move_speed))
	if Input.is_action_pressed("ui_down"):
		moveCamera(Vector2(0, move_speed))

func zoom(value):
	var zoomVec = Vector2(.5, .5) * value
	print (self.zoom)
	print("Wheel moved!")
	self.zoom += zoomVec
	print (self.zoom)

func moveCamera(value):
	print("Camera movement")
	self.set_position(self.position + value)
