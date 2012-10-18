package org.angle3d.animation
{
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Spatial;
	import org.angle3d.utils.Assert;
	import org.angle3d.utils.TempVars;

	/**
	 * This public class represents the track for spatial animation.
	 *
	 * @author Marcin Roguski (Kaelthas)
	 */
	public class SpatialTrack implements Track
	{
		/**
		 * Translations of the track.
		 */
		private var translations : Vector.<Number>;
		/**
		 * Rotations of the track.
		 */
		private var rotations : Vector.<Number>;
		/**
		 * Scales of the track.
		 */
		private var scales : Vector.<Number>;
		/**
		 * The times of the animations frames.
		 */
		private var times : Vector.<Number>;

		public function SpatialTrack(times : Vector.<Number>,
			translations : Vector.<Number> = null,
			rotations : Vector.<Number> = null,
			scales : Vector.<Number> = null)
		{
			setKeyframes(times, translations, rotations, scales);
		}

		/**
		 *
		 * Modify the spatial which this track modifies.
		 *
		 * @param time
		 *            the current time of the animation
		 * @param spatial
		 *            the spatial that should be animated with this track
		 */
		public function setCurrentTime(time : Number, weight : Number, control : AnimControl, channel : AnimChannel, vars : TempVars) : void
		{
			var tempV : Vector3f = vars.vect1;
			var tempS : Vector3f = vars.vect2;
			var tempQ : Quaternion = vars.quat1;
			var tempV2 : Vector3f = vars.vect3;
			var tempS2 : Vector3f = vars.vect4;
			var tempQ2 : Quaternion = vars.quat2;

			var lastFrame : int = times.length - 1;
			if (lastFrame == 0 || time < 0 || time >= times[lastFrame])
			{
				var frame : int = 0;
				if (time >= times[lastFrame])
				{
					frame = lastFrame;
				}

				if (rotations != null)
				{
					getRotation(frame, tempQ);
				}
				if (translations != null)
				{
					getTranslation(frame, tempV);
				}
				if (scales != null)
				{
					getScale(frame, tempS);
				}
			}
			else
			{
				var startFrame : int = 0;
				var endFrame : int = 1;
				// use lastFrame so we never overflow the array
				for (var i : int = 0; i < lastFrame && times[i] < time; i++)
				{
					startFrame = i;
					endFrame = i + 1;
				}

				var blend : Number = (time - times[startFrame]) / (times[endFrame] - times[startFrame]);

				if (rotations != null)
				{
					getRotation(startFrame, tempQ);
					getRotation(endFrame, tempQ2);
				}
				if (translations != null)
				{
					getTranslation(startFrame, tempV);
					getTranslation(endFrame, tempV2);
				}
				if (scales != null)
				{
					getScale(startFrame, tempS);
					getScale(endFrame, tempS2);
				}

				tempQ.slerp(tempQ, tempQ2, blend);
				tempV.lerp(tempV, tempV2, blend);
				tempS.lerp(tempS, tempS2, blend);
			}

			var spatial : Spatial = control.spatial;

			if (translations != null)
			{
				spatial.setTranslation(tempV);
			}

			if (rotations != null)
			{
				spatial.setRotation(tempQ);
			}

			if (scales != null)
			{
				spatial.setScale(tempS);
			}
		}

		/**
		 * Set the translations and rotations for this bone track
		 * @param times a float array with the time of each frame
		 * @param translations the translation of the bone for each frame
		 * @param rotations the rotation of the bone for each frame
		 */
		public function setKeyframes(times : Vector.<Number>,
			translations : Vector.<Number>,
			rotations : Vector.<Number>,
			scales : Vector.<Number> = null) : void
		{
			Assert.assert(times.length > 0, "SpatialTrack with no keyframes!");

			this.times = times;
			this.translations = translations;
			this.rotations = rotations;
			this.scales = scales;
		}


		/**
		 * @return the length of the track
		 */
		public function get totalTime() : Number
		{
			return times == null ? 0 : times[times.length - 1] - times[0];
		}

		public function clone() : Track
		{
			//need implements
			return null;
		}

		private function getTranslation(index : int, vec3 : Vector3f) : void
		{
			var i3 : int = index * 3;
			vec3.x = translations[i3];
			vec3.y = translations[int(i3 + 1)];
			vec3.z = translations[int(i3 + 2)];
		}

		private function getScale(index : int, vec3 : Vector3f) : void
		{
			var i3 : int = index * 3;
			vec3.x = scales[i3];
			vec3.y = scales[int(i3 + 1)];
			vec3.z = scales[int(i3 + 2)];
		}

		private function getRotation(index : int, quat : Quaternion) : void
		{
			var i4 : int = index * 4;
			quat.x = rotations[i4];
			quat.y = rotations[int(i4 + 1)];
			quat.z = rotations[int(i4 + 2)];
			quat.w = rotations[int(i4 + 3)];
		}

	}
}

