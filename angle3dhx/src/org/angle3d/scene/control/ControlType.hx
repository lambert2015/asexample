package org.angle3d.scene.control;

/**
 * The type of control.
 *
 * @author Kirill Vainer.
 */
class ControlType 
{
	/**
     * Manages the level of detail for the model.
     */
	public static inline var LevelOfDetail:String = "levelOfDetail";

    /**
     * Provides methods to manipulate the skeleton and bones.
     */
    public static inline var BoneControl:String = "boneControl";

    /**
     * Handles the bone animation and skeleton updates.
     */
    public static inline var BoneAnimation:String = "boneAnimation";

    /**
     * Handles attachments to bones
     */
    public static inline var Attachment:String = "attachment";

    /**
     * Handles vertex/morph animation.
     */
    public static inline var VertexAnimation:String = "vertexAnimation";

    /**
     * Handles poses or morph keys.
     */
    public static inline var Pose:String = "pose";

    /**
     * Handles particle updates
     */
    public static inline var Particle:String = "particle";
}