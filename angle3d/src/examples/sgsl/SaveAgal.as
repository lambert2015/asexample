package examples.sgsl
{
	import com.adobe.utils.AGALMiniAssembler2;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class SaveAgal extends Sprite
	{
		private var _data:ByteArray;

		public function SaveAgal()
		{
			var vertexSrc:String =
				"mov vt0.x va1.x\n" +
				"mov vt0.x vc0.x\n" +
				"mul vt1 vt0.x vc[va2.x+5]\n" +
				"mov vt2 vt1\n" +
				"mul vt1 vt0.x vc[va2.x+6]\n" +
				"mov vt3 vt1\n" +
				"mul vt1 vt0.x vc[va2.x+7]\n" +
				"mov vt4 vt1\n" +
				"m34 vt0.xyz va0 vt2\n" +
				"mov vt0.w vc0.x\n" +
				"m44 op vt0 vc1";

			var fragmentSrc:String = "mov fd0 v0";

			_data = new AGALMiniAssembler2().assemble("fragment", fragmentSrc, 2);

			this.stage.addEventListener(MouseEvent.CLICK, _saveData);
		}

		private function _saveData(e:MouseEvent):void
		{
			new FileReference().save(_data, "vertex.agal");
		}
	}
}

