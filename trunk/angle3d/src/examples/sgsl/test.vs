/**
 * u_size ---> x=beginSize,y=endSize,z= endSize - beginSize
 */
attribute vec4 a_position;
attribute vec4 a_texCoord;
attribute vec4 a_velocity;
attribute vec4 a_lifeScaleSpin;

#ifdef(USE_LOCAL_COLOR){  
	attribute vec4 a_color;
} 

#ifdef(USE_LOCAL_ACCELERATION){  
	attribute vec3 a_acceleration;
} 

uniform mat4 u_invertViewMat;
uniform mat4 u_viewProjectionMat;
uniform vec4 u_vertexOffset[4];
uniform vec4 u_curTime;
uniform vec4 u_size;

/*使用重力*/
#ifdef(USE_ACCELERATION){  
	uniform vec4 u_acceleration;
} 

varying vec4 v_texCoord;

/*全局颜色*/
#ifdef(USE_COLOR){  
	uniform vec4 u_beginColor;
	uniform vec4 u_incrementColor;
} 


#ifdef(USE_COLOR || USE_LOCAL_COLOR){  
	varying vec4 v_color;
} 

/*使用SpriteSheet*/
#ifdef(USE_SPRITESHEET){  
	uniform vec4 u_spriteSheet;
} 

function main(){ 
	/*计算粒子当前运行时间*/
	/*时间少于0时，代表粒子还未触发，设置其时间为0*/
	float t_time = max(u_curTime.x - a_lifeScaleSpin.x,0.0);

	/*进度  = 当前运行时间/总生命时间*/
	/*取小数部分*/
	float t_interp = fract(t_time / a_lifeScaleSpin.y);

	if(t_interp > 0){
		t_interp = 0;
	}else{
		t_interp = fract(t_interp);
	}

	/*判断是否生命结束,非循环时生命结束后保持最后一刻或者应该使其不可见*/
	#ifdef(NOT_LOOP){ 
		/*粒子生命周期结束，停在最后一次*/
		/*float t_finish = greaterThanEqual(t_time,a_lifeScaleSpin.y);*/
		/*t_interp = add(t_interp,t_finish);*/
		/*t_interp = min(t_interp,1.0);*/
		/*粒子生命周期结束，不可见*/
		t_interp = t_interp * greaterThanEqual(a_lifeScaleSpin.y,t_time);
	} 

	/*使用全局颜色和自定义颜色*/
	#ifdef(USE_COLOR && USE_LOCAL_COLOR){  
		vec4 t_offsetColor = u_beginColor + (u_incrementColor * t_interp);
		/*混合全局颜色和粒子自定义颜色*/
		v_color = a_color * t_offsetColor;
	} 
	/*只使用全局颜色*/
	#elseif(USE_COLOR){  
		v_color = u_beginColor + (u_incrementColor * t_interp);
	} 
	/*只使用粒子本身颜色*/
	#elseif(USE_LOCAL_COLOR){  
		v_color = a_color;
	} 

	/*当前运行时间*/
	float t_curLife = t_interp * a_lifeScaleSpin.y;

	/*计算移动速度和重力影响*/
	vec3 t_offsetPos;	
	vec3 t_localAcceleration;
	#ifdef(USE_ACCELERATION){  
		#ifdef(USE_LOCAL_ACCELERATION){  
			t_localAcceleration = (u_acceleration.xyz + a_acceleration) * t_curLife;
		}  
		#else {  
			t_localAcceleration = u_acceleration * t_curLife;
		}  
		t_offsetPos = (a_velocity + t_localAcceleration) * t_curLife;
	}  
	#else {  
		#ifdef(USE_LOCAL_ACCELERATION){  
			t_localAcceleration = a_acceleration * t_curLife + a_velocity;
			t_offsetPos = t_localAcceleration * t_curLife;
		}  
		#else {  
			t_offsetPos = a_velocity * t_curLife;
		}  
	} 

	/*顶点的偏移位置（2个三角形的4个顶点）*/
	vec4 t_pos = u_vertexOffset[a_position.w];

	/*自转*/
	#ifdef(USE_SPIN){  
		float t_angle = t_curLife * a_velocity.w + a_lifeScaleSpin.w;
		vec2 t_xy;
		float t_cos = cos(t_angle);
		float t_sin = sin(t_angle);
		t_xy.x = t_cos * t_pos.x - t_sin * t_pos.y;
		t_xy.y = t_sin * t_pos.x + t_cos * t_pos.y;
		t_pos.xy = t_xy.xy;
	} 

	/*使其面向相机*/
	/*加上位移*/
	t_pos.xyz = m33(t_pos.xyz,u_invertViewMat) + t_offsetPos.xyz;

	/*根据粒子大小确定未转化前的位置*/
	/*u_size.x == start size,u_size.y == end size,u_size.z = end size - start size*/
	/*a_lifeScaleSpin.z == particle scale*/
	float t_offsetSize = u_size.z * t_interp;
	float t_size = (u_size.x + t_offsetSize) * a_lifeScaleSpin.z;

	/*加上中心点*/
	t_pos.xyz = t_pos.xyz * t_size + a_position.xyz;

	/*判断此时粒子是否已经发出，没有放出的话设置该点坐标为0，4个顶点皆为0，所以此粒子不可见*/
	float t_lessThan = lessThan(-t_time,0.0);
	t_pos.xyz = t_pos.xyz * t_lessThan;

	/*最终位置*/
	output = m44(t_pos,u_viewProjectionMat);

	/*计算当前动画所到达的帧数，没有使用SpriteSheet时则直接设置UV为a_texCoord*/
	/*a_texCoord.x --> u,a_texCoord.y --> v*/
	/*a_texCoord.z -->totalFrame,a_texCoord.w --> defaultFrame*/
	#ifdef(USE_SPRITESHEET){ 
		float t_frame;   
		#ifdef(USE_ANIMATION){ 
			t_frame = t_curLife / u_spriteSheet.x + a_texCoord.w;

			float t_frameInterp = fract(t_frame / a_texCoord.z);

			t_frame = floor(t_frameInterp * a_texCoord.z);
		}  
		#else {  
			t_frame = a_texCoord.z;
		} 

		/*计算当前帧时贴图的UV坐标*/
		/*首先计算其在第几行，第几列*/
		float t_curRowIndex = floor(t_frame / u_spriteSheet.y);
		float t_curColIndex = t_frame - t_curRowIndex * u_spriteSheet.y;

		vec2 t_texCoord;

		/*每个单元格所占用的UV坐标*/
		t_texCoord.x = (t_curColIndex + a_texCoord.x) / u_spriteSheet.y;
		t_texCoord.y = (t_curRowIndex + a_texCoord.y) / u_spriteSheet.z;

		v_texCoord = t_texCoord;
	} 
	#else {
		v_texCoord = a_texCoord;
	} 
}