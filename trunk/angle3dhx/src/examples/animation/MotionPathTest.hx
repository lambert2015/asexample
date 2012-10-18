package examples.animation;

import flash.Lib;
import org.angle3d.animation.LoopMode;
import org.angle3d.app.SimpleApplication;
import org.angle3d.cinematic.events.MotionPathEvent;
import org.angle3d.cinematic.MotionPath;
import org.angle3d.cinematic.tracks.Direction;
import org.angle3d.cinematic.tracks.MotionTrack;
import org.angle3d.input.ChaseCamera;
import org.angle3d.material.MaterialVertexColor;
import org.angle3d.math.FastMath;
import org.angle3d.math.Quaternion;
import org.angle3d.math.SplineType;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.shape.Box;
import examples.Stats;

class MotionPathTest extends SimpleApplication
{
	private var box:Geometry;
	
	private var path:MotionPath;
    private var motionControl:MotionTrack;

	public function new()
	{
		super();

	    this.addChild(new Stats());
	}
	
	override private function initialize():Void
	{
		super.initialize();
		
		createScene();
		
		cam.setLocation(new Vector3f(8.4399185, 11.189463, 14.267577));
		cam.lookAt(new Vector3f(), Vector3f.Y_AXIS);
		
		path = new MotionPath();
		path.setCycle(true);
		path.addWayPoint(new Vector3f(10, 3, 0));
        path.addWayPoint(new Vector3f(10, 3, 10));
        path.addWayPoint(new Vector3f(-40, 3, 10));
        path.addWayPoint(new Vector3f(-40, 3, 0));
        path.addWayPoint(new Vector3f(-40, 8, 0));
        path.addWayPoint(new Vector3f(10, 8, 0));
        path.addWayPoint(new Vector3f(10, 8, 10));
        path.addWayPoint(new Vector3f(15, 8, 10));
        path.enableDebugShape(rootNode);
		path.setSplineType(SplineType.CatmullRom);
		
		path.addEventListener(MotionPathEvent.ON_WAYPOINT_REACH, _onWayPointReach);
		
		motionControl = new MotionTrack(box, path, 10, LoopMode.Loop);
        motionControl.setDirectionType(Direction.PathAndRotation);
		var rot:Quaternion = new Quaternion();
		rot.fromAngleNormalAxis( -FastMath.HALF_PI, Vector3f.Y_AXIS);
        motionControl.setRotation(rot);
        motionControl.setInitialDuration(10);
        motionControl.setSpeed(1);
		motionControl.play();
		
		flyCam.setDragToRotate(true);
		flyCam.setMoveSpeed(2.0);
		flyCam.setEnabled(false);
		
		var cc:ChaseCamera = new ChaseCamera(this.cam, box, inputManager);
		cc.setEnabled(true);
	}
	
	private function createScene():Void
	{
		box = new Geometry("box", new Box(1, 1, 1));
		
		var mat:MaterialVertexColor = new MaterialVertexColor();
		box.setMaterial(mat);
		
		rootNode.attachChild(box);
	}
	
	override public function simpleUpdate(tpf:Float):Void
	{
	}
	
	private function _onWayPointReach(e:MotionPathEvent):Void
	{
		Lib.trace("currentPointIndex is "+e.getWayPointIndex());
	}
	
	static function main() 
	{
		Lib.current.addChild(new MotionPathTest());
	}
}
