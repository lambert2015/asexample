package org.angle3d.scene.control;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.Spatial;
import flash.errors.Error;

/**
 * An abstract implementation of the Control interface.
 *
 * @author Kirill Vainer
 */

class AbstractControl implements Control
{
    private var enabled:Bool;
	private var spatial:Spatial;
	
	public function new() 
	{
		enabled = true;
	}
	
	public function setSpatial(spatial:Spatial):Void
	{
		if (this.spatial != null && spatial != null) 
		{
            throw new Error("This control has already been added to a Spatial");
        } 
		
        this.spatial = spatial;
    }
	
	public function getSpatial():Spatial
	{
		return spatial;
	}

    public function setEnabled(enabled:Bool):Void 
	{
        this.enabled = enabled;
    }

    public function isEnabled():Bool 
	{
        return enabled;
    }

    public function update(tpf:Float):Void
	{
        if (!enabled)
            return;

        controlUpdate(tpf);
    }
	
	/**
     * To be implemented in subclass.
     */
    private function controlUpdate(tpf:Float):Void
	{
		
	}

    public function render(rm:RenderManager,vp:ViewPort):Void
	{
        if (!enabled)
            return;

        controlRender(rm, vp);
    }
	
	/**
     * To be implemented in subclass.
     */
    private function controlRender(rm:RenderManager,vp:ViewPort):Void
	{
		
	}
	
	public function cloneForSpatial(newSpatial:Spatial):Control
	{
		return null;
	}
	
}