shader_type spatial;

uniform sampler2D gradient_tex : source_color, filter_linear, repeat_disable;
uniform float z_min = -1.0;
uniform float z_max = 1.0;
uniform bool use_lighting = true;

varying float v_height;

void vertex() {
    // Pass vertex world-space height to fragment stage
    vec4 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0));
    v_height = world_pos.y; // Assuming Y is height (z = f(x,y))
}

void fragment() {
    // Normalize height to [0,1] range
    float t = clamp((v_height - z_min) / (z_max - z_min), 0.0, 1.0);
    
    // Sample 1D gradient texture
    vec3 color = texture(gradient_tex, vec2(t, 0.5)).rgb;

    ALBEDO = color;

    if (use_lighting) {
        // Let Godot handle normal lighting
    } else {
        // Unlit mode
        METALLIC = 0.0;
        ROUGHNESS = 1.0;
        EMISSION = color;
    }
}
