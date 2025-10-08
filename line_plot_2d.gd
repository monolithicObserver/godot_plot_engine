extends Control

class_name LinePlot2D

@export var plot_rect: Control
@export var plot_body: Control
@export var x_axis_labels: Control
@export var y_axis_labels: Control
@export var data_lines: Control
@export var coord_label: Label

@export var line_colors: Array[Color] = [Color.RED,
Color.GREEN,Color.BLUE, Color.BLACK, Color.DARK_ORANGE,Color.BLUE_VIOLET,Color.DARK_GREEN]

class data_2d:
	var data_length: int = 0
	var data_x: Array[float] = []
	var data_y: Array[float] = []
	
var max_x: float = 1.0
var min_x: float = 0.0
var max_y: float = 1.0
var min_y: float = 0.0

var data_to_plot: Dictionary[String,data_2d]

@export var  tick_label_settings: LabelSettings

func _add_data(data_name: String,new_data: data_2d) -> void:
	data_to_plot.set(data_name,new_data)
	_update_min_max_values()

#func _append_point_to_line(data_name: String, point_x: float,point_y: float) -> void:
	#data_to_plot.get(data_name).data_x.append(point_x)
	
func _update_min_max_values() -> void:
	var max_x_values: Array[float] = []
	var min_x_values: Array[float] = []
	var max_y_values: Array[float] = []
	var min_y_values: Array[float] = []
	for dl in data_to_plot.values():
		max_x_values.append(dl.data_x.max())
		min_x_values.append(dl.data_x.min())
		max_y_values.append(dl.data_y.max())
		min_y_values.append(dl.data_y.min())
	
	max_x = max_x_values.max()
	min_x = min_x_values.min()
	max_y = max_y_values.max()
	min_y = min_y_values.min()


func _ready() -> void:
	var line1: data_2d = data_2d.new()
	line1.data_length = 100
	for i in line1.data_length:
		line1.data_x.append(i)
		line1.data_y.append((randf()-0.5))
	
	var line2: data_2d = data_2d.new()
	line2.data_length = 35
	
	for i in line2.data_length:
		line2.data_x.append(-20 + i)
		line2.data_y.append(randf_range(-5.0,3.5))
	
	_add_data("Line 1",line1)
	_add_data("Line 2",line2)
	
	
	_draw_plot()
	_refresh_axis_labels()
	


	
	
	
	

func _draw_plot() -> void:
	for lines in data_lines.get_children():
		lines.queue_free()
	var plot_rect_size: Vector2 = plot_rect.size
	
	var line_count = 0
	for data_name in data_to_plot.keys():
		var data_2d_i: data_2d = data_to_plot.get(data_name)
		var x_values: Array[float] = data_2d_i.data_x
		var y_values: Array[float] = data_2d_i.data_y
		var line_visual: Line2D = Line2D.new()
		for j in data_2d_i.data_length:
			var new_point: Vector2
			new_point.x = remap(x_values[j],min_x,max_x,0.0,plot_rect_size.x)
			new_point.y = remap(y_values[j],min_y,max_y,plot_rect_size.y,0.0)
			line_visual.add_point(new_point)
			
		line_visual.default_color = line_colors[line_count]
		line_visual.width = 1.0
		line_count += 1
		data_lines.add_child(line_visual)
		
		
func _on_plot_body_resized() -> void:
	_draw_plot()
	_refresh_axis_labels()


