package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;


	use namespace dx_internal;


	[DXML(show = "true")]

	[DefaultProperty(name = "dataProvider", array = "false")]

	/**
	 * 添加了项呈示器
	 */
	[Event(name = "rendererAdd", type = "org.flexlite.domUI.events.RendererExistenceEvent")]
	/**
	 * 移除了项呈示器
	 */
	[Event(name = "rendererRemove", type = "org.flexlite.domUI.events.RendererExistenceEvent")]

	/**
	 * 数据项目的容器基类
	 * 将数据项目转换为可视元素以进行显示。
	 * @author DOM
	 */
	public class DataGroup extends GroupBase
	{
		public function DataGroup()
		{
			super();
		}

		private var _rendererOwner:IItemRendererOwner;

		/**
		 * 项呈示器的主机组件
		 */
		dx_internal function get rendererOwner():IItemRendererOwner
		{
			return _rendererOwner;
		}

		dx_internal function set rendererOwner(value:IItemRendererOwner):void
		{
			_rendererOwner = value;
		}


		private var useVirtualLayoutChanged:Boolean = false;

		/**
		 * @inheritDoc
		 */
		override public function set layout(value:LayoutBase):void
		{
			if (value == layout)
				return;

			if (layout != null)
			{
				layout.typicalLayoutRect = null;
				layout.removeEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
			}

			if (layout && value && (layout.useVirtualLayout != value.useVirtualLayout))
				changeUseVirtualLayout();
			super.layout = value;
			if (value)
			{
				value.typicalLayoutRect = typicalLayoutRect;
				value.addEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
			}
		}

		/**
		 * 是否使用虚拟布局标记改变
		 */
		private function layout_useVirtualLayoutChangedHandler(event:Event):void
		{
			changeUseVirtualLayout();
		}

		/**
		 * 存储当前可见的项呈示器索引列表
		 */
		private var virtualRendererIndices:Vector.<int>;

		/**
		 * @inheritDoc
		 */
		override public function getVirtualElementAt(index:int, changeElementInViews:Boolean = false):IVisualElement
		{
			if (index < 0 || index >= dataProvider.length)
				return null;
			if (changeElementInViews)
				virtualRendererIndices.push(index);
			if (indexToRenderer[index] != null)
			{
				return indexToRenderer[index];
			}

			var item:Object = dataProvider[index];
			var renderer:IItemRenderer = createVirtualRenderer(index);
			indexToRenderer[index] = renderer;
			updateRenderer(renderer, index, item);
			if (createNewRendererFlag)
			{
				createNewRendererFlag = false;
				if (renderer is IInvalidating)
					(renderer as IInvalidating).validateNow();
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD,
					false, false, renderer, index, item));
			}
			return renderer as IVisualElement;
		}


		private var freeRenderers:Dictionary = new Dictionary;

		/**
		 * 释放指定索引处的项呈示器
		 */
		private function freeRendererByIndex(index:int):void
		{
			if (indexToRenderer[index] == null)
				return;
			var renderer:IItemRenderer = indexToRenderer[index] as IItemRenderer;
			delete indexToRenderer[index];
			if (renderer != null && renderer is DisplayObject)
			{
				doFreeRenderer(renderer);
			}
		}

		/**
		 * 释放指定的项呈示器
		 */
		private function doFreeRenderer(renderer:IItemRenderer):void
		{
			var rendererClass:Class = getDefinitionByName(getQualifiedClassName(renderer)) as Class;
			if (freeRenderers[rendererClass] == null)
			{
				freeRenderers[rendererClass] = new Vector.<IItemRenderer>();
			}
			freeRenderers[rendererClass].push(renderer);
			(renderer as DisplayObject).visible = false;
		}

		/**
		 * 是否创建了新的项呈示器标志
		 */
		private var createNewRendererFlag:Boolean = false;

		/**
		 * 为指定索引创建虚拟的项呈示器
		 */
		private function createVirtualRenderer(index:int):IItemRenderer
		{
			var item:Object = dataProvider[index];
			var renderer:IItemRenderer;
			var rendererClass:Class = itemToRendererClass(item);
			if (freeRenderers[rendererClass] != null
				&& freeRenderers[rendererClass].length > 0)
			{
				renderer = freeRenderers[rendererClass].pop();
				(renderer as DisplayObject).visible = true;
				return renderer;
			}
			createNewRendererFlag = true;
			return createOneRenderer(rendererClass);
		}

		/**
		 * 根据rendererClass创建一个Renderer,并添加到显示列表
		 */
		private function createOneRenderer(rendererClass:Class):IItemRenderer
		{
			var renderer:IItemRenderer = new rendererClass() as IItemRenderer;
			if (renderer == null || !(renderer is DisplayObject))
				return null;
			if (_itemRendererSkinName)
			{
				var client:ISkinnableClient = renderer as ISkinnableClient;
				if (client && client.skinName == null)
					client.skinName = _itemRendererSkinName;
			}
			super.addChild(renderer as DisplayObject);
			return renderer;
		}

		/**
		 * 虚拟布局结束清理不可见的项呈示器
		 */
		private function finishVirtualLayout():void
		{
			if (!virtualLayoutUnderWay)
				return;
			for (var index:* in indexToRenderer)
			{
				if (virtualRendererIndices.indexOf(index) == -1)
				{
					freeRendererByIndex(index);
				}
			}
			virtualLayoutUnderWay = false;
		}

		/**
		 * @inheritDoc
		 */
		override public function getElementIndicesInView():Vector.<int>
		{
			if (layout != null && layout.useVirtualLayout)
				return virtualRendererIndices == null ?
					new Vector.<int>(0) : virtualRendererIndices;
			return super.getElementIndicesInView();
		}

		/**
		 * 更改是否使用虚拟布局
		 */
		private function changeUseVirtualLayout():void
		{
			useVirtualLayoutChanged = true;
			cleanFreeRenderer = true;
			removeDataProviderListener();
			invalidateProperties();
		}

		private var dataProviderChanged:Boolean = false;

		private var _dataProvider:ICollection;

		/**
		 * 列表数据源，请使用实现了ICollection接口的数据类型，例如ArrayCollection
		 */
		public function get dataProvider():ICollection
		{
			return _dataProvider;
		}

		public function set dataProvider(value:ICollection):void
		{
			if (_dataProvider == value)
				return;
			removeDataProviderListener();
			_dataProvider = value;
			dataProviderChanged = true;
			cleanFreeRenderer = true;
			invalidateProperties();
		}

		/**
		 * 移除数据源监听
		 */
		private function removeDataProviderListener():void
		{
			if (_dataProvider != null)
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}

		/**
		 * 数据源改变事件处理
		 */
		private function onCollectionChange(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					itemAddedHandler(event.items, event.location);
					break;
				case CollectionEventKind.MOVE:
					itemMovedHandler(event.items[0], event.location, event.oldLocation);
					break;
				case CollectionEventKind.REMOVE:
					itemRemovedHandler(event.items, event.location);
					break;
				case CollectionEventKind.UPDATE:
					itemUpdatedHandler(event.items[0], event.location);
					break;
				case CollectionEventKind.REPLACE:
					itemRemoved(event.oldItems[0], event.location);
					itemAdded(event.items[0], event.location);
					break;
				case CollectionEventKind.RESET:
				case CollectionEventKind.REFRESH:
					for (var index:* in indexToRenderer)
					{
						freeRendererByIndex(index);
					}
					dataProviderChanged = true;
					invalidateProperties();
					break;
			}
			invalidateSize();
			invalidateDisplayList();
		}

		/**
		 * 数据源添加项目事件处理
		 */
		private function itemAddedHandler(items:Array, index:int):void
		{
			var length:int = items.length;
			for (var i:int = 0; i < length; i++)
			{
				itemAdded(items[i], index + i);
			}
			resetRenderersIndices();
		}

		/**
		 * 数据源移动项目事件处理
		 */
		private function itemMovedHandler(item:Object, location:int, oldLocation:int):void
		{
			itemRemoved(item, oldLocation);
			itemAdded(item, location);
			resetRenderersIndices();
		}

		/**
		 * 数据源移除项目事件处理
		 */
		private function itemRemovedHandler(items:Array, location:int):void
		{
			var length:int = items.length;
			for (var i:int = length - 1; i >= 0; i--)
			{
				itemRemoved(items[i], location + i);
			}

			resetRenderersIndices();
		}

		/**
		 * 添加一项
		 */
		private function itemAdded(item:Object, index:int):void
		{
			if (layout)
				layout.elementAdded(index);

			if (layout && layout.useVirtualLayout)
			{
				if (virtualRendererIndices)
				{
					const virtualRendererIndicesLength:int = virtualRendererIndices.length;
					for (var i:int = 0; i < virtualRendererIndicesLength; i++)
					{
						const vrIndex:int = virtualRendererIndices[i];
						if (vrIndex >= index)
							virtualRendererIndices[i] = vrIndex + 1;
					}
					indexToRenderer.splice(index, 0, null);
				}
				return;
			}
			var rendererClass:Class = itemToRendererClass(item);
			var renderer:IItemRenderer = createOneRenderer(rendererClass);
			indexToRenderer.splice(index, 0, renderer);
			if (!renderer)
				return;
			updateRenderer(renderer, index, item);
			dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD,
				false, false, renderer, index, item));

		}

		/**
		 * 移除一项
		 */
		private function itemRemoved(item:Object, index:int):void
		{
			if (layout)
				layout.elementRemoved(index);
			if (virtualRendererIndices && (virtualRendererIndices.length > 0))
			{
				var vrItemIndex:int = -1;
				const virtualRendererIndicesLength:int = virtualRendererIndices.length;
				for (var i:int = 0; i < virtualRendererIndicesLength; i++)
				{
					const vrIndex:int = virtualRendererIndices[i];
					if (vrIndex == index)
						vrItemIndex = i;
					else if (vrIndex > index)
						virtualRendererIndices[i] = vrIndex - 1;
				}
				if (vrItemIndex != -1)
					virtualRendererIndices.splice(vrItemIndex, 1);
			}
			const oldRenderer:IItemRenderer = indexToRenderer[index];

			if (indexToRenderer.length > index)
				indexToRenderer.splice(index, 1);

			dispatchEvent(new RendererExistenceEvent(
				RendererExistenceEvent.RENDERER_REMOVE, false, false, oldRenderer, index, item));

			if (oldRenderer != null && oldRenderer is DisplayObject)
			{
				super.removeChild(oldRenderer as DisplayObject);
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE,
					false, false, oldRenderer, oldRenderer.itemIndex, oldRenderer.data));
			}
		}

		/**
		 * 更新当前所有项的索引
		 */
		private function resetRenderersIndices():void
		{
			if (indexToRenderer.length == 0)
				return;

			if (layout && layout.useVirtualLayout)
			{
				for each (var index:int in virtualRendererIndices)
					resetRendererItemIndex(index);
			}
			else
			{
				const indexToRendererLength:int = indexToRenderer.length;
				for (index = 0; index < indexToRendererLength; index++)
					resetRendererItemIndex(index);
			}
		}

		/**
		 * 数据源更新或替换项目事件处理
		 */
		private function itemUpdatedHandler(item:Object, location:int):void
		{
			if (renderersBeingUpdated)
				return; //防止无限循环

			var renderer:IItemRenderer = indexToRenderer[location];
			if (renderer != null)
				updateRenderer(renderer, location, item);
		}

		/**
		 * 调整指定项呈示器的索引值
		 */
		private function resetRendererItemIndex(index:int):void
		{
			var renderer:IItemRenderer = indexToRenderer[index] as IItemRenderer;
			if (renderer)
				renderer.itemIndex = index;
		}


		/**
		 * 项呈示器改变
		 */
		private var itemRendererChanged:Boolean;

		private var _itemRenderer:Class;

		/**
		 * 用于数据项目的项呈示器。该类必须实现 IItemRenderer 接口。<br/>
		 * rendererClass获取顺序：itemRendererFunction > itemRenderer > 默认ItemRenerer。
		 */
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:Class):void
		{
			if (_itemRenderer === value)
				return;
			_itemRenderer = value;
			itemRendererChanged = true;
			typicalItemChanged = true;
			cleanFreeRenderer = true;
			removeDataProviderListener();
			invalidateProperties();
		}

		private var _itemRendererSkinName:Object;

		/**
		 * 条目渲染器的可选皮肤标识符。在实例化itemRenderer时，若其内部没有设置过skinName,则将此属性的值赋值给它的skinName。
		 * 注意:若itemRenderer不是ISkinnableClient，则此属性无效。
		 */
		public function get itemRendererSkinName():Object
		{
			return _itemRendererSkinName;
		}

		public function set itemRendererSkinName(value:Object):void
		{
			_itemRendererSkinName = value;
		}


		private var _itemRendererFunction:Function;

		/**
		 * 为某个特定项目返回一个项呈示器Class的函数。<br/>
		 * rendererClass获取顺序：itemRendererFunction > itemRenderer > 默认ItemRenerer。<br/>
		 * 应该定义一个与此示例函数类似的呈示器函数： <br/>
		 * function myItemRendererFunction(item:Object):Class
		 */
		public function get itemRendererFunction():Function
		{
			return _itemRendererFunction;
		}

		public function set itemRendererFunction(value:Function):void
		{
			if (_itemRendererFunction == value)
				return;
			_itemRendererFunction = value;

			itemRendererChanged = true;
			typicalItemChanged = true;
			removeDataProviderListener();
			invalidateProperties();
		}

		/**
		 * 为特定的数据项返回项呈示器类定义
		 */
		private function itemToRendererClass(item:Object):Class
		{
			var rendererClass:Class;
			if (_itemRendererFunction != null)
			{
				rendererClass = _itemRendererFunction(item);
				if (rendererClass == null)
					rendererClass = _itemRenderer;
			}
			else
			{
				rendererClass = _itemRenderer;
			}
			return rendererClass != null ? rendererClass : ItemRenderer;
		}

		/**
		 * @private
		 * 设置默认的ItemRenderer
		 */
		override protected function createChildren():void
		{
			if (layout == null)
			{
				layout = new VerticalLayout;
			}
			super.createChildren();
		}


		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if (itemRendererChanged || dataProviderChanged || useVirtualLayoutChanged)
			{
				removeAllRenderers();
				if (layout != null)
					layout.clearVirtualLayoutCache();
				useVirtualLayoutChanged = false;
				itemRendererChanged = false;
				if (_dataProvider != null)
					_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
				if (layout != null && layout.useVirtualLayout)
				{
					invalidateSize();
					invalidateDisplayList();
				}
				else
				{
					createRenderers();
				}
				if (dataProviderChanged)
				{
					dataProviderChanged = false;
					verticalScrollPosition = horizontalScrollPosition = 0;
				}
			}

			super.commitProperties();

			if (typicalItemChanged)
			{
				typicalItemChanged = false;
				measureRendererSize();
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			if (layout && layout.useVirtualLayout)
			{
				ensureTypicalLayoutElement();
			}
			super.measure();
		}

		/**
		 * 正在进行虚拟布局阶段
		 */
		private var virtualLayoutUnderWay:Boolean = false;

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (layoutInvalidateDisplayListFlag && layout != null && layout.useVirtualLayout)
			{
				virtualLayoutUnderWay = true;
				virtualRendererIndices = new Vector.<int>();
				ensureTypicalLayoutElement();
			}
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (virtualLayoutUnderWay)
				finishVirtualLayout();
		}

		/**
		 * 用于测试默认大小的数据
		 */
		private var typicalItem:Object

		private var typicalItemChanged:Boolean = false;

		/**
		 * 确保测量过默认条目大小。
		 */
		private function ensureTypicalLayoutElement():void
		{
			if (layout.typicalLayoutRect)
				return;

			if (_dataProvider && _dataProvider.length > 0)
			{
				typicalItem = _dataProvider.getItemAt(0);
				measureRendererSize();
			}
		}

		/**
		 * 测量项呈示器默认尺寸
		 */
		private function measureRendererSize():void
		{
			if (!typicalItem)
			{
				setTypicalLayoutRect(null);
				return;
			}
			var rendererClass:Class = itemToRendererClass(typicalItem);
			var typicalRenderer:IItemRenderer = createOneRenderer(rendererClass);
			if (typicalRenderer == null)
			{
				setTypicalLayoutRect(null);
				return;
			}
			var displayObj:DisplayObject = typicalRenderer as DisplayObject;
			updateRenderer(typicalRenderer, 0, typicalItem);
			if (typicalRenderer is IInvalidating)
				(typicalRenderer as IInvalidating).validateNow();
			var w:Number = isNaN(displayObj.width) ? 0 : displayObj.width;
			var h:Number = isNaN(displayObj.height) ? 0 : displayObj.height;
			var rect:Rectangle = new Rectangle(0, 0,
				Math.abs(w * displayObj.scaleX), Math.abs(h * displayObj.scaleY));
			super.removeChild(displayObj);
			setTypicalLayoutRect(rect);
		}

		/**
		 * 项呈示器的默认尺寸
		 */
		private var typicalLayoutRect:Rectangle;

		/**
		 * 设置项目默认大小
		 */
		private function setTypicalLayoutRect(rect:Rectangle):void
		{
			typicalLayoutRect = rect;
			if (layout)
				layout.typicalLayoutRect = rect;
		}


		/**
		 * 索引到项呈示器的转换数组
		 */
		private var indexToRenderer:Array = [];
		/**
		 * 清理freeRenderer标志
		 */
		private var cleanFreeRenderer:Boolean = false;

		/**
		 * 移除所有项呈示器
		 */
		private function removeAllRenderers():void
		{
			var length:int = indexToRenderer.length;
			var renderer:IItemRenderer;
			for (var i:int = 0; i < length; i++)
			{
				renderer = indexToRenderer[i];
				if (renderer != null)
				{
					super.removeChild(renderer as DisplayObject);
					dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE,
						false, false, renderer, renderer.itemIndex, renderer.data));
				}
			}
			indexToRenderer = [];
			virtualRendererIndices = null;
			if (!cleanFreeRenderer)
				return;
			for each (var list:Vector.<IItemRenderer> in freeRenderers)
			{
				for each (renderer in list)
				{
					super.removeChild(renderer as DisplayObject);
				}
			}
			freeRenderers = new Dictionary;
			cleanFreeRenderer = false;
		}

		/**
		 * 为数据项创建项呈示器
		 */
		private function createRenderers():void
		{
			if (_dataProvider == null)
				return;
			var index:int = 0;
			for each (var item:Object in _dataProvider)
			{
				var rendererClass:Class = itemToRendererClass(item);
				var renderer:IItemRenderer = createOneRenderer(rendererClass);
				if (renderer == null)
					continue;
				indexToRenderer[index] = renderer;
				updateRenderer(renderer, index, item);
				if (renderer is IInvalidating)
					(renderer as IInvalidating).validateNow();
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD,
					false, false, renderer, index, item));
				index++;
			}
		}
		/**
		 * 正在更新数据项的标志
		 */
		private var renderersBeingUpdated:Boolean = false;

		/**
		 * 更新项呈示器
		 */
		protected function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			renderersBeingUpdated = true;

			if (_rendererOwner)
			{
				renderer = _rendererOwner.updateRenderer(renderer, itemIndex, data);
			}
			else
			{
				if (renderer is IVisualElement)
				{
					(renderer as IVisualElement).owner = this;
				}
				renderer.itemIndex = itemIndex;
				renderer.label = itemToLabel(data);
				renderer.data = data;
			}

			renderersBeingUpdated = false;
			return renderer;
		}

		/**
		 * 返回可在项呈示器中显示的 String。
		 * 若DataGroup被作为SkinnableDataContainer的皮肤组件,此方法将不会执行，被SkinnableDataContainer.itemToLabel()所替代。
		 */
		protected function itemToLabel(item:Object):String
		{
			if (item !== null)
				return item.toString();
			else
				return " ";
		}

		/**
		 * @inheritDoc
		 */
		override public function getElementAt(index:int):IVisualElement
		{
			return indexToRenderer[index];
		}

		/**
		 * @inheritDoc
		 */
		override public function getElementIndex(element:IVisualElement):int
		{
			if (element == null)
				return -1;
			return indexToRenderer.indexOf(element);
		}

		/**
		 * @inheritDoc
		 */
		override public function get numElements():int
		{
			if (_dataProvider == null)
				return 0;
			return _dataProvider.length;
		}

		private static const errorStr:String = "在此组件中不可用，若此组件为容器类，请使用";

		[Deprecated]
		/**
		 * addChild()在此组件中不可用，若此组件为容器类，请使用addElement()代替
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("addChild()" + errorStr + "addElement()代替"));
		}

		[Deprecated]
		/**
		 * addChildAt()在此组件中不可用，若此组件为容器类，请使用addElementAt()代替
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw(new Error("addChildAt()" + errorStr + "addElementAt()代替"));
		}

		[Deprecated]
		/**
		 * removeChild()在此组件中不可用，若此组件为容器类，请使用removeElement()代替
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("removeChild()" + errorStr + "removeElement()代替"));
		}

		[Deprecated]
		/**
		 * removeChildAt()在此组件中不可用，若此组件为容器类，请使用removeElementAt()代替
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			throw(new Error("removeChildAt()" + errorStr + "removeElementAt()代替"));
		}

		[Deprecated]
		/**
		 * setChildIndex()在此组件中不可用，若此组件为容器类，请使用setElementIndex()代替
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw(new Error("setChildIndex()" + errorStr + "setElementIndex()代替"));
		}

		[Deprecated]
		/**
		 * swapChildren()在此组件中不可用，若此组件为容器类，请使用swapElements()代替
		 */
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw(new Error("swapChildren()" + errorStr + "swapElements()代替"));
		}

		[Deprecated]
		/**
		 * swapChildrenAt()在此组件中不可用，若此组件为容器类，请使用swapElementsAt()代替
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw(new Error("swapChildrenAt()" + errorStr + "swapElementsAt()代替"));
		}

	}
}
