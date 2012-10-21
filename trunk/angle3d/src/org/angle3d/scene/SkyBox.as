package org.angle3d.scene
{
	import org.angle3d.bounding.BoundingSphere;
	import org.angle3d.material.MaterialSkyBox;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.scene.shape.Sphere;
	import org.angle3d.texture.CubeTextureMap;

	/**
	 * ...
	 * @author andy
	 */

	public class SkyBox extends Geometry
	{
		public function SkyBox(cubeTexture:CubeTextureMap, size:Number = 100.0)
		{
			super("SkyBox");

			setMaterial(new MaterialSkyBox(cubeTexture));
			//TODO 添加参数用来选择使用Sphere还是Box
			var sphereMesh:Sphere = new Sphere(size / 2, 10, 10);
			//setMesh(new SkyBoxShape(size));
			setMesh(sphereMesh);
			localQueueBucket = QueueBucket.Sky;
			localCullHint = CullHint.Never;
			setBound(new BoundingSphere(Number.POSITIVE_INFINITY));
		}
	}
}

