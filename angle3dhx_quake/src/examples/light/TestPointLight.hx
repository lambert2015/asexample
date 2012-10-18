package examples.light;

import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.Lib;
import flash.Vector;
import org.angle3d.app.SimpleApplication;
import org.angle3d.light.AmbientLight;
import org.angle3d.light.PointLight;
import org.angle3d.material.ColorMaterial;
import org.angle3d.material.LightMode;
import org.angle3d.material.Material;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.LightNode;
import org.angle3d.scene.Node;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.scene.shape.Torus;
import org.angle3d.shader.basic.GouraudPointLighting;
import org.angle3d.shader.basic.SimpleTextureShader;
import org.angle3d.shader.ShaderType;
import org.angle3d.utils.Stats;



class TestPointLight extends SimpleApplication
{
	private var geometry:Geometry;
	private var material:Material;
	
	private var movingNode:Node;

	private var angle:Float;
	
	private var light:PointLight;

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
		
		var colorMap:BitmapData = new ColorMapTexture(0, 0);
		var colorMapTexture:Texture = stage3D.context3D.createTexture(colorMap.width, colorMap.height, Context3DTextureFormat.BGRA, false);
		colorMapTexture.uploadFromBitmapData(colorMap);
		
		var grid:BitmapData = new GridTexture(0, 0);
		var gridTexture:Texture = stage3D.context3D.createTexture(grid.width, grid.height, Context3DTextureFormat.BGRA, false);
		gridTexture.uploadFromBitmapData(grid);

		var material:Material = new Material();
		material.setShader(new GouraudPointLighting());
		material.setTexture("s_texture", colorMapTexture);
		material.setParam(ShaderType.VERTEX, "u_Diffuse", Vector.ofArray([1.0, 1.0, 1.0, 1.0]));
		material.setParam(ShaderType.VERTEX, "u_Specular", Vector.ofArray([1.0, 1.0, 1.0, 32.0]));


		var torus:Torus = new Torus(35, 10, 0.5, 3);
		var gt:Geometry = new Geometry("Torus", torus);
		gt.setMaterial(material);
		rootNode.attachChild(gt);
		
		var sphere:Sphere = new Sphere(25, 25, 2.5);
		gt = new Geometry("sphere1", sphere);
		gt.setMaterial(material);
		gt.rotateYRP(3.14 / 2, 0, 0);
		rootNode.attachChild(gt);
		
		var colorMat:ColorMaterial = new ColorMaterial();
		colorMat.setColor(0x0000ff);
		
		var sphere:Sphere = new Sphere(8, 8, 0.2);
		gt = new Geometry("sphere", sphere);
		gt.setMaterial(colorMat);
		movingNode = new Node("lightParentNode");
		movingNode.attachChild(gt);

		light = new PointLight();
        light.setColor(Color.Green);
        light.setRadius(6);
        rootNode.addLight(light);
		
		var al:AmbientLight = new AmbientLight();
		al.setColor(new Color(0.3, 0.3, 0.3, 1));
		//rootNode.addLight(al);
		
		var lightNode:LightNode = new LightNode("pointLight", light);
        movingNode.attachChild(lightNode);

		var material3:Material = new Material();
		material3.setShader(new SimpleTextureShader());
		material3.setLightMode(LightMode.Disable);
		material3.setTexture("s_texture", gridTexture);

		rootNode.attachChild(movingNode);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
		angle += 0.03;
		if (angle > FastMath.TWO_PI)
		{
			light.setColor(new Color(Math.random(), Math.random(), Math.random()));
		}
        angle %= FastMath.TWO_PI;

        movingNode.setLocalTranslation(new Vector3f(Math.cos(angle) * 5, 0, Math.sin(angle) * 5));
	}
	
	static function main() 
	{
		Lib.current.addChild(new TestPointLight());
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