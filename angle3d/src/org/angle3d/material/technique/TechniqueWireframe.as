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
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * ...
	 * @author andy
	 */
	//TODO 算法可能有些问题，线条过于不平滑了。Away3D中好像没这种现象
	public class TechniqueWireframe extends Technique
	{
		[Embed(source = "data/wireframe.vs", mimeType = "application/octet-stream")]
		private static var WireframeVS:Class;
		[Embed(source = "data/wireframe.fs", mimeType = "application/octet-stream")]
		private static var WireframeFS:Class;

		private var _color:Color;
		private var _thickness:Number;

		public function TechniqueWireframe(color:uint = 0xFFFFFFFF, thickness:Number = 1)
		{
			super();

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = true;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = false;

			_color = new Color();

			this.color = color;
			this.thickness = thickness;
		}

		public function set color(color:uint):void
		{
			_color.setRGB(color);
		}

		public function get color():uint
		{
			return _color.getColor();
		}

		public function set alpha(alpha:Number):void
		{
			_color.a = FastMath.fclamp(alpha, 0.0, 1.0);
		}

		public function get alpha():Number
		{
			return _color.a;
		}

		public function set thickness(thickness:Number):void
		{
			_thickness = thickness * 0.001;
		}

		public function get thickness():Number
		{
			return _thickness;
		}

		override public function updateShader(shader:Shader):void
		{
			shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);
			shader.getUniform(ShaderType.VERTEX, "u_thickness").setFloat(_thickness);
		}

		override protected function getVertexSource():String
		{
			var ba:ByteArray = new WireframeVS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getFragmentSource():String
		{
			var ba:ByteArray = new WireframeFS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.POSITION1] = "a_position1";
			return map;
		}

		override protected function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldViewMatrix", UniformBinding.WorldViewMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_projectionMatrix", UniformBinding.ProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

