package org.angle3d.scene.control
{

	/**
	 * The type of control.
	 *
	 * @author Kirill Vainer.
	 */
	public class ControlType
	{
		/**
		 * Manages the level of detail for the model.
		 */
		public static const LevelOfDetail:String = "levelOfDetail";

		/**
		 * Provides methods to manipulate the skeleton and bones.
		 */
		public static const BoneControl:String = "boneControl";

		/**
		 * Handles the bone animation and skeleton updates.
		 */
		public static const BoneAnimation:String = "boneAnimation";

		/**
		 * Handles attachments to bones
		 */
		public static const Attachment:String = "attachment";

		/**
		 * Handles vertex/morph animation.
		 */
		public static const VertexAnimation:String = "vertexAnimation";

		/**
		 * Handles poses or morph keys.
		 */
		public static const Pose:String = "pose";

		/**
		 * Handles particle updates
		 */
		public static const Particle:String = "particle";
	}
}

