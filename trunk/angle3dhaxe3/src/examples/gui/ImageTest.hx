package examples.gui
{

	import org.angle3d.app.SimpleApplication;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.MaterialTexture;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.ui.Picture;
	import org.angle3d.texture.Texture2D;
	import org.angle3d.utils.Stats;

	public class ImageTest extends SimpleApplication
	{
		private var image:Picture;
		private var image2:Picture;

		[Embed(source = "../../../assets/crate256.jpg")]
		private static var EmbedPositiveZ:Class;

		[Embed(source = "../../../assets/embed/t351sml.jpg")]
		private static var Embed2:Class;

		public function ImageTest()
		{
			super();

			this.addChild(new Stats());
		}

		private var material:MaterialTexture;
		private var material2:MaterialTexture;

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			flyCam.setEnabled(false);

			var texture:Texture2D = new Texture2D(new EmbedPositiveZ().bitmapData);
			var texture2:Texture2D = new Texture2D(new Embed2().bitmapData);

			image = new Picture("image", false);
			image.move(new Vector3f(0, 0, -1));
			image.setPosition(200, 200);
			image.setSize(400, 400);
			image.setTexture(texture, true);


			material = image.getMaterial() as MaterialTexture;

			image2 = new Picture("image2", false);
			image2.move(new Vector3f(0, 0, 10));
			image2.setPosition(250, 200);
			image2.setSize(300, 300);
			image2.setTexture(texture2, true);

			gui.attachChild(image);
			gui.attachChild(image2);

			material2 = image2.getMaterial() as MaterialTexture;
			material2.technique.renderState.applyBlendMode = true;
			material2.technique.renderState.blendMode = BlendMode.AlphaAdditive;
		}

		override public function simpleUpdate(tpf:Number):void
		{
		}
	}
}

