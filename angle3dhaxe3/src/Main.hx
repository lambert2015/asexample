package ;

import flash.display3D.Context3D;
import flash.display3D.Context3DMipFilter;
import flash.display3D.Context3DTextureFilter;
import flash.display3D.Context3DWrapMode;
import flash.Lib;
import org.angle3d.math.Vector2f;
import org.angle3d.math.Vector3f;
import org.angle3d.math.Color;
import org.angle3d.math.Vector4f;
import org.angle3d.math.VectorUtil;
import org.angle3d.math.Line;
import org.angle3d.math.LineSegment;
import org.angle3d.math.Quaternion;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Transform;
import org.angle3d.math.Triangle;
import org.angle3d.math.Spline;
import org.angle3d.math.Ray;
import org.angle3d.math.Rect;
import org.angle3d.math.Plane;
import org.angle3d.math.CurveAndSurfaceMath;
import org.angle3d.utils.TempVars;
import org.angle3d.bounding.BoundingBox;
import org.angle3d.bounding.BoundingSphere;
import org.angle3d.bounding.Intersection;
import org.angle3d.texture.TextureMapBase;
import org.angle3d.texture.CubeTextureMap;
import org.angle3d.texture.ATFTexture;
import org.angle3d.texture.FrameBuffer;
import org.angle3d.texture.MipmapGenerator;
import org.angle3d.texture.ShadowCompareMode;
import org.angle3d.texture.Texture2D;
import org.angle3d.texture.TextureUtil;
import org.angle3d.texture.TextureType;
import org.angle3d.light.DirectionalLight;
import org.angle3d.light.Light;
import org.angle3d.light.LightType;
import org.angle3d.light.PointLight;
import org.angle3d.light.ShadowType;
import org.angle3d.light.SpotLight;
import org.angle3d.app.SimpleApplication;
import org.angle3d.animation.Animation;
import org.angle3d.animation.AnimChannel;
import org.angle3d.animation.AnimControl;
import org.angle3d.animation.Bone;
import org.angle3d.animation.BoneTrack;
import org.angle3d.animation.Skeleton;
import org.angle3d.animation.SkeletonAnimControl;
import org.angle3d.animation.SkeletonControl;
import org.angle3d.animation.SpatialTrack;
import org.angle3d.animation.Track;
import org.angle3d.app.Application;
import org.angle3d.app.state.AppStateManager;
import org.angle3d.material.Material;
import org.angle3d.material.RenderState;
import org.angle3d.material.technique.Technique;
import org.angle3d.material.MaterialSkyBox;
import org.angle3d.material.MaterialTexture;
import org.angle3d.material.MaterialColorFill;
import org.angle3d.scene.mesh.MorphMesh;
import org.angle3d.material.MaterialReflective;
import org.angle3d.material.MaterialRefraction;
/**
 * andy
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		trace(new Vector2f(4, 5));
		trace(new Vector3f(4, 5,6));
		trace(new Color(1, 0.5, 0.3, 1));
		trace(new Vector4f(1, 23.3, 4, 4));
		
		var technique = new Technique();
		trace(technique.name);
		
		//var context3d:Context3D = new Context3D();
		//context3d.setSamplerStateAt(0, Context3DWrapMode.CLAMP, Context3DTextureFilter.LINEAR, Context3DMipFilter.MIPLINEAR);
	}
	
}