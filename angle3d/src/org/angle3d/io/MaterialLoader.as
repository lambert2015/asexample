package org.angle3d.io
{
	import org.angle3d.material.MaterialDef;

	public class MaterialLoader
	{
		public function MaterialLoader()
		{
		}

		public function parse(json:String):MaterialDef
		{
			var jsonObj:Object = JSON.parse(json);

			var def:MaterialDef = new MaterialDef();

			if (jsonObj.parameters != null)
			{
				for (var key:String in jsonObj.parameters)
				{
					var obj:Object = jsonObj.parameters[key];
					def.addMaterialParam(obj.type, key, obj.value);
				}
			}

			if (jsonObj.techniques != null)
			{
				var techniqueParse:TechniqueParser = new TechniqueParser();
				var techniques:Array = jsonObj.techniques;
				for (var i:int = 0; i < techniques.length; i++)
				{
					def.addTechniqueDef(techniqueParse.parse(techniques[i]));
				}
			}

			return def;
		}
	}
}
