shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float pixel_size = 50.0;
uniform float softness: hint_range(0.0,3.0) = 1;
uniform vec4 vignette_color: source_color = vec4(1.0,0.0,0.0,1.0);

void fragment() {
	ivec2 size = textureSize(SCREEN_TEXTURE, 0);
	int xRes = size.x;
	int yRes = size.y;
	float xFactor = float(xRes) / float(pixel_size);
	float yFactor = float(yRes) / float(pixel_size);
	float grid_uv_x = round(SCREEN_UV.x * xFactor) / xFactor;
	float grid_uv_y = round(SCREEN_UV.y * yFactor) / yFactor;
	
	float vignette = smoothstep(0.2, softness, distance(vec2(0.5), vec2(grid_uv_x, grid_uv_y)));
	
	COLOR = vec4(vignette_color.rgb, vignette);
}
