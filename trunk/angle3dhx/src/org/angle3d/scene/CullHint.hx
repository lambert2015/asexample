package org.angle3d.scene;

/**
 * CullHint
 * @author andy
 */
class CullHint 
{
	/** 
     * Do whatever our parent does. If no parent, we'll default to dynamic.
     */
    public static inline var Inherit:Int = 0;
    /**
     * Do not draw if we are not at least partially within the view frustum
     * of the renderer's camera.
     */
    public static inline var Auto:Int = 1;
    /** 
     * Always cull this from view.
     */
    public static inline var Always:Int = 2;
    /**
     * Never cull this from view. Note that we will still get culled if our
     * parent is culled.
     */
    public static inline var Never:Int = 3;
	
}