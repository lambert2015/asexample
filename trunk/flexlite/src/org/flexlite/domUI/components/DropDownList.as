package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.DropDownListBase;
	import org.flexlite.domUI.core.IDisplayText;
	import org.flexlite.domCore.dx_internal;

	use namespace dx_internal;

	[DXML(show = "true")]

	/**
	 * 不可输入的下拉列表控件。带输入功能的下拉列表控件，请使用ComboBox。
	 * @see org.flexlite.domUI.components.ComboBox
	 * @author DOM
	 */
	public class DropDownList extends DropDownListBase
	{
		/**
		 * 构造函数
		 */
		public function DropDownList()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return DropDownList;
		}

		/**
		 * [SkinPart]选中项文本
		 */
		public var labelDisplay:IDisplayText;
		/**
		 * label发生改变标志
		 */
		private var labelChanged:Boolean = false;

		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();

			if (labelChanged)
			{
				labelChanged = false;
				updateLabelDisplay();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if (instance == labelDisplay)
			{
				labelChanged = true;
				invalidateProperties();
			}
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
			if (labelDisplay)
			{
				if (displayItem == undefined)
					displayItem = selectedItem;
				if (displayItem != null && displayItem != undefined)
					labelDisplay.text = itemToLabel(displayItem);
				else
					labelDisplay.text = "";
			}
		}

	}

}
