uniform sampler2D s_texture;
			
function main(){
	vec4 t_diffuseColor = texture2D(v_texCoord,s_texture);

	#ifdef(USE_COLOR || USE_LOCAL_COLOR){
		t_diffuseColor = t_diffuseColor * v_color;
	}
	
	output = t_diffuseColor;
}