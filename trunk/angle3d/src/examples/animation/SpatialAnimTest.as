package examples.animation
{
	import flash.utils.Dictionary;

	import org.angle3d.animation.AnimChannel;
	import org.angle3d.animation.AnimControl;
	import org.angle3d.animation.Animation;
	import org.angle3d.animation.SpatialTrack;
	import org.angle3d.app.SimpleApplication;
	import org.angle3d.cinematic.LoopMode;
	import org.angle3d.material.MaterialVertexColor;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.shape.Box;
	import org.angle3d.scene.shape.Quad;

	public class SpatialAnimTest extends SimpleApplication
	{
		public function SpatialAnimTest()
		{
			super();
		}

		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			flyCam.setDragToRotate(true);

			var material : MaterialVertexColor = new MaterialVertexColor();

			// Create model
			var box : Box = new Box(1, 1, 1);
			var geom : Geometry = new Geometry("box", box);
			geom.setMaterial(material);
			var model : Node = new Node("model");
			model.attachChild(geom);

			var child : Box = new Box(0.5, 0.5, 0.5);
			var childGeom : Geometry = new Geometry("box", child);
			childGeom.setMaterial(material);
			var childModel : Node = new Node("childmodel");
			childModel.setTranslationXYZ(2, 2, 2);
			childModel.attachChild(childGeom);
			model.attachChild(childModel);

			//animation parameters
			var animTime : Number = 20;
			var fps : Number = 60;
			var totalXLength : int = 20;

			//calculating frames
			var totalFrames : int = int(fps * animTime);
			var dT : Number = animTime / totalFrames;
			var t : Number = 0;
			var dX : Number = totalXLength / totalFrames;
			var x : Number = -10;
			var times : Vector.<Number> = new Vector.<Number>(totalFrames);

			var translations : Vector.<Number> = new Vector.<Number>(totalFrames * 3);
			var rotations : Vector.<Number> = new Vector.<Number>(totalFrames * 4);
			var scales : Vector.<Number> = new Vector.<Number>(totalFrames * 3);

			var ds : Number = 1.0;

			var tmpQuat : Quaternion = new Quaternion();
			for (var i : int = 0; i < totalFrames; i++)
			{
				times[i] = t;
				t += dT;

				translations[i * 3] = x;
				translations[i * 3 + 1] = 0;
				translations[i * 3 + 2] = 0;
				x += dX;

				tmpQuat.fromAngles(i * 0.05, i * 0.04, i * 0.03); //Quaternion.IDENTITY;

				rotations[i * 4] = tmpQuat.x;
				rotations[i * 4 + 1] = tmpQuat.y;
				rotations[i * 4 + 2] = tmpQuat.z;
				rotations[i * 4 + 3] = tmpQuat.w;

				scales[i * 3] = ds;
				scales[i * 3 + 1] = ds;
				scales[i * 3 + 2] = ds;
				ds += 1 / totalFrames;
			}

			var spatialTrack : SpatialTrack = new SpatialTrack(times, translations, rotations, scales);

			//creating the animation
			var spatialAnimation : Animation = new Animation("anim", animTime);
			spatialAnimation.addTrack(spatialTrack);

			//create spatial animation control
			var control : AnimControl = new AnimControl();

			control.addAnimation("anim", spatialAnimation);

			model.addControl(control);

			scene.attachChild(model);

			//run animation
			var channel : AnimChannel = control.createChannel();
			channel.playAnimation("anim", LoopMode.Cycle, 1.0);
		}

		override public function simpleUpdate(tpf : Number) : void
		{
		}
	}
}
