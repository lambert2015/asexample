package org.angle3d.scene.mesh
{

	/**
	 * Type of buffer. Specifies the actual attribute it defines.
	 */
	public class BufferType
	{
		public static const VERTEX_TYPES:Array = [POSITION, TEXCOORD, NORMAL, COLOR, TANGENT, BINORMAL, BONE_WEIGHTS, BONE_INDICES, BIND_POSE_POSITION, TEXCOORD2, TEXCOORD3, TEXCOORD4, POSITION1, NORMAL1, PARTICLE_VELOCITY, PARTICLE_LIFE_SCALE_ANGLE];

		/**
		 * Position of the vertex (3 floats)
		 */
		public static const POSITION:String = "position";

		/**
		 * Texture coordinate
		 */
		public static const TEXCOORD:String = "texCoord";

		/**
		 * Normal vector, normalized.
		 */
		public static const NORMAL:String = "normal";

		/**
		 * Color
		 */
		public static const COLOR:String = "color";

		/**
		 * Tangent vector, normalized.
		 */
		public static const TANGENT:String = "tangent";

		/**
		 * Binormal vector, normalized.
		 */
		public static const BINORMAL:String = "binormal";

		/**
		 * Bone weights, used with animation (4 floats)
		 */
		public static const BONE_WEIGHTS:String = "boneWeights";

		/**
		 * Bone indices, used with animation (4 floats)
		 */
		public static const BONE_INDICES:String = "boneIndices";

		/**
		 * 只在CPU计算骨骼动画时使用
		 */
		public static const BIND_POSE_POSITION:String = "bindPosPosition";

		/**
		 * Texture coordinate #2
		 */
		public static const TEXCOORD2:String = "texCoord2";

		/**
		 * Texture coordinate #3
		 */
		public static const TEXCOORD3:String = "texCoord3";

		/**
		 * Texture coordinate #4
		 */
		public static const TEXCOORD4:String = "texCoord4";

		/**
		 * Position of the vertex (3 floats)
		 * wireframe时使用4个float,最后一个是thickness
		 * keyframe animation时使用3个float
		 */
		public static const POSITION1:String = "position1";

		/**
		 * Normal vector, normalized. (3 floats)
		 * keyframe animation
		 */
		public static const NORMAL1:String = "normal1";

		/**
		 * particle translate and rotation velocity. (4 floats)
		 * particle 移动速度和旋转速度
		 */
		public static const PARTICLE_VELOCITY:String = "particle_velocity";

		/**
		 * particle Life , Scale and Spin. (4 floats)
		 * particle
		 */
		public static const PARTICLE_LIFE_SCALE_ANGLE:String = "particle_life_scale_angle";

		/**
		 * particle acceleration. (3 floats)
		 * particle 加速度
		 */
		public static const PARTICLE_ACCELERATION:String = "particle_acceleration";
	}
}

