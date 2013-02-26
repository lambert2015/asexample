package org.angle3d.app;
import flash.events.KeyboardEvent;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.ui.Keyboard;
import org.angle3d.input.controls.ActionListener;
import org.angle3d.input.controls.KeyTrigger;
import org.angle3d.input.FlyByCamera;
import org.angle3d.math.Quaternion;
import org.angle3d.renderer.queue.QueueBucket;
import org.angle3d.renderer.RenderManager;
import org.angle3d.scene.CullHint;
import org.angle3d.scene.Node;

/**
 * <code>SimpleApplication</code> extends the {@link com.jme3.app.Application}
 * class to provide default functionality like a first-person camera,
 * and an accessible root node that is updated and rendered regularly.
 * Additionally, <code>SimpleApplication</code> will display a statistics view
 * using the {@link com.jme3.app.StatsView} class. It will display
 * the current frames-per-second value on-screen in addition to the statistics.
 * Several keys have special functionality in <code>SimpleApplication</code>:<br/>
 *
 * <table>
 * <tr><td>Esc</td><td>- Close the application</td></tr>
 * <tr><td>C</td><td>- Display the camera position and rotation in the console.</td></tr>
 * <tr><td>M</td><td>- Display memory usage in the console.</td></tr>
 * </table>
 */
class SimpleApplication extends Application,implements ActionListener
{
	public static inline var INPUT_MAPPING_EXIT:String = "SIMPLEAPP_Exit";
    public static inline var INPUT_MAPPING_CAMERA_POS:String = "SIMPLEAPP_CameraPos";
	
    private var rootNode:Node;
	private var guiNode:Node;
	
	private var flyCam:FlyByCamera;

	public function new() 
	{
		super();
		
	}
	
	public function onAction(name:String,value:Bool,tpf:Float):Void 
	{
        if (!value) {
            return;
        }

        if (name == INPUT_MAPPING_EXIT) 
		{
            stop();
        } 
		else if (name == INPUT_MAPPING_CAMERA_POS) 
		{
            if (cam != null) 
			{
                var loc:Vector3f = cam.getLocation();
                var rot:Quaternion = cam.getRotation();
				#if debug
                Lib.trace("Camera Position: ("
                            + loc.x + ", " + loc.y + ", " + loc.z + ")");
                Lib.trace("Camera Rotation: " + rot);
                Lib.trace("Camera Direction: " + cam.getDirection());
				#end
            }
        }
    }
	
	/**
     * Retrieves flyCam
     * @return flyCam Camera object
     *
     */
    public function getFlyByCamera():FlyByCamera
	{
        return flyCam;
    }
	
	/**
     * Retrieves guiNode
     * @return guiNode Node object
     *
     */
	public function getGuiNode():Node
	{
		return guiNode;
	}
	
	/**
     * Retrieves rootNode
     * @return rootNode Node object
     *
     */
	public function getRootNode():Node
	{
		return rootNode;
	}
	
	override private function initialize():Void
	{
		super.initialize();
		
		rootNode = new Node("Root Node");
		viewPort.attachScene(rootNode);
		
		guiNode = new Node("Gui Node");
		guiNode.setQueueBucket(QueueBucket.Gui);
		guiNode.setCullHint(CullHint.Never);
		guiViewPort.attachScene(guiNode);
		
		if (inputManager != null)
		{
			flyCam = new FlyByCamera(cam);
			flyCam.setMoveSpeed(1.0);
			flyCam.registerWithInput(inputManager);
			
			inputManager.addSingleMapping(INPUT_MAPPING_CAMERA_POS, new KeyTrigger(Keyboard.C));
	        
			var arr:Array<String> = new Array<String>();
			arr[0] = INPUT_MAPPING_CAMERA_POS;
			
			inputManager.addListener(this, arr);
		}
		
		// call user code
		simpleInitApp();
	}
	
	override public function update():Void
	{
		super.update();
		
		//update states
		stateManager.update(tpf);
		
		 // simple update and root node
        simpleUpdate(tpf);
		
        rootNode.updateLogicalState(tpf);
        rootNode.updateGeometricState();
		
		guiNode.updateLogicalState(tpf);
        guiNode.updateGeometricState();

        // render states
        stateManager.render(renderManager);
		
        renderManager.render(tpf);
		
        simpleRender(renderManager);
		
        stateManager.postRender();
	}
	
	public function simpleInitApp():Void
	{
		start();
	}
	
	public function simpleUpdate(tpf:Float):Void
	{
		
	}
	
	public function simpleRender(rm:RenderManager):Void
	{
		
	}
}