package org.angle3d.shadow
{
	import flash.display3D.textures.Texture;

	import org.angle3d.material.Material;
	import org.angle3d.material.post.SceneProcessor;
	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.renderer.queue.GeometryList;
	import org.angle3d.renderer.queue.OpaqueComparator;
	import org.angle3d.renderer.queue.RenderQueue;
	import org.angle3d.renderer.queue.ShadowMode;
	import org.angle3d.scene.CullHint;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.debug.WireFrustum;
	import org.angle3d.scene.ui.Picture;
	import org.angle3d.texture.FrameBuffer;
	import org.angle3d.texture.MagFilter;
	import org.angle3d.texture.MinFilter;
	import org.angle3d.texture.Texture2D;

	/**
	 * abstract shadow renderer that holds commons feature to have for a shadow
	 * renderer
	 *
	 * @author Rémy Bouquet aka Nehon
	 */
	public class AbstractShadowRenderer implements SceneProcessor
	{
		protected var nbShadowMaps:int = 1;
		protected var shadowMapSize:Number;
		protected var shadowIntensity:Number = 0.7;
		protected var renderManager:RenderManager;
		protected var viewPort:ViewPort;
		protected var shadowFB:Vector.<FrameBuffer>;
		protected var shadowMaps:Vector.<Texture2D>;
		protected var dummyTex:Texture2D;
		protected var preshadowMat:Material;
		protected var postshadowMat:Material;
		protected var lightViewProjectionsMatrices:Vector.<Matrix4f>;
		protected var debug:Boolean = false;
		protected var edgesThickness:Number = 1.0;
		protected var edgeFilteringMode:int = EdgeFilteringMode.Bilinear;
		protected var dispPic:Vector.<Picture>;
		protected var flushQueues:Boolean = true;
		// define if the fallback material should be used.
		protected var needsfallBackMaterial:Boolean = false;
		//Name of the post material technique
		protected var postTechniqueName:String = "PostShadow";
		//flags to know when to change params in the materials
		//a list of material of the post shadow queue geometries.
		protected var matCache:Vector.<Material> = new Vector.<Material>();
		protected var sceneReceivers:GeometryList;
		protected var lightReceivers:GeometryList = new GeometryList(new OpaqueComparator());
		protected var shadowMapOccluders:GeometryList = new GeometryList(new OpaqueComparator());


		/**
		 * Create an abstract shadow renderer, this is to be called in extending
		 * classes
		 *
		 * @param assetManager the application asset manager
		 * @param shadowMapSize the size of the rendered shadowmaps (512,1024,2048,
		 * etc...)
		 * @param nbShadowMaps the number of shadow maps rendered (the more shadow
		 * maps the more quality, the less fps).
		 */
		public function AbstractShadowRenderer(shadowMapSize:int, nbShadowMaps:int)
		{
			this.shadowMapSize = shadowMapSize;
			this.nbShadowMaps = nbShadowMaps;

			init(nbShadowMaps, shadowMapSize);
		}

		private function init(shadowMapSize:int, nbShadowMaps:int):void
		{
			this.postshadowMat = new Material(); //assetManager, "Common/MatDefs/Shadow/PostShadow.j3md");
			shadowFB = new FrameBuffer[nbShadowMaps];
			shadowMaps = new Texture2D[nbShadowMaps];
			dispPic = new Picture[nbShadowMaps];
			lightViewProjectionsMatrices = new Matrix4f[nbShadowMaps];

			//DO NOT COMMENT THIS (it prevent the OSX incomplete read buffer crash)
			//dummyTex = new Texture2D(shadowMapSize, shadowMapSize); //, Format.RGBA8);

			preshadowMat = new Material(); //assetManager, "Common/MatDefs/Shadow/PreShadow.j3md");
			postshadowMat.setFloat("ShadowMapSize", shadowMapSize);

			for (var i:int = 0; i < nbShadowMaps; i++)
			{
				lightViewProjectionsMatrices[i] = new Matrix4f();
//				shadowFB[i] = new FrameBuffer(shadowMapSize, shadowMapSize, 1);
//				shadowMaps[i] = new Texture2D(shadowMapSize, shadowMapSize); //, Format.Depth);

				shadowFB[i].setDepthTexture(shadowMaps[i]);

				//DO NOT COMMENT THIS (it prevent the OSX incomplete read buffer crash)
				shadowFB[i].setColorTexture(dummyTex);

				postshadowMat.setTexture("ShadowMap" + i, shadowMaps[i]);

				//quads for debuging purpose
				dispPic[i] = new Picture("Picture" + i);
				dispPic[i].setTexture(shadowMaps[i], false);
			}

			setEdgeFilteringMode(edgeFilteringMode);
			setShadowIntensity(shadowIntensity);
		}

		/**
		 * set the post shadow material for this renderer
		 *
		 * @param postShadowMat
		 */
		protected function setPostShadowMaterial(postShadowMat:Material):void
		{
			this.postshadowMat = postShadowMat;
			postshadowMat.setFloat("ShadowMapSize", shadowMapSize);
			for (var i:int = 0; i < nbShadowMaps; i++)
			{
				postshadowMat.setTexture("ShadowMap" + i, shadowMaps[i]);
			}
			setEdgeFilteringMode(edgeFilteringMode);
			setShadowIntensity(shadowIntensity);
		}

		/**
		 * Sets the filtering mode for shadow edges see {@link EdgeFilteringMode}
		 * for more info
		 *
		 * @param EdgeFilteringMode
		 */
		final public function setEdgeFilteringMode(filterMode:int):void
		{
			if (this.edgeFilteringMode == filterMode)
			{
				return;
			}

			this.edgeFilteringMode = filterMode;
			postshadowMat.setInt("FilterMode", filterMode);
			postshadowMat.setFloat("PCFEdge", edgesThickness);

			for (var shadowMap:Texture2D in shadowMaps)
			{
				if (filterMode == EdgeFilteringMode.Bilinear)
				{
					shadowMap.setTextureFilter(MagFilter.Bilinear);
					shadowMap.setMipFilter(MinFilter.NoMip);
				}
				else
				{
					shadowMap.setTextureFilter(MagFilter.Nearest);
					shadowMap.setMipFilter(MinFilter.NoMip);
				}
			}
		}

		/**
		 * returns the the edge filtering mode
		 *
		 * @see EdgeFilteringMode
		 * @return
		 */
		public function getEdgeFilteringMode():int
		{
			return edgeFilteringMode;
		}

		//debug function that create a displayable frustrum
		protected function createFrustum(pts:Vector.<Vector3f>, i:int):Geometry
		{
			var frustum:WireFrustum = new WireFrustum(pts);
			var frustumMdl:Geometry = new Geometry("f", frustum);
			frustumMdl.localCullHint = CullHint.Never;
			frustumMdl.localShadowMode = ShadowMode.Off;

//			var mat:Material = new Material(); //assetManager, "Common/MatDefs/Misc/Unshaded.j3md");
//			mat.getAdditionalRenderState().setWireframe(true);
//			frustumMdl.setMaterial(mat);
			switch (i)
			{
				case 0:
					frustumMdl.getMaterial().setParticleColor("Color", Color.Pink);
					break;
				case 1:
					frustumMdl.getMaterial().setParticleColor("Color", Color.Red);
					break;
				case 2:
					frustumMdl.getMaterial().setParticleColor("Color", Color.Green);
					break;
				case 3:
					frustumMdl.getMaterial().setParticleColor("Color", Color.Blue);
					break;
				default:
					frustumMdl.getMaterial().setParticleColor("Color", Color.White);
					break;
			}

			frustumMdl.updateGeometricState();
			return frustumMdl;
		}

		/**
		 * returns the shdaow intensity
		 *
		 * @see #setShadowIntensity(float shadowIntensity)
		 * @return shadowIntensity
		 */
		public function getShadowIntensity():Number
		{
			return shadowIntensity;
		}

		/**
		 * Set the shadowIntensity, the value should be between 0 and 1, a 0 value
		 * gives a bright and invisilble shadow, a 1 value gives a pitch black
		 * shadow, default is 0.7
		 *
		 * @param shadowIntensity the darkness of the shadow
		 */
		final public function setShadowIntensity(shadowIntensity:Number):void
		{
			this.shadowIntensity = shadowIntensity;
			postshadowMat.setFloat("ShadowIntensity", shadowIntensity);
		}

		/**
		 * returns the edges thickness
		 *
		 * @see #setEdgesThickness(int edgesThickness)
		 * @return edgesThickness
		 */
		public function getEdgesThickness():int
		{
			return int(edgesThickness * 10);
		}

		/**
		 * Sets the shadow edges thickness. default is 1, setting it to lower values
		 * can help to reduce the jagged effect of the shadow edges
		 *
		 * @param edgesThickness
		 */
		public function setEdgesThickness(edgesThickness:int):void
		{
			this.edgesThickness = Math.max(1, Math.min(edgesThickness, 10));
			this.edgesThickness *= 0.1;
			postshadowMat.setFloat("PCFEdge", edgesThickness);
		}

		/**
		 * returns true if the PssmRenderer flushed the shadow queues
		 *
		 * @return flushQueues
		 */
		public function isFlushQueues():Boolean
		{
			return flushQueues;
		}

		/**
		 * Set this to false if you want to use several PssmRederers to have
		 * multiple shadows cast by multiple light sources. Make sure the last
		 * PssmRenderer in the stack DO flush the queues, but not the others
		 *
		 * @param flushQueues
		 */
		public function setFlushQueues(flushQueues:Boolean):void
		{
			this.flushQueues = flushQueues;
		}

		public function initialize(rm:RenderManager, vp:ViewPort):void
		{
		}

		public function get initialized():Boolean
		{
			return false;
		}

		public function reshape(vp:ViewPort, w:int, h:int):void
		{
		}

		public function preFrame(tpf:Number):void
		{
		}

		public function postQueue(rq:RenderQueue):void
		{
		}

		public function postFrame(out:FrameBuffer):void
		{
		}

		public function cleanup():void
		{
		}
	}
}
