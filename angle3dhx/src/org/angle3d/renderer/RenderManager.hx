package org.angle3d.renderer;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Program3D;
import org.angle3d.light.Light;
import org.angle3d.light.LightList;
import org.angle3d.material.technique.Technique;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.Vector;
import org.angle3d.material.Material;
import org.angle3d.material.RenderState;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Matrix4f;
import org.angle3d.post.SceneProcessor;
import org.angle3d.renderer.queue.GeometryList;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.renderer.queue.RenderQueue;
import org.angle3d.renderer.queue.ShadowMode;
import org.angle3d.scene.CullHint;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.Node;
import org.angle3d.scene.Spatial;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.Uniform;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.utils.Assert;

/**
 * <code>RenderManager</code> is a high-level rendering interface that is
 * above the Renderer implementation. RenderManager takes care
 * of rendering the scene graphs attached to each viewport and
 * handling SceneProcessors.
 *
 * @see SceneProcessor
 * @see ViewPort
 * @see Spatial
 */
class RenderManager 
{
	private var _renderer:IRenderer;
	
	private var preViewPorts:Vector<ViewPort>;
	private var viewPorts:Vector<ViewPort>;
	private var postViewPorts:Vector<ViewPort>;
	
	private var camera:Camera3D;
	
	private var viewX:Int;
	private var viewY:Int;
	private var viewWidth:Int;
	private var viewHeight:Int;
	
	private var near:Float;
	private var far:Float;
	
	private var orthoMatrix:Matrix4f;
	private var viewMatrix:Matrix4f;
	private var projMatrix:Matrix4f;
	private var viewProjMatrix:Matrix4f;
	private var worldMatrix:Matrix4f;
	
	private var tmpMatrix:Matrix4f;
	private var tmpMatrix3:Matrix3f;
	
	private var camUp:Vector3f;
	private var camLeft:Vector3f;
	private var camDir:Vector3f;
	private var camLoc:Vector3f;
	
	
	//temp technique
	private var tmpTech:String;
	private var handleTranlucentBucket:Bool;
	
	private var _lastProgram:Program3D;

	/**
     * Create a high-level rendering interface over the
     * low-level rendering interface.
     * @param renderer
     */
	public function new(renderer:IRenderer) 
	{
		_renderer = renderer;
		_init();
	}
	
	private function _init():Void
	{
		preViewPorts = new Vector<ViewPort>();
		viewPorts = new Vector<ViewPort>();
		postViewPorts = new Vector<ViewPort>();
		
		orthoMatrix = new Matrix4f();
		viewMatrix = new Matrix4f();
		projMatrix = new Matrix4f();
		viewProjMatrix = new Matrix4f();
		worldMatrix = new Matrix4f();
		
		tmpMatrix = new Matrix4f();
		tmpMatrix3 = new Matrix3f();
		
		camUp = new Vector3f();
		camLeft = new Vector3f();
		camDir = new Vector3f();
		camLoc = new Vector3f();
		
		handleTranlucentBucket = false;
	}
	
	/**
     * Returns the pre ViewPort with the given name.
     * 
     * @param viewName The name of the pre ViewPort to look up
     * @return The ViewPort, or null if not found.
     * 
     * @see #createPreView(String, com.jme3.renderer.Camera) 
     */
	public function getPreView(viewName:String):ViewPort
	{
		for (i in 0...preViewPorts.length)
		{
			if (preViewPorts[i].getName() == viewName)
			{
				return preViewPorts[i];
			}
		}
		return null;
	}
	
	/**
     * Removes the specified pre ViewPort.
     * 
     * @param view The pre ViewPort to remove
     * @return True if the ViewPort was removed successfully.
     * 
     * @see #createPreView(String, com.jme3.renderer.Camera) 
     */
	public function removePreView(view:ViewPort):Bool
	{
		var index:Int = preViewPorts.indexOf(view);
		if (index > -1)
		{
			preViewPorts.splice(index, 1);
			return true;
		}
		return false;
	}
	
	/**
     * Returns the main ViewPort with the given name.
     * 
     * @param viewName The name of the main ViewPort to look up
     * @return The ViewPort, or null if not found.
     * 
     * @see #createMainView(String, com.jme3.renderer.Camera) 
     */
	public function getMainView(viewName:String):ViewPort
	{
		for (i in 0...viewPorts.length)
		{
			if (viewPorts[i].getName() == viewName)
			{
				return viewPorts[i];
			}
		}
		return null;
	}
	
