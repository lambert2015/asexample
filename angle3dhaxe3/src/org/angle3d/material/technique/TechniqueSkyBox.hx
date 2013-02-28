package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;
	import org.angle3d.texture.CubeTextureMap;

	/**
	 * 天空体
	 * @author andy
	 */

	class TechniqueSkyBox extends Technique
	{
		[Embed(source = "data/skybox.vs", mimeType = "application/octet-stream")]
		private static var SkyBoxVS:Class;
		[Embed(source = "data/skybox.fs", mimeType = "application/octet-stream")]
		private static var SkyBoxFS:Class;

		private var _cubeTexture:CubeTextureMap;

		public function TechniqueSkyBox(cubeTexture:CubeTextureMap)
		{
			super();

			_cubeTexture = cubeTexture;

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.NONE;

			_renderState.compareMode = Context3DCompareMode.ALWAYS;

			_renderState.applyDepthTest = false;
			_renderState.depthTest = false;

			_renderState.applyBlendMode = false;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):Void
		{
			shader.getTextureVar("t_cubeTexture").textureMap = _cubeTexture;
		}

		override private function getVertexSource():String
		{
			var ba:ByteArray = new SkyBoxVS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getFragmentSource():String
		{
			var ba:ByteArray = new SkyBoxFS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			return map;
		}

		override private function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<UniformBindingHelp>
		{
			var list:Vector<UniformBindingHelp> = new Vector<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_ViewMatrix", UniformBinding.ViewMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_ProjectionMatrix", UniformBinding.ProjectionMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldMatrix", UniformBinding.WorldMatrix));
			list.fixed = true;
			return list;
		}
	}
}

