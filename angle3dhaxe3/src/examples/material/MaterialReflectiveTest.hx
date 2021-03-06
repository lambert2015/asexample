package examples.material;

import examples.skybox.DefaultSkyBox;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import org.angle3d.app.SimpleApplication;
import org.angle3d.material.MaterialReflective;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.WireframeShape;
import org.angle3d.scene.shape.WireframeUtil;
import org.angle3d.scene.WireframeGeometry;
import org.angle3d.texture.Texture2D;
import org.angle3d.utils.Stats;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Cone;
import org.angle3d.scene.shape.Cylinder;
import org.angle3d.scene.shape.Quad;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.scene.shape.TorusKnot;
import org.angle3d.scene.shape.WireframeCube;
import org.angle3d.scene.shape.WireframeCurve;
import org.angle3d.scene.shape.WireframeGrid;
import org.angle3d.light.LightList;

class MaterialReflectiveTest extends SimpleApplication
{
	static function main() 
	{
		flash.Lib.current.addChild(new MaterialReflectiveTest());
	}
	
	private var reflectiveSphere : Geometry;

	public function new()
	{
		super();
	}

	override private function initialize(width : Int, height : Int) : Void
	{
		super.initialize(width, height);

		flyCam.setDragToRotate(false);

		var sky : DefaultSkyBox = new DefaultSkyBox(500);
		scene.attachChild(sky);

		var decalMap : Texture2D = new Texture2D(new DECALMAP_ASSET(0, 0));
		var material : MaterialReflective = new MaterialReflective(decalMap, sky.cubeMap, 0.8);

		var sphere : org.angle3d.scene.shape.Sphere = new org.angle3d.scene.shape.Sphere(50, 30, 30); //Sphere = new Sphere(50, 30, 30);
		reflectiveSphere = new Geometry("sphere", sphere);
		reflectiveSphere.setMaterial(material);
		scene.attachChild(reflectiveSphere);

		var wireShape : WireframeShape = WireframeUtil.generateNormalLineShape(sphere, 10);
		var wireGeom : WireframeGeometry = new WireframeGeometry("wireShape", wireShape);
		scene.attachChild(wireGeom);

		camera.location.setTo(0, 0, -200);
		camera.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
		
		Stats.show(stage);
		
		start();
	}

	private var angle : Float = 0;

	override public function simpleUpdate(tpf : Float) : Void
	{
		super.simpleUpdate(tpf);
		
		angle += 0.02;
		angle %= FastMath.TWO_PI();


		camera.location.setTo(Math.cos(angle) * 200, 0, Math.sin(angle) * 200);
		camera.lookAt(new Vector3f(), Vector3f.Y_AXIS);
	}
}

@:bitmap("embed/water.png") class DECALMAP_ASSET extends flash.display.BitmapData { }