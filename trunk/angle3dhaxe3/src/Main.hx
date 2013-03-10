package ;

//import examples.material.MaterialRefractionTest;
import examples.material.MaterialWireframeTest;
//import examples.material.MaterialReflectiveTest;
import flash.Lib;
import org.angle3d.io.parser.md2.MD2Parser;
import org.angle3d.io.parser.ms3d.MS3DGroup;
import org.angle3d.io.parser.ms3d.MS3DJoint;
import org.angle3d.io.parser.ms3d.MS3DKeyframe;
import org.angle3d.io.parser.ms3d.MS3DMaterial;
import org.angle3d.io.parser.ms3d.MS3DParser;
import org.angle3d.io.parser.ms3d.MS3DTriangle;
import org.angle3d.io.parser.ms3d.MS3DVertex;
import org.angle3d.io.parser.ms3d.MS3DWeight;
/**
 * andy
 * @author 
 */

class Main 
{
	static function main() 
	{
		Lib.current.addChild(new MaterialWireframeTest());
		//Lib.current.addChild(new MaterialReflectiveTest());
		//Lib.current.addChild(new MaterialRefractionTest());
	}
}