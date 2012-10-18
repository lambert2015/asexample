package org.angle3d.examples.sgsl
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileReference;

	import org.angle3d.material.sgsl.SgslCompiler;
	import org.angle3d.material.shader.Shader;

	public class SaveSgsl extends Sprite
	{
		private var shader : Shader;

		public function SaveSgsl()
		{
			var vertexSrc : String = 
				"attribute vec3 a_position;" +
				"attribute vec4 a_boneWeights;" +
				"attribute vec4 a_boneIndices;" +
				
				"uniform mat4 u_WorldViewProjectionMatrix;" +
				"uniform vec4 u_boneMatrixs[" + 32 * 3 + "];" +

				"function main(){" +
				"		mat3 t_skinTransform;" +
				"		vec4 t_vec;" +
				"		vec4 t_vec1;" +
				
				"       float n1 = a_boneWeights.x;"+
				"       n1 = 1.0;"+
				"		t_vec1 = mul(n1,u_boneMatrixs[a_boneIndices.x]);" +
				"		t_skinTransform[0] = t_vec1;" +
				
				"		t_vec1 = mul(n1,u_boneMatrixs[a_boneIndices.x + 1]);" +
				"		t_skinTransform[1] = t_vec1;" +
				
				"		t_vec1 = mul(n1,u_boneMatrixs[a_boneIndices.x + 2]);" +
				"		t_skinTransform[2] = t_vec1;" +
				
				"		vec4 t_localPos;" +
				"		t_localPos.xyz = m34(a_position,t_skinTransform);" +
				"		t_localPos.w = 1.0;" +
				"		output = m44(t_localPos,u_WorldViewProjectionMatrix);" +
				"}";;

			var fragmentSrc : String = <![CDATA[
							function main(){
				                output = 1.0;
							}]]>;

			var parser : SgslCompiler = new SgslCompiler();
			shader = parser.complie([vertexSrc, fragmentSrc]);

			this.stage.addEventListener(MouseEvent.CLICK, _saveData);
		}
		private var count : int = 0;

		private function _saveData(e : MouseEvent) : void
		{
			if (count == 0)
			{
				new FileReference().save(shader.vertexData, "vertex.sgsl");
			}
			else
			{
				new FileReference().save(shader.fragmentData, "fragment.sgsl");
			}

			count++;
			if (count > 1)
			{
				count = 0;
			}
		}
	}
}

