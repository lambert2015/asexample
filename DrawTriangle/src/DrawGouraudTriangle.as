package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	public class DrawGouraudTriangle
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
		
		private var drdyl:Number;
		private var drdyr:Number;
		private var dgdyl:Number;
		private var dgdyr:Number;
		private var dbdyl:Number;
		private var dbdyr:Number;
		
		private var r0:int;
		private var g0:int;
		private var b0:int;
		
		private var r1:int;
		private var g1:int;
		private var b1:int;
		
		private var r2:int;
		private var g2:int;
		private var b2:int;
		
		private var ri:Number;
		private var bi:Number;
		private var gi:Number;
		
		private var rl:Number;
		private var gl:Number;
		private var bl:Number;
		
		private var rr:Number;
		private var gr:Number;
		private var br:Number;
		
		private var dr:Number;
		private var dg:Number;
		private var db:Number;
		
		public function DrawGouraudTriangle(target:BitmapData):void
        {
        	this.target=target;
        	rect=target.rect;
		}
		public function drawTriangle(vt0 : Vertex, vt1 : Vertex, vt2 : Vertex):void
		{
			var temp1 : Vertex;
			var tri_type : int;
			var temp : Number;
			if (((vt0.y < rect.y) && (vt1.y < rect.y) && (vt2.y < rect.y)) ||
				((vt0.y > rect.height) && (vt1.y > rect.height) && (vt2.y > rect.height)) ||
				((vt0.x < rect.x) && (vt1.x < rect.x) && (vt2.x < rect.x)) ||
				((vt0.x > rect.width) && (vt1.x > rect.width) && (vt2.x > rect.width)))
				return ;
				if (((vt0.x == vt1.x) && (vt1.x == vt2.x)) || ((vt0.y == vt1.y) && (vt1.y == vt2.y))) return;
				 
				if (vt1.y < vt0.y)
				{
					temp1 = vt0,vt0 = vt1,vt1 = temp1;
				}
				if (vt2.y < vt0.y)
				{
					temp1 = vt0,vt0 = vt2,vt2 = temp1;
				}
				if (vt2.y < vt1.y)
				{
					temp1 = vt1,vt1 = vt2,vt2 = temp1;
				}
				
				if (vt0.y == vt1.y)
				{
					tri_type = Triangle3D.TRI_TYPE_FLAT_TOP;
					
					if (vt1.x < vt0.x)
					{
						temp1 = vt0,vt0 = vt1,vt1 = temp1;
					}
					
				} else if (vt1.y == vt2.y)
				{
					
					tri_type = Triangle3D.TRI_TYPE_FLAT_BOTTOM;
					if (vt2.x < vt1.x)
					{
						temp1 = vt1,vt1 = vt2,vt2 = temp1;
					}
				} else
				{
					tri_type = Triangle3D.TRI_TYPE_GENERAL;
				}
				side = 0;
				 
				r0 = vt0.r,g0 = vt0.g,b0 = vt0.b;
				 
				x0 = vt0.x,y0 = vt0.y;
				
				r1 = vt1.r,g1 = vt1.g,b1 = vt1.b;
				x1 = vt1.x,y1 = vt1.y;
				
				r2 = vt2.r,g2 = vt2.g,b2 = vt2.b;
				x2 = vt2.x,y2 = vt2.y;
				
				ys = y1;
				if (tri_type == Triangle3D.TRI_TYPE_FLAT_TOP || tri_type == Triangle3D.TRI_TYPE_FLAT_BOTTOM)
				{
					
					if (tri_type == Triangle3D.TRI_TYPE_FLAT_TOP)
					{
						 
						dy = 1 / (y2 - y0);
						dxdyl = (x2 - x0) * dy;

						drdyl = (r2 - r0) * dy;
						dgdyl = (g2 - g0) * dy;
						dbdyl = (b2 - b0) * dy;
						
						dxdyr = (x2 - x1) * dy;
						
						drdyr = (r2 - r1) * dy;
						dgdyr = (g2 - g1) * dy;
						dbdyr = (b2 - b1) * dy;
						
						if (y0 < rect.y)
						{
							
							dy = (rect.y - y0);
							
							xl = dxdyl * dy + x0;
							
							rl = drdyl * dy + r0;
							gl = dgdyl * dy + g0;
							bl = dbdyl * dy + b0;
							
							xr = dxdyr * dy + x1;
							
							rr = drdyr * dy + r1;
							gr = dgdyr * dy + g1;
							br = dbdyr * dy + b1;
							
							ystart = rect.y;
						} else
						{
							xl = x0,xr = x1;

						    rl = r0,gl = g0,bl = b0;
							rr = r1,gr = g1,br = b1;
						 
							ystart = y0;
						}
					} 
					else
					{
						 
						dy = 1 / (y1 - y0);
						
						
						dxdyl = (x1 - x0) * dy;

						drdyl = (r1 - r0) * dy;
						dgdyl = (g1 - g0) * dy;
						dbdyl = (b1 - b0) * dy;
						
						dxdyr = (x2 - x0) * dy;
						
						drdyr = (r2 - r0) * dy;
						dgdyr = (g2 - g0) * dy;
						dbdyr = (b2 - b0) * dy;

						 
						if (y0 < rect.y)
						{
							 
							dy = (rect.y - y0);
							 
							xl = dxdyl * dy + x0;
							
							rl = drdyl * dy + r0;
							gl = dgdyl * dy + g0;
							bl = dbdyl * dy + b0;
							 
							xr = dxdyr * dy + x0;
					
							rr = drdyr * dy + r0;
							gr = dgdyr * dy + g0;
							br = dbdyr * dy + b0;
							 
							ystart = rect.y;
						} else
						{
							 
							xl = x0,xr = x0;
							rl = r0,gl = g0,bl = b0;
							rr = r0,gr = g0,br = b0;
							 
							ystart = y0;
						}
					}
					 
					if ((yend = y2) > rect.height) yend = rect.height;
 
					if ((x0 < rect.x) || (x0 > rect.width) ||
					(x1 < rect.x) || (x1 > rect.width) ||
					(x2 < rect.x) || (x2 > rect.width))
					{
						 
						for (yi = ystart; yi <= yend; yi ++)
						{
							 
							xstart = xl;
							xend = xr;
							
							ri = rl,gi = gl,bi = bl;
							if ((dx = (xend - xstart)) > 0)
							{
								dx = 1 / dx;

								dr = (rr - rl) * dx;
								dg = (gr - gl) * dx;
								db = (br - bl) * dx;
							} else
							{
								
								dr = (rr - rl);
								dg = (gr - gl);
								db = (br - bl);
							}
							
							if (xstart < rect.x)
							{
								 
								dx = rect.x - xstart;

								ri += dx * dr,gi += dx * dg,bi += dx * db;
								xstart = rect.x;
							}
							 
							if (xend > rect.width) xend = rect.width;
							
								for (xi = xstart; xi <= xend; xi ++)
								{

								    	//color = (-16777216 | ri << 16 | gi << 8  | bi );
								    	target.setPixel32(xi,yi,(-16777216 | ri << 16 | gi << 8  | bi ));
									ri += dr,gi += dg,bi += db;
								}
							xl += dxdyl;
							rl += drdyl,gl += dgdyl,bl += dbdyl;
							
							xr += dxdyr;
							rr += drdyr,gr += dgdyr,br += dbdyr;
						}
					} else
					{
						 
						for (yi = ystart; yi <= yend; yi ++)
						{
							 
							xstart = xl;
							xend = xr;

							ri = rl,gi = gl,bi = bl;
							 
							if ((dx = (xend - xstart)) > 0)
							{
								dx = 1 / dx;
								dr = (rr - rl) * dx;
								dg = (gr - gl) * dx;
								db = (br - bl) * dx;
							} else
							{
								dr = (rr - rl);
								dg = (gr - gl);
								db = (br - bl);
							}

								for (xi = xstart; xi <= xend; xi ++)
								{
								    	//color = (-16777216 | ri << 16 | gi << 8  | bi );
								    	target.setPixel32(xi,yi,(-16777216 | ri << 16 | gi << 8  | bi ));

									ri += dr,gi += dg,bi += db;
								}

							xl += dxdyl;
							rl += drdyl,gl += dgdyl,bl += dbdyl;
							
							xr += dxdyr;
							rr += drdyr,gr += dgdyr,br += dbdyr;
						}
					}
				} else
				{
					
					if ((yend = y2) > rect.height) yend = rect.height;
					 
					if (y1 < rect.y)
					{
						 
						dyl = 1 / (y2 - y1);
						dxdyl = (x2 - x1 ) * dyl;

						drdyl = (r2 - r1) * dyl;
						dgdyl = (g2 - g1) * dyl;
						dbdyl = (b2 - b1) * dyl;
						 
						dyr = 1 / (y2 - y0);
						
						dxdyr = (x2 - x0 ) * dyr;

						drdyr = (r2 - r0) * dyr;
						dgdyr = (g2 - g0) * dyr;
						dbdyr = (b2 - b0) * dyr;
						 
						dyr = (rect.y - y0);
						dyl = (rect.y - y1);
						xl = dxdyl * dyl + x1;
					
						rl = drdyl * dyl + r1;
						gl = dgdyl * dyl + g1;
						bl = dbdyl * dyl + b1;
						 
						xr = dxdyr * dyr + x0;
						
						rr = drdyr * dyr + r0;
						gr = dgdyr * dyr + g0;
						br = dbdyr * dyr + b0;
						 
						ystart = rect.y;
						 
						if (dxdyr > dxdyl)
						{
							temp = dxdyl,dxdyl = dxdyr,dxdyr = temp;
							
							temp = drdyl,drdyl = drdyr,drdyr = temp;
							temp = dgdyl,dgdyl = dgdyr,dgdyr = temp;
							temp = dbdyl,dbdyl = dbdyr,dbdyr = temp;
							temp = xl,xl = xr,xr = temp;

							temp = x1,x1 = x2,x2 = temp;
							temp = y1,y1 = y2,y2 = temp;
							
							temp = r1,r1 = r2,r2 = temp;
							temp = g1,g1 = g2,g2 = temp;
							temp = b1,b1 = b2,b2 = temp;
						    
							side = 1;
						}
					} 
					else if (y0 < rect.y)
					{
						 
						dyl = 1 / (y1 - y0);
						dxdyl = (x1 - x0) * dyl;
						
						drdyl = (r1 - r0) * dyl;
						dgdyl = (g1 - g0) * dyl;
						dbdyl = (b1 - b0) * dyl;
						 
						dyr = 1 / (y2 - y0);
						dxdyr = (x2 - x0) * dyr;

					
						drdyr = (r2 - r0) * dyr;
						dgdyr = (g2 - g0) * dyr;
						dbdyr = (b2 - b0) * dyr;
						
						dy = (rect.y - y0);
						xl = dxdyl * dy + x0 ;
				
						rl = drdyl * dy + r0;
						gl = dgdyl * dy + g0;
						bl = dbdyl * dy + b0;
						
						xr = dxdyr * dy + x0 ;
					
						rr = drdyr * dy + r0;
						gr = dgdyr * dy + g0;
						br = dbdyr * dy + b0;
						ystart = rect.y;
						if (dxdyr < dxdyl)
						{
							temp = dxdyl,dxdyl = dxdyr,dxdyr = temp;

							
							temp = drdyl,drdyl = drdyr,drdyr = temp;
							temp = dgdyl,dgdyl = dgdyr,dgdyr = temp;
							temp = dbdyl,dbdyl = dbdyr,dbdyr = temp;
							temp = xl,xl = xr,xr = temp;

							temp = x1,x1 = x2,x2 = temp;
							temp = y1,y1 = y2,y2 = temp;
						
							temp = r1,r1 = r2,r2 = temp;
							temp = g1,g1 = g2,g2 = temp;
							temp = b1,b1 = b2,b2 = temp;
						    
							side = 1;
						}
					} else
					{
						 
						dyl = 1 / (y1 - y0);
						dxdyl = (x1 - x0) * dyl;

					
						drdyl = (r1 - r0) * dyl;
						dgdyl = (g1 - g0) * dyl;
						dbdyl = (b1 - b0) * dyl;
						 
						dyr = 1 / (y2 - y0);
						dxdyr = (x2 - x0) * dyr;
					
						drdyr = (r2 - r0) * dyr;
						dgdyr = (g2 - g0) * dyr;
						dbdyr = (b2 - b0) * dyr;
						 
						xl = x0 ,xr = x0 ;
						rl = r0,gl = g0,bl = b0;
						rr = r0,gr = g0,br = b0;
						ystart = y0;
						 
						if (dxdyr < dxdyl)
						{
							temp = dxdyl,dxdyl = dxdyr,dxdyr = temp;
							
							temp = drdyl,drdyl = drdyr,drdyr = temp;
							temp = dgdyl,dgdyl = dgdyr,dgdyr = temp;
							temp = dbdyl,dbdyl = dbdyr,dbdyr = temp;
							temp = xl,xl = xr,xr = temp;

							temp = x1,x1 = x2,x2 = temp;
							temp = y1,y1 = y2,y2 = temp;
						
							temp = r1,r1 = r2,r2 = temp;
							temp = g1,g1 = g2,g2 = temp;
							temp = b1,b1 = b2,b2 = temp;
						    
							side = 1;
						}
					}
			 
					if ((x0 < rect.x) || (x0 > rect.width) ||
					(x1 < rect.x) || (x1 > rect.width) ||
					(x2 < rect.x) || (x2 > rect.width))
					{
						 
						for (yi = ystart; yi <= yend; yi ++)
						{
							 
							xstart = xl;
							xend = xr;

							ri = rl,gi = gl,bi = bl;
							if ((dx = (xend - xstart)) > 0)
							{
								dr = (rr - rl) / dx;
								dg = (gr - gl) / dx;
								db = (br - bl) / dx;

							}  
							else
							{
								dr = (rr - rl);
								dg = (gr - gl);
								db = (br - bl);
							}  
							if (xstart < rect.x)
							{
								 
								dx = rect.x - xstart;

								ri += dx * dr,gi += dx * dg,bi += dx * db;
								xstart = rect.x;
							} 
							if (xend > rect.width) xend = rect.width;

								for (xi = xstart; xi <= xend; xi ++)
								{
								    target.setPixel32(xi,yi,(-16777216 | ri << 16 | gi << 8  | bi ));
	
									ri += dr,gi += dg,bi += db;
								}
							 
							xl += dxdyl;
							rl += drdyl,gl += dgdyl,bl += dbdyl;
							
							xr += dxdyr;
							rr += drdyr,gr += dgdyr,br += dbdyr;
							 
							if (yi == ys)
							{
								 
								if (side == 0)
								{
									 
									dyl = 1 / (y2 - y1);
									dxdyl = (x2 - x1) * dyl;
									
									drdyl = (r2 - r1) * dyl;
									dgdyl = (g2 - g1) * dyl;
									dbdyl = (b2 - b1) * dyl;
									 
									xl = x1 ;
									rl = r1,gl = g1,bl = b1;
									 
									xl += dxdyl;
									rl += drdyl,gl += dgdyl,bl += dbdyl;
								} else
								{
									 
									dyr = 1 / (y1 - y2);
									dxdyr = (x1 - x2) * dyr;

									
									drdyr = (r1 - r2) * dyr;
									dgdyr = (g1 - g2) * dyr;
									dbdyr = (b1 - b2) * dyr;
									 
									xr = x2 ;
									rr = r2,gr = g2,br = b2;
									 
									xr += dxdyr;
									rr += drdyr,gr += dgdyr,br += dbdyr;
								}
							}
						}
					} else
					{
						 
						for (yi = ystart; yi <= yend; yi ++)
						{
							 
							xstart = xl;
							xend = xr;

							ri = rl,gi = gl,bi = bl;
							if ((dx = (xend - xstart)) > 0)
							{
								dx = 1 / dx;

								dr = (rr - rl) * dx;
								dg = (gr - gl) * dx;
								db = (br - bl) * dx;

							} else
							{
								dr = (rr - rl);
								
								dg = (gr - gl);
								db = (br - bl);
							}  
								for (xi = xstart; xi <= xend; xi ++)
								{
								    target.setPixel32(xi,yi,(-16777216 | ri << 16 | gi << 8  | bi ));

									ri += dr,gi += dg,bi += db;
								}
							 
							xl += dxdyl;
							rl += drdyl,gl += dgdyl,bl += dbdyl;

							xr += dxdyr;
							rr += drdyr,gr += dgdyr,br += dbdyr;

							 
							if (yi == ys)
							{ 
								if (side == 0)
								{
									 
									dyl = 1 / (y2 - y1);
									dxdyl = (x2 - x1) * dyl;
									
									drdyl = (r2 - r1) * dyl;
									dgdyl = (g2 - g1) * dyl;
									dbdyl = (b2 - b1) * dyl;
									 
									xl = x1 ;
									
									rl = r1;
									gl = g1;
									bl = b1;
									 
									xl += dxdyl;
									
									rl += drdyl;
									gl += dgdyl;
									bl += dbdyl;
								} else
								{
									 
									dyr = 1 / (y1 - y2);
									dxdyr = (x1 - x2) * dyr;
									
									drdyr = (r1 - r2) * dyr;
									dgdyr = (g1 - g2) * dyr;
									dbdyr = (b1 - b2) * dyr;
									 
									xr = x2 ;
									rr = r2,gr = g2,br = b2;
									 
									xr += dxdyr;
									rr += drdyr,gr += dgdyr,br += dbdyr;
								}
							}
						}
					}
				}
		}
	}
}