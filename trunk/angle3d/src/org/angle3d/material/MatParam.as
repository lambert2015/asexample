package org.angle3d.material 
{
	import org.angle3d.material.technique.Technique;
	import org.angle3d.renderer.IRenderer;
	/**
	 * Describes a material parameter. This is used for both defining a name and type
	 * as well as a material parameter value.
	 *
	 * @author Kirill Vainer
	 */
	public class MatParam 
	{
		public var type:String;
		public var name:String;
		public var value:*;
		
		public function MatParam(type:String,name:String,value:*) 
		{
			this.type = type;
			this.name = name;
			this.value = value;
		}
		
		public function apply(r:IRenderer, technique:Technique):void
		{
			
		}
		
		public function clone():MatParam
		{
			return new MatParam(this.type, this.name, this.value);
		}
		
		//TODO value不能这样比较
		public function equals(other:MatParam):Boolean
		{
			return this.type == other.type &&
			this.name == other.name &&
			this.value == other.value;
		}
		
	}

}