package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.FastMath;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueVertexColor extends Technique
	{
		[Embed(source = "data/vertexcolor.vs", mimeType = "application/octet-stream")]
		private static var VertexColorVS:Class;
		[Embed(source = "data/vertexcolor.fs", mimeType = "application/octet-stream")]
		private static var VertexColorFS:Class;

		private var _alpha:Vector.<Number>;

		public function TechniqueVertexColor()
		{
			super();

			_renderState.applyDepthTest = true;
			_renderState.depthTest = true;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = false;

			_alpha = new Vector.<Number>(4, true);
		}

		public function setAlpha(alpha:Number):void
		{
			_alpha[0] = FastMath.fclamp(alpha, 0.0, 1.0);

			if (_alpha[0] < 1)
			{
				_renderState.depthTest = false;
				_renderState.applyBlendMode = true;
				_renderState.blendMode = BlendMode.Alpha;
			}
			else
			{
				_renderState.depthTest = true;
				_renderState.applyBlendMode = false;
			}
		}

		public function getAlpha():Number
		{
			return _alpha[0];
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getUniform(ShaderType.VERTEX, "u_alpha").setVector(_alpha);
		}

		override protected function getVertexSource():String
		{
			var ba:ByteArray = new VertexColorVS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getFragmentSource():String
		{
			var ba:ByteArray = new VertexColorFS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.COLOR] = "a_color";

			return map;
		}

		override protected function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

