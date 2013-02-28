package org.angle3d.material
{

	class VarType
	{
		public static const FLOAT:String = "Float";
		public static const INT:String = "Int";

		public static const VECTOR2:String = "Vector2";
		public static const VECTOR3:String = "Vector3";
		public static const VECTOR4:String = "Vector4";
		public static const Bool:String = "Bool";

		public static const MATRIX3:String = "Matrix3";
		public static const MATRIX4:String = "Matrix4";

		public static const TEXTURE2D:String = "Texture2D";
		public static const TEXTURECUBEMAP:String = "TextureCubeMap";

		public static function isTextureType(type:String):Bool
		{
			return type == TEXTURE2D || type == TEXTURECUBEMAP;
		}
	}
}