	/**
     * Removes the main ViewPort with the specified name.
     * 
     * @param view The main ViewPort name to remove
     * @return True if the ViewPort was removed successfully.
     * 
     * @see #createMainView(String, com.jme3.renderer.Camera) 
     */
	public function removeMainViewByName(viewName:String):Bool
	{
		for (i in 0...viewPorts.length)
		{
			if (viewPorts[i].getName() == viewName)
			{
				viewPorts.splice(i, 1);
				return true;
			}
		}
		return false;
	}
	
	/**
     * Removes the specified main ViewPort.
     * 
     * @param view The main ViewPort to remove
     * @return True if the ViewPort was removed successfully.
     * 
     * @see #createMainView(String, com.jme3.renderer.Camera) 
     */
	public function removeMainView(view:ViewPort):Bool
	{
		var index:Int = viewPorts.indexOf(view);
		if (index > -1)
		{
			viewPorts.splice(index, 1);
			return true;
		}
		return false;
	}
	
	/**
     * Returns the post ViewPort with the given name.
     * 
     * @param viewName The name of the post ViewPort to look up
     * @return The ViewPort, or null if not found.
     * 
     * @see #createPostView(String, com.jme3.renderer.Camera) 
     */
	public function getPostView(viewName:String):ViewPort
	{
		for (i in 0...postViewPorts.length)
		{
			if (postViewPorts[i].getName() == viewName)
			{
				return postViewPorts[i];
			}
		}
		return null;
	}
	/**
     * Removes the post ViewPort with the specified name.
     * 
     * @param view The post ViewPort name to remove
     * @return True if the ViewPort was removed successfully.
     * 
     * @see #createPostView(String, com.jme3.renderer.Camera) 
     */
	public function removePostViewByName(viewName:String):Bool
	{
		for (i in 0...postViewPorts.length)
		{
			if (postViewPorts[i].getName() == viewName)
			{
				postViewPorts.splice(i, 1);
				return true;
			}
		}
		return false;
	}
	
	/**
     * Removes the specified pre ViewPort.
     * 
     * @param view The pre ViewPort to remove
     * @return True if the ViewPort was removed successfully.
     * 
     * @see #createPreView(String, com.jme3.renderer.Camera) 
     */
	public function removePostView(view:ViewPort):Bool
	{
		var index:Int = postViewPorts.indexOf(view);
		if (index > -1)
		{
			postViewPorts.splice(index, 1);
			return true;
		}
		return false;
	}
	
	/**
     * Returns a read-only list of all pre ViewPorts
     * @return a read-only list of all pre ViewPorts
     * @see #createPreView(String, com.jme3.renderer.Camera) 
     */
	public function getPreViews():Vector<ViewPort>
	{
		return preViewPorts;
	}
	
	/**
     * Returns a read-only list of all main ViewPorts
     * @return a read-only list of all main ViewPorts
     * @see #createMainView(String, com.jme3.renderer.Camera) 
     */
	public function getMainViews():Vector<ViewPort>
	{
		return viewPorts;
	}
	
	/**
     * Returns a read-only list of all post ViewPorts
     * @return a read-only list of all post ViewPorts
     * @see #createPostView(String, com.jme3.renderer.Camera) 
     */
	public function getPostViews():Vector<ViewPort>
	{
		return postViewPorts;
	}
	
	/**
     * Creates a new pre ViewPort, to display the given camera's content.
     * <p>
     * The view will be processed before the main and post viewports.
     */
    public function createPreView(viewName:String,cam:Camera3D):ViewPort
	{
        var vp:ViewPort = new ViewPort(viewName, cam);
        preViewPorts.push(vp);
        return vp;
    }
	
	/**
     * Creates a new main ViewPort, to display the given camera's content.
     * <p>
     * The view will be processed before the post viewports but after
     * the pre viewports.
     */
    public function createMainView(viewName:String,cam:Camera3D):ViewPort
	{
        var vp:ViewPort = new ViewPort(viewName, cam);
        viewPorts.push(vp);
        return vp;
    }
	
	/**
     * Creates a new post ViewPort, to display the given camera's content.
     * <p>
     * The view will be processed after the pre and main viewports.
     */
    public function createPostView(viewName:String,cam:Camera3D):ViewPort
	{
        var vp:ViewPort = new ViewPort(viewName, cam);
        postViewPorts.push(vp);
        return vp;
    }
	
