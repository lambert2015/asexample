package org.angle3d.scene
{

	import org.angle3d.material.Material;
	import org.angle3d.material.MaterialWireframe;
	import org.angle3d.scene.shape.WireframeShape;
	import org.angle3d.utils.Assert;

	public class WireframeGeometry extends Geometry
	{

		public function WireframeGeometry(name:String, mesh:WireframeShape)
		{
			super(name, mesh);

			this.mMaterial = new MaterialWireframe();
		}

		override public function setMaterial(material:Material):void
		{
			CF::DEBUG
			{
				Assert.assert(material is MaterialWireframe, "material should be WireframeMaterial");
			}

			super.setMaterial(material);
		}

		public function get materialWireframe():MaterialWireframe
		{
			return this.mMaterial as MaterialWireframe;
		}
	}
}

