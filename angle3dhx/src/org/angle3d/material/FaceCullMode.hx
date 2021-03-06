package org.angle3d.material;

/**
 * <code>FaceCullMode</code> specifies the criteria for faces to be culled.
 * 
 * @see RenderState#setFaceCullMode(FaceCullMode) 
 */
class FaceCullMode 
{

	/**
     * Face culling is disabled.
     */
    public static inline var Off:Int = 0;
	
    /**
     * Cull front faces
     */
    public static inline var Front:Int = 1;
	
    /**
     * Cull back faces
     */
    public static inline var Back:Int = 2;
	
    /**
     * Cull both front and back faces.
     */
    public static inline var FrontAndBack:Int = 3;
}