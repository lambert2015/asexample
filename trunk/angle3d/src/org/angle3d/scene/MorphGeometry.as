package org.angle3d.scene
{
	import org.angle3d.scene.control.MorphControl;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MorphMesh;

	public class MorphGeometry extends Geometry
	{
		private var mMorphMesh : MorphMesh;

		private var mControl : MorphControl;

		public function MorphGeometry(name : String, mesh : MorphMesh = null)
		{
			super(name, mesh);

			mControl = new MorphControl();
			addControl(mControl);
		}

		public function setAnimationSpeed(speed : Number) : void
		{
			mControl.setAnimationSpeed(speed);
		}

		public function playAnimation(animationName : String, loop : Boolean = true) : void
		{
			mControl.playAnimation(animationName, loop);
		}

		public function stop() : void
		{
			mControl.stop();
		}

		override public function setMesh(mesh : Mesh) : void
		{
			mMorphMesh = mesh as MorphMesh;
			super.setMesh(mesh);
		}

		public function get morphMesh() : MorphMesh
		{
			return mMorphMesh;
		}
	}
}
