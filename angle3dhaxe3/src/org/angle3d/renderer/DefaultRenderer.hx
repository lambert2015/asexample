package org.angle3d.renderer;

import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DClearMask;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import flash.geom.Rectangle;
import haxe.ds.StringMap;
import haxe.ds.Vector;
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
	private var _context3D:Context3D;

	private var _stage3D:Stage3D;

	private var _renderContext:RenderContext;

	private var _bgColor:Color;

	private var _clipRect:Rectangle;

	private var _frameBuffer:FrameBuffer;

	private var _shader:Shader;

	private var _lastProgram:Program3D;

	private var _registerTextureIndex:Int = 0;
	private var _registerBufferIndex:Int = 0;

	public function new(stage3D:Stage3D)
	{
		_stage3D = stage3D;
		_context3D = _stage3D.context3D;

		_renderContext = new RenderContext();

		_bgColor = new Color();

		_clipRect = new Rectangle();
	}

	public var stage3D(get, null):Stage3D;
	private inline function get_stage3D():Stage3D
	{
		return _stage3D;
	}

	public var context3D(get, null):Context3D;
	private inline function get_context3D():Context3D
	{
		return _context3D;
	}

	public function invalidateState():Void
	{
		_renderContext.reset();
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
			_context3D.clear(_bgColor.r, _bgColor.g, _bgColor.b, _bgColor.a, 1, 0, bits);
		}
	}

	public function setBackgroundColor(color:UInt):Void
	{
		_bgColor.setColor(color);
	}

	/**
	 *
	 * @param state
	 *
	 */
	public function applyRenderState(state:RenderState):Void
	{
		//TODO 这里有问题，需要检查
		if (state.depthTest != _renderContext.depthTest || state.compareMode != _renderContext.compareMode)
		{
			_context3D.setDepthTest(state.depthTest, state.compareMode);
			_renderContext.depthTest = state.depthTest;
			_renderContext.compareMode = state.compareMode;
		}

		if (state.colorWrite != _renderContext.colorWrite)
		{
			var colorWrite:Bool = state.colorWrite;
			_context3D.setColorMask(colorWrite, colorWrite, colorWrite, colorWrite);
			_renderContext.colorWrite = colorWrite;
		}

		if (state.cullMode != _renderContext.cullMode)
		{
			_context3D.setCulling(state.cullMode);
			_renderContext.cullMode = state.cullMode;
		}

		if (state.blendMode != _renderContext.blendMode)
		{
			switch (state.blendMode)
			{
				case BlendMode.Off:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				case BlendMode.Additive:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				case BlendMode.AlphaAdditive:
					_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
				case BlendMode.Color:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
				case BlendMode.Alpha:
					_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
				case BlendMode.PremultAlpha:
					_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				case BlendMode.Modulate:
					_context3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ZERO);
				case BlendMode.ModulateX2:
					_context3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.SOURCE_COLOR);
			}
			_renderContext.blendMode = state.blendMode;
		}

	}

	public function onFrame():Void
	{

	}

	//TODO 这里不应该经常调用，应该只在舞台大小变动时才修改，这些API很费时
	private var _oldContext3DWidth:Int;
	private var _oldContext3DHeight:Int;

	public function setViewPort(x:Int, y:Int, width:Int, height:Int):Void
	{
		if (_stage3D.x != x)
			_stage3D.x = x;
		if (_stage3D.y != y)
			_stage3D.y = y;

		if (_oldContext3DWidth != width || _oldContext3DHeight != height)
		{
			_oldContext3DWidth = width;
			_oldContext3DHeight = height;
			_context3D.configureBackBuffer(width, height, 0, true);
		}
	}

	public function setClipRect(x:Int, y:Int, width:Int, height:Int):Void
	{
		if (!_renderContext.clipRectEnabled)
		{
			_renderContext.clipRectEnabled = true;
		}

		if (_clipRect.x != x || _clipRect.y != y ||
			_clipRect.width != width || _clipRect.height != height)
		{
			_clipRect.setTo(x, y, width, height);
			_context3D.setScissorRectangle(_clipRect);
		}
	}

	public function clearClipRect():Void
	{
		if (_renderContext.clipRectEnabled)
		{
			_renderContext.clipRectEnabled = false;
			_context3D.setScissorRectangle(null);

			_clipRect.setEmpty();
		}
	}

	public function setFrameBuffer(fb:FrameBuffer):Void
	{
		if (_frameBuffer == fb)
			return;

		_frameBuffer = fb;

		if (_frameBuffer == null)
		{
			_context3D.setRenderToBackBuffer();
		}
		else
		{
			_context3D.setRenderToTexture(_frameBuffer.texture.getTexture(_context3D), _frameBuffer.enableDepthAndStencil, _frameBuffer.antiAlias, _frameBuffer.surfaceSelector);
		}
	}

	public function setShader(shader:Shader):Void
	{

			Assert.assert(shader != null, "shader cannot be null");

		if (_shader != shader)
		{
			clearTextures();

			_shader = shader;

			var program:Program3D = ShaderManager.getInstance().getProgram(_shader.name);

			if (_lastProgram != program)
			{
				_context3D.setProgram(program);
				_lastProgram = program;
			}
		}

		//上传Shader数据
		_shader.uploadTexture(this);
		_shader.upload(this);
	}

	public function setTextureAt(index:Int, map:TextureMapBase):Void
	{
		if (index > _registerTextureIndex)
		{
			_registerTextureIndex = index;
		}
		_context3D.setTextureAt(index, map.getTexture(_context3D));
		//TODO 减少变化
		_context3D.setSamplerStateAt(index, map.getWrapMode(), map.getTextureFilter(), map.getMipFilter());
	}

	//耗时有点久
	public function setShaderConstants(shaderType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void
	{
		_context3D.setProgramConstantsFromVector(shaderType, firstRegister, data.toData(), numRegisters);
	}

	public function setDepthTest(depthMask:Bool, passCompareMode:TestFunction):Void
	{
		_context3D.setDepthTest(depthMask, passCompareMode);
	}

	public function setCulling(cullMode:CullMode):Void
	{
		_context3D.setCulling(cullMode);
	}

	public function cleanup():Void
	{
		invalidateState();
	}

	public function renderMesh(mesh:Mesh):Void
	{
		var subMeshList:Array<SubMesh> = mesh.subMeshList;
		for (i in 0...subMeshList.length)
		{
			var subMesh:SubMesh = subMeshList[i];
			setVertexBuffers(subMesh);
			_context3D.drawTriangles(subMesh.getIndexBuffer3D(_context3D));
		}
	}

	public function renderShadow(mesh:Mesh, light:Light, cam:Camera3D):Void
	{

	}

	public function present():Void
	{
		_context3D.present();
	}

	private function clearTextures():Void
	{
		for (i in 0..._registerTextureIndex+1)
		{
			_context3D.setTextureAt(i, null);
		}
		_registerTextureIndex = 0;
	}

	/**
	 * 清理之前遗留下来未使用的属性寄存器
	 */
	private function clearVertexBuffers(maxRegisterIndex:Int):Void
	{
		if (_registerBufferIndex > maxRegisterIndex)
		{
			for (i in maxRegisterIndex + 1..._registerBufferIndex + 1)
			{
				_context3D.setVertexBufferAt(i, null);
			}
		}
		_registerBufferIndex = maxRegisterIndex;
	}

	/**
	 * 传递相关信息
	 * @param	vb
	 */
	private function setVertexBuffers(subMesh:SubMesh):Void
	{
		//属性寄存器使用的最大索引
		var maxRegisterIndex:Int = 0;

		var attributes:StringMap<ShaderVariable> = _shader.getAttributes();

		var attribute:AttributeVar;
		var location:Int;
		var bufferTypes = attributes.keys();
		for (bufferType in bufferTypes)
		{
			attribute = cast attributes.get(bufferType);
			location = subMesh.merge ? attribute.location : 0;
			_context3D.setVertexBufferAt(attribute.index, subMesh.getVertexBuffer3D(_context3D, bufferType), location, attribute.format);
			if (attribute.index > maxRegisterIndex)
			{
				maxRegisterIndex = attribute.index;
			}
		}

		clearVertexBuffers(maxRegisterIndex);
	}
}

