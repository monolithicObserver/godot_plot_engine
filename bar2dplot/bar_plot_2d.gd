extends Control

class_name BarPlot2D

@export var vertical_bars: HBoxContainer
@export var vb_scene: PackedScene
@export var bar_min = 0.0
@export var bar_max = 50.0
@export var bar_values: Array[float]
@export var bar_names: Array[String]
@export var bar_fill_colors: Array[Color]
@export var bar_border_colors: Array[Color]

func _ready() -> void:
	_update_bar_plot()

func _update_bar_plot()->void:
	for bar in vertical_bars.get_children():
		bar.queue_free()
	var n = 0
	for v in bar_values:
		var new_bar = vb_scene.instantiate() as VerticalBar
		new_bar.bar_name = bar_names[n]
		
		new_bar.min_value = bar_min
		new_bar.max_value = bar_max
		new_bar.update_bar_value(v)
		new_bar.fill_stye.bg_color = bar_fill_colors[n]
		new_bar.fill_stye.border_color = bar_border_colors[n]
		
		
		vertical_bars.add_child(new_bar)
		n += 1
		
		
