package yanyan.camera
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.geom.Matrix3D;

	/**
	 * 
	 * 基础的相机类 
	 * 
	 * @author harry
	 * @date 11.07 2012
	 * 
	 */
	public class BaseCamera
	{
		protected var mTransform:Matrix3D = null;
		protected var mEyeTransform:Matrix3D = null;
		
		protected var mProjectionMatrix:PerspectiveMatrix3D = null;
		
		public function BaseCamera()
		{
			mTransform = new Matrix3D();
			mTransform.identity();
			
			mEyeTransform = new Matrix3D();
			mEyeTransform.identity();
			
			mProjectionMatrix = new PerspectiveMatrix3D();
			mProjectionMatrix.identity();
			mProjectionMatrix.perspectiveFieldOfViewRH(45.0*Math.PI/180, 1000/600, 0.01, 5000.0);
		}
		
		/*
		 * 获取相机坐标系转换矩阵 
		 * 
		 * 
		 */
		public function get eye():Matrix3D
		{
			mEyeTransform.copyFrom( mTransform );
			mEyeTransform.invert();
			
			return mEyeTransform;
		}
		
		public function get transform():Matrix3D
		{
			return mTransform;
		}
		
		/*
		 * 获取透视变换矩阵
		 *  
		 * 
		 */
		public function get projectionMatrix():PerspectiveMatrix3D
		{
			return mProjectionMatrix;
		}
		
	}
}