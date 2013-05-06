package quake3.render;
import nme.display3D.Context3D;
import nme.display3D.Context3DCompareMode;
import nme.display3D.Context3DTriangleFace;
import nme.display3D.textures.TextureBase;
import nme.display3D.VertexBuffer3D;
import nme.geom.Matrix3D;
import nme.Vector;
import quake3.bsp.BSP;
import quake3.bsp.BSPFace;
import quake3.core.Camera3D;
import quake3.core.GroupGeometry;
import quake3.core.IGeometry;
import quake3.core.SubGeometry;
import quake3.shader.LightMapShader;

class Renderer 
{
	private var _context3D:Context3D;
	
	private var _camera:Camera3D;
	
	private var _bsp:BSP;
	
	private var _testShader:Shader;

	private var _invertCameraMatrix:Matrix3D;

	public function new(context:Context3D,camera:Camera3D) 
	{
		_invertCameraMatrix = new Matrix3D();
		
		_camera = camera;
		
		initContext3D(context);
	}
	
	private function initContext3D(context:Context3D):Void
	{
		_context3D = context;
		
		_context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
		_context3D.setCulling(Context3DTriangleFace.BACK);

		_testShader = new LightMapShader();
	}

	public function setBSP(bsp:BSP):Void
	{
		_bsp = bsp;
		_bsp.uploadGeometry(_context3D);
	}
	
	/**
	 * 1、计算出可见的BSPFace
	 * 2、划分BSPFace为透明和不透明两部分
	 * 3、渲染天空
	 * 4、从近到远渲染不透明物体
	 * 5、从远到近渲染透明物体
	 */
	public function render():Void
	{
		_camera.update();
		
		

		_context3D.clear();
		
		//计算出可见的BSPFace
		_invertCameraMatrix.copyFrom(_camera.getViewMatrix());
		_invertCameraMatrix.invert();
		_bsp.calculateVisibleFaces(_invertCameraMatrix.position);
		
		var faces:Vector<BSPFace> = _bsp.faces;
		var numFace:Int = faces.length;
		for (i in 0...numFace)
		{
			var face:BSPFace = faces[i];
			//判断某face是否可见
			face.setVisible(_bsp.facesSet.isSet(i));
		}

		var group:GroupGeometry = _bsp.group;
		
		//set attribute
		var buffer:VertexBuffer3D = group.getVertexBuffer();
		_testShader.setAttribute(_context3D,"a_position", buffer);
		_testShader.setAttribute(_context3D,"a_texCoord", buffer);
		_testShader.setAttribute(_context3D,"a_lightCoord", buffer);
		_testShader.setAttribute(_context3D,"a_normal", buffer);
		_testShader.setAttribute(_context3D, "a_color", buffer);
		
		var vpClone:Matrix3D = _camera.getViewProjectionMatrix().clone();
		vpClone.transpose();
		
		_testShader.setUniform(ShaderType.VERTEX, "u_modelProjection",vpClone.rawData);
		
		var geometrys:Vector<SubGeometry> = group.geometrys;
		var numGeom:Int = geometrys.length;
		for (i in 0...numGeom)
		{
			var geometry:IGeometry = geometrys[i];
			if (geometry.isVisible())
			{
				var texture:TextureBase = geometry.getMaterial().getTextureAt(0);
				if (texture != null)
				{
					_testShader.getTextureVar("s_texture").setTexture(texture);
				}
				
				texture = geometry.getMaterial().getTextureAt(1);
				if (texture != null)
				{
					_testShader.getTextureVar("s_lightmap").setTexture(texture);
				}
				
				_testShader.uploadUniform(_context3D);
				
				_context3D.drawTriangles(geometry.getIndexBuffer());
			}
		}
		
		_context3D.present();
	}
}