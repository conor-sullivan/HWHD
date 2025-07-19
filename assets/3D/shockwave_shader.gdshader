shader_type spatial;
render_mode unshaded;

uniform vec3 shock_center;
uniform float shock_radius = 0.0;
uniform float shock_width = 0.2;
uniform float strength = 0.3;

void fragment() {
vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float dist = distance(world_pos, shock_center);

    float delta = dist - shock_radius;
    float pulse = 1.0 - abs(delta / shock_width);

    if (pulse < 0.0) {
        discard;
    }

    // Fade out the effect with distance from the wavefront
    pulse = max(pulse, 0.0);
    float intensity = pulse * strength;

    // Color tint (optional)
    vec3 color = vec3(0.3, 0.8, 1.0) * intensity;

    ALBEDO = color;
    ALPHA = intensity;
}
