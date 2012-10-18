package org.angle3d.cinematic;
import flash.events.EventDispatcher;
import flash.Vector;
import org.angle3d.cinematic.events.MotionPathEvent;
import org.angle3d.cinematic.tracks.MotionTrack;
import org.angle3d.material.ColorMaterial;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.math.Spline;
import org.angle3d.math.SplineType;
import org.angle3d.math.Vector2f;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.debug.WireframeCube;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.WireframeGeometry;
import org.angle3d.utils.TempVars;
/**
 * Motion path is used to create a path between way points.
 * @author Nehon
 */
class MotionPath extends EventDispatcher
{
	private var debugNode:Node;
	
	private var spline:Spline;
	
	private var eps:Float;
	
    /**
     * Create a motion Path
     */
	public function new() 
	{
		super();
		
		spline = new Spline();
		eps = 0.0001;
	}
	
	/**
     * interpolate the path giving the time since the beginnin and the motionControl     
     * this methods sets the new localTranslation to the spatial of the motionTrack control.
     * @param time the time since the animation started
     * @param control the ocntrol over the moving spatial
     */
	public function interpolatePath(time:Float, control:MotionTrack):Float
	{
        var val:Float;
        var traveledDistance:Float = 0;
		
        var vars:TempVars = TempVars.getTempVars();
        var temp:Vector3f = vars.vect1;
        var tmpVector:Vector3f = vars.vect2;
		
        switch (spline.getType())
		{
            case SplineType.CatmullRom:

                //this iterative process is done to keep the spatial travel at a constant speed on the path even if 
                //waypoints are not equally spread over the path

                // we compute the theorical distance that the spatial should travel on this frame
                val = (time * (spline.getTotalLength() / control.getDuration())) - control.getTraveledDistance();
                //adding and epsilon value to the control currents value
                control.setCurrentValue(control.getCurrentValue() + eps);
                //computing the new position at current value
                spline.interpolate(control.getCurrentValue(), control.getCurrentWayPoint(), temp);
                //computing traveled distance at current value
                var dist:Float = getDist(control, temp, tmpVector);

                //While the distance traveled this frame is below the theorical distance we iterate the obove computation
                while (dist < val) 
				{
                    //storing the distance traveled this frame
                    traveledDistance = dist;
                    control.setCurrentValue(control.getCurrentValue() + eps);
                    spline.interpolate(control.getCurrentValue(), control.getCurrentWayPoint(), temp);
                    dist = getDist(control, temp, tmpVector);
                }
                //compute the direction of the spline
                if (control.needsDirection()) 
				{
                    tmpVector.copyFrom(temp);
					tmpVector.subtractLocal(control.getSpatial().getLocalTranslation());
					tmpVector.normalizeLocal();
                    control.setDirection(tmpVector);
                }
                //updating traveled distance to the total distance traveled by the spatial since the start
                traveledDistance += control.getTraveledDistance();
				
            case SplineType.Linear:
                //distance traveled this frame
                val = (time * (spline.getTotalLength() / control.getDuration())) - control.getTraveledDistance();
                // computing total traveled distance
                traveledDistance = control.getTraveledDistance() + val;
                //computing interpolation ratio for this frame
                val = val / spline.getSegmentsLength()[control.getCurrentWayPoint()];
                control.setCurrentValue(FastMath.fmin(control.getCurrentValue() + val, 1.0));
                //interpolationg position
                spline.interpolate(control.getCurrentValue(), control.getCurrentWayPoint(), temp);
                //computing line direction
                if (control.needsDirection()) 
				{
                    tmpVector.copyFrom(spline.getControlPointAt(control.getCurrentWayPoint() + 1));
					tmpVector.subtractLocal(spline.getControlPointAt(control.getCurrentWayPoint()));
					tmpVector.normalizeLocal();
                    control.setDirection(tmpVector);
                }
			default:
				//
        }
		
        control.getSpatial().setLocalTranslation(temp);
		
        vars.release();
		
        return traveledDistance;
    }
	
	/**
     * computes the distance between the spatial position and the temp vector.
     * @param control the control holding the psatial 
     * @param temp the temp position
     * @param store a temp vector3f to store the result
     * @return 
     */
    private function getDist(control:MotionTrack, temp:Vector3f, store:Vector3f):Float
	{
        store.copyFrom(temp);
        store.subtractLocal(control.getSpatial().getLocalTranslation());
		return store.length;
    }
	
	private function attachDebugNode(root:Node):Void
	{
        if (debugNode == null) 
		{
            debugNode = new Node("MotionPath_debug");

			var points:Vector<Vector3f> = spline.getControlPoints();
			for (i in 0...points.length)
			{
				var geo:WireframeGeometry = new WireframeGeometry("sphere" + i, new WireframeCube(0.5,0.5,0.5,0xffff00,1));
				geo.setLocalTranslation(points[i]);
				debugNode.attachChild(geo);
			}
			
			//TODO 目前还不能画线，所以暂时不添加
            //switch (spline.getType()) 
			//{
                //case SplineType.CatmullRom:
                    //debugNode.attachChild(createCatmullRomPath());
                //case SplineType.Linear:
                    //debugNode.attachChild(createLinearPath());
                //default:
                    //debugNode.attachChild(createLinearPath());
            //}

            root.attachChild(debugNode);
        }
    }
	
