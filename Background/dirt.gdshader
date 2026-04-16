shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const float CELLS = 10.0;

varying vec2 world_position;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 voronoi(vec2 uv) {
    vec2 gridPos = floor(uv*CELLS);
    
    vec2 posInGrid = fract(uv*CELLS);
    posInGrid -= 0.5;

    vec2 uv2 = posInGrid;
    uv2 = abs(uv2);

    float distToEdge = max(uv2.x,uv2.y);

    float point = 0.0;
    float minDistFromPoint = 100.;

    vec2 nearestGridPos = gridPos;

    for (float i = -1.0; i <= 1.0; i++) {
        for (float j = -1.0; j <= 1.0; j++) {
            vec2 adjGrid = vec2(i,j);
            vec2 pointOnAdjGrid = adjGrid + vec2(sin(100. * rand(gridPos + adjGrid)),sin(100. * rand(gridPos + adjGrid + 1.))) * 0.5;

            float dist = length(posInGrid - pointOnAdjGrid);
            if (dist < minDistFromPoint) {
                nearestGridPos = adjGrid + gridPos;
            }
            minDistFromPoint = min(dist, minDistFromPoint);
        }
    }
	
    return vec4(vec3(abs(sin(rand(nearestGridPos))) * 0.5 + 0.5),1.);   
}

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	if (COLOR.a > 0.) {
		COLOR *= voronoi(world_position / 1024.);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
