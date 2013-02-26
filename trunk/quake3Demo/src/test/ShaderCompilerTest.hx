package test;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.net.FileReference;
import flash.utils.ByteArray;
import org.angle3d.shader.hgal.ShaderCompiler;
import org.angle3d.shader.Shader;
/**
 * ...
 * @author andy
 */
//TODO 写一个简易的界面,上方是hgal写入的地方，点编译会生成ByteArray.下面两个文本框会生成对应的agal
//还有一个对比按钮，比较生成的byteArray是否有不同
class ShaderCompilerTest 
{
	static function main()
	{
		new ShaderCompilerTest();
	}
	
	private var shader:Shader;
	private var vertexData:ByteArray;

	public function new() 
	{
			  
		var vertexSrc:String =
		                  "attribute vec3 a_position\n" +
						  "attribute vec3 a_position1\n" +
						  "attribute float a_thickness\n" +
						  "attribute vec3 a_color\n" +
						  
						  "varying vec4 v_color\n" +
						  
						  "uniform mat4 u_worldViewMatrix\n" +
						  "uniform mat4 u_projectionMatrix\n" +

						  "temp vec4 t_start\n" +
						  "temp vec4 t_end\n" +
						  "temp vec3 t_L\n" +
						  "temp float t_distance\n"+
						  "temp vec3 t_sideVec\n" +
						  
						  "##main\n" +
						  
						  "t_start.xyz = m34(a_position,u_worldViewMatrix)\n" +
						  "t_end.xyz = m34(a_position1,u_worldViewMatrix)\n" +
						  
						  // calculate side vector for line
						  "t_L = sub(t_end.xyz,t_start.xyz)\n" +
						  "t_sideVec = cross(t_L,t_start.xyz)\n" +
						  "t_sideVec = normalize(t_sideVec)\n" +
						  
						  // calculate the amount required to move at the point's distance to correspond to the line's pixel width
						  // scale the side vector by that amount
						  "t_distance = mul(t_start.z,0.001)\n" +
						  "t_distance = mul(t_distance,a_thickness)\n" +
						  "t_sideVec = mul(t_sideVec,t_distance)\n" +
						  
						  // add scaled side vector to Q0 and transform to clip space
						  "t_start.xyz = add(t_start.xyz,t_sideVec)\n" +
						  
						  // transform Q0 to clip space
						  "op = m44(t_start,u_projectionMatrix)\n" +
						  
                           // interpolate color
						  "v_color = a_color";
						  
		var fragmentSrc:String = "##main\n" +
						  "oc = v_color"; 
			  
		shader = new Shader();
			  
		var parser:ShaderCompiler = new ShaderCompiler();
		parser.complie(vertexSrc, fragmentSrc, shader);
		
		vertexData = shader.getVertexData();
			  
		Lib.current.stage.addEventListener(MouseEvent.CLICK, _mouseClick);
	}
	
	private function _mouseClick(e:Event):Void
	{
		new FileReference().save(vertexData, "hgal.byte");
	}
	
}