	private function notifyVPReshape(vp:ViewPort, w:Int, h:Int):Void
	{
		var processors:Vector<SceneProcessor> = vp.getProcessors();
	    for (proc in processors)
		{
			if (!proc.isInitialized())
			{
				proc.initialize(this, vp);
			}
			else
			{
				proc.reshape(vp, w, h);
			}
		}
	}
	
	/**
     * Internal use only.
     * Updates the resolution of all on-screen cameras to match
     * the given width and height.
     */
	public function notifyReshape(w:Int, h:Int):Void
	{
		for (vp in preViewPorts)
		{
			if (vp.frameBuffer == null)
			{
				vp.camera.resize(w, h, true);
			}
			notifyVPReshape(vp, w, h);
		}
		
		for (vp in viewPorts)
		{
			if (vp.frameBuffer == null)
			{
				vp.camera.resize(w, h, true);
			}
			notifyVPReshape(vp, w, h);
		}
		
		for (vp in postViewPorts)
		{
			if (vp.frameBuffer == null)
			{
				vp.camera.resize(w, h, true);
			}
			notifyVPReshape(vp, w, h);
		}
	}
	
	public function updateShaderBinding(shader:Shader):Void
	{
		updateUniformBindings(shader.getBindUniforms());
	}
	
	/**
     * Internal use only.
     * Updates the given list of uniforms with {@link UniformBinding uniform bindings}
     * based on the current world state.
     */
    private function updateUniformBindings(params:Vector<Uniform>):Void
	{
        // assums worldMatrix is properly set.
        for (i in 0...params.length) 
		{
            var u:Uniform = params[i];
            switch (u.getBinding()) 
			{
                case UniformBinding.WorldMatrix:
                    u.setMatrix4(worldMatrix);
					
                case UniformBinding.ViewMatrix:
                    u.setMatrix4(viewMatrix);
					
                case UniformBinding.ProjectionMatrix:
                    u.setMatrix4(projMatrix);
					
                case UniformBinding.ViewProjectionMatrix:
                    u.setMatrix4(viewProjMatrix);
					
                case UniformBinding.WorldViewMatrix:
                    tmpMatrix.copyFrom(viewMatrix);
                    tmpMatrix.multLocal(worldMatrix);
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.NormalMatrix:
                    tmpMatrix.copyFrom(viewMatrix);
                    tmpMatrix.multLocal(worldMatrix);
                    tmpMatrix3 = tmpMatrix.toRotationMatrix();
                    tmpMatrix3.invertLocal();
                    tmpMatrix3.transposeLocal();
                    u.setMatrix3(tmpMatrix3);
					
                case UniformBinding.WorldViewProjectionMatrix:
					tmpMatrix.copyFrom(viewProjMatrix);
                    tmpMatrix.multLocal(worldMatrix);
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.WorldMatrixInverse:
					tmpMatrix.copyFrom(worldMatrix);
                    tmpMatrix.invertLocal();
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.ViewMatrixInverse:
					tmpMatrix.copyFrom(viewMatrix);
                    tmpMatrix.invertLocal();
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.ProjectionMatrixInverse:
					tmpMatrix.copyFrom(projMatrix);
                    tmpMatrix.invertLocal();
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.ViewProjectionMatrixInverse:
					tmpMatrix.copyFrom(viewProjMatrix);
                    tmpMatrix.invertLocal();
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.WorldViewMatrixInverse:
					tmpMatrix.copyFrom(viewMatrix);
                    tmpMatrix.multLocal(worldMatrix);
                    tmpMatrix.invertLocal();
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.NormalMatrixInverse:
					tmpMatrix.copyFrom(viewMatrix);
                    tmpMatrix.multLocal(worldMatrix);
                    tmpMatrix3 = tmpMatrix.toRotationMatrix();
                    tmpMatrix3.invertLocal();
                    tmpMatrix3.transposeLocal();
                    tmpMatrix3.invertLocal();
                    u.setMatrix3(tmpMatrix3);
					
                case UniformBinding.WorldViewProjectionMatrixInverse:
					tmpMatrix.copyFrom(viewProjMatrix);
                    tmpMatrix.multLocal(worldMatrix);
                    tmpMatrix.invertLocal();
                    u.setMatrix4(tmpMatrix);
					
                case UniformBinding.CameraPosition:
                    u.setVector3(camLoc);
					
                case UniformBinding.CameraDirection:
                    u.setVector3(camDir);
            }
        }
    }
	
