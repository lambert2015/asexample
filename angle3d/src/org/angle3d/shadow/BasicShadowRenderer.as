package org.angle3d.shadow
{
	import org.angle3d.material.Material;
	import org.angle3d.material.MaterialPostShadow;
	import org.angle3d.material.MaterialPreShadow;
	import org.angle3d.material.post.SceneProcessor;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.IRenderer;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.renderer.queue.GeometryList;
	import org.angle3d.renderer.queue.RenderQueue;
	import org.angle3d.renderer.queue.ShadowMode;
	import org.angle3d.scene.ui.Image;
	import org.angle3d.texture.FrameBuffer;
	import org.angle3d.texture.Texture2D;
	import org.angle3d.texture.TextureMap;

	/**
	 * BasicShadowRenderer uses standard shadow mapping with one map
	 * it's useful to render shadows in a small scene, but edges might look a bit jagged.
	 *
	 */
	public class BasicShadowRenderer implements SceneProcessor
	{
		private var renderManager:RenderManager;
		private var viewPort:ViewPort;
		private var shadowCam:Camera3D;

		private var shadowFB:FrameBuffer;
		private var shadowMap:TextureMap;

		private var noOccluders:Boolean;
		private var points:Vector.<Vector3f>;
		private var mDirection:Vector3f;

		private var preshadowMat:MaterialPreShadow;
		private var postshadowMat:MaterialPostShadow;

		private var picture:Image;

		public function BasicShadowRenderer(size:int)
		{
			shadowMap = new Texture2D(size, size);
			shadowFB = new FrameBuffer(shadowMap, true);

			shadowCam = new Camera3D(size, size);

			preshadowMat = new MaterialPreShadow();
			postshadowMat = new MaterialPostShadow();
			postshadowMat.setTexture(shadowMap);

			picture = new Image("ShadowMap", false);
			picture.setTexture(shadowMap, false);

			noOccluders = false;
			points = new Vector.<Vector3f>(8, true);
			for (var i:int = 0; i < 8; i++)
			{
				points[i] = new Vector3f();
			}
			mDirection = new Vector3f();
		}

		public function getDirection():Vector3f
		{
			return mDirection;
		}

		/**
		 * sets the light direction to use to computs shadows
		 * @param direction
		 */
		public function setDirection(direction:Vector3f):void
		{
			this.mDirection.copyFrom(direction);
			this.mDirection.normalizeLocal();
		}

		public function initialize(rm:RenderManager, vp:ViewPort):void
		{
			renderManager = rm;
			viewPort = vp;

			reshape(vp, vp.camera.width, vp.camera.height);
		}

		public function get initialized():Boolean
		{
			return viewPort != null;
		}

		public function reshape(vp:ViewPort, w:int, h:int):void
		{
			picture.setPosition(w / 20, h / 20);
			picture.setSize(w / 5, h / 5);
		}

		/**
		 * debug only
		 * returns the shadow camera
		 * @return
		 */
		public function getShadowCamera():Camera3D
		{
			return shadowCam;
		}

		/**
		 * debug only
		 * @return
		 */
		public function getPicture():Image
		{
			return picture;
		}

		public function preFrame(tpf:Number):void
		{
		}

		public function postQueue(rq:RenderQueue):void
		{
			var occluders:GeometryList = rq.getShadowQueueContent(ShadowMode.Cast);

			noOccluders = (occluders.size == 0);
			if (noOccluders)
			{
				return;
			}

			var receivers:GeometryList = rq.getShadowQueueContent(ShadowMode.Receive);

			//update frustum points based on current camera
			var viewCam:Camera3D = viewPort.camera;
			ShadowUtil.updateFrustumPoints(viewCam, viewCam.frustumNear, viewCam.frustumFar, 1.0, points);

			var frustaCenter:Vector3f = new Vector3f();
			for (var i:int = 0; i < 8; i++)
			{
				frustaCenter.addLocal(points[i]);
			}
			frustaCenter.scaleLocal(1.0 / 8);

			// update light direction
			shadowCam.setProjectionMatrix(null);
			shadowCam.parallelProjection = true;


			shadowCam.lookAtDirection(mDirection, Vector3f.Y_AXIS);
			shadowCam.update();
			shadowCam.location = frustaCenter;
			shadowCam.update();
			shadowCam.updateViewProjection();

			// render shadow casters to shadow map
			ShadowUtil.updateShadowCamera(occluders, receivers, shadowCam, points);

			var r:IRenderer = renderManager.getRenderer();
			renderManager.setCamera(shadowCam, false);
			renderManager.setForcedMaterial(preshadowMat);

			r.setFrameBuffer(shadowFB);
			r.clearBuffers(false, true, false);
			viewPort.renderQueue.renderShadowQueueByShadowMode(ShadowMode.Cast, renderManager, shadowCam, true);
			r.setFrameBuffer(viewPort.frameBuffer);

			renderManager.clearForcedMaterial();
			renderManager.setCamera(viewCam, false);
		}

		public function postFrame(out:FrameBuffer):void
		{
			if (!noOccluders)
			{
				postshadowMat.setLightViewProjection(shadowCam.getViewProjectionMatrix());
				renderManager.setForcedMaterial(postshadowMat);
				viewPort.renderQueue.renderShadowQueueByShadowMode(ShadowMode.Receive, renderManager, viewPort.camera, true);
				renderManager.clearForcedMaterial();
			}
		}

		public function cleanup():void
		{
		}
	}
}
