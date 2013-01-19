package org.flexlite.domUI.components
{

	import org.flexlite.domUI.core.IDisplayText;

	[DXML(show = "true")]

	/**
	 * 带有标题，内容区域的面板组件
	 * @author DOM
	 */
	public class Panel extends SkinnableContainer
	{
		/**
		 * 构造函数
		 */
		public function Panel()
		{
			super();
			mouseEnabled = false;
		}

		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Panel;
		}

		/**
		 * [SkinPart]标题显示对象
		 */
		public var titleDisplay:IDisplayText;

		private var _title:String = "";
		/**
		 * 标题内容改变
		 */
		private var titleChanged:Boolean;

		/**
		 * 标题文本内容
		 */
		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;

			if (titleDisplay)
				titleDisplay.text = title;
		}

		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if (instance == titleDisplay)
			{
				titleDisplay.text = title;
			}
		}

	}
}
