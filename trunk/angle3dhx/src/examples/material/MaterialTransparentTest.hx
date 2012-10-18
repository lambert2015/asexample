package examples.material;

import flash.Lib;
import flash.Vector;
import org.angle3d.app.SimpleApplication;
import org.angle3d.input.ChaseCamera;
import org.angle3d.material.BlendMode;
import org.angle3d.material.MaterialFill;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Vector3f;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.scene.shape.WireframeCube;
import org.angle3d.scene.shape.WireframeGrid;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.scene.WireframeGeometry;
import examples.Stats;


class MaterialTransparentTest extends SimpleApplication
{
	static function main() 
	{
		Lib.current.addChild(new MaterialTransparentTest());
	}
	
	private var angle:Float;
	
	private var movingNode:Geometry;

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
		
		var colorMat:MaterialFill = new MaterialFill(0xFFFF00);

		var sphere:Geometry = new Geometry("solid", new Sphere(15, 15, 30));
		sphere.setMaterial(colorMat);
		sphere.setLocalTranslationTo(0, 0, -30);
		rootNode.attachChild(sphere);
		
		var transparentMat:MaterialFill = new MaterialFill(0x550000);
		transparentMat.alpha = 0.5;
		
		movingNode = new Geometry("sphere", new Sphere(20, 20, 50));
		movingNode.setMaterial(transparentMat);
		
		if (transparentMat.alpha < 1)
            movingNode.setQueueBucket(QueueBucket.Transparent);
        else
            movingNode.setQueueBucket(QueueBucket.Opaque);
		
		rootNode.attachChild(movingNode);
		
		cam.setLocation(new Vector3f(0, 0, 400));
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
        angle %= FastMath.TWO_PI;
		
		movingNode.setLocalTranslation(new Vector3f(Math.cos(angle) * 100, 0, Math.sin(angle) * 100));
	}
}