shader_type canvas_item;

uniform vec4 flash_color: hint_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 1.0;
uniform float alpha_color: hint_range(0.0, 1.0) = 0.5;


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	color.a = color.a * alpha_color;
	
	COLOR = color;
}