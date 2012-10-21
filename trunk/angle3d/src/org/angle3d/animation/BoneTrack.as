package org.angle3d.animation
{
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.utils.TempVars;

	/**
	 * Contains a list of transforms and times for each keyframe.
	 *
	 */
	public class BoneTrack implements Track
	{
		/**
		* Bone index in the skeleton which this track effects.
		*/
		public var boneIndex:int;

		/**
		 * Transforms and times for track.
		 */
		public var translations:Vector.<Number>;
		public var rotations:Vector.<Number>;
		public var scales:Vector.<Number>;
		public var times:Vector.<Number>;
		public var totalFrame:int;

		private var useScale:Boolean=false;

		/**
		 * Creates a bone track for the given bone index
		 * @param targetBoneIndex the bone index
		 * @param times a float array with the time of each frame
		 * @param translations the translation of the bone for each frame
		 * @param rotations the rotation of the bone for each frame
		 * @param scales the scale of the bone for each frame
		 */
		public function BoneTrack(boneIndex:int, times:Vector.<Number>, translations:Vector.<Number>, rotations:Vector.<Number>, scales:Vector.<Number>=null)
		{
			this.boneIndex=boneIndex;
			this.setKeyframes(times, translations, rotations, scales);
		}

		public function setCurrentTime(time:Number, weight:Number, control:AnimControl, channel:AnimChannel, tempVars:TempVars):void
		{
			var tmpTranslation:Vector3f=tempVars.vect1;
			var tmpQuat:Quaternion=tempVars.quat1;

			var tmpTranslation2:Vector3f=tempVars.vect2;
			var tmpQuat2:Quaternion=tempVars.quat2;

			if (useScale)
			{
				var tmpScale:Vector3f=tempVars.vect3;
				var tmpScale2:Vector3f=tempVars.vect4;
			}

			var lastFrame:int=totalFrame - 1;
			if (lastFrame == 0 || time < 0 || time >= times[lastFrame])
			{
				var frame:int=0;
				if (time >= times[lastFrame])
				{
					frame=lastFrame;
				}

				getRotation(frame, tmpQuat);
				getTranslation(frame, tmpTranslation);
				if (useScale)
				{
					getScale(frame, tmpScale);
				}
			}
			else
			{
				var startFrame:int=0;
				var endFrame:int=1;

				//use lastFrame so we never overflow the array
				for (var i:int=0; i < lastFrame && times[i] < time; i++)
				{
					startFrame=i;
					endFrame=i + 1;
				}

				var blend:Number=(time - times[startFrame]) / (times[endFrame] - times[startFrame]);

				getRotation(startFrame, tmpQuat);
				getTranslation(startFrame, tmpTranslation);
				if (useScale)
				{
					getScale(startFrame, tmpScale);
				}

				getRotation(endFrame, tmpQuat2);
				getTranslation(endFrame, tmpTranslation2);
				if (useScale)
				{
					getScale(endFrame, tmpScale2);
				}

				tmpQuat.slerp(tmpQuat, tmpQuat2, blend);
				tmpTranslation.lerp(tmpTranslation, tmpTranslation2, blend);

				if (useScale)
				{
					tmpScale.lerp(tmpScale, tmpScale2, blend);
				}
			}

			var target:Bone=(control as SkeletonAnimControl).skeleton.getBoneAt(boneIndex);
			if (weight < 1.0)
			{
				target.blendAnimTransforms(tmpTranslation, tmpQuat, useScale ? tmpScale : null, weight);
			}
			else
			{
				target.setAnimTransforms(tmpTranslation, tmpQuat, useScale ? tmpScale : null);
			}
		}

		/**
		 * Set the translations and rotations for this bone track
		 * @param times a float array with the time of each frame
		 * @param translations the translation of the bone for each frame
		 * @param rotations the rotation of the bone for each frame
		 * @param scales the scale of the bone for each frame
		 */
		public function setKeyframes(times:Vector.<Number>, translations:Vector.<Number>, rotations:Vector.<Number>, scales:Vector.<Number>=null):void
		{

			CF::DEBUG
			{
				Assert.assert(times.length > 0, "BoneTrack with no keyframes!");
			}

			this.times=times;
			totalFrame=this.times.length;

			this.translations=translations;
			this.rotations=rotations;
			this.scales=scales;
			this.useScale=this.scales != null;
		}

		/**
		 * @return the time of the track
		 */
		public function get totalTime():Number
		{
			return times == null ? 0 : times[totalFrame - 1] - times[0];
		}

		public function clone():Track
		{
			//need implements
			return null;
		}

		[Inline]
		private final function getTranslation(index:int, vec3:Vector3f):void
		{
			var i3:int=index * 3;
			vec3.x=translations[i3];
			vec3.y=translations[int(i3 + 1)];
			vec3.z=translations[int(i3 + 2)];
		}

		[Inline]
		private final function getScale(index:int, vec3:Vector3f):void
		{
			var i3:int=index * 3;
			vec3.x=scales[i3];
			vec3.y=scales[int(i3 + 1)];
			vec3.z=scales[int(i3 + 2)];
		}

		[Inline]
		private final function getRotation(index:int, quat:Quaternion):void
		{
			var i4:int=index * 4;
			quat.x=rotations[i4];
			quat.y=rotations[int(i4 + 1)];
			quat.z=rotations[int(i4 + 2)];
			quat.w=rotations[int(i4 + 3)];
		}

	}
}

