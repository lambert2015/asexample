package examples.material;

import flash.Lib;
import org.angle3d.app.SimpleApplication;
import org.angle3d.material.MaterialFill;
import org.angle3d.material.MaterialWireframe;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.WireframeGrid;
import org.angle3d.scene.WireframeGeometry;
import examples.Stats;


class MaterialFillTest extends SimpleApplication
{
	static function main() 
	{
		Lib.current.addChild(new MaterialFillTest());
	}
	
	private var geometry:Geometry;

	private var angle:Float;
	
	private var movingNode:Node;
	
	private var colorMat:MaterialFill;

	public function new()
	{
		super();
		
		angle = 0;

	    this.addChild(new Stats());
	}
	
	override private function initialize():Void
	{
		super.initialize();
		
		flyCam.setDragToRotate(true);
		
		var grid:WireframeGrid = new WireframeGrid(10, 200);
		var wireGm:WireframeGeometry = new WireframeGeometry("WireGeometry", grid);
		Lib.as(wireGm.getMaterial(), MaterialWireframe).setColor(0xFFFF00);
		rootNode.attachChild(wireGm);
		

		colorMat = new MaterialFill(0xFFFF00);
		
		var sphere:Sphere = new Sphere(15, 15, 30);
		var gm:Geometry = new Geometry("sphere", sphere);
		gm.setMaterial(colorMat);
		movingNode = new Node("lightParentNode");
		movingNode.attachChild(gm);
		
		rootNode.attachChild(movingNode);
		
		cam.setLocation(new Vector3f(60, 40, 400));
		cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
        angle %= FastMath.TWO_PI;
		
		movingNode.setLocalTranslation(new Vector3f(Math.cos(angle) * 100, 0, Math.sin(angle) * 100));
	}
}