	/**
     * True if the translucent bucket should automatically be rendered
     * by the RenderManager.
     * 
     * @return Whether or not the translucent bucket is rendered.
     * 
     * @see #setHandleTranslucentBucket(boolean) 
     */
    public function isHandleTranslucentBucket():Bool
	{
        return handleTranlucentBucket;
    }
	
	/**
     * Enable or disable rendering of the 
     * {@link Bucket#Translucent translucent bucket}
     * by the RenderManager. The default is enabled.
     * 
     * @param handleTranslucentBucket Whether or not the translucent bucket should
     * be rendered.
     */
    public function setHandleTranslucentBucket(handleTranslucentBucket:Bool):Void
	{
        this.handleTranlucentBucket = handleTranslucentBucket;
    }
	
	/**
     * Internal use only. Sets the world matrix to use for future
     * rendering. This has no effect unless objects are rendered manually
     * using {@link Material#render(com.jme3.scene.Geometry, com.jme3.renderer.RenderManager) }.
     * Using {@link #renderGeometry(com.jme3.scene.Geometry) } will 
     * override this value.
     * 
     * @param mat The world matrix to set
     */
    public function setWorldMatrix(mat:Matrix4f):Void
	{
        worldMatrix.copyFrom(mat);
    }
	
	/**
     * Renders the given geometry.
     * <p>
     * First the proper world matrix is set, if 
     * the geometry's {@link Geometry#setIgnoreTransform(boolean) ignore transform}
     * feature is enabled, the identity world matrix is used, otherwise, the 
     * geometry's {@link Geometry#getWorldMatrix() world transform matrix} is used. 
     * <p>
     * Once the world matrix is applied, the proper material is chosen for rendering.
     * If a {@link #setForcedMaterial(com.jme3.material.Material) forced material} is
     * set on this RenderManager, then it is used for rendering the geometry,
     * otherwise, the {@link Geometry#getMaterial() geometry's material} is used.
     * <p>
     * If a {@link #setForcedTechnique(String) forced technique} is
     * set on this RenderManager, then it is selected automatically
     * on the geometry's material and is used for rendering. Otherwise, one
     * of the {@link MaterialDef#getDefaultTechniques() default techniques} is
     * used.
     * <p>
     * If a {@link #setForcedRenderState(com.jme3.material.RenderState) forced
     * render state} is set on this RenderManager, then it is used
     * for rendering the material, and the material's own render state is ignored.
     * Otherwise, the material's render state is used as intended.
     * 
     * @param g The geometry to render
     * 
     * @see Technique
     * @see RenderState
     * @see Material#selectTechnique(String, com.jme3.renderer.RenderManager) 
     * @see Material#render(com.jme3.scene.Geometry, com.jme3.renderer.RenderManager) 
     */
	public function renderGeometry(geom:Geometry):Void
	{
		if (geom.isIgnoreTransform())
		{
			setWorldMatrix(Matrix4f.IDENTITY);
		}
		else
		{
			setWorldMatrix(geom.getWorldMatrix());
		}
		
		// for each technique in material
		var techniques:Vector<Technique> = geom.getMaterial().getTechniques();
		for (i in 0...techniques.length)
		{
			var technique:Technique = techniques[i];
			var lightList:LightList = geom.getWorldLightList();
			
			var mesh:Mesh = geom.getMesh();
			
			var state:RenderState = technique.getRenderState();
			//culling,blend mode .....
			_renderer.applyRenderState(state);
			
			if (technique.requiresLight && lightList.getSize() > 0)
			{
				for (j in 0...lightList.getSize())
				{
					var light:Light = lightList.getLightAt(j);
					
					var shader:Shader = technique.getShader(light.getType(),mesh.getMeshType());
					
					//需要更新绑定和用户自定义的Uniform，然后上传到GPU
					updateShaderBinding(shader);
					technique.updateShader(shader);
					
					_renderer.setShader(shader);
					_renderer.renderMesh(mesh);
				}
			}
			else
			{
				var shader:Shader = technique.getShader();
					
				//需要更新绑定和用户自定义的Uniform，然后上传到GPU
				updateShaderBinding(shader);
				technique.updateShader(shader);
					
				_renderer.setShader(shader);
				_renderer.renderMesh(mesh);
			}
			
		}
		
	}
	
