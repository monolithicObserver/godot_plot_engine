extends ProgressBar

class_name VerticalBar

@export var bar_value_label: Label
@export var bar_name_label: Label

@export var background_style: StyleBoxFlat
@export var fill_stye: StyleBoxFlat

var bar_name: String = "Test"

func _ready() -> void:
	add_theme_stylebox_override("background",background_style)
	add_theme_stylebox_override("fill",fill_stye)
	bar_value_label.text = String.num_scientific(value)
	bar_name_label.text = bar_name

func update_bar_value(new_value:float)->void:
	value = new_value
	bar_value_label.text = String.num_scientific(value)
	
	
