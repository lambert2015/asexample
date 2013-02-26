package org.angle3d.renderer;

import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.VertexBuffer3D;
import flash.geom.Rectangle;
import flash.Vector;
import org.angle3d.material.BlendMode;
import org.angle3d.material.ClearMask;
import org.angle3d.material.FaceCullMode;
import org.angle3d.material.RenderState;
import org.angle3d.material.TestFunction;
import org.angle3d.math.Color;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.mesh.VertexBuffer;
import org.angle3d.shader.Shader;
import org.angle3d.texture.FrameBuffer;
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

	public function new(stage3D:Stage3D) 
	{
		_stage3D = stage3D;
		_context3D = _stage3D.context3D;

		_renderContext = new RenderContext();
		
		_bgColor = new Color();
		
		_clipRect = new Rectangle();
	}
	
	public function getStage3D():Stage3D
	{
		return _stage3D;
	}
	
	public function getContext3D():Context3D
	{
		return _context3D;
	}
	
	/**
     * Invalidates the current rendering state. Should be called after
     * the GL state was changed manually or through an external library.
     */
	public function invalidateState():Void
	{
		_renderContext.reset();
	}

	public function clearBuffers(color:Bool, depth:Bool, stencil:Bool):Void
	{
		var bits:UInt = 0;
		if (color)
		{
			//See explanations of the depth below, we must enable color write to be able to clear the color buffer
			if (_renderContext.colorWriteEnabled == false)
			{
				_context3D.setColorMask(true, true, true, true);
				_renderContext.colorWriteEnabled = true;
			}
			bits = ClearMask.COLOR;
		}
		
		if (depth) 
		{
			if (_renderContext.depthWriteEnabled == false)
			{
				_context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
				_renderContext.depthWriteEnabled = true;
			}
			bits |= ClearMask.DEPTH;
		}
		
		if (stencil)
			bits |= ClearMask.STENCIL;
		
		if (bits != 0)
		{
			_context3D.clear(_bgColor.r, _bgColor.g, _bgColor.b, _bgColor.a, 1, 0, bits);
		}
	}
	
	/**
     * Sets the background (aka clear) color.
     * @param color
     */
	public function setBackgroundColor(color:UInt):Void
	{
		_bgColor.setColor(color);
	}
	
	/**
     * Applies the given renderstate, making the neccessary
     * GL calls so that the state is applied.
     */
	public function applyRenderState(state:RenderState):Void
	{
		if (state.isDepthTest() && !_renderContext.depthTestEnabled)
		{
			_context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			_renderContext.depthTestEnabled = true;
		}
		else if (!state.isDepthTest() && _renderContext.depthTestEnabled)
		{
			_context3D.setDepthTest(false, Context3DCompareMode.NEVER);
			_renderContext.depthTestEnabled = false;
		}
		
		if (state.isColorWrite() && !_renderContext.colorWriteEnabled) 
		{
            _context3D.setColorMask(true, true, true, true);
            _renderContext.colorWriteEnabled = true;
        } 
		else if (!state.isColorWrite() && _renderContext.colorWriteEnabled) 
		{
            _context3D.setColorMask(false, false, false, false);
            _renderContext.colorWriteEnabled = false;
        }
		
		if (state.getFaceCullMode() != _renderContext.cullMode)
		{
			switch(state.getFaceCullMode())
			{
				case FaceCullMode.Off:
					_context3D.setCulling(Context3DTriangleFace.NONE);
				case FaceCullMode.Back:
					_context3D.setCulling(Context3DTriangleFace.BACK);
			    case FaceCullMode.Front:
					_context3D.setCulling(Context3DTriangleFace.FRONT);
				case FaceCullMode.FrontAndBack:
					_context3D.setCulling(Context3DTriangleFace.FRONT_AND_BACK);
			}
			
			_renderContext.cullMode = state.getFaceCullMode();
		}
		
		if (state.getBlendMode() != _renderContext.blendMode)
		{
			var CBF = Context3DBlendFactor;
			switch(state.getBlendMode())
			{
				case BlendMode.Off:
					_context3D.setBlendFactors(CBF.ONE, CBF.ZERO);
				case BlendMode.Additive:
					_context3D.setBlendFactors(CBF.ONE, CBF.ONE);
			    case BlendMode.AlphaAdditive:
					_context3D.setBlendFactors(CBF.SOURCE_ALPHA,CBF.ONE);
				case BlendMode.Color:
					_context3D.setBlendFactors(CBF.ONE, CBF.ONE_MINUS_SOURCE_COLOR);
				case BlendMode.Alpha:
					_context3D.setBlendFactors(CBF.SOURCE_ALPHA, CBF.ONE_MINUS_SOURCE_COLOR);
				case BlendMode.PremultAlpha:
					_context3D.setBlendFactors(CBF.ONE, CBF.ONE_MINUS_SOURCE_ALPHA);
				case BlendMode.Modulate:
					_context3D.setBlendFactors(CBF.DESTINATION_COLOR, CBF.ZERO);
				case BlendMode.ModulateX2:
					_context3D.setBlendFactors(CBF.DESTINATION_COLOR, CBF.SOURCE_COLOR);
			}
			
			_renderContext.blendMode = state.getBlendMode();
		}
		
	}
	
	private function convertTestFunction(testFunc:Int):Context3DCompareMode
	{
		var CCM = Context3DCompareMode;
        switch (testFunc) 
		{
            case TestFunction.Never:
                return CCM.NEVER;
            case TestFunction.Less:
                return CCM.LESS;
            case TestFunction.LessOrEqual:
                return CCM.LESS_EQUAL;
            case TestFunction.Greater:
                return CCM.GREATER;
            case TestFunction.GreaterOrEqual:
                return CCM.GREATER_EQUAL;
            case TestFunction.Equal:
                return CCM.EQUAL;
            case TestFunction.NotEqual:
                return CCM.NOT_EQUAL;
            case TestFunction.Always:
                return CCM.ALWAYS;
            default:
                Assert.assert(false, "Unrecognized test function: " + testFunc);
				return null;
        }
    }
	
	/**
     * Called when a new frame has been rendered.
     */
	public function onFrame():Void
	{
		
	}

    public function setViewPort(x:Int, y:Int, width:Int, height:Int):Void
	{
		_stage3D.x = x;
		_stage3D.y = y;
		_context3D.configureBackBuffer(width, height, 4, true);
	}
	
	
	public function setClipRect(x:Int, y:Int, width:Int, height:Int):Void
	{
        if (!_renderContext.clipRectEnabled) 
		{
            _renderContext.clipRectEnabled = true;
        }
		
        if (_clipRect.x != x || _clipRect.y != y || _clipRect.width != width || _clipRect.height != height) 
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
		_frameBuffer = fb;
		
		if (_frameBuffer == null)
		{
			_context3D.setRenderToBackBuffer();
		}
		else
		{
			_context3D.setRenderToTexture(_frameBuffer.texture, _frameBuffer.enableDepthAndStencil, _frameBuffer.antiAlias, _frameBuffer.surfaceSelector);
		}
	}
	
	private function clearAttribute():Void
	{
		for (i in 0...8)
		{
			_context3D.setVertexBufferAt(i, null);
			_context3D.setTextureAt(i, null);
		}
	}
	
	public function setShader(shader:Shader):Void
	{
		//TODO 设置新shader时，清除之前设置的配置
		clearAttribute();
		
		Assert.assert(shader != null, "shader cannot be null");
		
		_shader = shader;

		_context3D.setProgram(_shader.getProgram3D());
		
		//上传Shader Uniform数据
		_shader.uploadUniform(_context3D);
	}

	public function setDepthTest(depthMask:Bool, passCompareMode:Context3DCompareMode):Void
	{
		_context3D.setDepthTest(depthMask, passCompareMode);
	}
	
	public function setCulling(triangleFaceToCull:Context3DTriangleFace):Void
	{
		_context3D.setCulling(triangleFaceToCull);
	}
	
	public function cleanup():Void
	{
		invalidateState();
	}
	
	/**
     * Renders <code>count</code> meshes, with the geometry data supplied.
     * The shader which is currently set with <code>setShader</code> is
     * responsible for transforming the input verticies into clip space
     * and shading it based on the given vertex attributes.
     * @param mesh
     */
	public function renderMesh(mesh:Mesh,lod:Int,count:Int):Void
	{
		if (mesh.getVertexCount() == 0)
		{
			return;
		}

		//var buffersList = mesh.getBufferList();
		//var indices:IndexBuffer;
		//if (mesh.getNumLodLevels() > 0)
		//{
			//indices = mesh.getLodLevel(lod);
		//}
		//else
		//{
			//indices = mesh.getIndexBuffer();
		//}
		//Assert.assert(indices != null, "IndexBuffer is null");
		
		//upload index and vertex buffer
		mesh.upload(_context3D);

		setVertexAttrib(mesh);
		
		_context3D.drawTriangles(mesh.getIndexBuffer3D());
		
		//clearTextureUnits();
	}

	/**
	 * Synchronize graphics subsytem rendering
	 */
	public function present():Void
	{
		_context3D.present();
	}
	
	public function clearTextureUnits():Void
	{
		for (i in 0...8)
		{
			_context3D.setTextureAt(i, null);
		}
	}
	
	/**
	 * 传递相关信息
	 * @param	vb
	 */
	public inline function setVertexAttrib(mesh:Mesh):Void
	{
		var vb3d:VertexBuffer3D = mesh.getVertexBuffer3D();
		
		var buffersList:Vector<VertexBuffer> = mesh.getBufferList();
		for (i in 0...buffersList.length)
		{
			var vb:VertexBuffer = buffersList[i];
			if (_shader.getAttribute("a_" + vb.getType()) != null)
			{
				_shader.setAttribute(_context3D, "a_" + vb.getType(), vb3d, vb.getOffset());
			}
		}
	}
}