	/**
     * Renders the given GeometryList.
     * <p>
     * For every geometry in the list, the 
     * {@link #renderGeometry(com.jme3.scene.Geometry) } method is called.
     * 
     * @param gl The geometry list to render.
     * 
     * @see GeometryList
     * @see #renderGeometry(com.jme3.scene.Geometry) 
     */
	public function renderGeometryList(gl:GeometryList):Void
	{
		for (i in 0...gl.getSize())
		{
			renderGeometry(gl.getGeometry(i));
		}
	}
	
	/**
     * If a spatial is not inside the eye frustum, it
     * is still rendered in the shadow frustum (shadow casting queue)
     * through this recursive method.
     */
	private function renderShadow(s:Spatial, rq:RenderQueue):Void
	{
		if (Std.is(s, Node))
		{
			var n:Node = Lib.as(s, Node);
			var children:Vector<Spatial> = n.getChildren();
			for (i in 0...children.length)
			{
				renderShadow(children[i], rq);
			}
		}
		else if (Std.is(s, Geometry))
		{
			var gm:Geometry = Lib.as(s, Geometry);
			
			var shadowMode:Int = s.getShadowMode();
			if (shadowMode != ShadowMode.Off && shadowMode != ShadowMode.Receive)
			{
				//forcing adding to shadow cast mode, culled objects doesn't have to be in the receiver queue
				rq.addToShadowQueue(gm, ShadowMode.Cast);
			}
		}
	}

	/**
     * Flattens the given scene graph into the ViewPort's RenderQueue,
     * checking for culling as the call goes down the graph recursively.
     * <p>
     * First, the scene is checked for culling based on the <code>Spatial</code>s
     * {@link Spatial#setCullHint(com.jme3.scene.Spatial.CullHint) cull hint},
     * if the camera frustum contains the scene, then this method is recursively
     * called on its children.
     * <p>
     * When the scene's leaves or {@link Geometry geometries} are reached,
     * they are each enqueued into the 
     * {@link ViewPort#getQueue() ViewPort's render queue}.
     * <p>
     * In addition to enqueuing the visible geometries, this method
     * also scenes which cast or receive shadows, by putting them into the
     * RenderQueue's 
     * {@link RenderQueue#addToShadowQueue(com.jme3.scene.Geometry, com.jme3.renderer.queue.RenderQueue.ShadowMode) 
     * shadow queue}. Each Spatial which has its 
     * {@link Spatial#setShadowMode(com.jme3.renderer.queue.RenderQueue.ShadowMode) shadow mode}
     * set to not off, will be put into the appropriate shadow queue, note that
     * this process does not check for frustum culling on any 
     * {@link ShadowMode#Cast shadow casters}, as they don't have to be
     * in the eye camera frustum to cast shadows on objects that are inside it.
     * 
     * @param scene The scene to flatten into the queue
     * @param vp The ViewPort provides the {@link ViewPort#getCamera() camera}
     * used for culling and the {@link ViewPort#getQueue() queue} used to 
     * contain the flattened scene graph.
     */
	public function renderScene(scene:Spatial, vp:ViewPort):Void
	{
		if (scene.parent == null)
		{
			vp.camera.setPlaneState(0);
		}
		
		// check culling first.
		if (!scene.checkCulling(vp.camera))
		{
			// move on to shadow-only render
			if ((scene.getShadowMode() != ShadowMode.Off || Std.is(scene, Node)) && scene.getCullHint() != CullHint.Always)
			{
				renderShadow(scene, vp.queue);
			}
			return;
		}
		
		scene.runControlRender(this, vp);
		
		if (Std.is(scene, Node))
		{
			//recurse for all children
			var n:Node = Lib.as(scene, Node);
			
			var children:Vector<Spatial> = n.getChildren();
			//saving cam state for culling
			var camState:Int = vp.camera.getPlaneState();
			for (i in 0...children.length)
			{
				//restoring cam state before proceeding children recusively
				vp.camera.setPlaneState(camState);
				renderScene(children[i], vp);
			}
		}
		else if (Std.is(scene, Geometry))
		{
			// add to the render queue
		    var gm:Geometry = Lib.as(scene, Geometry);

			#if debug
			Assert.assert(gm.getMaterial() != null, "No material is set for Geometry: " + gm.getName());
			#end
			
			vp.queue.addToQueue(gm, gm.getQueueBucket());
			 
			//add to shadow queue if needed
			var shadowMode:Int = gm.getShadowMode();
			if (shadowMode != ShadowMode.Off)
			{
				vp.queue.addToShadowQueue(gm, shadowMode);
			}
		}
	}
	
