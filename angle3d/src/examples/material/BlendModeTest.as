package examples.material
{
	import com.adobe.utils.AGALMiniAssembler;

	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	public class BlendModeTest extends Sprite
	{
		public const viewWidth:Number = 320;
		public const viewHeight:Number = 200;

		private var stage3D:Stage3D;
		private var renderContext:Context3D;
		private var indexList:IndexBuffer3D;
		private var vertexes:VertexBuffer3D;

		private const VERTEX_SHADER:String =
			"mov op, va0    \n" + //copy position to output 
			"mov v0, va1"; //copy color to varying variable v0

		private const FRAGMENT_SHADER:String =
			"mov oc, v0"; //Set the output color to the value interpolated from the three triangle vertices 

		private var vertexAssembly:AGALMiniAssembler = new AGALMiniAssembler();
		private var fragmentAssembly:AGALMiniAssembler = new AGALMiniAssembler();
		private var programPair:Program3D;

		private var sourceFactor:int = 6;
		private var destinationFactor:int = 4;
		private var blendFactors:Array = [Context3DBlendFactor.DESTINATION_ALPHA,
			Context3DBlendFactor.DESTINATION_COLOR,
			Context3DBlendFactor.ONE,
			Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA,
			Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA,
			Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR,
			Context3DBlendFactor.SOURCE_ALPHA,
			Context3DBlendFactor.SOURCE_COLOR,
			Context3DBlendFactor.ZERO];

		private var textField:TextField;

		public function BlendModeTest()
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			textField = new TextField();
			textField.width = 1200;
			textField.y = 250;
			textField.textColor = 0xff0000;
			this.addChild(textField);
			stage3D = this.stage.stage3Ds[0];
			stage3D.x = 10;
			stage3D.y = 10;

			//Add event listener before requesting the context
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextCreated);
			stage3D.addEventListener(ErrorEvent.ERROR, contextError);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);

			//Compile shaders
			vertexAssembly.assemble(Context3DProgramType.VERTEX, VERTEX_SHADER);
			fragmentAssembly.assemble(Context3DProgramType.FRAGMENT, FRAGMENT_SHADER);
		}

		//Note, context3DCreate event can happen at any time, such as when the hardware resources are taken by another process
		private function contextCreated(event:Event):void
		{
			renderContext = Stage3D(event.target).context3D;
			trace("3D driver: " + renderContext.driverInfo);

			renderContext.enableErrorChecking = true; //Can slow rendering - only turn on when developing/testing
			renderContext.configureBackBuffer(viewWidth, viewHeight, 2, false);

			//Create vertex index list for the triangles
			var triangles:Vector.<uint> = Vector.<uint>([0, 3, 2,
				0, 1, 3,
				6, 4, 5,
				5, 7, 6,
				10, 8, 9,
				9, 11, 10,
				12, 15, 14,
				12, 13, 15,
				16, 17, 19,
				16, 19, 18
				]);
			indexList = renderContext.createIndexBuffer(triangles.length);
			indexList.uploadFromVector(triangles, 0, triangles.length);

			//Create vertexes
			const dataPerVertex:int = 7;
			var vertexData:Vector.<Number> = Vector.<Number>(
				[
				// x, y, z    r, g, b, a format
				-1, 1, 0, 1, 1, 1, .5,
				0, 1, 0, 1, 1, 1, .5,
				-1, 0, 0, 1, 1, 1, .5,
				0, 0, 0, 1, 1, 1, .5,

				0, 1, 0, .8, .8, .8, .6,
				1, 1, 0, .8, .8, .8, .6,
				0, 0, 0, .8, .8, .8, .6,
				1, 0, 0, .8, .8, .8, .6,

				-1, 0, 0, 1, 0, 0, .5,
				0, 0, 0, 0, 1, 0, .5,
				-1, -1, 0, 0, 0, 1, .5,
				0, -1, 0, 1, 0, 1, .5,

				0, 0, 0, 0, 0, 0, .5,
				1, 0, 0, 0, 0, 0, .5,
				0, -1, 0, 0, 0, 0, .5,
				1, -1, 0, 0, 0, 0, .5,

				-.8, .8, 0, .6, .4, .2, .4,
				.8, .8, 0, .6, .4, .2, .4,
				-.8, -.8, 0, .6, .4, .2, .4,
				.8, -.8, 0, .6, .4, .2, .4
				]
				);
			vertexes = renderContext.createVertexBuffer(vertexData.length / dataPerVertex, dataPerVertex);
			vertexes.uploadFromVector(vertexData, 0, vertexData.length / dataPerVertex);

			//Identify vertex data inputs for vertex program
			renderContext.setVertexBufferAt(0, vertexes, 0, Context3DVertexBufferFormat.FLOAT_3); //va0 is position
			renderContext.setVertexBufferAt(1, vertexes, 3, Context3DVertexBufferFormat.FLOAT_4); //va1 is color

			//Upload programs to render context
			programPair = renderContext.createProgram();
			programPair.upload(vertexAssembly.agalcode, fragmentAssembly.agalcode);
			renderContext.setProgram(programPair);

			render();
		}

		private function render():void
		{
			//Clear required before first drawTriangles() call
			renderContext.clear(1, 1, 1, 1);
			//Draw the back triangles
			renderContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO); //No blending
			renderContext.drawTriangles(indexList, 0, 8);

			//Set blend
			renderContext.setBlendFactors(blendFactors[sourceFactor], blendFactors[destinationFactor]);

			//Draw the front triangles
			renderContext.drawTriangles(indexList, 24, 2);

			//Show the frame
			renderContext.present();
		}

		private function contextError(error:ErrorEvent):void
		{
			trace(error.errorID + ": " + error.text);
		}

		private function keyHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.NUMBER_1:
					if (--sourceFactor < 0)
						sourceFactor = blendFactors.length - 1;
					break;
				case Keyboard.NUMBER_2:
					if (++sourceFactor > blendFactors.length - 1)
						sourceFactor = 0;
					break;
				case Keyboard.NUMBER_3:
					if (--destinationFactor < 0)
						destinationFactor = blendFactors.length - 1;
					break;
				case Keyboard.NUMBER_4:
					if (++destinationFactor > blendFactors.length - 1)
						destinationFactor = 0;
					break;
			}
			textField.text = ("Source blend factor: " + blendFactors[sourceFactor] + ", destination blend factor: " + blendFactors[destinationFactor]);
			render();
		}
	}
}
