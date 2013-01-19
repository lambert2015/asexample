package org.flexlite.domUI.components
{
	import flash.events.Event;

	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ArrayCollection;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.events.IndexChangeEvent;

	use namespace dx_internal;

	[DXML(show = "true")]

	/**
	 * 指示索引即将更改,可以通过调用preventDefault()方法阻止索引发生更改
	 */
	[Event(name = "changing", type = "org.flexlite.domUI.events.IndexChangeEvent")]
	/**
	 * 指示索引已更改
	 */
	[Event(name = "change", type = "org.flexlite.domUI.events.IndexChangeEvent")]
	/**
	 * Tab导航容器。<br/>
	 * 使用子项的name属性作为选项卡上显示的字符串。
	 * @author DOM
	 */
	public class TabNavigator extends SkinnableContainer
	{
		/**
		 * 构造函数
		 */
		public function TabNavigator()
		{
			super();
		}

		override protected function get hostComponentKey():Object
		{
			return TabNavigator;
		}
		/**
		 * [SkinPart]选项卡组件
		 */
		public var tabBar:TabBar;

		/**
		 * viewStack引用
		 */
		private function get viewStack():ViewStack
		{
			return contentGroup as ViewStack;
		}

		private var viewStackProperties:Object = {};

		/**
		 * 当前可见的子容器。
		 */
		public function get selectedChild():IVisualElement
		{
			return viewStack ? viewStack.selectedChild :
				viewStackProperties.selectedChild;
		}

		public function set selectedChild(value:IVisualElement):void
		{
			if (viewStack)
			{
				viewStack.selectedChild = value;
			}
			else
			{
				delete viewStackProperties.selectedIndex;
				viewStackProperties.selectedChild = value;
			}
		}

		/**
		 * 当前可见子容器的索引。索引从0开始。
		 */
		public function get selectedIndex():int
		{
			if (viewStack)
				return viewStack.selectedIndex;
			if (viewStackProperties.selectedIndex !== undefined)
				return viewStackProperties.selectedIndex;
			return -1;
		}

		public function set selectedIndex(value:int):void
		{
			if (viewStack)
			{
				viewStack.selectedIndex = value;
			}
			else
			{
				delete viewStackProperties.selectedChild;
				viewStackProperties.selectedIndex = value;
			}
		}

		/**
		 * TabBar数据源
		 */
		private var tabBarData:ArrayCollection = new ArrayCollection;

		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == tabBar)
			{
				tabBar.dataProvider = tabBarData;
				tabBar.selectedIndex = viewStack ? viewStack.selectedIndex : -1;
				tabBar.addEventListener(IndexChangeEvent.CHANGE, onTabBarIndexChange);
				tabBar.addEventListener(IndexChangeEvent.CHANGING, onTabBarIndexChanging);
			}
			else if (instance == viewStack)
			{
				viewStack.addEventListener(IndexChangeEvent.CHANGE, onViewStackIndexChange);
				if (viewStackProperties.selectedIndex !== undefined)
				{
					viewStack.selectedIndex = viewStackProperties.selectedIndex;
				}
				else if (viewStackProperties.selectedChild !== undefined)
				{
					viewStack.selectedChild = viewStackProperties.selectedChild;
				}
				viewStackProperties = {};
			}
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if (instance == tabBar)
			{
				tabBar.dataProvider = null;
				tabBar.removeEventListener(IndexChangeEvent.CHANGE, onTabBarIndexChange);
				tabBar.removeEventListener(IndexChangeEvent.CHANGING, onTabBarIndexChanging);
			}
			else if (instance == viewStack)
			{
				viewStack.removeEventListener(IndexChangeEvent.CHANGE, onViewStackIndexChange);
				viewStackProperties.selectedIndex = viewStack.selectedIndex;
			}
		}

		/**
		 * ViewStack选中项改变事件
		 */
		private function onViewStackIndexChange(event:IndexChangeEvent):void
		{
			if (tabBar)
				tabBar.selectedIndex = event.newIndex;
		}

		/**
		 * 传递TabBar的IndexChanging事件
		 */
		private function onTabBarIndexChanging(event:IndexChangeEvent):void
		{
			if (!dispatchEvent(event))
				event.preventDefault();
		}

		/**
		 * TabBar选中项改变事件
		 */
		private function onTabBarIndexChange(event:IndexChangeEvent):void
		{
			if (viewStack)
				viewStack.setSelectedIndex(event.newIndex, false);
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
		{
			super.contentGroup_elementAddedHandler(event);
			tabBarData.addItemAt(event.element.name, event.index);
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
		{
			super.contentGroup_elementRemovedHandler(event);
			tabBarData.removeItemAt(event.index);
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function removeSkinParts():void
		{
		}
	}
}
