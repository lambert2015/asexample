package examples.material;

import flash.display.BitmapData;
import flash.Lib;
import org.angle3d.app.SimpleApplication;
import org.angle3d.material.MaterialTexture;
import org.angle3d.material.MaterialVertexColor;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Torus;
import org.angle3d.texture.BitmapTexture;
import examples.Stats;


class MaterialTextureTest extends SimpleApplication
{
	private var geometry:Geometry;

	private var angle:Float;
	
	private var movingNode:Node;
	
	private var textureMat:MaterialTexture;

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
		
		var normalMapTexture:BitmapTexture = new BitmapTexture(new NormalAsset(0, 0));
		
		var lightmapTexture:BitmapTexture = new BitmapTexture(new LightmapAsset(0, 0));
		
		textureMat = new MaterialTexture();
		textureMat.setTexture(normalMapTexture);
		//textureMat.setLightmap(lightmapTexture);
		
		var sphere:Torus = new Torus(15, 15, 20,25);
		var gm:Geometry = new Geometry("sphere", sphere);
		gm.setMaterial(textureMat);
		
		var vertexColor:MaterialVertexColor = new MaterialVertexColor();
		
		var box:Box = new Box(10, 10, 10);
		var boxGeom:Geometry = new Geometry("box", box);
		boxGeom.setMaterial(textureMat);
		boxGeom.setLocalTranslationTo(-10, 0, 0);
		
		
		movingNode = new Node("lightParentNode");
		//movingNode.attachChild(gm);
		movingNode.attachChild(boxGeom);
		
		rootNode.attachChild(movingNode);
		
		cam.setLocation(new Vector3f(60, 40, 400));
		cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
        angle %= FastMath.TWO_PI;
		
		//movingNode.setLocalTranslation(new Vector3f(Math.cos(angle) * 100, 0, Math.sin(angle) * 100));
	}
	
	static function main() 
	{
		Lib.current.addChild(new MaterialTextureTest());
	}
}

@:bitmap("../bin/assets/crate256.jpg") class NormalAsset extends BitmapData {}

@:bitmap("../bin/assets/colorramp.png") class LightmapAsset extends BitmapData {}