func _refresh_axis_labels() -> void:
	
	for label in x_axis_labels.get_children():
		label.queue_free()
	
	for label in y_axis_labels.get_children():
		label.queue_free()
	
	
	
	
		
	var plot_size: Vector2 = plot_rect.size
	var window_size: Vector2 = plot_body.size
	var window_pos: Vector2 = -plot_rect.position
	
	
	
	var x_axis_length = max_x - min_x
	var y_axis_length = max_y - min_y
	
	var x_scale = (window_size.x / plot_size.x)
	var y_scale = (window_size.y / plot_size.y)
	
	var resized_x = x_axis_length * x_scale
	var resized_y = y_axis_length * y_scale
	
	var spacing_x = _get_grid_spacing(resized_x,4)
	var spacing_y = _get_grid_spacing(resized_y,4)
	
	
	plot_rect.material.set_shader_parameter("plot_rect",Vector4(min_x,min_y,max_x-min_x,max_y-min_y))
	plot_rect.material.set_shader_parameter("plot_size",plot_size)
	plot_rect.material.set_shader_parameter("spacing_x",spacing_x)
	plot_rect.material.set_shader_parameter("spacing_y",spacing_y)
	
	var window_x_min = remap(window_pos.x,0.0,plot_size.x,min_x,max_x)
	var window_y_max = remap(window_pos.y,plot_size.y,0.0,min_y,max_y)
	
	var window_x_max = remap(window_pos.x + window_size.x,0.0,plot_size.x,min_x,max_x)
	var window_y_min = remap(window_pos.y + window_size.y,plot_size.y,0.0,min_y,max_y)
	
	var x_ticks: Array = range(ceil(window_x_min/spacing_x),ceil(window_x_max/spacing_x),1)
	
	var y_ticks: Array = range(ceil(window_y_min/spacing_y),ceil(window_y_max/spacing_y),1)
	
	
	for tick in x_ticks:
		var tick_val = tick * spacing_x
		var tick_label = Label.new()
		tick_label.label_settings = tick_label_settings
		tick_label.text = String.num_scientific(tick_val)
		x_axis_labels.add_child(tick_label)
		tick_label.position.x = remap(tick_val,window_x_min,window_x_max,0.0,window_size.x) - tick_label.size.x * 0.5
		tick_label.position.x = clamp(tick_label.position.x,0.0,window_size.x)
		tick_label.position.y = 0.0
	
	for tick in y_ticks:
		
		var tick_val = tick * spacing_y
		var tick_label = Label.new()
		tick_label.size.x = 50.0
		tick_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		tick_label.label_settings = tick_label_settings
		tick_label.text = String.num_scientific(tick_val)
		y_axis_labels.add_child(tick_label)
		tick_label.position.y = remap(tick_val,window_y_min,window_y_max,window_size.y,0.0) - tick_label.size.y * 0.4
		tick_label.position.x = 0.0
		


func _on_plot_body_panned() -> void:
	_refresh_axis_labels()

func _get_grid_spacing(axis_length: float, target_lines: int = 10) -> float:
	if axis_length <= 0:
		return 0.0
	
	# Desired spacing if we had exactly target_lines
	var raw_spacing = axis_length / float(target_lines)
	
	# Get order of magnitude (10^n)
	var power = pow(10, floor(log(raw_spacing)/log(10)))
	
	# Normalize raw_spacing to [1,10)
	var normalized = raw_spacing / power
	
	# Choose "nice" step from {1, 2, 5}
	var step: float
	if normalized < 2.0:
		step = 1.0
	elif normalized < 5.0:
		step = 2.0
	else:
		step = 5.0
	
	return step * power
	
var coord_label_active = false

func _on_plot_body_mouse_entered() -> void:
	coord_label.visible = true
	coord_label_active = true

func _on_plot_body_mouse_exited() -> void:
	coord_label.visible = false
	coord_label_active = false

func _process(delta: float) -> void:
	if coord_label_active:
		var local_cursor = plot_rect.get_local_mouse_position()
		var coord_x = remap(local_cursor.x,0.0,plot_rect.size.x,min_x,max_x)
		var coord_y = remap(local_cursor.y,plot_rect.size.y,0,min_y,max_y)
		var x_text = _num_2_scientific_str(coord_x)
		var y_text = _num_2_scientific_str(coord_y)
		coord_label.text = "("+x_text+","+y_text+")"

func _num_2_scientific_str(number: float) -> String:
	var decimal_scale = floor(log(abs(number)) / log(10))
	if abs(decimal_scale) <= 1:
		return String.num_scientific(number).pad_decimals(2)
	else:
		return String.num_scientific(number).pad_decimals(2) + "e" + str(decimal_scale).pad_decimals(-1)
