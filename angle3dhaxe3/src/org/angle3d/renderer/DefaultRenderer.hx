package org.angle3d.renderer;

import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DClearMask;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import flash.geom.Rectangle;
import haxe.ds.StringMap;
import flash.Vector;
import org.angle3d.light.Light;
import org.angle3d.manager.ShaderManager;
import org.angle3d.material.BlendMode;
import org.angle3d.material.CullMode;
import org.angle3d.material.RenderState;
import org.angle3d.material.shader.AttributeVar;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderVariable;
import org.angle3d.material.TestFunction;
import org.angle3d.math.Color;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.SubMesh;
import org.angle3d.texture.FrameBuffer;
import org.angle3d.texture.TextureMapBase;
import org.angle3d.utils.Assert;




class DefaultRenderer implements IRenderer
{
	public var stage3D(get, null):Stage3D;
	public var context3D(get, null):Context3D;
	
	public var enableDepthAndStencil(default, default):Bool;
	
	private var mContext3D:Context3D;

	private var mStage3D:Stage3D;
	
	private var mAntiAlias:Int;

	private var mRenderContext:RenderContext;

	private var mBgColor:Color;

	private var mClipRect:Rectangle;

	private var mFrameBuffer:FrameBuffer;

	private var mShader:Shader;

	private var mLastProgram:Program3D;

	private var mRegisterTextureIndex:Int = 0;
	private var mRegisterBufferIndex:Int = 0;

	public function new(stage3D:Stage3D)
	{
		mStage3D = stage3D;
		mContext3D = mStage3D.context3D;

		mRenderContext = new RenderContext();

		mBgColor = new Color();

		mClipRect = new Rectangle();
		
		mAntiAlias = 0;
		
		enableDepthAndStencil = true;
	}

	public function invalidateState():Void
	{
		mRenderContext.reset();
	}

	public function clearBuffers(color:Bool, depth:Bool, stencil:Bool):Void
	{
		var bits:UInt = 0;
		if (color)
		{
			bits = Context3DClearMask.COLOR;
		}

		if (depth)
		{
			bits |= Context3DClearMask.DEPTH;
		}

		if (stencil)
			bits |= Context3DClearMask.STENCIL;

		if (bits != 0)
		{
			mContext3D.clear(mBgColor.r, mBgColor.g, mBgColor.b, mBgColor.a, 1, 0, bits);
		}
	}

	public function setBackgroundColor(color:UInt):Void
	{
		mBgColor.setColor(color);
	}

