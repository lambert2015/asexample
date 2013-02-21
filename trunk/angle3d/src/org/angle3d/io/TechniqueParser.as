package org.angle3d.io
{
	import org.angle3d.material.TechniqueDef;

	public class TechniqueParser
	{
		public function TechniqueParser()
		{
		}

		public function parse(technique:Object):TechniqueDef
		{
			var def:TechniqueDef = new TechniqueDef(technique.name);
			def.vertLanguage = technique.vs;
			def.fragLanguage = technique.fs;
			if (technique.worldparameters != null)
			{
				var params:Array = technique.worldparameters;
				for (var i:int = 0; i < params.length; i++)
				{
					def.addWorldParam(params[i]);
				}
			}

			if (technique.defines != null)
			{
				var defines:Array = technique.defines;
				for (i = 0; i < defines.length; i++)
				{
					var define:Object = defines[i];
					def.addShaderParamDefine(define.param, define.define);
				}
			}
			return def;
		}
	}
}
