uniform sampler2D s_texture;
function main(){
	vec4 t_diffuseColor = texture2D(v_texCoord,s_texture,linear,nomip,clamp);
	t_diffuseColor = mul(t_diffuseColor,v_color);
	output = t_diffuseColor;
}