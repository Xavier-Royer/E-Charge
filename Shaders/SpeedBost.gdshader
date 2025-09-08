shader_type canvas_item;

uniform float speed;
void fragment(){
	vec2 point = UV;
	point.x -= (TIME*speed);
	//point += vec2(speed/100.0,0);
	if (point.x>1.0){
		point.x -=floor(point.x)
	}
	
	if (point.x<0.0){
		point.x -=floor(point.x)
	}
	
	
	COLOR = vec4(texture(TEXTURE,(point) ));
	//COLOR = vec4(0,0,0,0);
	
	
}