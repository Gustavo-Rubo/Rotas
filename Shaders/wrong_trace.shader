shader_type canvas_item;

float round_sigmoid(float x) {
	return(1.0/(1.0 + exp(50.0*(-x + 0.5))));
}

void fragment() {
	// roughly the pixel interval of the repeating pattern
	float interval = 8.0;
	
	vec2 coord = FRAGCOORD.xy * SCREEN_PIXEL_SIZE.x * 1024.0;
	
//	float value = clamp(round(float(int(coord.x - coord.y/2.0) % interval) / float(interval)), 0.2, 1.0);
//	float value = clamp(round(float(mod(coord.x * 1.6, interval) + mod(coord.y * 0.9, interval)) / (2.0 * interval)), 0.2, 1.0);
	float value = mod(0.2 + round_sigmoid(mod(coord.x, interval)/interval) + round_sigmoid(mod(coord.y, interval)/interval), 2.0);
	
	COLOR = vec4(COLOR.rgb, value);
}