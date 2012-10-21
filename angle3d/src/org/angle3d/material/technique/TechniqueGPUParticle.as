package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.Color;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * ...
	 * @author andy
	 */
	public class TechniqueGPUParticle extends Technique
	{
		private var _texture:TextureMapBase;

		private var _offsetVector:Vector.<Number>;

		private var _beginColor:Color = new Color(1, 1, 1, 0);
		private var _endColor:Color = new Color(0, 0, 0, 0);
		private var _incrementColor:Color = new Color(0, 0, 0, 1);
		private var _useColor:Boolean = false;

		private var _curTime:Vector3f = new Vector3f(0, 0, 0);
		private var _size:Vector3f = new Vector3f(1, 1, 0);

		private var _loop:Boolean = true;

		private var _useAcceleration:Boolean = false;
		private var _acceleration:Vector3f;

		/**
		 * 是否自转
		 */
		private var _useSpin:Boolean = false;


		private var _useSpriteSheet:Boolean = false;
		private var _useAnimation:Boolean = false;
		private var _spriteSheetData:Vector.<Number> = new Vector.<Number>(4, true);

		private var _useLocalAcceleration:Boolean = false;
		private var _useLocalColor:Boolean = false;

		private static const USE_ACCELERATION:String = "USE_ACCELERATION";
		private static const USE_LOCAL_ACCELERATION:String = "USE_LOCAL_ACCELERATION";

		private static const USE_SPRITESHEET:String = "USE_SPRITESHEET";
		private static const USE_ANIMATION:String = "USE_ANIMATION";

		private static const USE_COLOR:String = "USE_COLOR";

		private static const USE_LOCAL_COLOR:String = "USE_LOCAL_COLOR";

		private static const USE_SPIN:String = "USE_SPIN";

		private static const NOT_LOOP:String = "NOT_LOOP";

		public function TechniqueGPUParticle()
		{
			super("TechniqueGPUParticle");

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = false;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = true;
			_renderState.blendMode = BlendMode.AlphaAdditive;

			_offsetVector = new Vector.<Number>(16, true);
			_offsetVector[0] = -0.5;
			_offsetVector[1] = -0.5;
			_offsetVector[2] = 0;
			_offsetVector[3] = 1;

			_offsetVector[4] = 0.5;
			_offsetVector[5] = -0.5;
			_offsetVector[6] = 0;
			_offsetVector[7] = 1;

			_offsetVector[8] = -0.5;
			_offsetVector[9] = 0.5;
			_offsetVector[10] = 0;
			_offsetVector[11] = 1;

			_offsetVector[12] = 0.5;
			_offsetVector[13] = 0.5;
			_offsetVector[14] = 0;
			_offsetVector[15] = 1;
		}

		public function set useLocalColor(value:Boolean):void
		{
			_useLocalColor = value;
		}

		public function get useLocalColor():Boolean
		{
			return _useLocalColor;
		}

		public function set useLocalAcceleration(value:Boolean):void
		{
			_useLocalAcceleration = value;
		}

		public function get useLocalAcceleration():Boolean
		{
			return _useLocalAcceleration;
		}

		public function setUseSpin(value:Boolean):void
		{
			_useSpin = value;
		}

		public function getUseSpin():Boolean
		{
			return _useSpin;
		}

		public function setLoop(value:Boolean):void
		{
			_loop = value;
		}

		public function getLoop():Boolean
		{
			return _loop;
		}

		/**
		 *
		 * @param animDuration 秒
		 * @param col 列
		 * @param row 行
		 *
		 */
		public function setSpriteSheet(animDuration:Number, col:int, row:int):void
		{
			//每个图像持续时间
			_spriteSheetData[0] = animDuration;

			_useAnimation = animDuration > 0;

			//列数
			_spriteSheetData[1] = col;
			//行数
			_spriteSheetData[2] = row;
			//总数
			_spriteSheetData[3] = col * row;

			_useSpriteSheet = col > 1 || row > 1;
		}

		public function set curTime(value:Number):void
		{
			_curTime.x = value;
		}

		public function get curTime():Number
		{
			return _curTime.x;
		}

		public function setColor(start:uint, end:uint):void
		{
			_beginColor.setRGB(start);
			_endColor.setRGB(end);

			_incrementColor.r = _endColor.r - _beginColor.r;
			_incrementColor.g = _endColor.g - _beginColor.g;
			_incrementColor.b = _endColor.b - _beginColor.b;

			_useColor = true;
		}

		public function setAlpha(start:Number, end:Number):void
		{
			_beginColor.a = start;
			_endColor.a = end;
			_incrementColor.a = _endColor.a - _beginColor.a;

			_useColor = true;
		}

		public function setSize(start:Number, end:Number):void
		{
			_size.x = start;
			_size.y = end;
			_size.z = end - start;
		}

		public function setAcceleration(acceleration:Vector3f):void
		{
			_acceleration = acceleration;
			_useAcceleration = _acceleration != null && !_acceleration.isZero();
		}

		public function get texture():TextureMapBase
		{
			return _texture;
		}

		public function set texture(value:TextureMapBase):void
		{
			_texture = value;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getTextureVar("s_texture").textureMap = _texture;

			//顶点偏移
			shader.getUniform(ShaderType.VERTEX, "u_vertexOffset").setVector(_offsetVector);

			if (_useColor)
			{
				shader.getUniform(ShaderType.VERTEX, "u_beginColor").setColor(_beginColor);
				shader.getUniform(ShaderType.VERTEX, "u_incrementColor").setColor(_incrementColor);
			}

			shader.getUniform(ShaderType.VERTEX, "u_curTime").setVector3(_curTime);
			shader.getUniform(ShaderType.VERTEX, "u_size").setVector3(_size);

			if (_useAcceleration)
			{
				shader.getUniform(ShaderType.VERTEX, "u_acceleration").setVector3(_acceleration);
			}

			if (_useSpriteSheet)
			{
				shader.getUniform(ShaderType.VERTEX, "u_spriteSheet").setVector(_spriteSheetData);
			}
		}

		/**
		 * u_size ---> x=beginSize,y=endSize,z= endSize - beginSize
		 */
		override protected function getVertexSource(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			return "attribute vec4 a_position;" + "attribute vec4 a_texCoord;" + "attribute vec4 a_velocity;" + "attribute vec4 a_lifeScaleSpin;" +

				"#ifdef(USE_LOCAL_COLOR){" + "	attribute vec4 a_color;" + "}" +

				"#ifdef(USE_LOCAL_ACCELERATION){" + "	attribute vec3 a_acceleration;" + "}" +

				"uniform mat4 u_invertViewMat;" + "uniform mat4 u_viewProjectionMat;" + "uniform vec4 u_vertexOffset[4];" + "uniform vec4 u_curTime;" + "uniform vec4 u_size;" +

				//使用重力
				"#ifdef(USE_ACCELERATION){" + "	uniform vec4 u_acceleration;" + "}" +

				"varying vec4 v_texCoord;" +

				//全局颜色
				"#ifdef(USE_COLOR){" + "	uniform vec4 u_beginColor;" + "	uniform vec4 u_incrementColor;" + "}" +


				"#ifdef(USE_COLOR || USE_LOCAL_COLOR){" + "	varying vec4 v_color;" + "}" +

				//使用SpriteSheet
				"#ifdef(USE_SPRITESHEET){" + "	uniform vec4 u_spriteSheet;" + "}" +

				"function main(){" +
				//计算粒子当前运行时间
				"	float t_time = sub(u_curTime.x,a_lifeScaleSpin.x);" +
				//时间少于0时，代表粒子还未触发，设置其时间为0
				"	t_time = max(t_time,0.0);" +

				//进度  = 当前运行时间/总生命时间
				"	float t_interp = divide(t_time,a_lifeScaleSpin.y);" +
				//取小数部分
				"	t_interp = fract(t_interp);" +

				//判断是否生命结束,非循环时生命结束后保持最后一刻或者应该使其不可见
				"	#ifdef(NOT_LOOP){" +
				//粒子生命周期结束，停在最后一次
//				"		float t_finish = greaterThanEqual(t_time,a_lifeScaleSpin.y);" +
//				"		t_interp = add(t_interp,t_finish);" +
//				"		t_interp = min(t_interp,1.0);" +
				//粒子生命周期结束，不可见
				"		float t_finish = greaterThanEqual(a_lifeScaleSpin.y,t_time);" + "		t_interp = mul(t_interp,t_finish);" + "	}" +

				//使用全局颜色和自定义颜色
				"	#ifdef(USE_COLOR && USE_LOCAL_COLOR){" + "		vec4 t_offsetColor = mul(u_incrementColor,t_interp);" + "		t_offsetColor = add(u_beginColor,t_offsetColor);" +
				//混合全局颜色和粒子自定义颜色
				"		v_color = mul(a_color,t_offsetColor);" + "	}" +
				//只使用全局颜色
				"	#elseif(USE_COLOR){" + "		vec4 t_offsetColor = mul(u_incrementColor,t_interp);" + "		v_color = add(u_beginColor,t_offsetColor);" + "	}" +
				//只使用粒子本身颜色
				"	#elseif(USE_LOCAL_COLOR){" + "		v_color = a_color;" + "	}" +

				//当前运行时间
				"	float t_curLife = mul(t_interp,a_lifeScaleSpin.y);" +

				//计算移动速度和重力影响
				"	vec3 t_offsetPos;" + "	vec3 t_localAcceleration;" + "	#ifdef(USE_ACCELERATION){" + "		#ifdef(USE_LOCAL_ACCELERATION){" + "			t_localAcceleration = add(u_acceleration.xyz,a_acceleration);" + "			t_localAcceleration = mul(t_localAcceleration,t_curLife);" + "		}" + "		#else {" + "			t_localAcceleration = mul(u_acceleration,t_curLife);" + "		}" + "		t_offsetPos = add(a_velocity,t_localAcceleration);" + "		t_offsetPos = mul(t_offsetPos,t_curLife);" + "	}" + "	#else {" + "		#ifdef(USE_LOCAL_ACCELERATION){" + "			t_localAcceleration = mul(a_acceleration,t_curLife);" + "			t_localAcceleration = add(t_localAcceleration,a_velocity);" + "			t_offsetPos = mul(t_localAcceleration,t_curLife);" + "		}" + "		#else {" + "			t_offsetPos = mul(a_velocity,t_curLife);" + "		}" + "	}" +

				//顶点的偏移位置（2个三角形的4个顶点）
				"	vec4 t_pos = u_vertexOffset[a_position.w];" +

				//自转
				"	#ifdef(USE_SPIN){" + "		float t_angle = mul(t_curLife,a_velocity.w);" + "		t_angle = add(t_angle,a_lifeScaleSpin.w);" + "		float t_cos = cos(t_angle);" + "		float t_sin = sin(t_angle);" + "		float t_cosx = mul(t_cos,t_pos.x);" + "		float t_siny = mul(t_sin,t_pos.y);" + "		vec2 t_xy;" + "		t_xy.x = sub(t_cosx,t_siny);" + "		float t_sinx = mul(t_sin,t_pos.x);" + "		float t_cosy = mul(t_cos,t_pos.y);" + "		t_xy.y = add(t_sinx,t_cosy);" + "		t_pos.xy = t_xy.xy;" + "	}" +

				//使其面向相机
				"	t_pos.xyz = m33(t_pos.xyz,u_invertViewMat);" +
				//加上位移
				"	t_pos.xyz = add(t_pos.xyz,t_offsetPos.xyz);" +

				//根据粒子大小确定未转化前的位置
				//u_size.x == start size,u_size.y == end size,u_size.z = end size - start size
				//a_lifeScaleSpin.z == particle scale
				"	float t_offsetSize = mul(u_size.z,t_interp);" + "	float t_size = add(u_size.x,t_offsetSize);" + "	t_size = mul(t_size,a_lifeScaleSpin.z);" + "	t_pos.xyz = mul(t_pos.xyz,t_size);" +
				//加上中心点
				"	t_pos.xyz = add(t_pos.xyz,a_position.xyz);" +

				//判断此时粒子是否已经发出，没有放出的话设置该点坐标为0，4个顶点皆为0，所以此粒子不可见
				"	float t_negate = negate(t_time);" + "	float t_lessThan = lessThan(t_negate,0.0);" + "	t_pos.xyz = mul(t_pos.xyz,t_lessThan);" +

				//最终位置
				"	output = m44(t_pos,u_viewProjectionMat);" +

				//计算当前动画所到达的帧数，没有使用SpriteSheet时则直接设置UV为a_texCoord
				//a_texCoord.x --> u,a_texCoord.y --> v
				//a_texCoord.z -->totalFrame,a_texCoord.w --> defaultFrame
				"	#ifdef(USE_SPRITESHEET){" + "		float t_frame; " + "		#ifdef(USE_ANIMATION){" + "			t_frame = divide(t_curLife,u_spriteSheet.x);" + "			t_frame = add(a_texCoord.w,t_frame);" +

				"			float t_frameInterp = divide(t_frame,a_texCoord.z);" + "			t_frameInterp  = fract(t_frameInterp);" + "			t_frame = mul(t_frameInterp,a_texCoord.z);" + "			t_frame = floor(t_frame);" + "		}" + "		#else {" + "			t_frame = a_texCoord.z;" + "		}" +

				//计算当前帧时贴图的UV坐标
				//首先计算其在第几行，第几列
				"		float t_curRowIndex = divide(t_frame,u_spriteSheet.y);" + "		t_curRowIndex = floor(t_curRowIndex);" + "		float t_curColIndex = mul(t_curRowIndex,u_spriteSheet.y);" + "		t_curColIndex = sub(t_frame,t_curColIndex);" +

				"		vec2 t_texCoord;" +

				//每个单元格所占用的UV坐标
				"		float t_dx = u_spriteSheet.y;" + "		t_dx = reciprocal(t_dx);" + "		float t_x0 = add(t_curColIndex,a_texCoord.x);" + "		t_texCoord.x = mul(t_x0,t_dx);" +

				"		float t_dy = u_spriteSheet.z;" + "		t_dy = reciprocal(t_dy);" + "		float t_y0 = add(t_curRowIndex,a_texCoord.y);" + "		t_texCoord.y = mul(t_y0,t_dy);" +

				"		v_texCoord = t_texCoord;" + "	}" + "	#else {" + "		v_texCoord = a_texCoord;" + "	}" + "}";
		}

		override protected function getFragmentSource(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			return <![CDATA[
			
				uniform sampler2D s_texture;
			
				function main(){
					vec4 t_diffuseColor = texture2D(v_texCoord,s_texture,linear,nomip,clamp);
			
					#ifdef(USE_COLOR || USE_LOCAL_COLOR){
						t_diffuseColor = mul(t_diffuseColor,v_color);
					}
					
					output = t_diffuseColor;
				}]]>;
		}


		override protected function getOption(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<Vector.<String>>
		{
			var results:Vector.<Vector.<String>> = super.getOption(lightType, meshType);
			if (_useAcceleration)
			{
				results[0].push(USE_ACCELERATION);
			}

			if (_useLocalAcceleration)
			{
				results[0].push(USE_LOCAL_ACCELERATION);
			}

			if (!_loop)
			{
				results[0].push(NOT_LOOP);
			}

			if (_useSpriteSheet)
			{
				results[0].push(USE_SPRITESHEET);
				if (_useAnimation)
				{
					results[0].push(USE_ANIMATION);
				}
			}

			if (_useSpin)
			{
				results[0].push(USE_SPIN);
			}

			if (_useColor)
			{
				results[0].push(USE_COLOR);
				results[1].push(USE_COLOR);
			}

			if (_useLocalColor)
			{
				results[0].push(USE_LOCAL_COLOR);
				results[1].push(USE_LOCAL_COLOR);
			}

			return results;
		}

		override protected function getKey(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var result:Array = [_name, meshType];

			if (_useAcceleration)
			{
				result.push(USE_ACCELERATION);
			}

			if (_useLocalAcceleration)
			{
				result.push(USE_LOCAL_ACCELERATION);
			}

			if (!_loop)
			{
				result.push(NOT_LOOP);
			}

			if (_useSpriteSheet)
			{
				result.push(USE_SPRITESHEET);
				if (_useAnimation)
				{
					result.push(USE_ANIMATION);
				}
			}

			if (_useSpin)
			{
				result.push(USE_SPIN);
			}

			if (_useColor)
			{
				result.push(USE_COLOR);
			}

			if (_useLocalColor)
			{
				result.push(USE_LOCAL_COLOR);
			}

			return result.join("_");
		}

		override protected function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
			map[BufferType.PARTICLE_VELOCITY] = "a_velocity";
			map[BufferType.PARTICLE_LIFE_SCALE_ANGLE] = "a_lifeScaleSpin";
			if (_useLocalAcceleration)
			{
				map[BufferType.PARTICLE_ACCELERATION] = "a_acceleration";
			}
			if (_useLocalColor)
			{
				map[BufferType.COLOR] = "a_color";
			}
			return map;
		}

		override protected function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_invertViewMat", UniformBinding.ViewMatrixInverse));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_viewProjectionMat", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

