package examples;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.net.FileReference;
import org.angle3d.material.hgal.ShaderCompiler;
import org.angle3d.material.shader.Shader;
/**
 * ...
 * @author andy
 */
//TODO 写一个简易的界面,上方是hgal写入的地方，点编译会生成ByteArray.下面两个文本框会生成对应的agal
//还有一个对比按钮，比较生成的byteArray是否有不同
class SaveHgal 
{
	static function main()
	{
		new SaveHgal();
	}
	
	private var shader:Shader;
	
	private var count:Int;

	public function new() 
	{
		count = 0;
			  
		var vertexSrc:String = "attribute vec3 a_position\n" +
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
						  
		var fragmentSrc:String = "@main\n" +
			   "oc = v_color";
			  
		var parser:ShaderCompiler = new ShaderCompiler();
		shader = parser.complie([vertexSrc, fragmentSrc]);

		Lib.current.stage.addEventListener(MouseEvent.CLICK, _mouseClick);
	}
	
	private function _mouseClick(e:Event):Void
	{
        if (count == 0)
		{
			new FileReference().save(shader.vertexData, "vertex.hgal");
		}
		else
		{
			new FileReference().save(shader.fragmentData, "fragment.hgal");
		}
		
		count++;
		if (count > 1)
		{
			count = 0;
		}
		
	}
	
}