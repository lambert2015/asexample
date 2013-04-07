// =================================================================================================
//
//	Starling Framework
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.filters;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.Program3D;
import flash.display3D.VertexBuffer3D;
import flash.errors.IllegalOperationError;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.Vector;
import starling.utils.MathUtil;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Stage;
import starling.errors.AbstractClassError;
import starling.errors.MissingContextError;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;
import starling.utils.VertexData;

/** The FragmentFilter class is the base class for all filter effects in Starling.
 *  All other filters of this package extend this class. You can attach them to any display
 *  object through the 'filter' property.
 * 
 *  <p>A fragment filter works in the following way:</p>
 *  <ol>
 *    <li>The object that is filtered is rendered into a texture (in stage coordinates).</li>
 *    <li>That texture is passed to the first filter pass.</li>
 *    <li>Each pass processes the texture using a fragment shader (and optionally a vertex 
 *        shader) to achieve a certain effect.</li>
 *    <li>The output of each pass is used as the input for the next pass; if it's the 
 *        final pass, it will be rendered directly to the back buffer.</li>  
 *  </ol>
 * 
 *  <p>All of this is set up by the abstract FragmentFilter class. Concrete subclasses
 *  just need to override the protected methods 'createPrograms', 'activate' and 
 *  (optionally) 'deactivate' to create and execute its custom shader code. Each filter
 *  can be configured to either replace the original object, or be drawn below or above it.
 *  This can be done through the 'mode' property, which accepts one of the Strings defined
 *  in the 'FragmentFilterMode' class.</p>
 * 
 *  <p>Beware that each filter should be used only on one object at a time. Otherwise, it
 *  will get slower and require more resources; and caching will lead to undefined
 *  results.</p>
 */ 
class FragmentFilter
{
	/** All filter processing is expected to be done with premultiplied alpha. */
	private var PMA:Bool = true;
	
	/** The standard vertex shader code. It will be used automatically if you don't create
	 *  a custom vertex shader yourself. */
	private var STD_VERTEX_SHADER:String = 
		"m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
		"mov v0, va1      \n";  // pass texture coordinates to fragment program
	
	/** The standard fragment shader code. It just forwards the texture color to the output. */
	private var STD_FRAGMENT_SHADER:String =
		"tex oc, v0, fs0 <2d, clamp, linear, mipnone>"; // just forward texture color
	
	public var isCached(get, null):Bool;
	public var resolution(get, set):Float;
	public var mode(get, set):String;
	public var offsetX(get, set):Float;
	public var offsetY(get, set):Float;
	public var marginX(get, set):Float;
	public var marginY(get, set):Float;
	public var numPasses(get, set):Int;
	public var vertexPosAtID(get, set):Int;
	public var texCoordsAtID(get, set):Int;
	public var baseTextureID(get, set):Int;
	public var mvpConstantID(get, set):Int;

	private var mVertexPosAtID:Int = 0;
	private var mTexCoordsAtID:Int = 1;
	private var mBaseTextureID:Int = 0;
	private var mMvpConstantID:Int = 0;
	
	private var mNumPasses:Int;
	private var mPassTextures:Vector<Texture>;

	private var mMode:String;
	private var mResolution:Float;
	private var mMarginX:Float;
	private var mMarginY:Float;
	private var mOffsetX:Float;
	private var mOffsetY:Float;
	
	private var mVertexData:VertexData;
	private var mVertexBuffer:VertexBuffer3D;
	private var mIndexData:Vector<UInt>;
	private var mIndexBuffer:IndexBuffer3D;
	
	private var mCacheRequested:Bool;
	private var mCache:QuadBatch;
	
	/** helper objects. */
	private var mProjMatrix:Matrix = new Matrix();
	private static var sBounds:Rectangle  = new Rectangle();
	private static var sStageBounds:Rectangle = new Rectangle();
	private static var sTransformationMatrix:Matrix = new Matrix();
	