	/**
     * Returns the camera currently used for rendering.
     * <p>
     * The camera can be set with {@link #setCamera(com.jme3.renderer.Camera, boolean) }.
     * 
     * @return the camera currently used for rendering.
     */
    public function getCamera():Camera3D
	{
        return camera;
    }
	
	/**
     * The renderer implementation used for rendering operations.
     * 
     * @return The renderer implementation
     * 
     * @see #RenderManager(com.jme3.renderer.Renderer) 
     * @see Renderer
     */
	public function getRenderer():IRenderer
	{
		return _renderer;
	}
	
	/**
     * Flushes the ViewPort's {@link ViewPort#getQueue() render queue}
     * by rendering each of its visible buckets.
     * By default the queues will automatically be cleared after rendering,
     * so there's no need to clear them manually.
     * 
     * @param vp The ViewPort of which the queue will be flushed
     * 
     * @see RenderQueue#renderQueue(com.jme3.renderer.queue.RenderQueue.Bucket, com.jme3.renderer.RenderManager, com.jme3.renderer.Camera) 
     * @see #renderGeometryList(com.jme3.renderer.queue.GeometryList) 
     */
	public function flushQueue(vp:ViewPort):Void
	{
		renderViewPortQueues(vp, true);
	}
	
	/**
     * Clears the queue of the given ViewPort.
     * Simply calls {@link RenderQueue#clear() } on the ViewPort's 
     * {@link ViewPort#getQueue() render queue}.
     * 
     * @param vp The ViewPort of which the queue will be cleared.
     * 
     * @see RenderQueue#clear()
     * @see ViewPort#getQueue()
     */
	public function clearQueue(vp:ViewPort):Void
	{
		vp.queue.clear();
	}
	
	/**
     * Render the given viewport queues.
     * <p>
     * Changes the {@link Renderer#setDepthRange(float, float) depth range}
     * appropriately as expected by each queue and then calls 
     * {@link RenderQueue#renderQueue(com.jme3.renderer.queue.RenderQueue.Bucket, com.jme3.renderer.RenderManager, com.jme3.renderer.Camera, boolean) }
     * on the queue. Makes sure to restore the depth range to [0, 1] 
     * at the end of the call.
     * Note that the {@link Bucket#Translucent translucent bucket} is NOT
     * rendered by this method. Instead the user should call 
     * {@link #renderTranslucentQueue(com.jme3.renderer.ViewPort) }
     * after this call.
     * 
     * @param vp the viewport of which queue should be rendered
     * @param flush If true, the queues will be cleared after
     * rendering.
     * 
     * @see RenderQueue
     * @see #renderTranslucentQueue(com.jme3.renderer.ViewPort) 
     */
	public function renderViewPortQueues(vp:ViewPort, flush:Bool):Void
	{
		var queue:RenderQueue = vp.queue;
		var cam:Camera3D = vp.camera;

		//TODO 此时修改depthTest为false
		// render the sky, with depth range set to the farthest
		if (!queue.isQueueEmpty(QueueBucket.Sky)) 
		{
			_renderer.setDepthTest(false, Context3DCompareMode.ALWAYS);
            queue.renderQueue(QueueBucket.Sky, this, cam, flush);
        }

		_renderer.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
		
		// render opaque objects with default depth range
        // opaque objects are sorted front-to-back, reducing overdraw
		queue.renderQueue(QueueBucket.Opaque, this, cam, flush);
		
		// transparent objects are last because they require blending with the
        // rest of the scene's objects. Consequently, they are sorted
        // back-to-front.
		if (!queue.isQueueEmpty(QueueBucket.Transparent)) 
		{
			_renderer.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
            queue.renderQueue(QueueBucket.Transparent, this, cam, flush);
        }

        if (!queue.isQueueEmpty(QueueBucket.Gui)) 
		{
			_renderer.setDepthTest(true, Context3DCompareMode.ALWAYS);
            setCamera(cam, true);
            queue.renderQueue(QueueBucket.Gui, this, cam, flush);
            setCamera(cam, false);
        }
	}
	
