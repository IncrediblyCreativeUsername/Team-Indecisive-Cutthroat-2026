shader_type canvas_item;

uniform vec3 skyColor = vec3(0,0.5,1);
uniform vec3 cloudColor = vec3(1,1,1);

float getColor(vec2 uv, float noise) {
	return min(1,noise - abs(sin(uv.y * PI - 1.2)) - abs(sin(uv.x * PI )-0.5));
}

void vertex() {
	
}

void fragment() {
	// Use noise to generate clouds
	vec2 uv = UV * 1.;
	float color = getColor(uv, COLOR.r);
	COLOR.rgb = vec3(color);
	if (color > 0.25) {
		COLOR = vec4(cloudColor,1);
	}
	else {
		COLOR = vec4(skyColor,1);
	}
	
	// Cloud outline
	bool outline = false;
	for (float i = -1.; i < 1.1; i++) {
		for (float j = -1.; j < 1.1; j++) {
			if (getColor(uv+vec2(0.001*i,0.001*j),texture(TEXTURE,uv+vec2(0.001*i,0.001*j)).x) > 0.25) {
				outline = true;
			}
		}
	}
	if (COLOR.xyz == skyColor && outline) {
		COLOR = vec4(0,0,0,1);
	}
}