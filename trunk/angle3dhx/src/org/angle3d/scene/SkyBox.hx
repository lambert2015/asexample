package org.angle3d.scene;
import flash.display3D.textures.CubeTexture;
import flash.display3D.textures.TextureBase;
import org.angle3d.bounding.BoundingSphere;
import org.angle3d.material.MaterialSkyBox;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.scene.shape.SkyBoxShape;
import org.angle3d.scene.shape.Sphere;
import org.angle3d.texture.CubeTextureMap;

/**
 * ...
 * @author andy
 */

class SkyBox extends Geometry
{
	public function new(cubeTexture:CubeTextureMap, size:Float = 100.0) 
	{
		super("SkyBox");
		
		setMaterial(new MaterialSkyBox(cubeTexture));
		//TODO 添加参数用来选择使用Sphere还是Box
		var sphereMesh:Sphere = new Sphere(10, 10, size/2, false, true);
		//setMesh(new SkyBoxShape(size));
		setMesh(sphereMesh);
		setQueueBucket(QueueBucket.Sky);
		setCullHint(CullHint.Never);
		setModelBound(new BoundingSphere(Math.POSITIVE_INFINITY));
	}
}