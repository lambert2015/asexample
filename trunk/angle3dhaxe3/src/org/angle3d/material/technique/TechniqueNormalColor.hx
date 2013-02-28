package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * ...
	 * @author andy
	 */

	class TechniqueNormalColor extends Technique
	{
		[Embed(source = "data/normalcolor.vs", mimeType = "application/octet-stream")]
		private static var NormalColorVS:Class;
		[Embed(source = "data/normalcolor.fs", mimeType = "application/octet-stream")]
		private static var NormalColorFS:Class;

		private var _influences:Vector<Float>;

		private var _normalScales:Vector<Float>;

		public function TechniqueNormalColor()
		{
			super();

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = true;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = false;

			_normalScales = new Vector<Float>(4, true);
			_normalScales[3] = 1.0;

			normalScale = new Vector3f(1, 1, 1);
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

		public function set normalScale(value:Vector3f):Void
		{
			_normalScales[0] = value.x;
			_normalScales[1] = value.y;
			_normalScales[2] = value.z;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):Void
		{
			shader.getUniform(ShaderType.FRAGMENT, "u_scale").setVector(_normalScales);

			var uniform:Uniform = shader.getUniform(ShaderType.VERTEX, "u_influences");
			if (uniform != null)
			{
				uniform.setVector(_influences);
			}
		}

		override private function getVertexSource():String
		{
			var ba:ByteArray = new NormalColorVS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getFragmentSource():String
		{
			var ba:ByteArray = new NormalColorFS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getOption(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<Vector<String>>
		{
			return super.getOption(lightType, meshType);
		}

		override private function getKey(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var result:Array = [name, meshType];
			return result.join("_");
		}

		override private function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.NORMAL] = "a_normal";

			if (meshType == MeshType.MT_KEYFRAME)
			{
				map[BufferType.POSITION1] = "a_position1";
				map[BufferType.NORMAL1] = "a_normal1";
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

