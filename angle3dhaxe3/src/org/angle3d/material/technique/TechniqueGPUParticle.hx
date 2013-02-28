package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
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
	class TechniqueGPUParticle extends Technique
	{
		[Embed(source = "data/gpuparticle.vs", mimeType = "application/octet-stream")]
		private static var GPUParticleVS:Class;
		[Embed(source = "data/gpuparticle.fs", mimeType = "application/octet-stream")]
		private static var GPUParticleFS:Class;

		private var _texture:TextureMapBase;

		private var _offsetVector:Vector<Float>;

		private var _beginColor:Color = new Color(1, 1, 1, 0);
		private var _endColor:Color = new Color(0, 0, 0, 0);
		private var _incrementColor:Color = new Color(0, 0, 0, 1);
		private var _useColor:Bool = false;

		private var _curTime:Vector3f = new Vector3f(0, 0, 0);
		private var _size:Vector3f = new Vector3f(1, 1, 0);

		private var _loop:Bool = true;

		private var _useAcceleration:Bool = false;
		private var _acceleration:Vector3f;

		/**
		 * 是否自转
		 */
		private var _useSpin:Bool = false;


		private var _useSpriteSheet:Bool = false;
		private var _useAnimation:Bool = false;
		private var _spriteSheetData:Vector<Float> = new Vector<Float>(4, true);

		private var _useLocalAcceleration:Bool = false;
		private var _useLocalColor:Bool = false;

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
			super();

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = false;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = true;
			_renderState.blendMode = BlendMode.AlphaAdditive;

			_offsetVector = new Vector<Float>(16, true);
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

		public function set useLocalColor(value:Bool):Void
		{
			_useLocalColor = value;
		}

		public function get useLocalColor():Bool
		{
			return _useLocalColor;
		}

		public function set useLocalAcceleration(value:Bool):Void
		{
			_useLocalAcceleration = value;
		}

		public function get useLocalAcceleration():Bool
		{
			return _useLocalAcceleration;
		}

		public function setUseSpin(value:Bool):Void
		{
			_useSpin = value;
		}

		public function getUseSpin():Bool
		{
			return _useSpin;
		}

		public function setLoop(value:Bool):Void
		{
			_loop = value;
		}

		public function getLoop():Bool
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
		public function setSpriteSheet(animDuration:Float, col:Int, row:Int):Void
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

		public function set curTime(value:Float):Void
		{
			_curTime.x = value;
		}

		public function get curTime():Float
		{
			return _curTime.x;
		}

		public function setColor(start:uint, end:uint):Void
		{
			_beginColor.setRGB(start);
			_endColor.setRGB(end);

			_incrementColor.r = _endColor.r - _beginColor.r;
			_incrementColor.g = _endColor.g - _beginColor.g;
			_incrementColor.b = _endColor.b - _beginColor.b;

			_useColor = true;
		}

		public function setAlpha(start:Float, end:Float):Void
		{
			_beginColor.a = start;
			_endColor.a = end;
			_incrementColor.a = _endColor.a - _beginColor.a;

			_useColor = true;
		}

		public function setSize(start:Float, end:Float):Void
		{
			_size.x = start;
			_size.y = end;
			_size.z = end - start;
		}

		public function setAcceleration(acceleration:Vector3f):Void
		{
			_acceleration = acceleration;
			_useAcceleration = _acceleration != null && !_acceleration.isZero();
		}

		public function get texture():TextureMapBase
		{
			return _texture;
		}

		public function set texture(value:TextureMapBase):Void
		{
			_texture = value;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):Void
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
		override private function getVertexSource():String
		{
			var ba:ByteArray = new GPUParticleVS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getFragmentSource():String
		{
			var ba:ByteArray = new GPUParticleFS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getOption(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<Vector<String>>
		{
			var results:Vector<Vector<String>> = super.getOption(lightType, meshType);
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

		override private function getKey(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var result:Array = [name, meshType];

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

		override private function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
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

		override private function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<UniformBindingHelp>
		{
			var list:Vector<UniformBindingHelp> = new Vector<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_invertViewMat", UniformBinding.ViewMatrixInverse));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_viewProjectionMat", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

