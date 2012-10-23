package org.angle3d.material.shader
{

	public final class UniformBinding
	{

		/**
		 * The world matrix. Converts Model space to World space.
		 * Type: mat4
		 */
		public static const WorldMatrix:int = 0;

		/**
		 * The view matrix. Converts World space to View space.
		 * Type: mat4
		 */
		public static const ViewMatrix:int = 1;

		/**
		 * The projection matrix. Converts View space to Clip/Projection space.
		 * Type: mat4
		 */
		public static const ProjectionMatrix:int = 2;

		/**
		 * The world view matrix. Converts Model space to View space.
		 * Type: mat4
		 */
		public static const WorldViewMatrix:int = 3;

		/**
		 * The normal matrix. The inverse transpose of the worldview matrix.
		 * Converts normals from model space to view space.
		 * Type: mat3
		 */
		public static const NormalMatrix:int = 4;

		/**
		 * The world view projection matrix. Converts Model space to Clip/Projection space.
		 * Type: mat4
		 */
		public static const WorldViewProjectionMatrix:int = 5;

		/**
		 * The view projection matrix. Converts Model space to Clip/Projection space.
		 * Type: mat4
		 */
		public static const ViewProjectionMatrix:int = 6;


		public static const WorldMatrixInverse:int = 7;
		public static const ViewMatrixInverse:int = 8;
		public static const ProjectionMatrixInverse:int = 9;
		public static const ViewProjectionMatrixInverse:int = 10;
		public static const WorldViewMatrixInverse:int = 11;
		public static const NormalMatrixInverse:int = 12;
		public static const WorldViewProjectionMatrixInverse:int = 13;

		/**
		 * Camera position in world space.
		 * Type: vec4
		 */
		public static const CameraPosition:int = 14;

		/**
		 * Direction of the camera.
		 * Type: vec4
		 */
		public static const CameraDirection:int = 15;

		/**
		 * ViewPort of the camera.
		 * Type: vec4
		 */
		public static const ViewPort:int = 16;
	}
}

