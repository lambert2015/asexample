temp vec4 t_textureMapColor;
			
uniform sampler2D s_texture;

#ifdef(lightmap){
    temp vec4 t_lightMapColor;
    uniform sampler2D s_lightmap;
}

//优化贴图格式选择部分，现在这样写太麻烦了
function main(){
	
	#ifdef(texCoordCompressAlpha){
		t_textureMapColor = texture2D(v_texCoord,s_texture,dxt5,linear,nomip,wrap);
	}
	#elseif(texCoordCompress){
		t_textureMapColor = texture2D(v_texCoord,s_texture,dxt1,linear,nomip,wrap);
	}
	#else {
		t_textureMapColor = texture2D(v_texCoord,s_texture,rgba,linear,nomip,wrap);
	}
    

    #ifdef(lightmap){
        #ifdef(useTexCoord2){
			#ifdef(lightmapCompressAlpha){
				t_lightMapColor = texture2D(v_texCoord2,s_lightmap,dxt5,linear,nomip,wrap);
			}
			#elseif(lightmapCompress){
				t_lightMapColor = texture2D(v_texCoord2,s_lightmap,dxt1,linear,nomip,wrap);
			}
			#else {
				t_lightMapColor = texture2D(v_texCoord2,s_lightmap,rgba,linear,nomip,wrap);
			}
        }
        #else{
			#ifdef(lightmapCompressAlpha){
				t_lightMapColor = texture2D(v_texCoord,s_lightmap,dxt5,linear,nomip,wrap);
			}
			#elseif(lightmapCompress){
				t_lightMapColor = texture2D(v_texCoord,s_lightmap,dxt1,linear,nomip,wrap);
			}
			#else {
				t_lightMapColor = texture2D(v_texCoord,s_lightmap,rgba,linear,nomip,wrap);
			}
        }

        t_textureMapColor = multiply(t_textureMapColor,t_lightMapColor);
    }
    output0 = t_textureMapColor;
}