	/** Creates a new Fragment filter with the specified number of passes and resolution.
	 *  This constructor may only be called by the constructor of a subclass. */
	public function new(numPasses:Int=1, resolution:Float=1.0)
	{
		if (Capabilities.isDebugger && 
			getQualifiedClassName(this) == "starling.filters::FragmentFilter")
		{
			throw new AbstractClassError();
		}
		
		if (numPasses < 1) throw new ArgumentError("At least one pass is required.");
		
		mNumPasses = numPasses;
		mMarginX = mMarginY = 0.0;
		mOffsetX = mOffsetY = 0;
		mResolution = resolution;
		mMode = FragmentFilterMode.REPLACE;
		
		mVertexData = new VertexData(4);
		mVertexData.setTexCoords(0, 0, 0);
		mVertexData.setTexCoords(1, 1, 0);
		mVertexData.setTexCoords(2, 0, 1);
		mVertexData.setTexCoords(3, 1, 1);
		
		mIndexData = Vector.ofArray<UInt>([0, 1, 2, 1, 3, 2]);
		mIndexData.fixed = true;
		
		createPrograms();
		
		// Handle lost context. By using the conventional event, we can make it weak; this  
		// avoids memory leaks when people forget to call "dispose" on the filter.
		Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, 
			onContextCreated, false, 0, true);
	}
	
	/** Disposes the filter (programs, buffers, textures). */
	public function dispose():Void
	{
		Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		if (mVertexBuffer) mVertexBuffer.dispose();
		if (mIndexBuffer)  mIndexBuffer.dispose();
		disposePassTextures();
		disposeCache();
	}
	
	private function onContextCreated(event:Dynamic):Void
	{
		mVertexBuffer = null;
		mIndexBuffer  = null;
		mPassTextures = null;
		
		createPrograms();
	}
	
	/** Applies the filter on a certain display object, rendering the output into the current 
	 *  render target. This method is called automatically by Starling's rendering system 
	 *  for the object the filter is attached to. */
	public function render(object:DisplayObject, support:RenderSupport, parentAlpha:Float):Void
	{
		// bottom layer
		
		if (mode == FragmentFilterMode.ABOVE)
			object.render(support, parentAlpha);
		
		// center layer
		
		if (mCacheRequested)
		{
			mCacheRequested = false;
			mCache = renderPasses(object, support, 1.0, true);
			disposePassTextures();
		}
		
		if (mCache)
			mCache.render(support, parentAlpha);
		else
			renderPasses(object, support, parentAlpha, false);
		
		// top layer
		
		if (mode == FragmentFilterMode.BELOW)
			object.render(support, parentAlpha);
	}
	
	private function renderPasses(object:DisplayObject, support:RenderSupport, 
								  parentAlpha:Float, intoCache:Bool=false):QuadBatch
	{
		var cacheTexture:Texture = null;
		var stage:Stage = object.stage;
		var context:Context3D = Starling.context;
		var scale:Float = Starling.current.contentScaleFactor;
		
		if (stage   == null) throw new Error("Filtered object must be on the stage.");
		if (context == null) throw new MissingContextError();
		
		// the bounds of the object in stage coordinates 
		calculateBounds(object, stage, !intoCache, sBounds);
		
		if (sBounds.isEmpty())
		{
			disposePassTextures();
			return intoCache ? new QuadBatch() : null; 
		}
		
		updateBuffers(context, sBounds);
		updatePassTextures(sBounds.width, sBounds.height, mResolution * scale);

		support.finishQuadBatch();
		support.raiseDrawCount(mNumPasses);
		support.pushMatrix();
		
		// save original projection matrix and render target
		mProjMatrix.copyFrom(support.projectionMatrix); 
		var previousRenderTarget:Texture = support.renderTarget;
		
		if (previousRenderTarget)
			throw new IllegalOperationError(
				"It's currently not possible to stack filters! " +
				"This limitation will be removed in a future Stage3D version.");
		
		if (intoCache) 
			cacheTexture = Texture.empty(sBounds.width, sBounds.height, PMA, true, 
										 mResolution * scale);
		
		// draw the original object into a texture
		support.renderTarget = mPassTextures[0];
		support.clear();
		support.blendMode = BlendMode.NORMAL;
		support.setOrthographicProjection(sBounds.x, sBounds.y, sBounds.width, sBounds.height);
		object.render(support, parentAlpha);
		support.finishQuadBatch();
		
		// prepare drawing of actual filter passes
		RenderSupport.setBlendFactors(PMA);
		support.loadIdentity();  // now we'll draw in stage coordinates!
		
		context.setVertexBufferAt(mVertexPosAtID, mVertexBuffer, VertexData.POSITION_OFFSET, 
								  Context3DVertexBufferFormat.FLOAT_2);
		context.setVertexBufferAt(mTexCoordsAtID, mVertexBuffer, VertexData.TEXCOORD_OFFSET,
								  Context3DVertexBufferFormat.FLOAT_2);
		
		// draw all passes
		for (i in 0...mNumPasses)
		{
			if (i < mNumPasses - 1) // intermediate pass  
			{
				// draw into pass texture
				support.renderTarget = getPassTexture(i+1);
				support.clear();
			}
			else // final pass
			{
				if (intoCache)
				{
					// draw into cache texture
					support.renderTarget = cacheTexture;
					support.clear();
				}
				else
				{
					// draw into back buffer, at original (stage) coordinates
					support.projectionMatrix = mProjMatrix;
					support.renderTarget = previousRenderTarget;
					support.translateMatrix(mOffsetX, mOffsetY);
					support.blendMode = object.blendMode;
					support.applyBlendMode(PMA);
				}
			}
			
			var passTexture:Texture = getPassTexture(i);
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, mMvpConstantID, 
												  support.mvpMatrix3D, true);
			context.setTextureAt(mBaseTextureID, passTexture.base);
			
			activate(i, context, passTexture);
			context.drawTriangles(mIndexBuffer, 0, 2);
			deactivate(i, context, passTexture);
		}
		
		// reset shader attributes
		context.setVertexBufferAt(mVertexPosAtID, null);
		context.setVertexBufferAt(mTexCoordsAtID, null);
		context.setTextureAt(mBaseTextureID, null);
		
		support.popMatrix();
		
		if (intoCache)
		{
			// restore support settings
			support.renderTarget = previousRenderTarget;
			support.projectionMatrix.copyFrom(mProjMatrix);
			
			// Create an image containing the cache. To have a display object that contains
			// the filter output in object coordinates, we wrap it in a QuadBatch: that way,
			// we can modify it with a transformation matrix.
			
			var quadBatch:QuadBatch = new QuadBatch();
			var image:Image = new Image(cacheTexture);
			
			stage.getTransformationMatrix(object, sTransformationMatrix);
			MatrixUtil.prependTranslation(sTransformationMatrix, 
										  sBounds.x + mOffsetX, sBounds.y + mOffsetY);
			quadBatch.addImage(image, 1.0, sTransformationMatrix);

			return quadBatch;
		}
		else return null;
	}
	
	// helper methods
	
	private function updateBuffers(context:Context3D, bounds:Rectangle):Void
	{
		mVertexData.setPosition(0, bounds.x, bounds.y);
		mVertexData.setPosition(1, bounds.right, bounds.y);
		mVertexData.setPosition(2, bounds.x, bounds.bottom);
		mVertexData.setPosition(3, bounds.right, bounds.bottom);
		
		if (mVertexBuffer == null)
		{
			mVertexBuffer = context.createVertexBuffer(4, VertexData.ELEMENTS_PER_VERTEX);
			mIndexBuffer  = context.createIndexBuffer(6);
			mIndexBuffer.uploadFromVector(mIndexData, 0, 6);
		}
		
		mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, 4);
	}
	
	private function updatePassTextures(width:Int, height:Int, scale:Float):Void
	{
		var numPassTextures:Int = mNumPasses > 1 ? 2 : 1;
		
		var needsUpdate:Bool = mPassTextures == null || 
			mPassTextures.length != numPassTextures ||
			mPassTextures[0].width != width || mPassTextures[0].height != height;  
		
		if (needsUpdate)
		{
			if (mPassTextures)
			{
				var texture:Texture;
				for (texture in mPassTextures) 
					texture.dispose();
				
				mPassTextures.length = numPassTextures;
			}
			else
			{
				mPassTextures = new Vector<Texture>(numPassTextures);
			}
			
			for (i in 0...numPassTextures)
				mPassTextures[i] = Texture.empty(width, height, PMA, true, scale);
		}
	}
	
	private function getPassTexture(pass:Int):Texture
	{
		return mPassTextures[pass % 2];
	}
	
	/** Calculates the bounds of the filter in stage coordinates, while making sure that the 
	 *  according textures will have powers of two. */
	private function calculateBounds(object:DisplayObject, stage:Stage, 
									 intersectWithStage:Bool, resultRect:Rectangle):Void
	{
		// optimize for full-screen effects
		if (object == stage || object == Starling.current.root)
			resultRect.setTo(0, 0, stage.stageWidth, stage.stageHeight);
		else
			object.getBounds(stage, resultRect);
		
		if (intersectWithStage)
		{
			sStageBounds.setTo(0, 0, stage.stageWidth, stage.stageHeight);
			RectangleUtil.intersect(resultRect, sStageBounds, resultRect);
		}
		
		if (!resultRect.isEmpty())
		{    
			// the bounds are a rectangle around the object, in stage coordinates,
			// and with an optional margin. To fit into a POT-texture, it will grow towards
			// the right and bottom.
			var deltaMargin:Float = mResolution == 1.0 ? 0.0 : 1.0 / mResolution; // avoid hard edges
			resultRect.x -= mMarginX + deltaMargin;
			resultRect.y -= mMarginY + deltaMargin;
			resultRect.width  += 2 * (mMarginX + deltaMargin);
			resultRect.height += 2 * (mMarginY + deltaMargin);
			resultRect.width  = MathUtil.getNextPowerOfTwo(resultRect.width  * mResolution) / mResolution;
			resultRect.height = MathUtil.getNextPowerOfTwo(resultRect.height * mResolution) / mResolution;
		}
	}
	
	private function disposePassTextures():Void
	{
		for (texture in mPassTextures)
			texture.dispose();
		
		mPassTextures = null;
	}
	
	private function disposeCache():Void
	{
		if (mCache)
		{
			if (mCache.texture) mCache.texture.dispose();
			mCache.dispose();
			mCache = null;
		}
	}
	
	// protected methods

	/** Subclasses must override this method and use it to create their 
	 *  fragment- and vertex-programs. */
	private function createPrograms():Void
	{
		throw new Error("Method has to be implemented in subclass!");
	}

	/** Subclasses must override this method and use it to activate their fragment- and 
	 *  to vertext-programs.
	 *  The 'activate' call directly precedes the call to 'context.drawTriangles'. Set up
	 *  the context the way your filter needs it. The following constants and attributes 
	 *  are set automatically:
	 *  
	 *  <ul><li>vertex constants 0-3: mvpMatrix (3D)</li>
	 *      <li>vertex attribute 0: vertex position (FLOAT_2)</li>
	 *      <li>vertex attribute 1: texture coordinates (FLOAT_2)</li>
	 *      <li>texture 0: input texture</li>
	 *  </ul>
	 *  
	 *  @param pass: the current render pass, starting with '0'. Multipass filters can
	 *               provide different logic for each pass.
	 *  @param context: the current context3D (the same as in Starling.context, passed
	 *               just for convenience)
	 *  @param texture: the input texture, which is already bound to sampler 0. */
	private function activate(pass:Int, context:Context3D, texture:Texture):Void
	{
		throw new Error("Method has to be implemented in subclass!");
	}
	
	/** This method is called directly after 'context.drawTriangles'. 
	 *  If you need to clean up any resources, you can do so in this method. */
	private function deactivate(pass:Int, context:Context3D, texture:Texture):Void
	{
		// clean up resources
	}
	
	/** Assembles fragment- and vertex-shaders, passed as Strings, to a Program3D. 
	 *  If any argument is  null, it is replaced by the class constants STD_FRAGMENT_SHADER or
	 *  STD_VERTEX_SHADER, respectively. */
	private function assembleAgal(fragmentShader:String = null, vertexShader:String = null):Program3D
	{
		if (fragmentShader == null) 
			fragmentShader = STD_FRAGMENT_SHADER;
		if (vertexShader   == null) 
			vertexShader   = STD_VERTEX_SHADER;
		
		return RenderSupport.assembleAgal(vertexShader, fragmentShader);
	}
	
	// cache
	
	/** Caches the filter output into a texture. An uncached filter is rendered in every frame;
	 *  a cached filter only once. However, if the filtered object or the filter settings
	 *  change, it has to be updated manually; to do that, call "cache" again. */
	public function cache():Void
	{
		mCacheRequested = true;
		disposeCache();
	}
	
	/** Clears the cached output of the filter. After calling this method, the filter will
	 *  be executed once per frame again. */ 
	public function clearCache():Void
	{
		mCacheRequested = false;
		disposeCache();
	}
	
	// flattening
	
	/** @private */
	public function compile(object:DisplayObject):QuadBatch
	{
		if (mCache) 
			return mCache;
		else
		{
			var renderSupport:RenderSupport;
			var stage:Stage = object.stage;
			
			if (stage == null) 
				throw new Error("Filtered object must be on the stage.");
			
			renderSupport = new RenderSupport();
			object.getTransformationMatrix(stage, renderSupport.modelViewMatrix);
			return renderPasses(object, renderSupport, 1.0, true);
		}
	}
	
	// properties
	
	/** Indicates if the filter is cached (via the "cache" method). */
	private function get_isCached():Bool 
	{
		return (mCache != null) || mCacheRequested;
	}
	
	/** The resolution of the filter texture. "1" means stage resolution, "0.5" half the
	 *  stage resolution. A lower resolution saves memory and execution time (depending on 
	 *  the GPU), but results in a lower output quality. Values greater than 1 are allowed;
	 *  such values might make sense for a cached filter when it is scaled up. @default 1 */
	private function get_resolution():Float 
	{ 
		return mResolution; 
	}
	private function set_resolution(value:Float):Float 
	{
		if (value <= 0) 
			throw new ArgumentError("Resolution must be > 0");
		else 
			mResolution = value; 
		
		return mResolution; 
	}
	
	/** The filter mode, which is one of the constants defined in the "FragmentFilterMode" 
	 *  class. @default "replace" */
	private function get_mode():String 
	{ 
		return mMode; 
	}
	private function set_mode(value:String):String 
	{ 
		return mMode = value; 
	}
	
	/** Use the x-offset to move the filter output to the right or left. */
	private function get_offsetX():Float 
	{ 
		return mOffsetX; 
	}
	private function set_offsetX(value:Float):Float 
	{ 
		return mOffsetX = value; 
	}
	
	/** Use the y-offset to move the filter output to the top or bottom. */
	private function get_offsetY():Float 
	{ 
		return mOffsetY; 
	}
	private function set_offsetY(value:Float):Float 
	{ 
		return mOffsetY = value; 
	}
	
	/** The x-margin will extend the size of the filter texture along the x-axis.
	 *  Useful when the filter will "grow" the rendered object. */
	private function get_marginX():Float 
	{ 
		return mMarginX; 
	}
	private function set_marginX(value:Float):Float 
	{ 
		return mMarginX = value; 
	}
	
	/** The y-margin will extend the size of the filter texture along the y-axis.
	 *  Useful when the filter will "grow" the rendered object. */
	private function get_marginY():Float 
	{ 
		return mMarginY; 
	}
	private function set_marginY(value:Float):Float 
	{ 
		return mMarginY = value; 
	}
	
	/** The number of passes the filter is applied. The "activate" and "deactivate" methods
	 *  will be called that often. */
	private function set_numPasses(value:Int):Int 
	{ 
		return mNumPasses = value; 
	}
	private function get_numPasses():Int 
	{ 
		return mNumPasses; 
	}
	
	/** The ID of the vertex buffer attribute that stores the vertex position. */ 
	private function get_vertexPosAtID():Int 
	{ 
		return mVertexPosAtID; 
	}
	private function set_vertexPosAtID(value:Int):Int 
	{ 
		return mVertexPosAtID = value; 
	}
	
	/** The ID of the vertex buffer attribute that stores the texture coordinates. */
	private function get_texCoordsAtID():Int 
	{ 
		return mTexCoordsAtID; 
	}
	private function set_texCoordsAtID(value:Int):Int 
	{ 
		return mTexCoordsAtID = value; 
	}

	/** The ID (sampler) of the input texture (containing the output of the previous pass). */
	private function get_baseTextureID():Int 
	{ 
		return mBaseTextureID; 
	}
	private function set_baseTextureID(value:Int):Int 
	{ 
		return mBaseTextureID = value; 
	}
	
	/** The ID of the first register of the modelview-projection constant (a 4x4 matrix). */
	private function get_mvpConstantID():Int 
	{ 
		return mMvpConstantID; 
	}
	private function set_mvpConstantID(value:Int):Int 
	{ 
		return mMvpConstantID = value; 
	}
}