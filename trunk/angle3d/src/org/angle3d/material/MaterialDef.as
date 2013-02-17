package org.angle3d.material
{
	import flash.utils.Dictionary;

	/**
	 * Describes a J3MD (Material definition).
	 *
	 */
	public class MaterialDef
	{
		/**
		 * The debug name of the material definition.
		 *
		 * @return debug name of the material definition.
		 */
		public var name:String;

		/**
		 * Returns the asset key name of the asset from which this material
		 * definition was loaded.
		 *
		 * @return Asset key name of the j3md file
		 */
		public var assetName:String;

		private var defaultTechs:Vector.<TechniqueDef>;

		private var techniques:Dictionary;
		private var matParams:Dictionary;

		public function MaterialDef()
		{
			defaultTechs = new Vector.<TechniqueDef>();

			techniques = new Dictionary();
			matParams = new Dictionary();
		}

		/**
		 * Adds a new material parameter.
		 *
		 * @param type Type of the parameter
		 * @param name Name of the parameter
		 * @param value Default value of the parameter
		 * @param ffBinding Fixed function binding for the parameter
		 */
		public function addMaterialParam(type:String, name:String, value:Object):void
		{
			matParams[name] = new MatParam(type, name, value);
		}

		/**
		 * Returns the material parameter with the given name.
		 *
		 * @param name The name of the parameter to retrieve
		 *
		 * @return The material parameter, or null if it does not exist.
		 */
		public function getMaterialParam(name:String):MatParam
		{
			return matParams[name];
		}

		/**
		 * Returns a collection of all material parameters declared in this
		 * material definition.
		 * <p>
		 * Modifying the material parameters or the collection will lead
		 * to undefined results.
		 *
		 * @return All material parameters declared in this definition.
		 */
		public function getMaterialParams():Dictionary
		{
			return matParams;
		}

		/**
		 * Adds a new technique definition to this material definition.
		 * <p>
		 * If the technique name is "Default", it will be added
		 * to the list of {@link MaterialDef#getDefaultTechniques() default techniques}.
		 *
		 * @param technique The technique definition to add.
		 */
		public function addTechniqueDef(technique:TechniqueDef):void
		{
			if (technique.name == "Default")
			{
				defaultTechs.push(technique);
			}
			else
			{
				techniques[technique.name] = technique;
			}
		}

		/**
		 * Returns a list of all default techniques.
		 *
		 * @return a list of all default techniques.
		 */
		public function getDefaultTechniques():Vector.<TechniqueDef>
		{
			return defaultTechs;
		}

		/**
		 * Returns a technique definition with the given name.
		 * This does not include default techniques which can be
		 * retrieved via {@link MaterialDef#getDefaultTechniques() }.
		 *
		 * @param name The name of the technique definition to find
		 *
		 * @return The technique definition, or null if cannot be found.
		 */
		public function getTechniqueDef(name:String):TechniqueDef
		{
			return techniques[name];
		}
	}
}