	private function createLinearPath():Geometry
	{
        var mat:ColorMaterial = new ColorMaterial();
		mat.setColor(Color.Blue);
		
        var lineGeometry:Geometry = new Geometry("line", null);//new Curve(spline, 0));
        lineGeometry.setMaterial(mat);
        return lineGeometry;
    }

    private function createCatmullRomPath():Geometry
	{
        var mat:ColorMaterial = new ColorMaterial();
		mat.setColor(Color.Blue);
		
        var lineGeometry:Geometry = new Geometry("line", null);//new Curve(spline, 0));
        lineGeometry.setMaterial(mat);
        return lineGeometry;
    }
	
	/**
     * compute the index of the waypoint and the interpolation value according to a distance
     * returns a vector 2 containing the index in the x field and the interpolation value in the y field
     * @param distance the distance traveled on this path
     * @return the waypoint index and the interpolation value in a vector2
     */
    public function getWayPointIndexForDistance(distance:Float):Vector2f
	{
        var sum:Float = 0;
        distance = distance % spline.getTotalLength();
		var list:Vector<Float> = spline.getSegmentsLength();
        for (i in 0...list.length) 
		{
			var len:Float = list[i];
            if (sum + len >= distance) 
			{
                return new Vector2f(i, (distance - sum) / len);
            }
            sum += len;
        }
        return new Vector2f(spline.getControlPoints().length - 1, 1.0);
    }
	
	/**
     * Addsa waypoint to the path
     * @param wayPoint a position in world space
     */
	public function addWayPoint(wayPoint:Vector3f):Void
	{
		spline.addControlPoint(wayPoint);
	}
	
	/**
     * retruns the length of the path in world units
     * @return the length
     */
	public function getLength():Float
	{
		return spline.getTotalLength();
	}
	
	/**
     * returns the waypoint at the given index
     * @param i the index
     * @return returns the waypoint position
     */
	public function getWayPoint(i:Int):Vector3f
	{
		return spline.getControlPointAt(i);
	}
	
	/**
     * remove the waypoint from the path
     * @param wayPoint the waypoint to remove
     */
	public function removeWayPoint(wayPoint:Vector3f):Void
	{
		spline.removeControlPoint(wayPoint);
	}
	
	/**
     * remove the waypoint at the given index from the path
     * @param i the index of the waypoint to remove
     */
	public function removeWayPointAt(i:Int):Void
	{
		spline.removeControlPoint(getWayPoint(i));
	}
	
	/**
     * return the type of spline used for the path interpolation for this path
     * @return the path interpolation spline type
     */
	public function getSplineType():SplineType
	{
		return spline.getType();
	}
	
	/**
     * sets the type of spline used for the path interpolation for this path
     * @param pathSplineType
     */
	public function setSplineType(type:SplineType):Void
	{
		spline.setType(type);
		
		refreshDebugNode();
	}
	
	/**
	 * 重新生成debugNode
	 */
	private function refreshDebugNode():Void
	{
		if (debugNode != null) 
		{
            var parent:Node = debugNode.getParent();
            debugNode.removeFromParent();
            debugNode.detachAllChildren();
            debugNode = null;
            attachDebugNode(parent);
        }
	}
	
	/**
     * disable the display of the path and the waypoints
     */
	public function disableDebugShape():Void
	{
		debugNode.detachAllChildren();
		debugNode = null;
	}
	
	/**
     * enable the display of the path and the waypoints
     * @param manager the assetManager
     * @param rootNode the node where the debug shapes must be attached
     */
	public function enableDebugShape(rootNode:Node):Void
	{
		attachDebugNode(rootNode);
	}
	
	/**
     * return the number of waypoints of this path
     * @return
     */
	public function getNumWayPoints():Int
	{
		return spline.getControlPoints().length;
	}
	
	public function triggerWayPointReach(wayPointIndex:Int, control:MotionTrack) 
	{
        dispatchEvent(new MotionPathEvent(control, wayPointIndex, MotionPathEvent.ON_WAYPOINT_REACH));
    }
	
	/**
     * Returns the curve tension
     * @return
     */
	public function getCurveTension():Float
	{
		return spline.getCurveTension();
	}
	
	/**
     * sets the tension of the curve (only for catmull rom) 0.0 will give a linear curve, 1.0 a round curve
     * @param curveTension
     */
	public function setCurveTension(curveTension:Float):Void
	{
		spline.setCurveTension(curveTension);
		
		refreshDebugNode();
	}
	
	public function clearWayPoints():Void
	{
		spline.clearControlPoints();
	}
	
	/**
     * Sets the path to be a cycle
     * @param cycle
     */
	public function setCycle(cycle:Bool):Void
	{
		spline.setCycle(cycle);
		
		refreshDebugNode();
	}
	
	/**
     * returns true if the path is a cycle
     * @return
     */
	public function isCycle():Bool
	{
		return spline.isCycle();
	}
	
	public function getSpline():Spline
	{
        return spline;
    }
}