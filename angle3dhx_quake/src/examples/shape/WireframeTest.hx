package examples.shape;

import flash.Lib;
import flash.Vector;
import org.angle3d.app.SimpleApplication;
import org.angle3d.input.ChaseCamera;
import org.angle3d.material.ColorMaterial;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.debug.WireframeCube;
import org.angle3d.scene.debug.WireframeGrid;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.scene.WireframeGeometry;
import org.angle3d.utils.Stats;


class WireframeTest extends SimpleApplication
{
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
		
		var cube:WireframeCube = new WireframeCube(100, 100, 100, 0xffff00, 1);
		var wireGm:WireframeGeometry = new WireframeGeometry("WireGeometry", cube);
		rootNode.attachChild(wireGm);
		
		wireGm.setLocalTranslationTo(0, 0, 0);

		var grid:WireframeGrid = new WireframeGrid(10, 110, 1, 0xFFFFFF);
		wireGm = new WireframeGeometry("WireframeGrid", grid);
		rootNode.attachChild(wireGm);

		
		var colorMat:ColorMaterial = new ColorMaterial();
		colorMat.setColor(0xFF0000);
		
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
	
	static function main() 
	{
		Lib.current.addChild(new WireframeTest());
	}
}