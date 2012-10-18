package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
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
		private var _color : Color;
		private var _thickness : Number;

		public function TechniqueWireframe(color : uint = 0xFFFFFFFF, thickness : Number = 1)
		{
			super("WireframeTechnique");

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

		public function set color(color : uint) : void
		{
			_color.setRGB(color);
		}

		public function get color() : uint
		{
			return _color.getColor();
		}

		public function set alpha(alpha : Number) : void
		{
			_color.a = FastMath.fclamp(alpha, 0.0, 1.0);
		}

		public function get alpha() : Number
		{
			return _color.a;
		}

		public function set thickness(thickness : Number) : void
		{
			_thickness = thickness * 0.001;
		}

		public function get thickness() : Number
		{
			return _thickness;
		}

		override public function updateShader(shader : Shader) : void
		{
			shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);
			shader.getUniform(ShaderType.VERTEX, "u_thickness").setFloat(_thickness);
		}

		override protected function getVertexSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
//			return "attribute vec3 a_position\n" + 
//				"attribute vec3 a_position1\n" +
//				//只是用来表示方向:1或者-1
//				"attribute float a_thickness\n" +
//
//				"varying vec4 v_color\n" +
//
//				"uniform mat4 u_worldViewMatrix\n" + 
//				"uniform mat4 u_projectionMatrix\n" + 
//				"uniform vec4 u_color\n" + 
//				"uniform vec4 u_thickness\n" +
//
//				"temp vec4 t_start\n" + 
//				"temp vec4 t_end\n" + 
//				"temp vec3 t_L\n" + 
//				"temp float t_distance\n" + 
//				"temp vec3 t_sideVec\n" +
//
//				"@main\n" +
//
//				"t_start = m44(a_position,u_worldViewMatrix)\n" + 
//				"t_end = m44(a_position1,u_worldViewMatrix)\n" +
//
//				// calculate side vector for line
//				"t_L = sub(t_end.xyz,t_start.xyz)\n" + 
//				"t_sideVec = cross(t_L,t_start.xyz)\n" + 
//				"t_sideVec = normalize(t_sideVec)\n" +
//
//				// calculate the amount required to move at the point's distance to correspond to the line's pixel width
//				// scale the side vector by that amount
//				"t_distance = mul(t_start.z,a_thickness)\n" + 
//				"t_distance = mul(t_distance,u_thickness.x)\n" + 
//				"t_sideVec = mul(t_sideVec,t_distance)\n" +
//
//				// add scaled side vector to Q0 and transform to clip space
//				"t_start.xyz = add(t_start.xyz,t_sideVec)\n" +
//
//				// transform Q0 to clip space
//				"output = m44(t_start,u_projectionMatrix)\n" +
//				"v_color = u_color";
			return <![CDATA[
				attribute vec3 a_position;
			    /*a_position1.w代表当前点方向，1或者-1*/
				attribute vec4 a_position1;

				varying vec4 v_color;
				
				uniform mat4 u_worldViewMatrix;
				uniform mat4 u_projectionMatrix;
				uniform vec4 u_color;
				uniform vec4 u_thickness;

				function main(){
					vec4 t_start = m44(a_position,u_worldViewMatrix);
					vec4 t_end = a_position1;
					t_end.w = 1;
					t_end = m44(t_end,u_worldViewMatrix);
					
					vec3 t_L = sub(t_end.xyz,t_start.xyz);
			        vec3 t_sideVec = cross(t_L,t_start.xyz);
					t_sideVec = normalize(t_sideVec);
					
					float t_distance = mul(t_start.z,a_position1.w);
					t_distance = mul(t_distance,u_thickness.x);
					t_sideVec = mul(t_sideVec,t_distance);
					
					t_start = add(t_start,t_sideVec);
					output = m44(t_start,u_projectionMatrix);
					v_color = u_color;
				}]]>;
		}

		override protected function getFragmentSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
				function main(){
			        output = v_color;
				}]]>;
		}

		override protected function getBindAttributes(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : Dictionary
		{
			var map : Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.POSITION1] = "a_position1";
			return map;
		}

		override protected function getBindUniforms(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : Vector.<UniformBindingHelp>
		{
			var list : Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldViewMatrix", UniformBinding.WorldViewMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_projectionMatrix", UniformBinding.ProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

