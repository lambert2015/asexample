package org.angle3d.scene.mesh;

/**
 * Type of buffer. Specifies the actual attribute it defines.
 */
class BufferType 
{
	/**
     * Specifies the index buffer, must contain integer data
     */
	public static inline var Index:String = "index";

	/**
     * Position of the vertex (3 floats)
     */
    public static inline var Position:String = "position";
	
	/**
     * Texture coordinate
     */
    public static inline var TexCoord:String = "texCoord";

    /**
     * Normal vector, normalized.
     */
    public static inline var Normal:String = "normal";
	
    /**
     * Color and Alpha (4 floats)
     */
    public static inline var Color:String = "color";

    /**
     * Tangent vector, normalized.
     */
    public static inline var Tangent:String = "tangent";

    /**
     * Binormal vector, normalized.
     */
    public static inline var Binormal:String = "binormal";

    /** 
     * Bone weights, used with animation
     */
    public static inline var BoneWeight:String = "boneWeight";

    /** 
     * Bone indices, used with animation
     */
    public static inline var BoneIndex:String = "boneIndex";

    /**
     * Texture coordinate #2
     */
    public static inline var TexCoord2:String = "texCoord2";

    /**
     * Texture coordinate #3
     */
    public static inline var TexCoord3:String = "texCoord3";

    /**
     * Texture coordinate #4
     */
    public static inline var TexCoord4:String = "texCoord4";
	
	/**
     * Position of the vertex (3 floats)
	 * wireframe
     */
    public static inline var Position1:String = "position1";
	
	/**
     * thickness of the line (1 floats)
	 * wireframe
     */
    public static inline var Thickness:String = "thickness";
}