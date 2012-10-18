package examples.transparent;

import flash.Lib;
import flash.Vector;
import org.angle3d.app.SimpleApplication;
import org.angle3d.input.ChaseCamera;
import org.angle3d.material.BlendMode;
import org.angle3d.material.ColorMaterial;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Vector3f;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.scene.debug.WireframeCube;
import org.angle3d.scene.debug.WireframeGrid;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.scene.WireframeGeometry;
import org.angle3d.utils.Stats;


class TransparentTest extends SimpleApplication
{
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
		
		var colorMat:ColorMaterial = new ColorMaterial();
		colorMat.setColor(0xFFFF00FF);
		
		var sphere:Geometry = new Geometry("solid", new Sphere(15, 15, 30));
		sphere.setMaterial(colorMat);
		sphere.setLocalTranslationTo(0, 0, -30);
		rootNode.attachChild(sphere);
		
		var transparentMat:ColorMaterial = new ColorMaterial();
		transparentMat.getAdditionalRenderState().applyBlendMode = true;
		transparentMat.getAdditionalRenderState().blendMode = BlendMode.Alpha;
		//transparentMat.getAdditionalRenderState().applyDepthTest = true;
		transparentMat.setColor(0x550000FF);
		
		movingNode = new Geometry("sphere", new Sphere(20, 20, 50));
		movingNode.setMaterial(transparentMat);
		
		if (transparentMat.isTransparent())
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
	
	static function main() 
	{
		Lib.current.addChild(new TransparentTest());
	}
}