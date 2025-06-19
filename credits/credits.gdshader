shader_type canvas_item;

uniform float brightness: hint_range(0., 1.) = 1.;
uniform float blurriness: hint_range(0., 10.) = 0.;

void fragment() {
	COLOR.xyz = textureLod(TEXTURE, UV, blurriness).xyz * brightness;
}

