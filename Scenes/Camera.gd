extends Camera2D


var zoom_size = 0
var zoom_speed = .5
var zoom_max = 4
var zoom_min = 1

var move_speed = 6
var current_zoom = 2

func _ready():
	zoom_max += self.zoom_size
	zoom_min += self.zoom_size
	
#func _input(event):
#	if event is InputEventMouseButton:
#		# zoom in
#		if event.button_index == BUTTON_WHEEL_UP and self.zoom_size >= zoom_min:
#			zoom(-zoom_amount)
#		# zoom out
#		if event.button_index == BUTTON_WHEEL_DOWN and self.zoom_size <= zoom_max:
#			#zoom_pos = get_global_mouse_position()
#			# call the zoom function
#			zoom(zoom_amount)
#



func _unhandled_input(event):
	if Input.is_key_pressed(KEY_CONTROL) and event.is_action_pressed("ui_wheel_up"):
		current_zoom -= zoom_speed
	if Input.is_key_pressed(KEY_CONTROL) and event.is_action_pressed("ui_wheel_down"):
		current_zoom += zoom_speed
	current_zoom = clamp(current_zoom, zoom_min, zoom_max)
	print(current_zoom)

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		moveCamera(Vector2.RIGHT, delta)
	if Input.is_action_pressed("ui_left"):
		moveCamera(Vector2.LEFT, delta)
	if Input.is_action_pressed("ui_up"):
		moveCamera(Vector2.UP, delta)
	if Input.is_action_pressed("ui_down"):
		moveCamera(Vector2.DOWN, delta)

	
	
	self.zoom = lerp(self.zoom, Vector2.ONE * current_zoom, zoom_speed)


func zoomIn():
	print("Zoom in!")
	
func zoomOut():
	print("Zoom out!")

func zoom(value):
	var zoomVec = Vector2(.5, .5) * value
	print (self.zoom)
	print("Wheel moved!")
	self.zoom += zoomVec
	print (self.zoom)

func moveCamera(direction, delta):
	print("Camera movement")
	self.set_position(lerp(self.position, self.position + direction, move_speed))