	/**
     * Renders the {@link Bucket#Translucent translucent queue} on the viewPort.
     * <p>
     * This call does nothing unless {@link #setHandleTranslucentBucket(boolean) }
     * is set to true. This method clears the translucent queue after rendering
     * it.
     * 
     * @param vp The viewport of which the translucent queue should be rendered.
     * 
     * @see #renderViewPortQueues(com.jme3.renderer.ViewPort, boolean) 
     * @see #setHandleTranslucentBucket(boolean) 
     */
	public function renderTranslucentQueue(vp:ViewPort):Void
	{
		var rq:RenderQueue = vp.queue;
        if (!rq.isQueueEmpty(QueueBucket.Translucent) && handleTranlucentBucket) 
		{
            rq.renderQueue(QueueBucket.Translucent, this, vp.camera, true);
        }
	}
	
	private function setViewPort(cam:Camera3D):Void
	{
		// this will make sure to update viewport only if needed
		if (cam != this.camera || cam.isViewportChanged())
		{
			viewX = Std.int(cam.getViewPortLeft() * cam.getWidth());
            viewY = Std.int(cam.getViewPortBottom() * cam.getHeight());
            viewWidth = Std.int((cam.getViewPortRight() - cam.getViewPortLeft()) * cam.getWidth());
            viewHeight = Std.int((cam.getViewPortTop() - cam.getViewPortBottom()) * cam.getHeight());
            _renderer.setViewPort(viewX, viewY, viewWidth, viewHeight);
            _renderer.setClipRect(viewX, viewY, viewWidth, viewHeight);
            cam.clearViewportChanged();
            this.camera = cam; 
		}
		
		orthoMatrix.loadIdentity();
        orthoMatrix.setTranslation(new Vector3f(-1, -1, 0));
        orthoMatrix.setScale(new Vector3f(2 / cam.getWidth(), 2 / cam.getHeight(), 0));
	}
	
	private function setViewProjection(cam:Camera3D, ortho:Bool):Void
	{
		if (ortho)
		{
			viewMatrix.loadIdentity();
			projMatrix.copyFrom(orthoMatrix);
			viewProjMatrix.copyFrom(orthoMatrix);
		}
		else
		{
			viewMatrix.copyFrom(cam.getViewMatrix());
			projMatrix.copyFrom(cam.getProjectionMatrix());
			viewProjMatrix.copyFrom(cam.getViewProjectionMatrix());
		}
			
		camLoc.copyFrom(cam.getLocation());
		cam.getLeft(camLeft);
		cam.getUp(camUp);
		cam.getDirection(camDir);
			
		near = cam.getFrustumNear();
		far = cam.getFrustumFar();
	}
	
	/**
     * Set the camera to use for rendering.
     * <p>
     * First, the camera's 
     * {@link Camera#setViewPort(float, float, float, float) view port parameters}
     * are applied. Then, the camera's {@link Camera#getViewMatrix() view} and 
     * {@link Camera#getProjectionMatrix() projection} matrices are set
     * on the renderer. If <code>ortho</code> is <code>true</code>, then
     * instead of using the camera's view and projection matrices, an ortho
     * matrix is computed and used instead of the view projection matrix. 
     * The ortho matrix converts from the range (0 ~ Width, 0 ~ Height, -1 ~ +1)
     * to the clip range (-1 ~ +1, -1 ~ +1, -1 ~ +1).
     * 
     * @param cam The camera to set
     * @param ortho True if to use orthographic projection (for GUI rendering),
     * false if to use the camera's view and projection matrices.
     */
	public function setCamera(cam:Camera3D, ortho:Bool):Void
	{
		setViewPort(cam);
		setViewProjection(cam, ortho);
	}
	
	/**
     * Draws the viewport but without notifying {@link SceneProcessor scene
     * processors} of any rendering events.
     * 
     * @param vp The ViewPort to render
     * 
     * @see #renderViewPort(com.jme3.renderer.ViewPort, float) 
     */
	public function renderViewPortRaw(vp:ViewPort):Void
	{
		setCamera(vp.camera, false);
		
		var scenes:Vector<Spatial> = vp.getScenes();
		var i:Int = scenes.length;
		while (i-- >= 0)
		{
			renderScene(scenes[i], vp);
		}
		flushQueue(vp);
	}
	
