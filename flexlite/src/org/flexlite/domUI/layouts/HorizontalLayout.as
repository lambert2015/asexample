package org.flexlite.domUI.layouts
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;

	[DXML(show = "false")]

	/**
	 * 水平布局
	 * @author DOM
	 */
	public class HorizontalLayout extends LayoutBase
	{
		public function HorizontalLayout()
		{
			super();
		}

		private var _horizontalAlign:String = HorizontalAlign.LEFT;

		/**
		 * 布局元素的水平对齐策略。参考HorizontalAlign定义的常量。
		 * 注意：对HorizontalLayout.horizontalAlign设置JUSTIFY无效。
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(value:String):void
		{
			if (_horizontalAlign == value)
				return;
			_horizontalAlign = value;
			if (target != null)
				target.invalidateDisplayList();
		}

		private var _verticalAlign:String = VerticalAlign.TOP;

		/**
		 * 布局元素的竖直对齐策略。参考VerticalAlign定义的常量。
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign == value)
				return;
			_verticalAlign = value;
			if (target != null)
				target.invalidateDisplayList();
		}

		private var _gap:int = 6;

		/**
		 * 布局元素之间的水平空间（以像素为单位）
		 */
		public function get gap():int
		{
			return _gap;
		}

		public function set gap(value:int):void
		{
			if (_gap == value)
				return;
			_gap = value;
			invalidateTargetSizeAndDisplayList();
			if (hasEventListener("gapChanged"))
				dispatchEvent(new Event("gapChanged"));
		}

		private var _paddingLeft:Number = 0;

		/**
		 * 容器的左边缘与布局元素的左边缘之间的最少像素数
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value)
				return;

			_paddingLeft = value;
			invalidateTargetSizeAndDisplayList();
		}

		private var _paddingRight:Number = 0;

		/**
		 * 容器的右边缘与布局元素的右边缘之间的最少像素数
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value)
				return;

			_paddingRight = value;
			invalidateTargetSizeAndDisplayList();
		}

		private var _paddingTop:Number = 0;

		/**
		 * 容器的顶边缘与第一个布局元素的顶边缘之间的像素数。
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value)
				return;

			_paddingTop = value;
			invalidateTargetSizeAndDisplayList();
		}

		private var _paddingBottom:Number = 0;

		/**
		 * 容器的底边缘与最后一个布局元素的底边缘之间的像素数。
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value)
				return;

			_paddingBottom = value;
			invalidateTargetSizeAndDisplayList();
		}

		/**
		 * 标记目标容器的尺寸和显示列表失效
		 */
		private function invalidateTargetSizeAndDisplayList():void
		{
			if (target != null)
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function measure():void
		{
			super.measure();
			if (target == null)
				return;
			if (useVirtualLayout)
			{
				measureVirtual();
			}
			else
			{
				measureReal();
			}
		}

		/**
		 * 测量使用虚拟布局的尺寸
		 */
		private function measureVirtual():void
		{
			var numElements:int = target.numElements;
			var typicalHeight:Number = typicalLayoutRect ? typicalLayoutRect.height : 22;
			var typicalWidth:Number = typicalLayoutRect ? typicalLayoutRect.width : 71;
			var measuredWidth:Number = getElementTotalSize();
			var measuredHeight:Number = Math.max(maxElementHeight, typicalHeight);

			var visibleIndices:Vector.<int> = target.getElementIndicesInView();
			for each (var i:int in visibleIndices)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement == null || !layoutElement.includeInLayout)
					continue;

				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredWidth += preferredWidth;
				measuredWidth -= isNaN(elementSizeTable[i]) ? typicalWidth : elementSizeTable[i];
				;
				measuredHeight = Math.max(measuredHeight, preferredHeight);
			}
			var hPadding:Number = _paddingLeft + _paddingRight;
			var vPadding:Number = _paddingTop + _paddingBottom;
			target.measuredWidth = Math.ceil(measuredWidth + hPadding);
			target.measuredHeight = Math.ceil(measuredHeight + vPadding);
		}

		/**
		 * 测量使用真实布局的尺寸
		 */
		private function measureReal():void
		{
			var count:int = target.numElements;
			var numElements:int = count;
			var measuredWidth:Number = 0;
			var measuredHeight:Number = 0;
			for (var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (!layoutElement || !layoutElement.includeInLayout)
				{
					numElements--;
					continue;
				}
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredWidth += preferredWidth;
				measuredHeight = Math.max(measuredHeight, preferredHeight);
			}
			measuredWidth += (numElements - 1) * _gap
			var hPadding:Number = _paddingLeft + _paddingRight;
			var vPadding:Number = _paddingTop + _paddingBottom;
			target.measuredWidth = Math.ceil(measuredWidth + hPadding);
			target.measuredHeight = Math.ceil(measuredHeight + vPadding);
		}

		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			if (target == null)
				return;
			if (useVirtualLayout)
			{
				updateDisplayListVirtual(width, height);
			}
			else
			{
				updateDisplayListReal(width, height);
			}
		}


		/**
		 * 虚拟布局使用的子对象尺寸缓存
		 */
		private var elementSizeTable:Array = [];

		/**
		 * 获取指定索引的起始位置
		 */
		private function getStartPosition(index:int):Number
		{
			if (!useVirtualLayout)
			{
				if (target != null)
				{
					return target.getElementAt(index).x;
				}
				return _paddingLeft;
			}
			var typicalWidth:Number = typicalLayoutRect ? typicalLayoutRect.width : 71;
			var startPos:Number = paddingLeft;
			for (var i:int = 0; i < index; i++)
			{
				var eltWidth:Number = elementSizeTable[i];
				if (isNaN(eltWidth))
				{
					eltWidth = typicalWidth;
				}
				startPos += eltWidth + gap;
			}
			return startPos;
		}

		/**
		 * 获取指定索引的元素尺寸
		 */
		private function getElementSize(index:int):Number
		{
			if (useVirtualLayout)
			{
				return elementSizeTable[index];
			}
			if (target != null)
			{
				return target.getElementAt(index).width;
			}
			return 0;
		}

		/**
		 * 获取缓存的子对象尺寸总和
		 */
		private function getElementTotalSize():Number
		{
			var typicalWidth:Number = typicalLayoutRect ? typicalLayoutRect.width : 71;
			var totalSize:Number = 0;
			var length:int = target.numElements;
			for (var i:int = 0; i < length; i++)
			{
				var eltWidth:Number = elementSizeTable[i];
				if (isNaN(eltWidth))
				{
					eltWidth = typicalWidth;
				}
				totalSize += eltWidth + gap;
			}
			totalSize -= gap;
			return totalSize;
		}

		/**
		 * @inheritDoc
		 */
		override public function elementAdded(index:int):void
		{
			if (!useVirtualLayout)
				return;
			super.elementAdded(index);
			var typicalWidth:Number = typicalLayoutRect ? typicalLayoutRect.width : 71;
			elementSizeTable.splice(index, 0, typicalWidth);
		}

		/**
		 * @inheritDoc
		 */
		override public function elementRemoved(index:int):void
		{
			if (!useVirtualLayout)
				return;
			super.elementRemoved(index);
			elementSizeTable.splice(index, 1);
		}

		/**
		 * @inheritDoc
		 */
		override public function clearVirtualLayoutCache():void
		{
			if (!useVirtualLayout)
				return;
			super.clearVirtualLayoutCache();
			elementSizeTable = [];
			maxElementHeight = 0;
		}



		/**
		 * 折半查找法寻找指定位置的显示对象索引
		 */
		private function findIndexAt(x:Number, i0:int, i1:int):int
		{
			var index:int = (i0 + i1) / 2;
			var elementX:Number = getStartPosition(index);
			var elementWidth:Number = getElementSize(index);
			if ((x >= elementX) && (x < elementX + elementWidth + gap))
				return index;
			else if (i0 == i1)
				return -1;
			else if (x < elementX)
				return findIndexAt(x, i0, Math.max(i0, index - 1));
			else
				return findIndexAt(x, Math.min(index + 1, i1), i1);
		}

		/**
		 * 虚拟布局使用的当前视图中的第一个元素索引
		 */
		private var startIndex:int = -1;
		/**
		 * 虚拟布局使用的当前视图中的最后一个元素的索引
		 */
		private var endIndex:int = -1;
		/**
		 * 视图的第一个和最后一个元素的索引值已经计算好的标志
		 */
		private var indexInViewCalculated:Boolean = false;

		/**
		 * @inheritDoc
		 */
		override protected function scrollPositionChanged():void
		{
			super.scrollPositionChanged();
			if (useVirtualLayout)
			{
				var changed:Boolean = getIndexInView();
				if (changed)
				{
					indexInViewCalculated = true;
					target.invalidateDisplayList();
				}
			}

		}

		/**
		 * 获取视图中第一个和最后一个元素的索引,返回是否发生改变
		 */
		private function getIndexInView():Boolean
		{
			if (target == null || target.numElements == 0)
			{
				startIndex = endIndex = -1;
				return false;
			}

			if (isNaN(target.width) || target.width == 0 || isNaN(target.height) || target.height == 0)
			{
				startIndex = endIndex = -1;
				return false;
			}

			var numElements:int = target.numElements;
			var contentWidth:Number = getStartPosition(numElements - 1) +
				elementSizeTable[numElements - 1] + paddingRight;
			var minVisibleX:Number = target.horizontalScrollPosition;
			if (minVisibleX > contentWidth - paddingRight)
			{
				startIndex = -1;
				endIndex = -1;
				return false;
			}
			var maxVisibleX:Number = target.horizontalScrollPosition + target.width;
			if (maxVisibleX < paddingLeft)
			{
				startIndex = -1;
				endIndex = -1;
				return false;
			}
			var oldStartIndex:int = startIndex;
			var oldEndIndex:int = endIndex;
			startIndex = findIndexAt(minVisibleX, 0, numElements - 1);
			if (startIndex == -1)
				startIndex = 0;
			endIndex = findIndexAt(maxVisibleX, 0, numElements - 1);
			if (endIndex == -1)
				endIndex = numElements - 1;
			return oldStartIndex != startIndex || oldEndIndex != endIndex;
		}

		/**
		 * 子对象最大宽度
		 */
		private var maxElementHeight:Number = 0;

		/**
		 * 更新使用虚拟布局的显示列表
		 */
		private function updateDisplayListVirtual(width:Number, height:Number):void
		{
			if (indexInViewCalculated)
				indexInViewCalculated = false;
			else
				getIndexInView();

			var contentWidth:Number;
			var numElements:int = target.numElements;
			if (startIndex == -1 || endIndex == -1)
			{
				contentWidth = getStartPosition(numElements) - _gap + _paddingRight;
				target.setContentSize(Math.ceil(contentWidth), target.contentHeight);
				return;
			}
			//获取垂直布局参数
			var justify:Boolean = _verticalAlign == VerticalAlign.JUSTIFY || _verticalAlign == VerticalAlign.CONTENT_JUSTIFY;
			var contentJustify:Boolean = _verticalAlign == VerticalAlign.CONTENT_JUSTIFY;
			var vAlign:Number = 0;
			if (!justify)
			{
				if (_verticalAlign == VerticalAlign.MIDDLE)
				{
					vAlign = 0.5;
				}
				else if (_verticalAlign == VerticalAlign.BOTTOM)
				{
					vAlign = 1;
				}
			}

			var targetHeight:Number = Math.max(0, height - paddingTop - paddingBottom);
			var justifyHeight:Number = Math.ceil(targetHeight);
			var layoutElement:ILayoutElement;
			if (contentJustify)
			{
				for (var index:int = startIndex; index <= endIndex; index++)
				{
					layoutElement = target.getVirtualElementAt(i) as ILayoutElement;
					if (layoutElement == null || !layoutElement.includeInLayout)
						continue;
					maxElementHeight = Math.max(maxElementHeight, layoutElement.preferredHeight);
				}
				justifyHeight = Math.ceil(Math.max(targetHeight, maxElementHeight));
			}
			var x:Number = 0;
			var y:Number = 0;
			var contentHeight:Number = 0;
			var needInvalidateSize:Boolean = false;
			//对可见区域进行布局
			for (var i:int = startIndex; i <= endIndex; i++)
			{
				var exceesHeight:Number = 0;
				layoutElement = target.getVirtualElementAt(i, true) as ILayoutElement;
				if (layoutElement == null)
				{
					continue;
				}
				else if (!layoutElement.includeInLayout)
				{
					elementSizeTable[i] = 0;
					continue;
				}
				if (justify)
				{
					y = _paddingTop;
					layoutElement.setLayoutBoundsSize(NaN, justifyHeight);
				}
				else
				{
					exceesHeight = (targetHeight - layoutElement.layoutBoundsHeight) * vAlign;
					exceesHeight = exceesHeight > 0 ? exceesHeight : 0;
					y = _paddingTop + Math.round(exceesHeight);
				}
				if (!contentJustify)
					maxElementHeight = Math.max(maxElementHeight, layoutElement.preferredHeight);
				contentHeight = Math.max(contentHeight, layoutElement.layoutBoundsHeight);
				if (!needInvalidateSize && elementSizeTable[i] != layoutElement.layoutBoundsHeight)
					needInvalidateSize = true;
				if (i == 0 && elementSizeTable[i] != layoutElement.layoutBoundsWidth)
					typicalLayoutRect = null;
				elementSizeTable[i] = layoutElement.layoutBoundsWidth;
				x = getStartPosition(i);
				layoutElement.setLayoutBoundsPosition(Math.round(x), Math.round(y));
			}

			contentHeight += paddingTop + paddingBottom;
			contentWidth = getStartPosition(numElements) - _gap + _paddingRight;
			target.setContentSize(Math.ceil(contentWidth),
				Math.ceil(contentHeight));
			if (needInvalidateSize)
			{
				target.invalidateSize();
			}
		}




		/**
		 * 更新使用真实布局的显示列表
		 */
		private function updateDisplayListReal(width:Number, height:Number):void
		{
			var targetWidth:Number = Math.max(0, width - paddingLeft - paddingRight);
			var targetHeight:Number = Math.max(0, height - paddingTop - paddingBottom);

			var justify:Boolean = _verticalAlign == VerticalAlign.JUSTIFY || _verticalAlign == VerticalAlign.CONTENT_JUSTIFY;
			var vAlign:Number = 0;
			if (!justify)
			{
				if (_verticalAlign == VerticalAlign.MIDDLE)
				{
					vAlign = 0.5;
				}
				else if (_verticalAlign == VerticalAlign.BOTTOM)
				{
					vAlign = 1;
				}
			}

			var count:int = target.numElements;
			var numElements:int = count;
			var x:Number = _paddingLeft;
			var y:Number = _paddingTop;
			var i:int;
			var layoutElement:ILayoutElement;


			var excessWidth:Number = targetWidth;
			var totalPercentWidth:Number = 0;
			var childInfoArray:Array = [];
			var childInfo:ChildInfo;
			for (i = 0; i < count; i++)
			{
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement == null || !layoutElement.includeInLayout)
				{
					numElements--;
					continue;
				}
				if (!isNaN(layoutElement.percentWidth))
				{
					totalPercentWidth += layoutElement.percentWidth;

					childInfo = new ChildInfo();
					childInfo.layoutElement = layoutElement;
					childInfo.percent = layoutElement.percentWidth;
					childInfo.min = layoutElement.minWidth
					childInfo.max = layoutElement.maxWidth;
					childInfoArray.push(childInfo);
				}
				else
				{
					maxElementHeight = Math.max(maxElementHeight, layoutElement.preferredHeight);
					excessWidth -= layoutElement.layoutBoundsWidth;
				}
			}

			excessWidth -= (numElements - 1) * _gap;
			excessWidth = excessWidth > 0 ? excessWidth : 0;

			var widthDic:Dictionary = new Dictionary;
			if (totalPercentWidth > 0)
			{
				flexChildrenProportionally(targetWidth, excessWidth,
					totalPercentWidth, childInfoArray);
				var roundOff:Number = 0;
				for each (childInfo in childInfoArray)
				{
					var childSize:int = Math.round(childInfo.size + roundOff);
					roundOff += childInfo.size - childSize;

					widthDic[childInfo.layoutElement] = childSize;
					excessWidth -= childSize;
				}
			}

			excessWidth = excessWidth > 0 ? excessWidth : 0;


			if (_horizontalAlign == HorizontalAlign.CENTER)
			{
				x = _paddingLeft + Math.round(excessWidth * 0.5);
			}
			else if (_horizontalAlign == HorizontalAlign.RIGHT)
			{
				x = _paddingLeft + Math.round(excessWidth);
			}

			var maxX:Number = _paddingLeft;
			var maxY:Number = _paddingTop;
			var dx:Number = 0;
			var dy:Number = 0;
			var justifyHeight:Number = Math.ceil(targetHeight);
			if (_verticalAlign == VerticalAlign.CONTENT_JUSTIFY)
				justifyHeight = Math.ceil(Math.max(targetHeight, maxElementHeight));
			for (i = 0; i < count; i++)
			{
				var exceesHeight:Number = 0;
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement == null || !layoutElement.includeInLayout)
					continue;
				if (justify)
				{
					y = _paddingTop;
					layoutElement.setLayoutBoundsSize(widthDic[layoutElement], justifyHeight);
				}
				else
				{
					var layoutElementHeight:Number = NaN;
					if (!isNaN(layoutElement.percentHeight))
					{
						var percent:Number = Math.min(100, layoutElement.percentHeight);
						layoutElementHeight = Math.round(targetHeight * percent * 0.01);
					}
					layoutElement.setLayoutBoundsSize(widthDic[layoutElement], layoutElementHeight);
					exceesHeight = (targetHeight - layoutElement.layoutBoundsHeight) * vAlign;
					exceesHeight = exceesHeight > 0 ? exceesHeight : 0;
					y = _paddingTop + Math.round(exceesHeight);
				}
				layoutElement.setLayoutBoundsPosition(Math.round(x), Math.round(y));
				dx = Math.ceil(layoutElement.layoutBoundsWidth);
				dy = Math.ceil(layoutElement.layoutBoundsHeight);
				maxX = Math.max(maxX, x + dx);
				maxY = Math.max(maxY, y + dy);
				x += dx + _gap;
			}
			target.setContentSize(Math.ceil(maxX + _paddingRight), Math.ceil(maxY + _paddingBottom));
		}

		/**
		 * 为每个可变尺寸的子项分配空白区域
		 */
		public static function flexChildrenProportionally(spaceForChildren:Number, spaceToDistribute:Number,
			totalPercent:Number, childInfoArray:Array):void
		{

			var numChildren:int = childInfoArray.length;
			var done:Boolean;

			do
			{
				done = true;

				var unused:Number = spaceToDistribute -
					(spaceForChildren * totalPercent / 100);
				if (unused > 0)
					spaceToDistribute -= unused;
				else
					unused = 0;

				var spacePerPercent:Number = spaceToDistribute / totalPercent;

				for (var i:int = 0; i < numChildren; i++)
				{
					var childInfo:ChildInfo = childInfoArray[i];

					var size:Number = childInfo.percent * spacePerPercent;

					if (size < childInfo.min)
					{
						var min:Number = childInfo.min;
						childInfo.size = min;

						childInfoArray[i] = childInfoArray[--numChildren];
						childInfoArray[numChildren] = childInfo;

						totalPercent -= childInfo.percent;
						if (unused >= min)
						{
							unused -= min;
						}
						else
						{
							spaceToDistribute -= min - unused;
							unused = 0;
						}
						done = false;
						break;
					}
					else if (size > childInfo.max)
					{
						var max:Number = childInfo.max;
						childInfo.size = max;

						childInfoArray[i] = childInfoArray[--numChildren];
						childInfoArray[numChildren] = childInfo;

						totalPercent -= childInfo.percent;
						if (unused >= max)
						{
							unused -= max;
						}
						else
						{
							spaceToDistribute -= max - unused;
							unused = 0;
						}
						done = false;
						break;
					}
					else
					{
						childInfo.size = size;
					}
				}
			} while (!done);
		}

		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if (target == null)
				return rect;
			var firstIndex:int = findIndexAt(scrollRect.left, 0, target.numElements - 1);
			if (firstIndex == -1)
			{
				if (scrollRect.left > target.contentWidth - _paddingRight)
				{
					rect.left = target.contentWidth - _paddingRight;
					rect.right = target.contentWidth;
				}
				else
				{
					rect.left = 0;
					rect.right = _paddingLeft;
				}
				return rect;
			}
			rect.left = getStartPosition(firstIndex);
			rect.right = getElementSize(firstIndex) + rect.left;
			if (rect.left == scrollRect.left)
			{
				firstIndex--;
				if (firstIndex != -1)
				{
					rect.left = getStartPosition(firstIndex);
					rect.right = getElementSize(firstIndex) + rect.left;
				}
				else
				{
					rect.left = 0;
					rect.right = _paddingLeft;
				}
			}
			return rect;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if (target == null)
				return rect;
			var numElements:int = target.numElements;
			var lastIndex:int = findIndexAt(scrollRect.right, 0, numElements - 1);
			if (lastIndex == -1)
			{
				if (scrollRect.right < _paddingLeft)
				{
					rect.left = 0;
					rect.right = _paddingLeft;
				}
				else
				{
					rect.left = target.contentWidth - _paddingRight;
					rect.right = target.contentWidth;
				}
				return rect;
			}
			rect.left = getStartPosition(lastIndex);
			rect.right = getElementSize(lastIndex) + rect.left;
			if (rect.right <= scrollRect.right)
			{
				lastIndex++;
				if (lastIndex < numElements)
				{
					rect.left = getStartPosition(lastIndex);
					rect.right = getElementSize(lastIndex) + rect.left;
				}
				else
				{
					rect.left = target.contentWidth - _paddingRight;
					rect.right = target.contentWidth;
				}
			}
			return rect;
		}

	}
}
import org.flexlite.domUI.core.ILayoutElement;

class ChildInfo
{
	public function ChildInfo()
	{
		super();
	}

	public var layoutElement:ILayoutElement;

	public var size:Number = 0;

	public var percent:Number;

	public var min:Number;

	public var max:Number;
}
