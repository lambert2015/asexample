package org.angle3d.renderer
{

	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Program3D;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.angle3d.light.Light;
	import org.angle3d.manager.ShaderManager;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.RenderState;
	import org.angle3d.material.shader.AttributeVar;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.math.Color;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;
	import org.angle3d.texture.FrameBuffer;
	import org.angle3d.texture.TextureMapBase;
	import org.angle3d.utils.Assert;


	public class DefaultRenderer implements IRenderer
	{
		private var _context3D:Context3D;

		private var _stage3D:Stage3D;

		private var _renderContext:RenderContext;

		private var _bgColor:Color;

		private var _clipRect:Rectangle;

		private var _frameBuffer:FrameBuffer;

		private var _shader:Shader;

		private var _lastProgram:Program3D;

		private var _registerTextureIndex:int = 0;
		private var _registerBufferIndex:int = 0;

		public function DefaultRenderer(stage3D:Stage3D)
		{
			_stage3D = stage3D;
			_context3D = _stage3D.context3D;

			_renderContext = new RenderContext();

			_bgColor = new Color();

			_clipRect = new Rectangle();
		}

		public function get stage3D():Stage3D
		{
			return _stage3D;
		}

		public function get context3D():Context3D
		{
			return _context3D;
		}

		public function invalidateState():void
		{
			_renderContext.reset();
		}

		public function clearBuffers(color:Boolean, depth:Boolean, stencil:Boolean):void
		{
			var bits:uint = 0;
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

		public function setBackgroundColor(color:uint):void
		{
			_bgColor.setColor(color);
		}

		public function applyRenderState(state:RenderState):void
		{
			//TODO 这里有问题，需要检查
//			if (state.depthTest != _renderContext.depthTest ||
//				state.compareMode != _renderContext.compareMode)
			{
				_context3D.setDepthTest(state.depthTest, state.compareMode);
				_renderContext.depthTest = state.depthTest;
				_renderContext.compareMode = state.compareMode;
			}

			if (state.colorWrite != _renderContext.colorWrite)
			{
				var colorWrite:Boolean = state.colorWrite;
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
				var CBF:Class = Context3DBlendFactor;
				switch (state.blendMode)
				{
					case BlendMode.Off:
						_context3D.setBlendFactors(CBF.ONE, CBF.ZERO);
						break;
					case BlendMode.Additive:
						_context3D.setBlendFactors(CBF.ONE, CBF.ONE);
						break;
					case BlendMode.AlphaAdditive:
						_context3D.setBlendFactors(CBF.SOURCE_ALPHA, CBF.ONE);
						break;
					case BlendMode.Color:
						_context3D.setBlendFactors(CBF.ONE, CBF.ONE_MINUS_SOURCE_COLOR);
						break;
					case BlendMode.Alpha:
						_context3D.setBlendFactors(CBF.SOURCE_ALPHA, CBF.ONE_MINUS_SOURCE_COLOR);
						break;
					case BlendMode.PremultAlpha:
						_context3D.setBlendFactors(CBF.ONE, CBF.ONE_MINUS_SOURCE_ALPHA);
						break;
					case BlendMode.Modulate:
						_context3D.setBlendFactors(CBF.DESTINATION_COLOR, CBF.ZERO);
						break;
					case BlendMode.ModulateX2:
						_context3D.setBlendFactors(CBF.DESTINATION_COLOR, CBF.SOURCE_COLOR);
						break;
				}

				_renderContext.blendMode = state.blendMode;
			}

		}

		public function onFrame():void
		{

		}

		//TODO 这里不应该经常调用，应该只在舞台大小变动时才修改，这些API很费时
		public function setViewPort(x:int, y:int, width:int, height:int):void
		{
			_stage3D.x = x;
			_stage3D.y = y;
			_context3D.configureBackBuffer(width, height, 0, true);
		}

		public function setClipRect(x:int, y:int, width:int, height:int):void
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

		public function clearClipRect():void
		{
			if (_renderContext.clipRectEnabled)
			{
				_renderContext.clipRectEnabled = false;
				_context3D.setScissorRectangle(null);

				_clipRect.setEmpty();
			}
		}

		public function setFrameBuffer(fb:FrameBuffer):void
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

		public function setShader(shader:Shader):void
		{
			CF::DEBUG
			{
				Assert.assert(shader != null, "shader cannot be null");
			}

			clearTextures();

			_shader = shader;

			var program:Program3D = ShaderManager.instance.getProgram(_shader.name);

			if (_lastProgram != program)
			{
				_context3D.setProgram(program);
				_lastProgram = program;
			}

			//上传Shader数据
			_shader.upload(this);
		}

		public function setTextureAt(index:int, map:TextureMapBase):void
		{
			if (index > _registerTextureIndex)
			{
				_registerTextureIndex = index;
			}
			_context3D.setTextureAt(index, map.getTexture(_context3D));
		}

		public function setShaderConstants(shaderType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1):void
		{
			_context3D.setProgramConstantsFromVector(shaderType, firstRegister, data, numRegisters);
		}

		public function setDepthTest(depthMask:Boolean, passCompareMode:String):void
		{
			_context3D.setDepthTest(depthMask, passCompareMode);
		}

		public function setCulling(triangleFaceToCull:String):void
		{
			_context3D.setCulling(triangleFaceToCull);
		}

		public function cleanup():void
		{
			invalidateState();
		}

		public function renderMesh(mesh:Mesh):void
		{
			var subMeshList:Vector.<SubMesh> = mesh.subMeshList;
			for (var i:int = 0, length:int = subMeshList.length; i < length; i++)
			{
				var subMesh:SubMesh = subMeshList[i];
				setVertexBuffers(subMesh);
				_context3D.drawTriangles(subMesh.getIndexBuffer3D(_context3D));
			}
		}

		public function renderShadow(mesh:Mesh, light:Light, cam:Camera3D):void
		{

		}

		public function present():void
		{
			_context3D.present();
		}

		private function clearTextures():void
		{
			for (var i:int = 0; i <= _registerTextureIndex; i++)
			{
				_context3D.setTextureAt(i, null);
			}
			_registerTextureIndex = 0;
		}

		/**
		 * 清理之前遗留下来未使用的属性寄存器
		 */
		private function clearVertexBuffers(maxRegisterIndex:int):void
		{
			if (_registerBufferIndex > maxRegisterIndex)
			{
				for (var i:int = maxRegisterIndex + 1; i <= _registerBufferIndex; i++)
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
		protected function setVertexBuffers(subMesh:SubMesh):void
		{
			//属性寄存器使用的最大索引
			var maxRegisterIndex:int = 0;

			var attributes:Dictionary = _shader.getAttributes();

			var attribute:AttributeVar;
			var location:int;
			var bufferType:String;
			for (bufferType in attributes)
			{
				attribute = attributes[bufferType];
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
}

