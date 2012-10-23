﻿package org.angle3d.material.sgsl.parser
{

	public class TokenType
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
		public static const CONDITION:String = "CONDITION";

		/** return */
		public static const FUNCTION_RETURN:String = "RETURN";

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

		/** = */
		public static const EQUAL:String = "EQUAL";

		/** && */
		public static const AND:String = "AND";

		/** || */
		public static const OR:String = "OR";

		/** [ */
		public static const LBRACKET:String = "LBRACKET";

		/** ] */
		public static const RBRACKET:String = "RBRACKET";
	}

}

