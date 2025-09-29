shader_type canvas_item;

// x,y is the position of rect corner and z,w is the size of the rect
uniform vec4 plot_rect = vec4(-10.0,-10.0,10.0,10.0);

uniform float spacing_x : hint_range(0.001, 1.0) = 0.2;
uniform float spacing_y : hint_range(0.001, 1.0) = 0.2;
uniform vec4 line_color: source_color = vec4(0.7, 0.7, 0.7, 1.0);
uniform vec4 axis_color_x: source_color = vec4(0.0,0.0,0.0,1.0);
uniform vec4 axis_color_y: source_color = vec4(0.0,0.0,0.0,1.0);
uniform float axis_width = 0.05;
uniform float line_width = 0.05;

void fragment() {
    vec2 plot_coord = plot_rect.xy + vec2(plot_rect.z * UV.x, plot_rect.w * UV.y);
	
	float ss_x = spacing_x * plot_rect.z;
	float ss_y = spacing_x * plot_rect.w;
	float lws_x = line_width * plot_rect.z;
	float lws_y = line_width * plot_rect.w;
	float aws_x = axis_width * plot_rect.z;
	float aws_y = axis_width * plot_rect.w;
    // Distance to nearest vertical/horizontal grid line
    float dx = abs(mod(plot_coord.x, ss_x));
    float dy = abs(mod(plot_coord.y, ss_y));

    float line = step(dx, lws_x) + step(dy, lws_y);
	
    if (line > 0.0) {
        COLOR = line_color;
    } else {
        COLOR = vec4(1.0,1.0,1.0,1.0);
    }
	
	if (abs(plot_coord.x) < aws_x) {
		COLOR = axis_color_x;
	}
	
	if (abs(plot_coord.y) < aws_y) {
		COLOR = axis_color_y;
	}
}

