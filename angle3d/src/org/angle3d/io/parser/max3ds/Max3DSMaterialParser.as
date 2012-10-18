package org.angle3d.io.parser.max3ds
{

	internal class Max3DSMaterialParser extends AbstractMax3DSParser
	{
		private var _name : String = null;
		private var _textureFilename : String = null;

		public function Max3DSMaterialParser(chunk : Max3DSChunk)
		{
			super(chunk);
		}

		public function get name() : String
		{
			return _name;
		}

		public function get textureFilename() : String
		{
			return _textureFilename;
		}

		override protected function initialize() : void
		{
			super.initialize();

			parseFunctions[Max3DSChunk.MATERIAL] = enterChunk;
			parseFunctions[Max3DSChunk.MATERIAL_NAME] = parseName;
			parseFunctions[Max3DSChunk.MATERIAL_TEXMAP] = enterChunk;
			parseFunctions[Max3DSChunk.MATERIAL_MAPNAME] = parseTextureFilename;
		}

		protected function parseName(chunk : Max3DSChunk) : void
		{
			_name = chunk.readString();
		}

		protected function parseTextureFilename(chunk : Max3DSChunk) : void
		{
			_textureFilename = chunk.readString();
		}

	}
}
