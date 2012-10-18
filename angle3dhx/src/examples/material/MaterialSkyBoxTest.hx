package examples.material;

import examples.DefaultSkyBox;
import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.CubeTexture;
import flash.display3D.textures.Texture;
import flash.Lib;
import org.angle3d.app.SimpleApplication;
import org.angle3d.material.MaterialTexture;
import org.angle3d.material.MaterialVertexColor;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Box;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.scene.SkyBox;
import org.angle3d.texture.CubeTextureMap;
import org.angle3d.texture.MipmapGenerator;
import examples.Stats;


class MaterialSkyBoxTest extends SimpleApplication
{
	public function new()
	{
		super();
		
	    this.addChild(new Stats());
	}
	
	override private function initialize():Void
	{
		super.initialize();
		
		flyCam.setDragToRotate(true);

		rootNode.attachChild(new DefaultSkyBox());
		
		//cam.setLocation(new Vector3f(60, 40, 400));
		cam.lookAt(new Vector3f(0, 0, 0), Vector3f.Y_AXIS);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
	}
	
	static function main() 
	{
		Lib.current.addChild(new MaterialSkyBoxTest());
	}
}