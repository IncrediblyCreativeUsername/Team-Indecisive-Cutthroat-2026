shader_type canvas_item;

uniform vec3 mountainColor = vec3(0.5,0.5,0.5);

float getColor(vec2 uv, sampler2D texture1) {
	if (uv.y < texture(texture1, uv).x * 0.125) {
		return 0.;
	}
	return 1.;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (UV.y < texture(TEXTURE, UV).x * 0.125) {
		COLOR.a = 0.;
	}
	
	bool outline = false;
	for (float i = -1.; i < 1.1; i++) {
		for (float j = -1.; j < 1.1; j++) {
			if (getColor(UV+vec2(0.002*i,0.002*j),TEXTURE) == 1.) {
				outline = true;
			}
		}
	}
	if (COLOR.a == 0. && outline) {
		COLOR = vec4(0,0,0,1);
	} else if (getColor(UV, TEXTURE) == 0.) {
		COLOR.a = 0.;
	} else {
		COLOR = vec4(mountainColor,1);
	}
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
