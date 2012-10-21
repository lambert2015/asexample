package org.angle3d.input.controls
{
	import org.angle3d.utils.Assert;

	/**
	 * A <code>KeyTrigger</code> is used as a mapping to keyboard keys.
	 *
	 * @author Kirill Vainer
	 */
	public class KeyTrigger implements Trigger
	{
		public var keyCode:int;

		/**
		 * Create a new <code>KeyTrigger</code> for the given keycode.
		 *
		 * @param keyCode the code for the key, see constants in {@link KeyInput}.
		 */
		public function KeyTrigger(keyCode:int)
		{
			this.keyCode=keyCode;
		}

		public function getName():String
		{
			return "KeyCode " + keyCode;
		}

		public static function keyHash(keyCode:int):int
		{
			CF::DEBUG
			{
				Assert.assert(keyCode >= 0 && keyCode <= 255, "keycode must be between 0 and 255");
			}

			return keyCode & 0xff;
		}

		public function triggerHashCode():int
		{
			return keyHash(keyCode);
		}
	}
}

