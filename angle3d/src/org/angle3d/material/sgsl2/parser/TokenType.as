package org.angle3d.material.sgsl2.parser
{

	final public class TokenType
	{
		public static const NONE:String = "NONE";
		public static const EOF:String = "EOF";

		public static const IDENTIFIER:String = "IDENTIFIER";
		public static const NUMBER:String = "NUMBER";

		/**
		 * Reserved words
		 */
		//数据类型
		public static const DATATYPE:String = "DATATYPE";

		//寄存器
		public static const REGISTER:String = "REGISTER";

		//函数
		/** function */
		public static const FUNCTION:String = "FUNCTION";

		//预编译条件
		/** # */
		public static const PREDEFINE:String = "PREDEFINE";

		public static const IF:String = "if";

		public static const ELSE:String = "else";

		/** return */
		public static const RETURN:String = "RETURN";

		/**
		 * Grouping, delimiting
		 */
		/** . */
		public static const DOT:String = "DOT";
		/** ; */
		public static const SEMI:String = "SEMI";
		/** { */
		public static const LBRACE:String = "LBRACE";
		/** } */
		public static const RBRACE:String = "RBRACE";
		/** ( */
		public static const LPAREN:String = "LPAREN";
		/** ) */
		public static const RPAREN:String = "RPAREN";
		/** , */
		public static const COMMA:String = "COMMA";

		/** + */
		public static const PLUS:String = "PLUS";

		/** - */
		public static const SUBTRACT:String = "SUBTRACT";

		/** * */
		public static const MULTIPLY:String = "MULTIPLY";

		/** / */
		public static const DIVIDE:String = "DIVIDE";

		/** = */
		public static const EQUAL:String = "EQUAL";

		/** && */
		public static const AND:String = "AND";

		/** || */
		public static const OR:String = "OR";

		/** == */
		public static const DOUBLE_EQUAL:String = "DOUBLE_EQUAL";

		/** != */
		public static const NOT_EQUAL:String = "NOT_EQUAL";

		/** >= */
		public static const GREATER_EQUAL:String = "GREATER_EQUAL";

		/** <= */
		public static const LESS_EQUAL:String = "LESS_EQUAL";

		/** > */
		public static const GREATER_THAN:String = "GREATER_THAN";

		/** < */
		public static const LESS_THAN:String = "LESS_THAN";

		/** [ */
		public static const LBRACKET:String = "LBRACKET";

		/** ] */
		public static const RBRACKET:String = "RBRACKET";
	}

}


