extends SubViewportContainer

@export var plot_dimensions: Vector3 = Vector3(10,10,10)
@export var x_axis_range: Vector2 = Vector2(-1.0,1.0)
@export var y_axis_range: Vector2 = Vector2(-1.0,1.0)
class data3d:
	
	var x_size: int = 0
	var y_size: int = 0
	
	var z_min: float = -1.0
	var z_max: float = 1.0
	
	var z_values: PackedFloat32Array
	
	func _index(x_idx: int, y_idx: int) -> int:
		return y_idx * x_size + x_idx
	func is_inside(x_idx: int, y_idx: int) -> bool:
		return x_idx >= 0 and x_idx < x_size and y_idx >= 0 and y_idx < y_size
	func set_value(x_idx: int, y_idx: int, value: float) -> void:
		if is_inside(x_idx, y_idx):
			z_values[_index(x_idx, y_idx)] = value
	func get_value(x_idx: int, y_idx: int) -> float:
		if is_inside(x_idx, y_idx):
			return z_values[_index(x_idx, y_idx)]
		return 0.0
	
	func add_new_column(new_column: PackedFloat32Array) -> void:
		if new_column.size() == x_size:
			z_values.append_array(new_column)
			y_size = y_size + 1
		else :
			print("Columns size does not match x_size")

@onready var data_to_plot: data3d = data3d.new()

@export var plot_mesh: MeshInstance3D
@onready var surface_tool: SurfaceTool = SurfaceTool.new()

func _ready():
	data_to_plot.x_size = 512
	

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and event.is_pressed():
		var new_column = PackedFloat32Array()
		new_column.resize(data_to_plot.x_size)
		for i in data_to_plot.x_size:
			new_column[i] = randf()
		data_to_plot.add_new_column(new_column)
		_update_plot()

func _update_plot()->void:
	plot_mesh.mesh =  generate_surface_mesh()



func generate_surface_mesh() -> ArrayMesh:
	surface_tool.clear()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var size_x = data_to_plot.x_size
	var size_y = data_to_plot.y_size

	for y in range(size_y - 1):
		for x in range(size_x - 1):
			# Compute vertices in grid cell
			var x0 = remap(x,0,size_x,-plot_dimensions.x,plot_dimensions.x)
			var y0 = remap(y,0,size_y,-plot_dimensions.y,plot_dimensions.y)
			var x1 = remap(x+1,0,size_x,-plot_dimensions.x,plot_dimensions.x)
			var y1 = remap(y+1,0,size_y,-plot_dimensions.y,plot_dimensions.y)

			var z00 = data_to_plot.get_value(x, y)
			var z10 = data_to_plot.get_value(x+1, y)
			var z01 = data_to_plot.get_value(x, y+1)
			var z11 = data_to_plot.get_value(x+1, y+1)

			# Two triangles per grid cell
			surface_tool.add_vertex(Vector3(x0, z00, y0))
			surface_tool.add_vertex(Vector3(x1, z10, y0))
			surface_tool.add_vertex(Vector3(x1, z11, y1))

			surface_tool.add_vertex(Vector3(x0, z00, y0))
			surface_tool.add_vertex(Vector3(x1, z11, y1))
			surface_tool.add_vertex(Vector3(x0, z01, y1))

	var mesh = surface_tool.commit()
	return mesh
