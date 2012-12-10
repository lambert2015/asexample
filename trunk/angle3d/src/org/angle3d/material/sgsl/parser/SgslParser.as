package org.angle3d.material.sgsl.parser
{
	import flash.utils.Dictionary;
	import org.angle3d.material.sgsl.node.ConditionEndNode;
	import org.angle3d.material.sgsl.node.ConditionNode;

	import org.angle3d.material.sgsl.RegType;
	import org.angle3d.material.sgsl.error.UnexpectedTokenError;
	import org.angle3d.material.sgsl.node.AgalNode;
	import org.angle3d.material.sgsl.node.ArrayAccessNode;
	import org.angle3d.material.sgsl.node.AtomNode;
	import org.angle3d.material.sgsl.node.BranchNode;
	import org.angle3d.material.sgsl.node.ConstantNode;
	import org.angle3d.material.sgsl.node.FunctionCallNode;
	import org.angle3d.material.sgsl.node.FunctionNode;
	import org.angle3d.material.sgsl.node.LeafNode;
	import org.angle3d.material.sgsl.node.ParameterNode;
	import org.angle3d.material.sgsl.node.PredefineNode;
	import org.angle3d.material.sgsl.node.PredefineSubNode;
	import org.angle3d.material.sgsl.node.PredefineType;
	import org.angle3d.material.sgsl.node.reg.RegFactory;
	import org.angle3d.material.sgsl.node.reg.RegNode;

	//TODO 添加更多的语法错误提示
	public class SgslParser
	{
		/**
		 * NOTE: next()/accept() etiquette! Always leave the current token on the
		 *       FIRST token of the grammar rule function you are
		 *       recursing to. Always leave the current token on the token
		 *       AFTER your grammar rule's last token when returning from a
		 *       function.
		 */

		private var _tok:Tokenizer;

		private var _shaderVarMap:Dictionary;

		/**
		 *
		 */
		public function SgslParser()
		{
		}

		public function exec(source:String):BranchNode
		{
			_shaderVarMap = new Dictionary();

			_tok = new Tokenizer(_cleanSource(source));
			_tok.next();

			var programNode:BranchNode = new BranchNode();
			parseProgram(programNode);
			return programNode;
		}

		public function execFunctions(source:String):Vector.<FunctionNode>
		{
			_shaderVarMap = new Dictionary();

			_tok = new Tokenizer(_cleanSource(source));
			_tok.next();

			var result:Vector.<FunctionNode> = new Vector.<FunctionNode>();

			while (_tok.token.type != TokenType.EOF)
			{
				result.push(parseFunction());
			}

			return result;
		}

		/**
		 * 清理源代码，除去多余的空格换行符等等
		 */
		private function _cleanSource(source:String):String
		{
			var result:String = source.replace(/\t+|\x20+/g, " ");
			result = result.replace(/\r\n|\n/g, "");
			return result;
		}

		/**
		 * program = { function | condition | shader_var };  至少包含一个main function
		 */
		private function parseProgram(program:BranchNode):void
		{
			while (_tok.token.type != TokenType.EOF)
			{
				if (_tok.token.type == TokenType.FUNCTION)
				{
					program.addChild(parseFunction());
				}
				else if (_tok.token.type == TokenType.PREDEFINE)
				{
					program.addChild(parsePredefine());
				}
				else
				{
					program.addChild(parseShaderVar());
				}
			}
		}

		/**
		 * #ifdef(...){
		 * }
		 * #elseif(...){
		 * }
		 * #else{
		 * }
		 *
		 * condition = '#ifdef || #elseif' '(' Identifier { "||" | "&&" } ")" || '#else' block;
		 */

		private function parsePredefine():PredefineNode
		{
			var condition:PredefineNode = new PredefineNode();

			condition.addChild(parseSubPredefine());

			//接下来一个也是条件，并且不是新的条件，而是之前条件的延续
			while (_tok.token.type == TokenType.PREDEFINE && _tok.peek.name != PredefineType.IFDEF)
			{
				condition.addChild(parseSubPredefine());
			}

			return condition;
		}

		/**
		 * 一个条件中的分支条件
		 * @param condition
		 * @param parent
		 *
		 */
		private function parseSubPredefine():PredefineSubNode
		{
			var predefine:Token = _tok.token;
			
			var subNode:PredefineSubNode = new PredefineSubNode(predefine.name.slice(1));
			
			_tok.accept(TokenType.PREDEFINE); //SKIP '#ifdef'

			if (subNode.name == PredefineType.IFDEF || subNode.name == PredefineType.ELSEIF)
			{
				_tok.accept(TokenType.LPAREN); //SKIP '('

				//至少有一个参数
				subNode.addKeyword(_tok.accept(TokenType.IDENTIFIER).name);

				//剩余参数
				if (_tok.token.type != TokenType.RPAREN)
				{
					while (_tok.token.type != TokenType.RPAREN)
					{
						if (_tok.token.type == TokenType.AND)
						{
							// &&
							subNode.addKeyword(_tok.accept(TokenType.AND).name);
						}
						else
						{
							// ||
							subNode.addKeyword(_tok.accept(TokenType.OR).name);
						}

						subNode.addKeyword(_tok.accept(TokenType.IDENTIFIER).name);
					}
				}

				_tok.accept(TokenType.RPAREN); //SKIP ')'
			}

			//解析块  {...}
			// skip '{'
			_tok.accept(TokenType.LBRACE);

			while (_tok.token.type != TokenType.RBRACE)
			{
				var t:Token = _tok.token;
				if (t.type == TokenType.REGISTER)
				{
					subNode.addChild(parseShaderVar());
				}
				else if (t.type == TokenType.FUNCTION)
				{
					subNode.addChild(parseFunction());
				}
				else if (t.type == TokenType.PREDEFINE)
				{
					subNode.addChild(parsePredefine());
				}
				else
				{
					parseStatement(subNode);
				}
			}

			// skip '}'
			_tok.accept(TokenType.RBRACE);

			return subNode;
		}

		/**
		 * function = 'function' Identifier '(' [declaration {',' declaration}]  ')' block;
		 */
		private function parseFunction():FunctionNode
		{
			// SKIP 'function'
			_tok.accept(TokenType.FUNCTION);

			var fn:FunctionNode = new FunctionNode(_tok.accept(TokenType.IDENTIFIER).name);

			//SKIP '('
			_tok.accept(TokenType.LPAREN);

			//参数部分
			if (_tok.token.type != TokenType.RPAREN)
			{
				fn.addParam(parseParams());

				while (_tok.token.type != TokenType.RPAREN)
				{
					//SKIP ','
					_tok.accept(TokenType.COMMA);
					fn.addParam(parseParams());
				}
			}

			//SKIP ')'
			_tok.accept(TokenType.RPAREN);

			//解析块  {...}
			// skip '{'
			_tok.accept(TokenType.LBRACE);

			while (_tok.token.type != TokenType.RBRACE)
			{
				var type:String = _tok.token.type;
				if (type == TokenType.PREDEFINE)
				{
					fn.addChild(parsePredefine());
				}
				else if (type == TokenType.IF)
				{
					parseIfCondition(fn);
				}
				else if (type == TokenType.FUNCTION_RETURN)
				{
					fn.result = parseReturn();
				}
				else
				{
					parseStatement(fn);
				}
			}

			// skip '}'
			_tok.accept(TokenType.RBRACE);

			return fn;
		}

		private function parseIfCondition(parent:BranchNode):void
		{
			var conditionToken:Token = _tok.token;
			var ifConditionNode:ConditionNode = new ConditionNode(conditionToken.name);
			
			_tok.accept(TokenType.IF);
			_tok.accept(TokenType.LPAREN);

			var leftNode:LeafNode = parseAtomExpression();
			ifConditionNode.addChild(leftNode);

			// > < >= ...
			ifConditionNode.compareMethod = _tok.token.name;
			//skip compareMethod
			_tok.next();

			var rightNode:LeafNode = parseAtomExpression();
			ifConditionNode.addChild(rightNode);
			
			parent.addChild(ifConditionNode);

			_tok.accept(TokenType.RPAREN);

			//解析块  {...}
			// skip '{'
			_tok.accept(TokenType.LBRACE);

			while (_tok.token.type != TokenType.RBRACE)
			{
				var type:String = _tok.token.type;
				if (type == TokenType.PREDEFINE)
				{
					parent.addChild(parsePredefine());
				}
				else if (type == TokenType.IF)
				{
					parseIfCondition(parent);
				}
				//不应该出现这种情况
				else if (type == TokenType.FUNCTION_RETURN)
				{
					//fn.result = parseReturn();
				}
				else
				{
					parseStatement(parent);
				}
			}

			// skip '}'
			_tok.accept(TokenType.RBRACE);
			
			//TODO 查找ELSE
			if (_tok.token.name == TokenType.ELSE)
			{
				parseElseCondition(ifConditionNode);
			}
			
			var conditionEndNode:ConditionEndNode = new ConditionEndNode("end");
			parent.addChild(conditionEndNode);
		}
		
		/**
		 * else{...}
		 * @param	ifNode
		 */
		private function parseElseCondition(ifNode:ConditionNode):void
		{
			var conditionToken:Token = _tok.token;
			var elseConditionNode:ConditionNode = new ConditionNode(conditionToken.name);
			
			_tok.accept(TokenType.ELSE);

			//解析块  {...}
			// skip '{'
			_tok.accept(TokenType.LBRACE);

			while (_tok.token.type != TokenType.RBRACE)
			{
				var type:String = _tok.token.type;
				if (type == TokenType.PREDEFINE)
				{
					//parent.addChild(parsePredefine());
				}
				else if (type == TokenType.IF)
				{
					//parseIfCondition(parent);
				}
				//不应该出现这种情况
				else if (type == TokenType.FUNCTION_RETURN)
				{
					//fn.result = parseReturn();
				}
				else
				{
					//parseStatement(parent);
				}
			}

			// skip '}'
			_tok.accept(TokenType.RBRACE);
		}

		/**
		 * shader_var = Specifier Type Identifier ';';
		 */
		private function parseShaderVar():RegNode
		{
			var registerType:String = _tok.accept(TokenType.REGISTER).name;
			var dataType:String = _tok.accept(TokenType.DATATYPE).name;
			var name:String = _tok.accept(TokenType.IDENTIFIER).name;

			//只有uniform可以使用数组定义，并且数组大小必须一开始就定义好
			var isArray:Boolean = false;
			var arraySize:int = 0;
			if (_tok.token.type == TokenType.LBRACKET)
			{
				_tok.next(); //Skip "["
				isArray = true;
				arraySize = parseInt(_tok.accept(TokenType.NUMBER).name);
				_tok.accept(TokenType.RBRACKET); //Skip "]"
			}

			// skip ';'
			_tok.accept(TokenType.SEMI);

			return RegFactory.create(name, registerType, dataType, isArray, arraySize);
		}

		private function parseReturn():LeafNode
		{
			_tok.accept(TokenType.FUNCTION_RETURN); //SKIP "return"

			var node:LeafNode = parseExpression();

			_tok.accept(TokenType.SEMI); //SKIP ";"

			return node;
		}

		/**
		 * 表达式
		 * statement     = (declaration | assignment | function_call) ';';
		 * declaration   = Type Identifier;
		 * assignment    = [declaration | Identifier] '=' expression;
		 * function_call = Identifier '(' [expression] {',' expression} ')';
		 */
		private function parseStatement(parent:BranchNode):void
		{
			var statement:AgalNode;
			var t:String = _tok.token.type;
			//临时变量定义
			if (t == TokenType.DATATYPE)
			{
				var declarName:String = _tok.peek.name;

				parent.addChild(parseDeclaration());

				// plain declaration
				if (_tok.token.type != TokenType.SEMI)
				{
					statement = new AgalNode();

					statement.addChild(new AtomNode(declarName));

					_tok.accept(TokenType.EQUAL); // SKIP '='

					statement.addChild(parseExpression());

					parent.addChild(statement);
				}
			}
			else if (_tok.peek.type == TokenType.LPAREN)
			{
				// function call

				statement = new AgalNode();

				statement.addChild(parseFunctionCall());

				parent.addChild(statement);
			}
			else
			{
				statement = new AgalNode();

				//左侧的不能是方法调用，所以用parseAtomExpression
				statement.addChild(parseAtomExpression() as AtomNode);

				_tok.accept(TokenType.EQUAL); // SKIP '='

				statement.addChild(parseExpression());

				parent.addChild(statement);
			}

			_tok.accept(TokenType.SEMI); //SKIP ";"
		}

		/**
		 *参数定义
		 */
		private function parseParams():ParameterNode
		{
			var dataType:String = _tok.accept(TokenType.DATATYPE).name;
			var name:String = _tok.accept(TokenType.IDENTIFIER).name;
			return new ParameterNode(dataType, name);
		}

		/**
		 * 临时变量定义,方法内部定义的变量(都是临时变量)
		 */
		private function parseDeclaration():RegNode
		{
			var dataType:String = _tok.accept(TokenType.DATATYPE).name;
			var name:String = _tok.accept(TokenType.IDENTIFIER).name;

			return RegFactory.create(name, RegType.TEMP, dataType);
		}

		/**
		 * 方法调用
		 * function_call = Identifier '(' [expression] {',' expression} ')';
		 */
		private function parseFunctionCall():FunctionCallNode
		{
			var bn:FunctionCallNode = new FunctionCallNode(_tok.accept(TokenType.IDENTIFIER).name);

			_tok.accept(TokenType.LPAREN); // SKIP '('

			while (_tok.token.type != TokenType.RPAREN)
			{
				//TODO 修改，目前不支持方法中嵌套方法
				//以后考虑支持嵌套
				//parseExpression(bn);

				bn.addChild(parseAtomExpression());

				if (_tok.token.type == TokenType.COMMA)
					_tok.next(); // SKIP ','
			}

			_tok.accept(TokenType.RPAREN); // SKIP ')'

			return bn;
		}

		/**
		 * expression  = Identifier | function_call | number_literal | Access | ArrayAccess;
		 */
		private function parseExpression():LeafNode
		{
			// a function call.
			if (_tok.token.type == TokenType.IDENTIFIER && _tok.peek.type == TokenType.LPAREN)
			{
				return parseFunctionCall();
			}
			else
			{
				return parseAtomExpression();
			}
		}

		/**
		 *  abc
		 *  abc.efg
		 *  abc[efg.rgb+3].xyzw
		 *
		 * @return
		 *
		 */
		private function parseAtomExpression():LeafNode
		{
			var ret:LeafNode;

			var type:String = _tok.token.type;
			if (type == TokenType.IDENTIFIER)
			{
				var pType:String = _tok.peek.type;

				if (pType == TokenType.LBRACKET)
				{
					//abc[efg]
					ret = parseBracketExpression();
				}
				else
				{
					// variable
					ret = parseDotExpression();
				}
			}
			// number literal
			else if (type == TokenType.NUMBER)
			{
				ret = new ConstantNode(parseFloat(_tok.accept(TokenType.NUMBER).name));
			}
			else
			{
				throw new UnexpectedTokenError(_tok.token);
			}

			return ret;
		}

		private function parseDotExpression():AtomNode
		{
			var bn:AtomNode = new AtomNode(_tok.accept(TokenType.IDENTIFIER).name);

			if (_tok.token.type == TokenType.DOT)
			{
				_tok.next(); // SKIP 'dot'
				bn.mask = _tok.accept(TokenType.IDENTIFIER).name;
			}

			return bn;
		}

		/**
		 * 几种情况如下：
		 * [1]
		 * [vt0] 这种情况下vt0类型应该为float
		 * [vt0.x]
		 * [vt0.x+1]
		 * [1+vt0.x]
		 * [1+vt0]
		 */
		private function parseBracketExpression():ArrayAccessNode
		{
			var bn:ArrayAccessNode = new ArrayAccessNode(_tok.accept(TokenType.IDENTIFIER).name);

			_tok.accept(TokenType.LBRACKET); // SKIP '['

			if (_tok.token.type != TokenType.RBRACKET)
			{
				while (_tok.token.type != TokenType.RBRACKET)
				{
					if (_tok.token.type == TokenType.NUMBER)
					{
						bn.offset = parseInt(_tok.accept(TokenType.NUMBER).name);
					}
					else if (_tok.token.type == TokenType.PLUS)
					{
						_tok.next(); // SKIP '+'
					}
					else
					{
						bn.access = parseDotExpression();
					}
				}
			}

			_tok.accept(TokenType.RBRACKET); // SKIP ']'

			//检查后面有没有.xyz
			if (_tok.token.type == TokenType.DOT)
			{
				_tok.next(); // SKIP "."
				bn.mask = _tok.accept(TokenType.IDENTIFIER).name;
			}

			return bn;
		}

		/**
		 * 这里判断名字为name的变量是否已经定义
		 */
		private function createAtomNode(name:String):AtomNode
		{
			var node:AtomNode = new AtomNode(name);
			return node;
		}

		private function createArrayAccessNode(name:String):ArrayAccessNode
		{
			var node:ArrayAccessNode = new ArrayAccessNode(name);
			return node;
		}
	}
}


