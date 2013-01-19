package org.flexlite.domUI.skins
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.DefaultSkinAdapter;
	import org.flexlite.domUI.core.IInvisibleSkin;
	import org.flexlite.domUI.core.ISkinAdapter;

	use namespace dx_internal;

	[DXML(show = "false")]

	/**
	 * 非显示对象皮肤基类
	 * @author DOM
	 */
	public class InvisibleSkin implements IInvisibleSkin
	{
		/**
		 * 构造函数
		 */
		public function InvisibleSkin()
		{
			super();
		}

		/**
		 * 皮肤解析适配器
		 */
		private static var skinAdapter:ISkinAdapter;
		/**
		 * 默认的皮肤解析适配器
		 */
		private static var defaultSkinAdapter:DefaultSkinAdapter;

		/**
		 * @inheritDoc
		 */
		public function getSkin(state:String, compFunc:Function, oldSkin:DisplayObject):void
		{
			var adapter:ISkinAdapter = skinAdapter;
			if (!adapter)
			{
				try
				{
					adapter = skinAdapter = Injector.getInstance(ISkinAdapter);
				}
				catch (e:Error)
				{
					if (!defaultSkinAdapter)
						defaultSkinAdapter = new DefaultSkinAdapter();
					adapter = defaultSkinAdapter;
				}
			}
			var skinName:Object = skinNameDic[state];
			if (!skinName)
			{
				skinName = skinNameDic[defaultState];
			}
			if (!skinName || skinName == "")
			{
				compFunc(null, skinName);
			}
			else if (skinDic[skinName])
			{
				compFunc(skinDic[skinName], skinName);
			}
			else
			{
				adapter.getSkin(skinName, onComp, oldSkin);
			}
			function onComp(skin:Object, skinName:Object):void
			{
				compFunc(skin, skinName);
				skinDic[skinName] = skin;
			}
		}

		/**
		 * 默认的视图状态,当某个视图状态的皮肤未设置时将使用默认视图状态的皮肤。
		 */
		protected function get defaultState():String
		{
			if (states)
			{
				return states[0];
			}
			return "";
		}

		/**
		 * 皮肤状态字典类
		 */
		private var skinNameDic:Dictionary = new Dictionary;

		/**
		 * 为指定的视图状态设置皮肤标识符
		 */
		protected function setSkinForState(state:String, skinName:Object):void
		{
			skinNameDic[state] = skinName;
		}

		/**
		 * 获取指定的视图状态的皮肤标识符
		 */
		protected function getSkinForState(state:String):Object
		{
			return skinNameDic[state];
		}

		protected var states:Array = [];

		/**
		 * 皮肤显示对象缓存字典
		 */
		private var skinDic:Dictionary = new Dictionary;

		/**
		 * 移除指定皮肤符缓存的显示对象
		 */
		public function removeCachedSkin(skinName:Object):void
		{
			if (skinDic[skinName] !== undefined)
			{
				delete skinDic[skinName];
			}
		}
	}
}
