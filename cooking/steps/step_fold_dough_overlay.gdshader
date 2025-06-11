shader_type canvas_item;

uniform int fold_type = 0;
uniform float fold = 1.;

void fragment() {
	float f = fold;
	switch(fold_type) {
		case 0: // north
			f = 1. - fold;
			// draw an imaginary line at `fold`
			float dist_to_fold = distance(UV.y, f);
			// if we're getting folded over, then compute the sample point
			// to be the valid texture
			float sample_point = dist_to_fold < distance(f, 0.) ? f - dist_to_fold : UV.y;
			
			// sample at sample point
			vec4 c = texture(TEXTURE, vec2(UV.x, sample_point));
			//COLOR = mix(COLOR, c, c.a);
			COLOR = dist_to_fold < distance(f, 0.) ? c : vec4(0.);
			
			// clear anything past the folded edge and draw a border line
			float alpha = texture(TEXTURE, UV).a;
			vec4 line_color = dist_to_fold < .01 ? vec4(.180, .109, .091, alpha) : vec4(0.);
			COLOR = f > UV.y ? line_color : COLOR;
			break;
		case 1: // east
			// draw an imaginary line at `fold`
			float dist_to_fold = distance(UV.x, f);
			// if we're getting folded over, then compute the sample point
			// to be the valid texture
			float sample_point = dist_to_fold < distance(f, 1.) ? f + dist_to_fold : UV.x;
			
			// sample at sample point
			vec4 c = texture(TEXTURE, vec2(sample_point, UV.y));
			COLOR = dist_to_fold < distance(f, 1.) ? c : vec4(0.);
			
			// clear anything past the folded edge and draw a border line
			float alpha = texture(TEXTURE, UV).a;
			vec4 line_color = dist_to_fold < .01 ? vec4(.180, .109, .091, alpha) : vec4(0.);
			COLOR = f < UV.x ? line_color : COLOR;
			break;
		case 2: // south
			// draw an imaginary line at `fold`
			float dist_to_fold = distance(UV.y, f);
			// if we're getting folded over, then compute the sample point
			// to be the valid texture
			float sample_point = dist_to_fold < distance(f, 1.) ? f + dist_to_fold : UV.y;
			
			// sample at sample point
			vec4 c = texture(TEXTURE, vec2(UV.x, sample_point));
			COLOR = dist_to_fold < distance(f, 1.) ? c : vec4(0.);
			
			// clear anything past the folded edge and draw a border line
			float alpha = texture(TEXTURE, UV).a;
			vec4 line_color = dist_to_fold < .01 ? vec4(.180, .109, .091, alpha) : vec4(0.);
			COLOR = f < UV.y ? line_color : COLOR;
			break;
		case 3: // west
			f = 1. - fold;
			// draw an imaginary line at `fold`
			float dist_to_fold = distance(UV.x, f);
			// if we're getting folded over, then compute the sample point
			// to be the valid texture
			float sample_point = dist_to_fold < distance(f, 0.) ? f - dist_to_fold : UV.x;
			
			// sample at sample point
			vec4 c = texture(TEXTURE, vec2(sample_point, UV.y));
			//COLOR = mix(COLOR, c, c.a);
			COLOR = dist_to_fold < distance(f, 0.) ? c : vec4(0.);
			
			// clear anything past the folded edge and draw a border line
			float alpha = texture(TEXTURE, UV).a;
			vec4 line_color = dist_to_fold < .01 ? vec4(.180, .109, .091, alpha) : vec4(0.);
			COLOR = f > UV.x ? line_color : COLOR;
			break;
	}
}
//