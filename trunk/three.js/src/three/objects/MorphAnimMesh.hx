package three.objects;
import three.core.Geometry;
import three.core.Object3D;
import three.core.BufferGeometry;
import three.materials.Material;
import three.materials.MeshBasicMaterial;
import three.utils.Logger;
import three.math.MathUtil;
/**
 * ...
 * @author 
 */
typedef Animation  = {
	var start:Int;
	var end:Int;
}

class MorphAnimMesh extends Mesh
{
	public var duration:Float;
	public var mirroredLoop:Bool;
	public var time:Float;
	
	public var lastKeyframe:Int;
	public var currentKeyframe:Int;
	
	public var startKeyframe:Int;
	public var endKeyframe:Int;
	public var length:Int;
	
	public var direction:Int;
	public var directionBackwards:Bool;
	
	public var animations:Dynamic;

	public function new(geometry:BufferGeometry, material:Material = null ) 
	{
		super(geometry, material);
		
		this.duration = 1000;
		// milliseconds
		this.mirroredLoop = false;
		this.time = 0;

		// internals

		this.lastKeyframe = 0;
		this.currentKeyframe = 0;

		this.direction = 1;
		this.directionBackwards = false;

		this.setFrameRange(0, this.geometry.morphTargets.length - 1);
	}
	
	public function setFrameRange(start:Int, end:Int):Void
	{
		this.startKeyframe = start;
		this.endKeyframe = end;

		this.length = this.endKeyframe - this.startKeyframe + 1;
	}

	public function setDirectionForward():Void
	{
		this.direction = 1;
		this.directionBackwards = false;
	}

	public function setDirectionBackward():Void
	{
		this.direction = -1;
		this.directionBackwards = true;
	}

	public function parseAnimations():Void 
	{
		var geometry:BufferGeometry = this.geometry;

		if (geometry.animations == null)
			geometry.animations = {};

		var firstAnimation:String = "";
		var animations = geometry.animations;

		var pattern:EReg = ~/([a-z]+)(\d+)/;

		for (i in 0...geometry.morphTargets.length) 
		{
			var morph = geometry.morphTargets[i];
			var morphName:String = morph.name;
			var parts:Array<String> =  untyped morphName.match(pattern);

			if (parts != null && parts.length > 1) 
			{
				var label:String = parts[1];
				var num:String = parts[2];

				var animation:Animation = Reflect.getProperty(animations, label);
				if (animation == null) 
				{
					animation = { start : Std.int(Math.POSITIVE_INFINITY), end : Std.int(Math.NEGATIVE_INFINITY) };
					Reflect.setField(animations, label, animation );
				}

				if (i < animation.start)
					animation.start = i;
				if (i > animation.end)
					animation.end = i;

				if (firstAnimation == "")
					firstAnimation = label;
			}

		}

		geometry.firstAnimation = firstAnimation;
	}

	public function setAnimationLabel(label:String, start:Int, end:Int):Void
	{
		if (this.geometry.animations == null)
			this.geometry.animations = { };
		
		Reflect.setField(this.geometry.animations, label, { start : start, end : end });
	}

	public function playAnimation(label:String, fps:Int):Void 
	{
		var animation:Animation = Reflect.getProperty(this.geometry.animations, label);
		if (animation != null) 
		{
			this.setFrameRange(animation.start, animation.end);
			this.duration = 1000 * ((animation.end - animation.start ) / fps );
			this.time = 0;
		} 
		else 
		{
			Logger.warn("animation[" + label + "] undefined");
		}
	}

	public function updateAnimation(delta:Float):Void 
	{
		var frameTime:Float = this.duration / this.length;

		this.time += this.direction * delta;

		if (this.mirroredLoop) 
		{
			if (this.time > this.duration || this.time < 0) 
			{
				this.direction *= -1;

				if (this.time > this.duration) 
				{
					this.time = this.duration;
					this.directionBackwards = true;
				}

				if (this.time < 0) 
				{
					this.time = 0;
					this.directionBackwards = false;
				}
			}
		} 
		else 
		{
			this.time = this.time % this.duration;

			if (this.time < 0)
				this.time += this.duration;
		}

		var keyframe:Int = Std.int(this.startKeyframe + MathUtil.clamp(Math.floor(this.time / frameTime), 0, this.length - 1));

		if (keyframe != this.currentKeyframe) 
		{
			this.morphTargetInfluences[this.lastKeyframe] = 0;
			this.morphTargetInfluences[this.currentKeyframe] = 1;

			this.morphTargetInfluences[keyframe] = 0;

			this.lastKeyframe = this.currentKeyframe;
			this.currentKeyframe = keyframe;

		}

		var mix = (this.time % frameTime ) / frameTime;

		if (this.directionBackwards) 
		{
			mix = 1 - mix;
		}

		this.morphTargetInfluences[this.currentKeyframe] = mix;
		this.morphTargetInfluences[this.lastKeyframe] = 1 - mix;
	}
}