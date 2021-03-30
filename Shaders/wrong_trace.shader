shader_type canvas_item;

// Usually takes a number between 0 and 1
float round_sigmoid(float x) {
	return(1.0/(1.0 + exp(50.0*(-x + 0.5))));
}

// Usually takes a number between 0 and 2
float kind_of_square_pulse(float s) {
	float s2 = (2.0 - 2.0*s);
	// The pow() function does not work properly, so I do this monstrosity here:
//	return(1.0/(1.0 + pow((2.0 - 2.0*s), 16)));
	return(1.0/(1.0 + s2*s2*s2*s2*s2*s2*s2*s2*s2*s2));
}

float sawtooth(float x, float interval) {
	return 2.0*mod(x, interval)/interval;
}

void fragment() {
	// roughly the pixel interval of the repeating pattern
	float interval = 12.0;
	
	vec2 coord = FRAGCOORD.xy * SCREEN_PIXEL_SIZE.x * 1024.0;
	
//	float value = clamp(round(float(int(coord.x - coord.y/2.0) % interval) / float(interval)), 0.2, 1.0);
//	float value = clamp(round(float(mod(coord.x * 1.6, interval) + mod(coord.y * 0.9, interval)) / (2.0 * interval)), 0.2, 1.0);
//	float value = clamp(mod(0.01+round_sigmoid(mod(coord.x+coord.y, interval)/interval) + round_sigmoid(mod(coord.y-coord.x, interval)/interval), 2.0), 0.2, 1.0);
	float value = kind_of_square_pulse(kind_of_square_pulse(sawtooth(coord.x + coord.y, interval)) + kind_of_square_pulse(sawtooth(coord.y - coord.x, interval)));
//	float value = -0.5;
	
	COLOR = vec4(COLOR.rgb, value);
}