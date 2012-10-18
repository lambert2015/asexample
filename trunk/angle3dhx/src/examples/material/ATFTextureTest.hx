package examples.material;

import flash.events.Event;
import flash.Lib;
import flash.net.URLRequest;
import org.angle3d.app.SimpleApplication;
import org.angle3d.material.MaterialFill;
import org.angle3d.material.MaterialTexture;
import org.angle3d.material.MaterialWireframe;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.net.ByteArrayLoader;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.scene.shape.WireframeGrid;
import org.angle3d.scene.WireframeGeometry;
import org.angle3d.texture.ATFTexture;
import examples.Stats;


class ATFTextureTest extends SimpleApplication
{
	static function main() 
	{
		Lib.current.addChild(new ATFTextureTest());
	}
	
	private var loader:ByteArrayLoader;
	
	private var angle:Float;
	
	private var gm:Geometry;
	
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
		
		cam.setLocation(new Vector3f(0, 0, -100));
		cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
		
		loader = new ByteArrayLoader();
		loader.addEventListener(Event.COMPLETE, _loadComplete);
		loader.load(new URLRequest("assets/atf/house_diffuse.atf"));
	}
	
	private function _loadComplete(e:Event):Void
	{
		var atfTexture:ATFTexture = new ATFTexture(loader.getData());
		
		var textureMat:MaterialTexture = new MaterialTexture();
		textureMat.setTexture(atfTexture);

		gm = new Geometry("box", new Sphere(10, 10, 50));
		gm.setMaterial(textureMat);
		
		rootNode.attachChild(gm);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
        angle %= FastMath.TWO_PI;
		
		//gm.setLocalRotation
	}
}