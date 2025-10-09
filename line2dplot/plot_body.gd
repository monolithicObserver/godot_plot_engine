extends Control

signal panned

# Zoom parameters
var zoom: float = 1.0
var zoom_step: float = 0.1
var zoom_min: float = 1.0
var zoom_max: float = 6.0

var is_panning := false
var pan_start := Vector2.ZERO
var pan_offset := Vector2.ZERO

@export var plot_rect: Control

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_at_cursor(1 + zoom_step, event.position)
			_limit_pos()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_at_cursor(1 - zoom_step, event.position)
			_limit_pos()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
			if is_panning:
				pan_start = event.position
				_limit_pos()

	if event is InputEventMouseMotion and is_panning:
		var delta = event.position - pan_start
		plot_rect.position += delta
		emit_signal("panned")
		pan_start = event.position
		_limit_pos()


func _zoom_at_cursor(factor: float, cursor_pos: Vector2):
	var new_zoom = clamp(zoom * factor, zoom_min, zoom_max)
	factor = new_zoom / zoom  # Actual factor after clamping

	var local_cursor = (get_global_mouse_position() - plot_rect.global_position)

	plot_rect.position = plot_rect.position * 1.0 + local_cursor * (1-factor)
	#plot_rect.scale = plot_rect.scale * factor
	plot_rect.size = self.size * new_zoom
	zoom = new_zoom
	
	emit_signal("resized")


func _limit_pos()-> void:
	plot_rect.position.x = min(0,plot_rect.position.x)
	plot_rect.position.y = min(0,plot_rect.position.y)
	
	plot_rect.position.x = max(-size.x * (zoom-1),plot_rect.position.x)
	plot_rect.position.y = max(-size.y * (zoom-1),plot_rect.position.y)


func _on_reset_button_up() -> void:
	plot_rect.position = Vector2.ZERO
	#plot_rect.scale = plot_rect.scale * factor
	plot_rect.size = self.size
	zoom = 1.0
	
	emit_signal("resized")
