uniform vec4 u_reflectivity;
uniform sampler2D u_decalMap;
uniform samplerCube u_environmentMap;

function lerp(vec4 source1,vec4 source2,float percent){
	float t_percent1 = percent;
	t_percent1 = sub(1.0,t_percent1);
	vec4 t_local1 = mul(source1,t_percent1);
	vec4 t_local2 = mul(source2,percent);
	return add(t_local1,t_local2);
}

function main(){
	vec4 t_reflectedColor = textureCube(v_R,u_environmentMap,nomip,linear,clamp);
	vec4 t_decalColor = texture2D(v_texCoord,u_decalMap,nomip,linear,clamp);
	output0 = lerp(t_decalColor.xyzw,t_reflectedColor.xyzw,u_reflectivity.x);
}