	/**
     * Renders the {@link ViewPort}.
     * <p>
     * If the ViewPort is {@link ViewPort#isEnabled() disabled}, this method
     * returns immediately. Otherwise, the ViewPort is rendered by 
     * the following process:<br>
     * <ul>
     * <li>All {@link SceneProcessor scene processors} that are attached
     * to the ViewPort are {@link SceneProcessor#initialize(com.jme3.renderer.RenderManager, com.jme3.renderer.ViewPort) initialized}.
     * </li>
     * <li>The SceneProcessors' {@link SceneProcessor#preFrame(float) } method 
     * is called.</li>
     * <li>The ViewPort's {@link ViewPort#getOutputFrameBuffer() output framebuffer}
     * is set on the Renderer</li>
     * <li>The camera is set on the renderer, including its view port parameters.
     * (see {@link #setCamera(com.jme3.renderer.Camera, boolean) })</li>
     * <li>Any buffers that the ViewPort requests to be cleared are cleared
     * and the {@link ViewPort#getBackgroundColor() background color} is set</li>
     * <li>Every scene that is attached to the ViewPort is flattened into 
     * the ViewPort's render queue 
     * (see {@link #renderViewPortQueues(com.jme3.renderer.ViewPort, boolean) })
     * </li>
     * <li>The SceneProcessors' {@link SceneProcessor#postQueue(com.jme3.renderer.queue.RenderQueue) }
     * method is called.</li>
     * <li>The render queue is sorted and then flushed, sending
     * rendering commands to the underlying Renderer implementation. 
     * (see {@link #flushQueue(com.jme3.renderer.ViewPort) })</li>
     * <li>The SceneProcessors' {@link SceneProcessor#postFrame(com.jme3.texture.FrameBuffer) }
     * method is called.</li>
     * <li>The translucent queue of the ViewPort is sorted and then flushed
     * (see {@link #renderTranslucentQueue(com.jme3.renderer.ViewPort) })</li>
     * <li>If any objects remained in the render queue, they are removed
     * from the queue. This is generally objects added to the 
     * {@link RenderQueue#renderShadowQueue(com.jme3.renderer.queue.RenderQueue.ShadowMode, com.jme3.renderer.RenderManager, com.jme3.renderer.Camera, boolean) 
     * shadow queue}
     * which were not rendered because of a missing shadow renderer.</li>
     * </ul>
     * 
     * @param vp
     * @param tpf 
     */
	public function renderViewPort(vp:ViewPort, tpf:Float):Void
	{
		if (!vp.enabled) 
            return;
		
		var processors:Vector<SceneProcessor> = vp.getProcessors();
        for (proc in processors) 
		{
            if (!proc.isInitialized()) 
			{
                proc.initialize(this, vp);
            }
            proc.preFrame(tpf);
        }
		
		_renderer.setFrameBuffer(vp.frameBuffer);
		
		setCamera(vp.camera, false);
		
		if (vp.isClearDepth() || vp.isClearColor() || vp.isClearStencil()) 
		{
            if (vp.isClearColor()) 
			{
                _renderer.setBackgroundColor(vp.getBackgroundColor());
            }
			
            _renderer.clearBuffers(vp.isClearColor(),
                    vp.isClearDepth(),
                    vp.isClearStencil());
        }
		
		var scenes:Vector<Spatial> = vp.getScenes();
		var i:Int = scenes.length;
		while (i-- > 0)
		{
			renderScene(scenes[i], vp);
		}
		

        for (proc in processors) 
		{
            proc.postQueue(vp.queue);
        }

		flushQueue(vp);
		
        for (proc in processors) 
	    {
            proc.postFrame(vp.frameBuffer);
        }
		
        //renders the translucent objects queue after processors have been rendered
        renderTranslucentQueue(vp);
		
        // clear any remaining spatials that were not rendered.
        clearQueue(vp);
	}
	
	/**
     * Called by the application to render any ViewPorts
     * added to this RenderManager.
     * <p>
     * Renders any viewports that were added using the following methods:
     * @param tpf Time per frame value
     */
	public function render(tpf:Float):Void
	{
        for (i in 0...preViewPorts.length) 
		{
            renderViewPort(preViewPorts[i], tpf);
        }
		
		for (i in 0...viewPorts.length) 
		{
            renderViewPort(viewPorts[i], tpf);
        }
		
		for (i in 0...postViewPorts.length) 
		{
            renderViewPort(postViewPorts[i], tpf);
        }
		
		_renderer.present();
    }
}