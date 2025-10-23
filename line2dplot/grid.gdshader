shader_type canvas_item;

// x,y is the position of rect corner and z,w is the size of the rect
uniform vec4 plot_rect = vec4(-10.0,-10.0,10.0,10.0);
uniform vec2 plot_size = vec2(487,460);

uniform float spacing_x = 1.0;
uniform float spacing_y = 1.0;
uniform vec4 line_color: source_color = vec4(0.7, 0.7, 0.7, 1.0);
uniform vec4 axis_color_x: source_color = vec4(0.0,0.0,0.0,1.0);
uniform vec4 axis_color_y: source_color = vec4(0.0,0.0,0.0,1.0);
uniform float axis_width = 1.0;
uniform float line_width = 1.0;

float remap(float value, float in_min, float in_max, float out_min, float out_max) {
    return out_min + ( (value - in_min) * (out_max - out_min) ) / (in_max - in_min);
}

void fragment() {
	vec2 density = plot_rect.zw / plot_size;
	vec2 plot_uv = vec2(UV.x,1.0-UV.y);
    vec2 plot_coord = plot_rect.xy + vec2(plot_rect.z * plot_uv.x, plot_rect.w * plot_uv.y);

    // Distance to nearest vertical/horizontal grid line
    float dx = plot_coord.x - round(plot_coord.x/spacing_x) * spacing_x;
    float dy = plot_coord.y - round(plot_coord.y/spacing_y) * spacing_y;

    if (abs(dx) < line_width * density.x) {
        COLOR = line_color;
    }
	if (abs(dy) < line_width * density.y) {
        COLOR = line_color;
    }
	if (abs(plot_coord.x) < axis_width * density.x) {
		COLOR = axis_color_y;
	}

	if (abs(plot_coord.y) < axis_width * density.y) {
		COLOR = axis_color_x;
	}
}
