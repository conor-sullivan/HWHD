shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform vec4 AuraColor : source_color;
uniform float Intensity;
uniform vec2 Speed;
uniform sampler2D tex_frg_6;

void fragment() {
// ColorParameter:7
	vec4 n_out7p0 = AuraColor;

// FloatParameter:9
	float n_out9p0 = Intensity;

// VectorOp:8
	vec4 n_out8p0 = n_out7p0 * vec4(n_out9p0);

// Input:2
	float n_out2p0 = TIME;

// Vector2Parameter:3
	vec2 n_out3p0 = Speed;

// VectorOp:4
	vec2 n_out4p0 = vec2(n_out2p0) * n_out3p0;

// UVFunc:5
	vec2 n_in5p1 = vec2(1.00000, 1.00000);
	vec2 n_out5p0 = n_out4p0 * n_in5p1 + UV;

// Texture2D:6
	vec4 n_out6p0 = texture(tex_frg_6, n_out5p0);

// Output:0
	ALBEDO = vec3(n_out8p0.xyz);
	ALPHA = n_out6p0.x; // This line controls the transparency.
}
