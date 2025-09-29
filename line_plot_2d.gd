extends Control

class_name LinePlot2D

@export var plot_rect: Control
@export var line_colors: Array[Color] = [Color.RED,
Color.GREEN,Color.BLUE, Color.BLACK, Color.DARK_ORANGE,Color.BLUE_VIOLET,Color.DARK_GREEN]

@export var plot_edge_margin = 10
class data_2d:
	var data_length: int = 0
	var data_x: Array[float] = []
	var data_y: Array[float] = []
	
var max_x: float = 1.0
var min_x: float = 0.0
var max_y: float = 1.0
var min_y: float = 0.0

var data_to_plot: Dictionary[String,data_2d]


func _add_data(data_name: String,new_data: data_2d) -> void:
	data_to_plot.set(data_name,new_data)
	
	max_x = max(max_x,new_data.data_x.max())
	max_y = max(max_y,new_data.data_y.max())
	
	min_x = min(min_x,new_data.data_x.min())
	min_y = min(min_y,new_data.data_y.min())

#func _append_point_to_line(data_name: String, point_x: float,point_y: float) -> void:
	#data_to_plot.get(data_name).data_x.append(point_x)
	


func _ready() -> void:
	var line1: data_2d = data_2d.new()
	line1.data_length = 100
	for i in line1.data_length:
		line1.data_x.append(i)
		line1.data_y.append(randf())
	
	var line2: data_2d = data_2d.new()
	line2.data_length = 35
	
	for i in line2.data_length:
		line2.data_x.append(20 + i)
		line2.data_y.append(randf_range(-0.1,3.5))
	
	_add_data("Line 1",line1)
	_add_data("Line 2",line2)
	
	
	
	

func _draw_plot() -> void:
	for lines in plot_rect.get_children():
		lines.queue_free()
	var plot_rect_size: Vector2 = plot_rect.size - Vector2.ONE * plot_edge_margin
	
	var line_count = 0
	for data_name in data_to_plot.keys():
		var data_2d_i: data_2d = data_to_plot.get(data_name)
		var x_values: Array[float] = data_2d_i.data_x
		var y_values: Array[float] = data_2d_i.data_y
		var line_visual: Line2D = Line2D.new()
		for j in data_2d_i.data_length:
			var new_point: Vector2
			new_point.x = remap(x_values[j],min_x,max_x,plot_edge_margin,plot_rect_size.x)
			new_point.y = remap(y_values[j],min_y,max_y,plot_rect_size.y,plot_edge_margin)
			line_visual.add_point(new_point)
			
		line_visual.default_color = line_colors[line_count]
		line_visual.width = 1.0
		line_count += 1
		plot_rect.add_child(line_visual)
		
		
func _on_plot_body_resized() -> void:
	_draw_plot()
