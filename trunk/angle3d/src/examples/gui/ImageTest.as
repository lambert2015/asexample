package examples.gui
{
	
	import org.angle3d.utils.Stats;
	
	import org.angle3d.app.SimpleApplication;
	import examples.skybox.DefaultSkyBox;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.ui.Image;
	import org.angle3d.texture.Texture2D;
	
	public class ImageTest extends SimpleApplication
	{
		private var image:Image;
		
		[Embed(source = "../../../assets/embed/no-shader.png")]
		private static var EmbedPositiveZ:Class;
		
		public function ImageTest()
		{
			super();

			this.addChild(new Stats());
		}
		
		override protected function initialize(width : int, height : int) : void
		{
			super.initialize(width, height);

			var texture:Texture2D = new Texture2D(new EmbedPositiveZ().bitmapData);
			//var textureMat:MaterialTexture = new MaterialTexture(texture);
			
			image = new Image("image",false);
			image.move(new Vector3f(0,0,-1));
			image.setPosition(200,200);
			image.setSize(200,200);
			image.setTexture(texture,true);
			gui.attachChild(image);
			
			var skybox : DefaultSkyBox = new DefaultSkyBox(500);
			scene.attachChild(skybox);
		}

		override public function simpleUpdate(tpf : Number) : void
		{
		}
	}
}

