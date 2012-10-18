package examples.material;

import flash.Lib;
import org.angle3d.app.SimpleApplication;
import org.angle3d.material.MaterialFill;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.WireframeCube;
import org.angle3d.scene.shape.WireframeGrid;
import org.angle3d.scene.WireframeGeometry;
import examples.Stats;


class MaterialWireframeTest extends SimpleApplication
{
	static function main() 
	{
		Lib.current.addChild(new MaterialWireframeTest());
	}
	
	private var geometry:Geometry;

	private var angle:Float;
	

	private var movingNode:Node;

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
		
		var cube:WireframeCube = new WireframeCube(100, 100, 100);
		var wireGm:WireframeGeometry = new WireframeGeometry("WireGeometry", cube);
		wireGm.getWireMaterial().setColor(0x007700);
		rootNode.attachChild(wireGm);
		
		wireGm.setLocalTranslationTo(0, 0, 0);

		var grid:WireframeGrid = new WireframeGrid(10, 110, 1);
		wireGm = new WireframeGeometry("WireframeGrid", grid);
		wireGm.getWireMaterial().setColor(0x000088);
		wireGm.rotateYRP(15/180*Math.PI, 50/180*Math.PI, 30/180*Math.PI);
		rootNode.attachChild(wireGm);

		
		var colorMat:MaterialFill = new MaterialFill(0xFF0000);

		var sphere:Sphere = new Sphere(15, 15, 30);
		var gm:Geometry = new Geometry("sphere", sphere);
		gm.setMaterial(colorMat);
		movingNode = new Node("lightParentNode");
		movingNode.attachChild(gm);
		
		rootNode.attachChild(movingNode);
		
		cam.setLocation(new Vector3f(0, 0, 400));
		//cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		
		//var cc:ChaseCamera = new ChaseCamera(this.cam, movingNode, inputManager);
		//cc.setEnabled(true);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
        angle %= FastMath.TWO_PI;
		
		movingNode.setLocalTranslation(new Vector3f(Math.cos(angle) * 100, 0, Math.sin(angle) * 100));
	}
}