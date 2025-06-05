shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.466;
uniform vec2 center = vec2(0.5, 0.5);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	float dist = distance(uv, center);

	if (dist > radius) {
		discard;
	} else {
		COLOR = texture(TEXTURE, uv);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
