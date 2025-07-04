shader_type spatial;

render_mode cull_back, depth_draw_opaque;

uniform sampler2D noise_texture : source_color;
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform float edge_thickness : hint_range(0.0, 0.2) = 0.05;
uniform vec3 edge_color : source_color = vec3(1.0, 0.5, 0.0); // glowing edge color
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0) = 0.01;

void fragment() {
    // Sample noise value at the current UV coordinates
    float noise = texture(noise_texture, UV).r;

    // Calculate dissolve effect based on noise
    float dissolve_edge = smoothstep(dissolve_amount - edge_thickness, dissolve_amount, noise);

    // Set the base color (optional: replace with a texture or other color)
    vec3 base_color = vec3(1.0);
    ALBEDO = mix(edge_color, base_color, dissolve_edge);

    // Set the alpha transparency based on the dissolve edge
    ALPHA = dissolve_edge;

    // Apply alpha scissor to discard transparent fragments
    if (ALPHA < alpha_scissor_threshold) {
        discard;
    }
}
