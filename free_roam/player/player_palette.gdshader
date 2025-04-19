shader_type canvas_item;

// Throw this shader on anything using the MC switchable color palette.
// Associated sprites MUST not be drawn with antialiasing, and MUST use the
// correct color palette.
//
// Finally, the Texture settings on the associated sprite MUST be set to
// Filter - Nearest, so that the colors can be correctly identified.

global uniform vec4 player_skin;
global uniform vec4 player_apron;
global uniform vec4 player_hair;
global uniform vec4 player_shirt;

const vec3 player_shirt_key = vec3(249, 180, 213) / 255.0;
const vec3 player_apron_key = vec3(229, 216, 184) / 255.0;
const vec3 player_skin_key = vec3(201, 131, 96) / 255.0;
const vec3 player_hair_key = vec3(32, 34, 61) / 255.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if(color.rgb == player_shirt_key) {
		color.rgb = player_shirt.rgb; // TODO: Make these uniforms vec3 somehow?
	}
	if(color.rgb == player_apron_key) {
		color.rgb = player_apron.rgb;
	}
	if(color.rgb == player_skin_key) {
		color.rgb = player_skin.rgb;
	}
	if(color.rgb == player_hair_key) {
		color.rgb = player_hair.rgb;
	}
	COLOR = color;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
