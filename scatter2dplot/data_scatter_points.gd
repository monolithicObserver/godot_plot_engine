extends Control

@export var scatter_plot_2d: ScatterPlot2D
func _draw_plot() -> void:
	
	var plot_rect_size: Vector2 = self.size
	
	var data_count = 0
	for data_name in scatter_plot_2d.data_to_plot.keys():
		var data_2d_i = scatter_plot_2d.data_to_plot.get(data_name)
		var x_values: Array[float] = data_2d_i.data_x
		var y_values: Array[float] = data_2d_i.data_y
		var point_color: Color = scatter_plot_2d.point_colors[data_count]
		for j in data_2d_i.data_length:
			var new_point: Vector2
			
			new_point.x = remap(x_values[j],scatter_plot_2d.min_x,scatter_plot_2d.max_x,0.0,plot_rect_size.x)
			new_point.y = remap(y_values[j],scatter_plot_2d.min_y,scatter_plot_2d.max_y,plot_rect_size.y,0.0)
			draw_circle(new_point ,4.0,point_color,true,-1.0,true)
		data_count += 1
	

func _draw() -> void:
	_draw_plot()
