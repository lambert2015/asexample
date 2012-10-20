package examples.shadow
{
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	
	public class ShadowTest extends SimpleApplication
	{
		public function ShadowTest()
		{
			super();
			
			this.addChild(new Stats());
		}
		
		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);
			
			flyCam.setDragToRotate(true);
		}
		
		override public function simpleUpdate(tpf : Number) : void
		{
		}
	}
}