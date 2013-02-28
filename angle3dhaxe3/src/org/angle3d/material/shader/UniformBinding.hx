package org.angle3d.material.shader
{

	public final class UniformBinding
	{

		/**
		 * The world matrix. Converts Model space to World space.
		 * Type: mat4
		 */
		public static const WorldMatrix:Int = 0;

		/**
		 * The view matrix. Converts World space to View space.
		 * Type: mat4
		 */
		public static const ViewMatrix:Int = 1;

		/**
		 * The projection matrix. Converts View space to Clip/Projection space.
		 * Type: mat4
		 */
		public static const ProjectionMatrix:Int = 2;

		/**
		 * The world view matrix. Converts Model space to View space.
		 * Type: mat4
		 */
		public static const WorldViewMatrix:Int = 3;

		/**
		 * The normal matrix. The inverse transpose of the worldview matrix.
		 * Converts normals from model space to view space.
		 * Type: mat3
		 */
		public static const NormalMatrix:Int = 4;

		/**
		 * The world view projection matrix. Converts Model space to Clip/Projection space.
		 * Type: mat4
		 */
		public static const WorldViewProjectionMatrix:Int = 5;

		/**
		 * The view projection matrix. Converts Model space to Clip/Projection space.
		 * Type: mat4
		 */
		public static const ViewProjectionMatrix:Int = 6;


		public static const WorldMatrixInverse:Int = 7;
		public static const ViewMatrixInverse:Int = 8;
		public static const ProjectionMatrixInverse:Int = 9;
		public static const ViewProjectionMatrixInverse:Int = 10;
		public static const WorldViewMatrixInverse:Int = 11;
		public static const NormalMatrixInverse:Int = 12;
		public static const WorldViewProjectionMatrixInverse:Int = 13;

		/**
		 * Camera position in world space.
		 * Type: vec4
		 */
		public static const CameraPosition:Int = 14;

		/**
		 * Direction of the camera.
		 * Type: vec4
		 */
		public static const CameraDirection:Int = 15;

		/**
		 * ViewPort of the camera.
		 * Type: vec4
		 */
		public static const ViewPort:Int = 16;
	}
}

