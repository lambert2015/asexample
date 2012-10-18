package org.angle3d.material.technique;
import org.angle3d.material.FaceCullMode;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;

/**
 * ...
 * @author andy
 */
//TODO 算法可能有些问题，线条过于不平滑了。Away3D中好像没这种现象
class TechniqueWireframe extends Technique
{
	private var _color:Color;
	private var _thickness:Float;

	public function new(color:UInt = 0xFFFFFFFF, thickness:Float = 1) 
	{
		super("WireframeTechnique");
		
		_renderState.applyCullMode = true;
		_renderState.cullMode = FaceCullMode.Off;
		
		_renderState.applyDepthTest = true;
		_renderState.depthTest = true;
		
		_renderState.applyBlendMode = false;
		
	    _color = new Color();

		setColor(color);
		setThickness(thickness);
	}
	
	public function setColor(color:UInt):Void
	{
		_color.setRGB(color);
	}
	
	public function getColor():UInt
	{
		return _color.getColor();
	}
	
	public function setAlpha(alpha:Float):Void
	{
		_color.a = FastMath.fclamp(alpha, 0.0, 1.0);
	}
	
	public function setThickness(thickness:Float):Void
	{
		_thickness = thickness * 0.001;
	}
	
	override public function updateShader(shader:Shader):Void
	{
		shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);
		shader.getUniform(ShaderType.VERTEX, "u_thickness").setFloat(_thickness);
	}
	
	override private function getVertexSource():String
	{
		return "attribute vec3 a_position\n" +
				"attribute vec3 a_position1\n" +
				//只是用来表示方向:1或者-1
				"attribute float a_thickness\n" +
						  
				"varying vec4 v_color\n" +
						  
				"uniform mat4 u_worldViewMatrix\n" +
				"uniform mat4 u_projectionMatrix\n" +
				"uniform vec4 u_color\n" +
				"uniform vec4 u_thickness\n" +

				"temp vec4 t_start\n" +
				"temp vec4 t_end\n" +
				"temp vec3 t_L\n" +
				"temp float t_distance\n"+
				"temp vec3 t_sideVec\n" +
						  
				"@main\n" +
						  
				"t_start = m44(a_position,u_worldViewMatrix)\n" +
				"t_end = m44(a_position1,u_worldViewMatrix)\n" +
						  
				// calculate side vector for line
				"t_L = sub(t_end.xyz,t_start.xyz)\n" +
				"t_sideVec = cross(t_L,t_start.xyz)\n" +
				"t_sideVec = normalize(t_sideVec)\n" +
						  
				// calculate the amount required to move at the point's distance to correspond to the line's pixel width
				// scale the side vector by that amount
				"t_distance = mul(t_start.z,a_thickness)\n" +
				"t_distance = mul(t_distance,u_thickness.x)\n" +
				"t_sideVec = mul(t_sideVec,t_distance)\n" +
						  
				// add scaled side vector to Q0 and transform to clip space
				"t_start.xyz = add(t_start.xyz,t_sideVec)\n" +
						  
				// transform Q0 to clip space
				"op = m44(t_start,u_projectionMatrix)\n" +
						  
                // interpolate color
				"v_color = u_color";
	}
	
	override private function getFragmentSource():String
	{
		return "@main\n" +
			   "oc = v_color";
	}
	
	override private function _initUniformBindings():Void
	{
		addUniformBinding(ShaderType.VERTEX, "u_worldViewMatrix", UniformBinding.WorldViewMatrix);
		addUniformBinding(ShaderType.VERTEX, "u_projectionMatrix", UniformBinding.ProjectionMatrix);
	}
	
}