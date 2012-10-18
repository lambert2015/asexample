package org.angle3d.material.hgal.core;
import org.angle3d.material.hgal.core.reg.Reg;

/**
 * ...
 * 
 * 例如 vc[va0.x+10]
 * va0 ---> variable
 * x ---> comp
 * 10 ---> offset
 * 
 * reg为null时不是一个真正的access,生成语句时会转换的
 * 例如一个矩阵matrix位置为8
 * t_vec.xyz = matrix[3].xyz
 * 转换为agal就是
 * t_vec.xyz = vc11.xyz
 * @author andy
 */
class Access 
{
	public var reg:Reg;
	
	/**
	 * 只能是一个字符(xyzwrgba)
	 */
	public var component:String;
	
	/**
	 * 最终的offset是CodeParam自身的index+offset
	 * 0~255
	 */
	public var offset:Int;

	public function new() 
	{
		offset = 0;
	}
	
}