shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float pixel_size = 100.0;
uniform float vignette_intensity = 0.4;

void fragment() {
	ivec2 size = textureSize(SCREEN_TEXTURE, 0);
	int xRes = size.x;
	int yRes = size.y;
	float xFactor = float(xRes) / float(pixel_size);
	float yFactor = float(yRes) / float(pixel_size);
	float grid_uv_x = round(SCREEN_UV.x * xFactor) / xFactor;
	float grid_uv_y = round(SCREEN_UV.y * yFactor) / yFactor;
	
	COLOR = vec4(1.0,0.0,0.0, distance(vec2(0.5), vec2(grid_uv_x, grid_uv_y))*vignette_intensity);
}
