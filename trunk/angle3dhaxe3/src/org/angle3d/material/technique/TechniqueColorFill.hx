package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * ...
	 * @author andy
	 */

	class TechniqueColorFill extends Technique
	{
		[Embed(source = "data/colorfill.vs", mimeType = "application/octet-stream")]
		private static var ColorFillVS:Class;
		[Embed(source = "data/colorfill.fs", mimeType = "application/octet-stream")]
		private static var ColorFillFS:Class;

		private var _color:Color;

		private var _influences:Vector<Float>;

		public function TechniqueColorFill(color:uint = 0xFFFFF)
		{
			super();

			_renderState.applyDepthTest = true;
			_renderState.depthTest = true;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = false;

			_color = new Color(0, 0, 0, 1);

			this.color = color;
		}

		public function set influence(value:Float):Void
		{
			if (_influences == null)
				_influences = new Vector<Float>(4, true);
			_influences[0] = 1 - value;
			_influences[1] = value;
		}

		public function get influence():Float
		{
			return _influences[1];
		}

		public function set color(color:uint):Void
		{
			_color.setRGB(color);
		}

		public function set alpha(alpha:Float):Void
		{
			_color.a = FastMath.fclamp(alpha, 0.0, 1.0);

			if (alpha < 1)
			{
				_renderState.applyBlendMode = true;
				_renderState.blendMode = BlendMode.Alpha;
			}
			else
			{
				_renderState.applyBlendMode = false;
				_renderState.blendMode = BlendMode.Off;
			}
		}

		public function get alpha():Float
		{
			return _color.a;
		}

		public function get color():uint
		{
			return _color.getColor();
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):Void
		{
			shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);

			var uniform:Uniform = shader.getUniform(ShaderType.VERTEX, "u_influences");
			if (uniform != null)
			{
				uniform.setVector(_influences);
			}
		}

		override private function getVertexSource():String
		{
			var ba:ByteArray = new ColorFillVS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getFragmentSource():String
		{
			var ba:ByteArray = new ColorFillFS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getOption(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<Vector<String>>
		{
			return super.getOption(lightType, meshType);
		}

		override private function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";

			if (meshType == MeshType.MT_KEYFRAME)
			{
				map[BufferType.POSITION1] = "a_position1";
			}
			return map;
		}

		override private function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<UniformBindingHelp>
		{
			var list:Vector<UniformBindingHelp> = new Vector<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

