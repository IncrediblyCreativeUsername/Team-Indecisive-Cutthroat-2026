shader_type canvas_item;

uniform float flash;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.a > 0.) {
		COLOR += vec4(1,1,1,0) * flash;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
