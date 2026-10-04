shader_type canvas_item;

uniform vec3 line_colour: source_color = vec3(1.0);
uniform int line_thickness: hint_range(0, 10) = 1;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 shadow_colour: source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform vec2 shadow_offset = vec2(5.0, 5.0);

void fragment() {
	vec2 size = SCREEN_PIXEL_SIZE * float(line_thickness);
	float line_alpha = 0.0;
	for (float i = -size.x; i <= size.x; i += SCREEN_PIXEL_SIZE.x) {
		for (float j = -size.y; j <= size.y; j += SCREEN_PIXEL_SIZE.y) {
			line_alpha += texture(screen_texture, SCREEN_UV + vec2(i, j)).a;
		}
	}
	vec4 screen_colour = texture(screen_texture, SCREEN_UV);
	vec4 outline = vec4(line_colour, min(line_alpha, 1.0));
	vec4 color_mult = mix(outline, screen_colour, screen_colour.a);
	
	if (color_mult.a > 0.0) {
		COLOR *= color_mult;
	} else {
		vec2 offset = SCREEN_PIXEL_SIZE * shadow_offset;
		float alpha = texture(screen_texture, SCREEN_UV + offset).a;
		vec4 colour = shadow_colour;
		colour.a = min(colour.a, alpha);
		COLOR = colour;
	}
}
