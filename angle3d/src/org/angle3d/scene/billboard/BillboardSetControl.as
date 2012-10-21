package org.angle3d.scene.billboard
{
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.Spatial;
	import org.angle3d.scene.control.AbstractControl;
	import org.angle3d.scene.control.Control;

	/**
	 * ...
	 * @author andy
	 */

	public class BillboardSetControl extends AbstractControl
	{
		private var _billboardSet:BillboardSet;

		public function BillboardSetControl()
		{
			super();
		}

		override public function set spatial(value:Spatial):void
		{
			super.spatial = value;

			_billboardSet = value as BillboardSet;
		}

		override public function cloneForSpatial(spatial:Spatial):Control
		{
			var control:BillboardSetControl = new BillboardSetControl();
			control.spatial = spatial;
			return control;
		}

		override protected function controlRender(rm:RenderManager, vp:ViewPort):void
		{
			var cam:Camera3D = vp.camera;

			//update geometry if need to.
			if (_billboardSet.getAutoUpdate() || _billboardSet.mBillboardDataChanged)
			{
				_billboardSet.mCamQ.copyFrom(cam.rotation);
				_billboardSet.mCamPos.copyFrom(cam.location);

				if (!_billboardSet.inWorldSpace)
				{
					var inverseRotation:Quaternion = _billboardSet.parent.getWorldRotation().inverse();

					inverseRotation.multiply(_billboardSet.mCamQ, _billboardSet.mCamQ);

					var pos:Vector3f = _billboardSet.mCamPos.subtract(_billboardSet.parent.getWorldTranslation());

					inverseRotation.multiplyVector(pos, _billboardSet.mCamPos);

					_billboardSet.mCamPos.divideLocal(_billboardSet.parent.getWorldScale());
				}

				// Camera direction points down -Z
				_billboardSet.mCamQ.multiplyVector(new Vector3f(0, 0, -1), _billboardSet.mCamDir);

				//修改布告板大小，颜色等变化
				var activeBillboards:Vector.<Billboard> = _billboardSet.getActiveBillboards();
				var activeCount:int = activeBillboards.length;
				_billboardSet.beginBillboards(activeCount);
				for (var i:int = 0; i < activeCount; i++)
				{
					_billboardSet.injectBillboard(i, activeBillboards[i]);
				}
				_billboardSet.endBillboards();
			}
		}
	}
}

