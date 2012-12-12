uniform sampler2D s_texture;
			
function main(){
	vec4 t_diffuseColor = texture2D(v_texCoord,s_texture,rgba,linear,nomip,wrap);

	#ifdef(USE_COLOR || USE_LOCAL_COLOR){
		t_diffuseColor = mul(t_diffuseColor,v_color);
	}
	
	output0 = t_diffuseColor;
}