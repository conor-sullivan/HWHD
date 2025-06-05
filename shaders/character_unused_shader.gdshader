shader_type canvas_item;

uniform bool use_grayscale = false;
uniform float transparency : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Grayscale conversion using luminosity
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 final_color = mix(tex_color.rgb, vec3(gray), use_grayscale ? 1.0 : 0.0);

    // Apply transparency
    COLOR = vec4(final_color, tex_color.a * transparency);
}
