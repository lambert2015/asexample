package examples.light;

import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.Lib;
import flash.Vector;
import org.angle3d.app.SimpleApplication;
import org.angle3d.light.SpotLight;
import org.angle3d.material.MaterialFill;
import org.angle3d.material.Material;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.shader.basic.PhongSpotLighting;
import org.angle3d.shader.ShaderType;
import examples.Stats;

class TestPhongSpotLight extends SimpleApplication
{
	private var geometry:Geometry;
	private var material:Material;
	
	private var movingNode:Node;

	private var angle:Float;
	
	private var light:SpotLight;
	
	private var lightMdl:Geometry;
	
	private var lightTarget:Vector3f;

	public function new()
	{
		super();
		
		angle = 0;
		
		lightTarget = new Vector3f();
		
	    this.addChild(new Stats());
	}
	
	override private function initialize():Void
	{
		super.initialize();
		
		flyCam.setDragToRotate(true);
		
		var colorMap:BitmapData = new ColorMapTexture(0, 0);
		var colorMapTexture:Texture = stage3D.context3D.createTexture(colorMap.width, colorMap.height, Context3DTextureFormat.BGRA, false);
		colorMapTexture.uploadFromBitmapData(colorMap);
		
		var grid:BitmapData = new GridTexture(0, 0);
		var gridTexture:Texture = stage3D.context3D.createTexture(grid.width, grid.height, Context3DTextureFormat.BGRA, false);
		gridTexture.uploadFromBitmapData(grid);

		var material:Material = new Material();
		material.setShader(new PhongSpotLighting());
		material.setTexture("s_texture", colorMapTexture);
		material.setParam(ShaderType.VERTEX, "u_Diffuse", Vector.ofArray([1.0, 1.0, 1.0, 1.0]));
		material.setParam(ShaderType.VERTEX, "u_Specular", Vector.ofArray([1.0, 1.0, 1.0, 32.0]));

		var gt:Geometry = new Geometry("Torus", new Torus(35, 10, 0.5, 3));
		gt.setMaterial(material);
		rootNode.attachChild(gt);
		
		gt = new Geometry("sphere1", new Sphere(25, 25, 2.5));
		gt.setMaterial(material);
		gt.rotateYRP(3.14 / 2, 0, 0);
		rootNode.attachChild(gt);

		light = new SpotLight();
		light.setSpotRange(1000);
		light.setSpotInnerAngle(5 * FastMath.DEGTORAD);
        light.setSpotOuterAngle(10 * FastMath.DEGTORAD);
	    light.setPosition(new Vector3f(77.70334, 0, 27.1017));
		light.setDirection(lightTarget.subtract(light.getPosition()));    
        light.setColor(Color.Green);
        rootNode.addLight(light);
		
		var colorMat:MaterialFill = new MaterialFill();
		colorMat.setColor(0x0000ff);
		
		lightMdl = new Geometry("Light", new Sphere(10, 10, 0.5));
		lightMdl.setMaterial(colorMat);
		lightMdl.setLocalTranslation(new Vector3f(77.70334, 0, 27.1017));
		rootNode.attachChild(lightMdl);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
		if (angle > FastMath.TWO_PI)
		{
			light.setColor(new Color(Math.random(), Math.random(), Math.random()));
		}
        angle %= FastMath.TWO_PI;
		
		light.setPosition(new Vector3f(Math.cos(angle) * 12, 0, Math.sin(angle) * 12));
		light.setDirection(lightTarget.subtract(light.getPosition()));  
		
		lightMdl.setLocalTranslation(light.getPosition());
	}
	
	static function main() 
	{
		Lib.current.addChild(new TestPhongSpotLight());
	}
}

@:bitmap("../bin/assets/crate256.jpg") 
class ColorMapTexture extends BitmapData 
{
}

@:bitmap("../bin/assets/no-shader.png") 
class GridTexture extends BitmapData 
{
}