	/**
	 *
	 * @param state
	 *
	 */
	public function applyRenderState(state:RenderState):Void
	{
		//TODO 这里有问题，有时候会出现一次也没执行的情况，导致渲染不出东西
		if (state.depthTest != mRenderContext.depthTest || 
			state.compareMode != mRenderContext.compareMode)
		{
			mContext3D.setDepthTest(state.depthTest, state.compareMode);
			mRenderContext.depthTest = state.depthTest;
			mRenderContext.compareMode = state.compareMode;
		}

		if (state.colorWrite != mRenderContext.colorWrite)
		{
			var colorWrite:Bool = state.colorWrite;
			mContext3D.setColorMask(colorWrite, colorWrite, colorWrite, colorWrite);
			mRenderContext.colorWrite = colorWrite;
		}

		if (state.cullMode != mRenderContext.cullMode)
		{
			mContext3D.setCulling(state.cullMode);
			mRenderContext.cullMode = state.cullMode;
		}

		if (state.blendMode != mRenderContext.blendMode)
		{
			switch (state.blendMode)
			{
				case BlendMode.Off:
					mContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				case BlendMode.Additive:
					mContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				case BlendMode.AlphaAdditive:
					mContext3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
				case BlendMode.Color:
					mContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
				case BlendMode.Alpha:
					mContext3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				case BlendMode.PremultAlpha:
					mContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				case BlendMode.Modulate:
					mContext3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ZERO);
				case BlendMode.ModulateX2:
					mContext3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.SOURCE_COLOR);
			}
			mRenderContext.blendMode = state.blendMode;
		}

	}

	public function onFrame():Void
	{

	}
	
	
	public function setAntiAlias(antiAlias:Int):Void
	{
		if (mAntiAlias != antiAlias)
		{
			mAntiAlias = antiAlias;
		}
	}

	//TODO 这里不应该经常调用，应该只在舞台大小变动时才修改，这些API很费时
	private var _oldContext3DWidth:Int;
	private var _oldContext3DHeight:Int;
	public function setViewPort(x:Int, y:Int, width:Int, height:Int):Void
	{
		if (mStage3D.x != x)
			mStage3D.x = x;
		if (mStage3D.y != y)
			mStage3D.y = y;

		if (_oldContext3DWidth != width || _oldContext3DHeight != height)
		{
			_oldContext3DWidth = width;
			_oldContext3DHeight = height;
			mContext3D.configureBackBuffer(width, height, mAntiAlias, enableDepthAndStencil);
		}
	}

	public function setClipRect(x:Int, y:Int, width:Int, height:Int):Void
	{
		if (!mRenderContext.clipRectEnabled)
		{
			mRenderContext.clipRectEnabled = true;
		}

		if (mClipRect.x != x || mClipRect.y != y ||
			mClipRect.width != width || mClipRect.height != height)
		{
			mClipRect.setTo(x, y, width, height);
			mContext3D.setScissorRectangle(mClipRect);
		}
	}

	public function clearClipRect():Void
	{
		if (mRenderContext.clipRectEnabled)
		{
			mRenderContext.clipRectEnabled = false;
			mContext3D.setScissorRectangle(null);

			mClipRect.setEmpty();
		}
	}

	public function setFrameBuffer(fb:FrameBuffer):Void
	{
		if (mFrameBuffer == fb)
			return;

		mFrameBuffer = fb;

		if (mFrameBuffer == null)
		{
			mContext3D.setRenderToBackBuffer();
		}
		else
		{
			mContext3D.setRenderToTexture(mFrameBuffer.texture.getTexture(mContext3D), mFrameBuffer.enableDepthAndStencil, mFrameBuffer.antiAlias, mFrameBuffer.surfaceSelector);
		}
	}

	public function setShader(shader:Shader):Void
	{
		Assert.assert(shader != null, "shader cannot be null");

		if (mShader != shader)
		{
			clearTextures();

			mShader = shader;

			var program:Program3D = ShaderManager.instance.getProgram(mShader.name);

			if (mLastProgram != program)
			{
				mContext3D.setProgram(program);
				mLastProgram = program;
			}
		}

		//上传Shader数据
		mShader.uploadTexture(this);
		mShader.upload(this);
	}

	public function setTextureAt(index:Int, map:TextureMapBase):Void
	{
		if (index > mRegisterTextureIndex)
		{
			mRegisterTextureIndex = index;
		}
		mContext3D.setTextureAt(index, map.getTexture(mContext3D));
		//TODO 减少变化
		mContext3D.setSamplerStateAt(index, map.wrapMode, map.textureFilter, map.mipFilter);
	}

	//耗时有点久
	public function setShaderConstants(shaderType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void
	{
		mContext3D.setProgramConstantsFromVector(shaderType, firstRegister, data, numRegisters);
	}

	public function setDepthTest(depthMask:Bool, passCompareMode:TestFunction):Void
	{
		mContext3D.setDepthTest(depthMask, passCompareMode);
	}

	public function setCulling(cullMode:CullMode):Void
	{
		mContext3D.setCulling(cullMode);
	}

	public function cleanup():Void
	{
		invalidateState();
	}

	public function renderMesh(mesh:Mesh):Void
	{
		var subMeshList:Vector<SubMesh> = mesh.subMeshList;
		for (i in 0...subMeshList.length)
		{
			var subMesh:SubMesh = subMeshList[i];
			setVertexBuffers(subMesh);
			mContext3D.drawTriangles(subMesh.getIndexBuffer3D(mContext3D));
		}
	}

	public function renderShadow(mesh:Mesh, light:Light, cam:Camera3D):Void
	{
	}

	public inline function present():Void
	{
		mContext3D.present();
	}
	
	private inline function get_stage3D():Stage3D
	{
		return mStage3D;
	}
	private inline function get_context3D():Context3D
	{
		return mContext3D;
	}

	private function clearTextures():Void
	{
		for (i in 0...mRegisterTextureIndex + 1)
		{
			mContext3D.setTextureAt(i, null);
		}
		mRegisterTextureIndex = 0;
	}

	/**
	 * 清理之前遗留下来未使用的属性寄存器
	 */
	private function clearVertexBuffers(maxRegisterIndex:Int):Void
	{
		if (mRegisterBufferIndex > maxRegisterIndex)
		{
			for (i in (maxRegisterIndex + 1)...mRegisterBufferIndex + 1)
			{
				mContext3D.setVertexBufferAt(i, null);
			}
		}
		mRegisterBufferIndex = maxRegisterIndex;
	}

	/**
	 * 传递相关信息
	 * @param	vb
	 */
	private function setVertexBuffers(subMesh:SubMesh):Void
	{
		//属性寄存器使用的最大索引
		var maxRegisterIndex:Int = 0;

		var attributes:StringMap<ShaderVariable> = mShader.getAttributes();

		var attribute:AttributeVar;
		var location:Int;
		//TODO 优化，不必每次都创建keys
		var bufferTypes = attributes.keys();
		for (bufferType in bufferTypes)
		{
			attribute = cast(attributes.get(bufferType), AttributeVar);
			location = subMesh.merge ? attribute.location : 0;
			mContext3D.setVertexBufferAt(attribute.index, subMesh.getVertexBuffer3D(mContext3D, bufferType), location, attribute.format);
			if (attribute.index > maxRegisterIndex)
			{
				maxRegisterIndex = attribute.index;
			}
		}

		clearVertexBuffers(maxRegisterIndex);
	}
}

