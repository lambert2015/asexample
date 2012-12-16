package
{
	import flash.display.Sprite;
	import flash.events.Event;

	import flsl.parser.AstNode;
	import flsl.parser.Parser;

	public class Main extends Sprite
	{

		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			var src:XML = <data><![CDATA[
			
				attribute Float4 pos;
				attribute Float4 norm;
				attribute Float4 uv;

				varying Float4 tuv;
				varying Float4 lpow;

				shader vertex :
					Matrix mpos,
					Matrix mproj,
					Float4 light
				{
					out = pos * mpos * mproj;
					Float4 tnorm = normalize(norm * pos);
					lpow = max(dot(light, tnorm), 0);
					tuv = uv;
				}

				shader fragment : 
					Texture tex
				{
					out = texture(tex, tuv) * (lpow * 0.8 + 0.2);
				}

			]]></data>;


			//var s1:Number = (new Date()).getMilliseconds();
			var node:AstNode = Parser.parse(src.toString());
			trace(node.toString());
			//var time1:Number = (new Date()).getMilliseconds() - s1;
			//trace(time1);
		}

	}

}
