package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	public class DrawTriangle
	{
		private var target : BitmapData;
		private var rect : Rectangle;
		private var side : int;
		private var ys : int;
		
		private var tri_type : int;
		//初始值
		private var x0 : int, x1 : int, x2 : int;
		private var y0 : int, y1 : int, y2 : int;
		
		private var xi : Number, yi : Number;
		
		private var xstart : int, xend : int;
		private var ystart : int, yend : int;
		private var xl : Number, xr : Number;//左右斜边当前值
		//y每递增1时，左右斜边的增量
		private var dxdyl : Number, dxdyr : Number;
		
		private var dx : Number, dy : Number;
		
		private var dyr : Number, dyl : Number;
        public function DrawTriangle(target:BitmapData):void
        {
        	this.target=target;
        	rect=target.rect;
        }
		public function drawTriangle (vt0 : Vertex, vt1 : Vertex, vt2 : Vertex,color:uint) : void
		{
			var temp1 : Vertex;
			var tri_type : int;
			var temp : Number;
			//判断所有点是否在rect范围内
			if (((vt0.y < rect.y) && (vt1.y < rect.y) && (vt2.y < rect.y)) ||
			((vt0.y > rect.height) && (vt1.y > rect.height) && (vt2.y > rect.height)) ||
			((vt0.x < rect.x) && (vt1.x < rect.x) && (vt2.x < rect.x)) ||
			((vt0.x > rect.width) && (vt1.x > rect.width) && (vt2.x > rect.width)))
			{
				return;
			}
			//判断是否是一条线，如果是，则返回。
			if (((vt0.x == vt1.x) && (vt1.x == vt2.x)) || ((vt0.y == vt1.y) && (vt1.y == vt2.y)))
			{
				return;
			}
			/**
			* 调整vt0,vt1,vt2,让它们的y值从小到大
			*/
			if (vt1.y < vt0.y)
			{
				temp1 = vt0, vt0 = vt1, vt1 = temp1;
			}
			if (vt2.y < vt0.y)
			{
				temp1 = vt0, vt0 = vt2, vt2 = temp1;
			}
			if (vt2.y < vt1.y)
			{
				temp1 = vt1, vt1 = vt2, vt2 = temp1;
			}
			/**
			* 判断三角形的类型
			*/
			if (vt0.y == vt1.y)
			{
				tri_type = Triangle3D.TRI_TYPE_FLAT_TOP;
				if (vt1.x < vt0.x)
				{
					temp1 = vt0, vt0 = vt1, vt1 = temp1;
				}
			} else if (vt1.y == vt2.y)
			{
				tri_type = Triangle3D.TRI_TYPE_FLAT_BOTTOM;
				if (vt2.x < vt1.x)
				{
					temp1 = vt1, vt1 = vt2, vt2 = temp1;
				}
			} else
			{
				tri_type = Triangle3D.TRI_TYPE_GENERAL;
			}
			
			side = 0;//转折后的斜边在哪一侧
			
			x0 = vt0.x, y0 = vt0.y;
			x1 = vt1.x, y1 = vt1.y;
			x2 = vt2.x, y2 = vt2.y;
			
			ys = y1;//转折点y坐标
			if (tri_type == Triangle3D.TRI_TYPE_FLAT_TOP || tri_type == Triangle3D.TRI_TYPE_FLAT_BOTTOM)
			{
				if (tri_type == Triangle3D.TRI_TYPE_FLAT_TOP)
				{
					dy = 1 / (y2 - y0);
					dxdyl = (x2 - x0) * dy;//左斜边倒数
				    dxdyr = (x2 - x1) * dy;//右斜边倒数
				    //y0小于视窗顶部y坐标，调整左斜边和右斜边当前值,y值开始值
					if (y0 < rect.y)
					{
						dy = (rect.y - y0);
						xl = dxdyl * dy + x0;
						xr = dxdyr * dy + x1;
						ystart = rect.y;
					} else
					{
						//注意平顶和平底这里的区别
						xl = x0;
						xr = x1;
						ystart = y0;
					}
				} 
				else
				{//平底三角形
					dy = 1 / (y1 - y0);
					dxdyl = (x1 - x0) * dy;
				    dxdyr = (x2 - x0) * dy;
					if (y0 < rect.y)
					{
						dy = (rect.y - y0);
						xl = dxdyl * dy + x0;
						xr = dxdyr * dy + x0;
						ystart = rect.y;
					} else
					{
						xl = x0;
						xr = x0;
						ystart = y0;
					}
				}
				//y2>视窗高度时，大于rect.height部分就不用画出了
				if ((yend = y2) > rect.height) yend = rect.height;
				
				//x值需要裁剪的情况
				if ((x0 < rect.x) || (x0 > rect.width) ||
				(x1 < rect.x) || (x1 > rect.width) ||
				(x2 < rect.x) || (x2 > rect.width))
				{
					for (yi = ystart; yi <= yend; yi ++)
					{
						xstart = xl;
						xend = xr;
						//初始值需要裁剪
						if (xstart < rect.x)
						{
							xstart = rect.x;
						}
						if (xend > rect.width) xend = rect.width;
						//这里可以使用target.fillRect(new Rectangle(xstart,yi,(xend-xstart),1),color);
						//但以后我们添加颜色插值时，还是必须单独绘制每个像素。
						//绘制扫描线
						for (xi = xstart; xi <= xend; xi ++)
						{
							target.setPixel32 (xi, yi, color);
						}
						//y每增加1时,xl和xr分别加上他们的递增量
						xl += dxdyl;
						xr += dxdyr;
					}
				} else
				{//不需要裁剪的情况
					for (yi = ystart; yi <= yend; yi ++)
					{
						xstart = xl, xend = xr;
						for (xi = xstart; xi <= xend; xi ++)
						{
							target.setPixel32 (xi, yi, color);
						}
						xl += dxdyl;
						xr += dxdyr;
					}
				}
			} else
			{//普通三角形
				if ((yend = y2) > rect.height) yend = rect.height;
				if (y1 < rect.y)
				{//由于y0<y1,这时相当于平顶三角形
					//计算左右斜边的斜率的倒数
					dyl = 1 / (y2 - y1);
					dxdyl = (x2 - x1 ) * dyl;
					dyr = 1 / (y2 - y0);
					dxdyr = (x2 - x0 ) * dyr;
					
					//计算左右斜边初始值
					dyr = (rect.y - y0);
					dyl = (rect.y - y1);
					xl = dxdyl * dyl + x1;
					xr = dxdyr * dyr + x0;
					ystart = rect.y;
					
					if (dxdyr > dxdyl)
					{
						//交换斜边
						temp = dxdyl, dxdyl = dxdyr, dxdyr = temp;
						temp = xl, xl = xr, xr = temp;
						temp = x1, x1 = x2, x2 = temp;
						temp = y1, y1 = y2, y2 = temp;
						side = 1;
					}
				}
				else if (y0 < rect.y)
				{
					dyl = 1 / (y1 - y0);
					dxdyl = (x1 - x0) * dyl;
					dyr = 1 / (y2 - y0);
					dxdyr = (x2 - x0) * dyr;
					
					dy = (rect.y - y0);
					xl = dxdyl * dy + x0;
					xr = dxdyr * dy + x0;
					ystart = rect.y;
					if (dxdyr < dxdyl)
					{
						temp = dxdyl, dxdyl = dxdyr, dxdyr = temp;
						temp = xl, xl = xr, xr = temp;
						temp = x1, x1 = x2, x2 = temp;
						temp = y1, y1 = y2, y2 = temp;
						side = 1;
					}
				} else
				{//y值都大于rect.y
					dyl = 1 / (y1 - y0);
					dxdyl = (x1 - x0) * dyl;
					dyr = 1 / (y2 - y0);
					dxdyr = (x2 - x0) * dyr;
					xl = x0;
					xr = x0;
					ystart = y0;
					if (dxdyr < dxdyl)
					{
						temp = dxdyl, dxdyl = dxdyr, dxdyr = temp;
						temp = xl, xl = xr, xr = temp;
						temp = x1, x1 = x2, x2 = temp;
						temp = y1, y1 = y2, y2 = temp;
						side = 1;
					}
				}
				//x需要裁剪
				if ((x0 < rect.x) || (x0 > rect.width) ||
				(x1 < rect.x) || (x1 > rect.width) ||
				(x2 < rect.x) || (x2 > rect.width))
				{
					for (yi = ystart; yi <= yend; yi ++)
					{
						xstart = xl, xend = xr;
						if (xstart < rect.x)
						{
							dx = rect.x - xstart;
							xstart = rect.x;
						}
						if (xend > rect.width)
						xend = rect.width;
						for (xi = xstart; xi <= xend; xi ++)
						{
							target.setPixel32 (xi, yi, color);
						}
						xl += dxdyl;
						xr += dxdyr;
						//转折点
						if (yi == ys)
						{
							if (side == 0)
							{
								dyl = 1 / (y2 - y1);
								dxdyl = (x2 - x1) * dyl;
								xl = x1;
								xl += dxdyl;
							} else
							{
								dyr = 1 / (y1 - y2);
								dxdyr = (x1 - x2) * dyr;
								xr = x2 ;
								xr += dxdyr;
							}
						}
					}
				} else
				{
					//不需要裁剪
					for (yi = ystart; yi <= yend; yi ++)
					{
						xstart = xl, xend = xr;
						for (xi = xstart; xi <= xend; xi ++)
						{
							target.setPixel32 (xi, yi, color);
						}
						xl += dxdyl;
						xr += dxdyr;
						if (yi == ys)
						{
							if (side == 0)
							{
								dyl = 1 / (y2 - y1);
								dxdyl = (x2 - x1) * dyl;
								xl = x1;
								xl += dxdyl;
							} else
							{
								dyr = 1 / (y1 - y2);
								dxdyr = (x1 - x2) * dyr;
								xr = x2 ;
								xr += dxdyr;
							}
						}
					}
				}
			}
		}
	}
}