package org.angle3d.material.sgsl.parser
{

	public class Token
	{
		public var name:String;
		public var type:String;

		public function Token(type:String, name:String)
		{
			this.type = type;
			this.name = name;
		}

		public function equals(type:String, name:String):Boolean
		{
			return (this.type == type && this.name == name);
		}

		public function equalsToken(token:Token):Boolean
		{
			return (type == token.type && name == token.name);
		}
	}

}


