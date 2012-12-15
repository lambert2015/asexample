package org.angle3d.material.sgsl.parser
{

	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.error.UnexpectedTokenError;

	//TODO 优化解析速度
	public class Tokenizer
	{
		private var _tokenRegex:Array;
		private var _tokenRegexSize:int;

		private var _finalRegex:RegExp;

		private var _source:String;
		private var _sourceSize:int;
		private var _position:int;

		public var token:Token;
		public var nextToken:Token;

		public function Tokenizer(source:String)
		{
			this.source = source;
		}

		/**
		 * 检查下一个
		 */
		//TODO 优化，每次检查之后应该去掉之前的字符串
		public function next():void
		{
			// skip spaces
			while (_source.charCodeAt(_position) <= 32)
			{
				_position++;
			}

			// end of script
			if (_position >= _sourceSize)
			{
				if (_position == _sourceSize)
				{
					token = nextToken;
					nextToken = new Token(TokenType.EOF, "<EOF>");
				}
				else
				{
					nextToken = new Token(TokenType.NONE, "<NONE>");
					token = new Token(TokenType.EOF, "<EOF>");
				}
				return;
			}

			token = nextToken;
			nextToken = _createNextToken(_source.substr(_position));
		}

		/**
		 * 检查是否正确，返回当前Token,并解析下一个关键字
		 */
		public function accept(type:String):Token
		{
			//检查是否同一类型
			if (token.type != type)
				throw new UnexpectedTokenError(token, type);

			var t:Token = token;

			next();

			return t;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			//忽略注释
			_source = cleanSource(value);

			_sourceSize = _source.length;
			_position = 0;

			token = new Token(TokenType.NONE, "<NONE>");
			nextToken = new Token(TokenType.NONE, "<NONE>");
			_buildRegex();
			next();
		}

		private function cleanSource(value:String):String
		{
			//删除/**/类型注释
//			var result:String = value.replace(/\/\*(.|[\r\n])*?\*\//g, "");
//			result = value.replace(/\/\/(.)*\\n/g, "");
			var result:String = value.replace(/\/\*(.|[^.])*?\*\//g, "");
			result = result.replace(/\/\/.*[^.]/g, "");

			/**
			 * 除去多余的空格换行符等等
			 */
			result = result.replace(/\t+|\x20+/g, " ");
			result = result.replace(/\r\n|\n/g, "");

			return result;
		}

		private function _buildRegex():void
		{
			_tokenRegex = [[TokenType.IDENTIFIER, /[a-zA-Z_][a-zA-Z0-9_]*/],
				[TokenType.NUMBER, /[-]?[0-9]+[.]?[0-9]*([eE][-+]?[0-9]+)?/],
				[TokenType.PREDEFINE, /#[elsdif]{4,6}/],
				// grouping
				[TokenType.SEMI, /;/],
				[TokenType.LBRACE, /{/],
				[TokenType.RBRACE, /}/],
				[TokenType.LBRACKET, /\[/],
				[TokenType.RBRACKET, /\]/],
				[TokenType.LPAREN, /\(/],
				[TokenType.RPAREN, /\)/],
				[TokenType.COMMA, /,/],
				//compare
				[TokenType.GREATER_THAN, /\>/],
				[TokenType.LESS_THAN, /\</],
				[TokenType.GREATER_EQUAL, /\>=/],
				[TokenType.LESS_EQUAL, /\<=/],
				[TokenType.NOT_EQUAL, /\!=/],
				[TokenType.DOUBLE_EQUAL, /==/],
				//operators
				[TokenType.DOT, /\./],
				[TokenType.PLUS, /\+/],
				[TokenType.EQUAL, /=/],
				[TokenType.AND, /&&/],
				[TokenType.OR, /\|\|/]];

			_tokenRegexSize = _tokenRegex.length;

			var reg:String = "^(";
			for (var i:int = 0; i < _tokenRegexSize; i++)
			{
				var arr:Array = _tokenRegex[i];
				reg += "?P<" + arr[0] + ">" + arr[1].source;
				if (i < _tokenRegexSize)
					reg += ")|^(";
			}

			reg += ")";

			_finalRegex = new RegExp(reg);
		}

		private function _createNextToken(source:String):Token
		{
			var result:Object = _finalRegex.exec(source);

			var result0:String = result[0];

			_position += result0.length;

			var type:String;
			for (var i:int = 0; i < _tokenRegexSize; i++)
			{
				var list:Array = _tokenRegex[i];

				var curType:String = list[0];
				if (result[curType] == result0)
				{
					type = curType;
					break;
				}
			}

			type = _reservedWords(result0, type);

			return new Token(type, result0);
		}

		private function _reservedWords(text:String, type:String):String
		{
			switch (text)
			{
				case "function":
					return TokenType.FUNCTION;
				case "return":
					return TokenType.RETURN;
				case "if":
					return TokenType.IF;
				case "else":
					return TokenType.ELSE;
				case DataType.VOID:
				case DataType.FLOAT:
				case DataType.VEC2:
				case DataType.VEC3:
				case DataType.VEC4:
				case DataType.MAT4:
				case DataType.MAT3:
				case DataType.SAMPLER2D:
				case DataType.SAMPLERCUBE:
					return TokenType.DATATYPE;
				case RegType.ATTRIBUTE:
				case RegType.VARYING:
				case RegType.UNIFORM:
				case RegType.TEMP:
					return TokenType.REGISTER;
			}
			return type;
		}

	}

}


