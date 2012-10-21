package org.angle3d.material.sgsl.parser
{

	import org.angle3d.material.sgsl.DataType;
	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.error.UnexpectedTokenError;

	public class Tokenizer
	{
		private var _tokenRegex:Array;
		private var _tokenRegexSize:int;

		private var _finalRegex:RegExp;

		private var _source:String;
		private var _sourceSize:int;
		private var _position:int;

		private var _token:Token;
		private var _nextToken:Token;

		public function Tokenizer(source:String)
		{
			this.source=source;
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
			if (_position > _sourceSize)
			{
				_nextToken=new Token(TokenType.NONE, "<NONE>");
				_token=new Token(TokenType.EOF, "<EOF>");
				return;
			}

			if (_position == _sourceSize)
			{
				_token=_nextToken;
				_nextToken=new Token(TokenType.EOF, "<EOF>");
				return;
			}

			_token=_nextToken;
			_nextToken=_createNextToken(_source.substr(_position));
		}

		public function get peek():Token
		{
			return _nextToken;
		}

		/**
		 * 检查是否正确，返回当前ToKen,并解析下一个关键字
		 */
		public function accept(type:String):Token
		{
			//检查是否同一类型
			if (_token.type != type)
				throw new UnexpectedTokenError(_token, type);

			var t:Token=_token;

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
			_source=value.replace(/\/\*(.|[\r\n])*?\*\//g, "");

			_sourceSize=_source.length;
			_position=0;

			_token=new Token(TokenType.NONE, "<NONE>");
			_nextToken=new Token(TokenType.NONE, "<NONE>");
			_buildRegex();
			next();
		}

		public function get token():Token
		{
			return _token;
		}

		//TODO 添加注释语法
		private function _buildRegex():void
		{
			_tokenRegex=[[TokenType.IDENTIFIER, /[a-zA-Z_][a-zA-Z0-9_]*/], [TokenType.NUMBER, /[-]?[0-9]+[.]?[0-9]*([eE][-+]?[0-9]+)?/], [TokenType.CONDITION, /#/],
				// grouping
				[TokenType.SEMI, /;/], [TokenType.LBRACE, /{/], [TokenType.RBRACE, /}/], [TokenType.LBRACKET, /\[/], [TokenType.RBRACKET, /\]/], [TokenType.LPAREN, /\(/], [TokenType.RPAREN, /\)/], [TokenType.COMMA, /,/],
				// operators
				[TokenType.DOT, /\./], [TokenType.PLUS, /\+/], [TokenType.EQUAL, /=/], [TokenType.AND, /&&/], [TokenType.OR, /\|\|/]];

			_tokenRegexSize=_tokenRegex.length;

			var reg:String="^(";
			for (var i:int=0; i < _tokenRegexSize; i++)
			{
				var arr:Array=_tokenRegex[i];
				reg+="?P<" + arr[0] + ">" + arr[1].source;
				if (i < _tokenRegexSize)
					reg+=")|^(";
			}

			reg+=")";

			_finalRegex=new RegExp(reg, "");
		}

		private function _createNextToken(source:String):Token
		{
			var result:Object=_finalRegex.exec(source);

			var result0:String=result[0];

			_position+=result0.length;

			var type:String;
			for (var i:int=0; i < _tokenRegexSize; i++)
			{
				var list:Array=_tokenRegex[i];

				var curType:String=list[0];
				if (result[curType] == result0)
				{
					type=curType;
					break;
				}
			}

			type=_reservedWords(result0, type);

			return new Token(type, result0);
		}

		private function _reservedWords(text:String, type:String):String
		{
			switch (text)
			{
				case "function":
					return TokenType.FUNCTION;
				case "return":
					return TokenType.FUNCTION_RETURN;
				case DataType.SAMPLER2D:
				case DataType.SAMPLERCUBE:
				case DataType.MAT4:
				case DataType.MAT3:
				case DataType.VEC4:
				case DataType.VEC3:
				case DataType.VEC2:
				case DataType.FLOAT:
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


