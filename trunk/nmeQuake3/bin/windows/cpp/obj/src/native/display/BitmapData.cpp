#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_native_Loader
#include <native/Loader.h>
#endif
#ifndef INCLUDED_native_Memory
#include <native/Memory.h>
#endif
#ifndef INCLUDED_native_display_BitmapData
#include <native/display/BitmapData.h>
#endif
#ifndef INCLUDED_native_display_BlendMode
#include <native/display/BlendMode.h>
#endif
#ifndef INCLUDED_native_display_IBitmapDrawable
#include <native/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_native_display_OptimizedPerlin
#include <native/display/OptimizedPerlin.h>
#endif
#ifndef INCLUDED_native_filters_BitmapFilter
#include <native/filters/BitmapFilter.h>
#endif
#ifndef INCLUDED_native_geom_ColorTransform
#include <native/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_native_geom_Matrix
#include <native/geom/Matrix.h>
#endif
#ifndef INCLUDED_native_geom_Point
#include <native/geom/Point.h>
#endif
#ifndef INCLUDED_native_geom_Rectangle
#include <native/geom/Rectangle.h>
#endif
#ifndef INCLUDED_native_utils_ByteArray
#include <native/utils/ByteArray.h>
#endif
#ifndef INCLUDED_native_utils_IDataInput
#include <native/utils/IDataInput.h>
#endif
#ifndef INCLUDED_native_utils_IMemoryRange
#include <native/utils/IMemoryRange.h>
#endif
namespace native{
namespace display{

Void BitmapData_obj::__construct(int inWidth,int inHeight,hx::Null< bool >  __o_inTransparent,Dynamic inFillRGBA,Dynamic inGPUMode)
{
HX_STACK_PUSH("BitmapData::new","native/display/BitmapData.hx",43);
bool inTransparent = __o_inTransparent.Default(true);
{
	HX_STACK_LINE(44)
	int fill_col;		HX_STACK_VAR(fill_col,"fill_col");
	HX_STACK_LINE(45)
	int fill_alpha;		HX_STACK_VAR(fill_alpha,"fill_alpha");
	HX_STACK_LINE(47)
	if (((inFillRGBA == null()))){
		HX_STACK_LINE(49)
		fill_col = (int)16777215;
		HX_STACK_LINE(50)
		fill_alpha = (int)255;
	}
	else{
		struct _Function_2_1{
			inline static int Block( Dynamic &inFillRGBA){
				HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",54);
				{
					HX_STACK_LINE(54)
					int v = inFillRGBA;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(54)
					return (int(v) & int((int)16777215));
				}
				return null();
			}
		};
		HX_STACK_LINE(54)
		fill_col = _Function_2_1::Block(inFillRGBA);
		struct _Function_2_2{
			inline static int Block( Dynamic &inFillRGBA){
				HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",55);
				{
					HX_STACK_LINE(55)
					int v = inFillRGBA;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(55)
					return hx::UShr(v,(int)24);
				}
				return null();
			}
		};
		HX_STACK_LINE(55)
		fill_alpha = _Function_2_2::Block(inFillRGBA);
	}
	HX_STACK_LINE(58)
	if (((bool((inWidth < (int)1)) || bool((inHeight < (int)1))))){
		HX_STACK_LINE(59)
		this->nmeHandle = null();
	}
	else{
		HX_STACK_LINE(64)
		int flags = ::native::display::BitmapData_obj::HARDWARE;		HX_STACK_VAR(flags,"flags");
		HX_STACK_LINE(66)
		if ((inTransparent)){
			HX_STACK_LINE(66)
			hx::OrEq(flags,::native::display::BitmapData_obj::TRANSPARENT);
		}
		HX_STACK_LINE(68)
		this->nmeHandle = ::native::display::BitmapData_obj::nme_bitmap_data_create(inWidth,inHeight,flags,fill_col,fill_alpha,inGPUMode);
	}
}
;
	return null();
}

BitmapData_obj::~BitmapData_obj() { }

Dynamic BitmapData_obj::__CreateEmpty() { return  new BitmapData_obj; }
hx::ObjectPtr< BitmapData_obj > BitmapData_obj::__new(int inWidth,int inHeight,hx::Null< bool >  __o_inTransparent,Dynamic inFillRGBA,Dynamic inGPUMode)
{  hx::ObjectPtr< BitmapData_obj > result = new BitmapData_obj();
	result->__construct(inWidth,inHeight,__o_inTransparent,inFillRGBA,inGPUMode);
	return result;}

Dynamic BitmapData_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BitmapData_obj > result = new BitmapData_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

hx::Object *BitmapData_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::native::display::IBitmapDrawable_obj)) return operator ::native::display::IBitmapDrawable_obj *();
	return super::__ToInterface(inType);
}

bool BitmapData_obj::get_transparent( ){
	HX_STACK_PUSH("BitmapData::get_transparent","native/display/BitmapData.hx",607);
	HX_STACK_THIS(this);
	HX_STACK_LINE(607)
	return ::native::display::BitmapData_obj::nme_bitmap_data_get_transparent(this->nmeHandle);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_transparent,return )

int BitmapData_obj::get_height( ){
	HX_STACK_PUSH("BitmapData::get_height","native/display/BitmapData.hx",606);
	HX_STACK_THIS(this);
	HX_STACK_LINE(606)
	return ::native::display::BitmapData_obj::nme_bitmap_data_height(this->nmeHandle);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_height,return )

int BitmapData_obj::get_width( ){
	HX_STACK_PUSH("BitmapData::get_width","native/display/BitmapData.hx",605);
	HX_STACK_THIS(this);
	HX_STACK_LINE(605)
	return ::native::display::BitmapData_obj::nme_bitmap_data_width(this->nmeHandle);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_width,return )

::native::geom::Rectangle BitmapData_obj::get_rect( ){
	HX_STACK_PUSH("BitmapData::get_rect","native/display/BitmapData.hx",604);
	HX_STACK_THIS(this);
	HX_STACK_LINE(604)
	return ::native::geom::Rectangle_obj::__new((int)0,(int)0,this->get_width(),this->get_height());
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_rect,return )

Void BitmapData_obj::noise( int randomSeed,hx::Null< int >  __o_low,hx::Null< int >  __o_high,hx::Null< int >  __o_channelOptions,hx::Null< bool >  __o_grayScale){
int low = __o_low.Default(0);
int high = __o_high.Default(255);
int channelOptions = __o_channelOptions.Default(7);
bool grayScale = __o_grayScale.Default(false);
	HX_STACK_PUSH("BitmapData::noise","native/display/BitmapData.hx",599);
	HX_STACK_THIS(this);
	HX_STACK_ARG(randomSeed,"randomSeed");
	HX_STACK_ARG(low,"low");
	HX_STACK_ARG(high,"high");
	HX_STACK_ARG(channelOptions,"channelOptions");
	HX_STACK_ARG(grayScale,"grayScale");
{
		HX_STACK_LINE(599)
		::native::display::BitmapData_obj::nme_bitmap_data_noise(this->nmeHandle,randomSeed,low,high,channelOptions,grayScale);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(BitmapData_obj,noise,(void))

Void BitmapData_obj::setFormat( int format){
{
		HX_STACK_PUSH("BitmapData::setFormat","native/display/BitmapData.hx",594);
		HX_STACK_THIS(this);
		HX_STACK_ARG(format,"format");
		HX_STACK_LINE(594)
		::native::display::BitmapData_obj::nme_bitmap_data_set_format(this->nmeHandle,format);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,setFormat,(void))

Void BitmapData_obj::unlock( ::native::geom::Rectangle changeRect){
{
		HX_STACK_PUSH("BitmapData::unlock","native/display/BitmapData.hx",589);
		HX_STACK_THIS(this);
		HX_STACK_ARG(changeRect,"changeRect");
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,unlock,(void))

Void BitmapData_obj::setVector( ::native::geom::Rectangle rect,Array< int > inPixels){
{
		HX_STACK_PUSH("BitmapData::setVector","native/display/BitmapData.hx",573);
		HX_STACK_THIS(this);
		HX_STACK_ARG(rect,"rect");
		HX_STACK_ARG(inPixels,"inPixels");
		HX_STACK_LINE(574)
		int count = ::Std_obj::_int((rect->width * rect->height));		HX_STACK_VAR(count,"count");
		HX_STACK_LINE(576)
		if (((inPixels->length < count))){
			HX_STACK_LINE(576)
			return null();
		}
		HX_STACK_LINE(579)
		::native::display::BitmapData_obj::nme_bitmap_data_set_array(this->nmeHandle,rect,inPixels);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,setVector,(void))

Void BitmapData_obj::setPixels( ::native::geom::Rectangle rect,::native::utils::ByteArray pixels){
{
		HX_STACK_PUSH("BitmapData::setPixels","native/display/BitmapData.hx",565);
		HX_STACK_THIS(this);
		HX_STACK_ARG(rect,"rect");
		HX_STACK_ARG(pixels,"pixels");
		HX_STACK_LINE(566)
		int size = ::Std_obj::_int(((rect->width * rect->height) * (int)4));		HX_STACK_VAR(size,"size");
		HX_STACK_LINE(567)
		pixels->checkData(::Std_obj::_int(size));
		HX_STACK_LINE(568)
		::native::display::BitmapData_obj::nme_bitmap_data_set_bytes(this->nmeHandle,rect,pixels,pixels->position);
		HX_STACK_LINE(569)
		hx::AddEq(pixels->position,size);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,setPixels,(void))

Void BitmapData_obj::setPixel32( int inX,int inY,int inColour){
{
		HX_STACK_PUSH("BitmapData::setPixel32","native/display/BitmapData.hx",556);
		HX_STACK_THIS(this);
		HX_STACK_ARG(inX,"inX");
		HX_STACK_ARG(inY,"inY");
		HX_STACK_ARG(inColour,"inColour");
		HX_STACK_LINE(556)
		::native::display::BitmapData_obj::nme_bitmap_data_set_pixel32(this->nmeHandle,inX,inY,inColour);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,setPixel32,(void))

Void BitmapData_obj::setPixel( int inX,int inY,int inColour){
{
		HX_STACK_PUSH("BitmapData::setPixel","native/display/BitmapData.hx",551);
		HX_STACK_THIS(this);
		HX_STACK_ARG(inX,"inX");
		HX_STACK_ARG(inY,"inY");
		HX_STACK_ARG(inColour,"inColour");
		HX_STACK_LINE(551)
		::native::display::BitmapData_obj::nme_bitmap_data_set_pixel(this->nmeHandle,inX,inY,inColour);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,setPixel,(void))

Void BitmapData_obj::setFlags( int inFlags){
{
		HX_STACK_PUSH("BitmapData::setFlags","native/display/BitmapData.hx",545);
		HX_STACK_THIS(this);
		HX_STACK_ARG(inFlags,"inFlags");
		HX_STACK_LINE(545)
		::native::display::BitmapData_obj::nme_bitmap_data_set_flags(this->nmeHandle,inFlags);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,setFlags,(void))

Void BitmapData_obj::scroll( int inDX,int inDY){
{
		HX_STACK_PUSH("BitmapData::scroll","native/display/BitmapData.hx",540);
		HX_STACK_THIS(this);
		HX_STACK_ARG(inDX,"inDX");
		HX_STACK_ARG(inDY,"inDY");
		HX_STACK_LINE(540)
		::native::display::BitmapData_obj::nme_bitmap_data_scroll(this->nmeHandle,inDX,inDY);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,scroll,(void))

Void BitmapData_obj::perlinNoise( Float baseX,Float baseY,int numOctaves,int randomSeed,bool stitch,bool fractalNoise,hx::Null< int >  __o_channelOptions,hx::Null< bool >  __o_grayScale,Array< ::Dynamic > offsets){
int channelOptions = __o_channelOptions.Default(7);
bool grayScale = __o_grayScale.Default(false);
	HX_STACK_PUSH("BitmapData::perlinNoise","native/display/BitmapData.hx",534);
	HX_STACK_THIS(this);
	HX_STACK_ARG(baseX,"baseX");
	HX_STACK_ARG(baseY,"baseY");
	HX_STACK_ARG(numOctaves,"numOctaves");
	HX_STACK_ARG(randomSeed,"randomSeed");
	HX_STACK_ARG(stitch,"stitch");
	HX_STACK_ARG(fractalNoise,"fractalNoise");
	HX_STACK_ARG(channelOptions,"channelOptions");
	HX_STACK_ARG(grayScale,"grayScale");
	HX_STACK_ARG(offsets,"offsets");
{
		HX_STACK_LINE(535)
		::native::display::OptimizedPerlin perlin = ::native::display::OptimizedPerlin_obj::__new(randomSeed,numOctaves,null());		HX_STACK_VAR(perlin,"perlin");
		HX_STACK_LINE(536)
		perlin->fill(hx::ObjectPtr<OBJ_>(this),baseX,baseY,(int)0,null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC9(BitmapData_obj,perlinNoise,(void))

Void BitmapData_obj::nmeLoadFromBytes( ::native::utils::ByteArray inBytes,::native::utils::ByteArray inRawAlpha){
{
		HX_STACK_PUSH("BitmapData::nmeLoadFromBytes","native/display/BitmapData.hx",529);
		HX_STACK_THIS(this);
		HX_STACK_ARG(inBytes,"inBytes");
		HX_STACK_ARG(inRawAlpha,"inRawAlpha");
		HX_STACK_LINE(529)
		this->nmeHandle = ::native::display::BitmapData_obj::nme_bitmap_data_from_bytes(inBytes,inRawAlpha);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,nmeLoadFromBytes,(void))

Void BitmapData_obj::nmeDrawToSurface( Dynamic inSurface,::native::geom::Matrix matrix,::native::geom::ColorTransform colorTransform,::String blendMode,::native::geom::Rectangle clipRect,bool smoothing){
{
		HX_STACK_PUSH("BitmapData::nmeDrawToSurface","native/display/BitmapData.hx",523);
		HX_STACK_THIS(this);
		HX_STACK_ARG(inSurface,"inSurface");
		HX_STACK_ARG(matrix,"matrix");
		HX_STACK_ARG(colorTransform,"colorTransform");
		HX_STACK_ARG(blendMode,"blendMode");
		HX_STACK_ARG(clipRect,"clipRect");
		HX_STACK_ARG(smoothing,"smoothing");
		HX_STACK_LINE(523)
		::native::display::BitmapData_obj::nme_render_surface_to_surface(inSurface,this->nmeHandle,matrix,colorTransform,blendMode,clipRect,smoothing);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(BitmapData_obj,nmeDrawToSurface,(void))

Void BitmapData_obj::lock( ){
{
		HX_STACK_PUSH("BitmapData::lock","native/display/BitmapData.hx",519);
		HX_STACK_THIS(this);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,lock,(void))

Array< int > BitmapData_obj::getVector( ::native::geom::Rectangle rect){
	HX_STACK_PUSH("BitmapData::getVector","native/display/BitmapData.hx",480);
	HX_STACK_THIS(this);
	HX_STACK_ARG(rect,"rect");
	HX_STACK_LINE(481)
	int pixels = ::Std_obj::_int((rect->width * rect->height));		HX_STACK_VAR(pixels,"pixels");
	HX_STACK_LINE(483)
	if (((pixels < (int)1))){
		HX_STACK_LINE(483)
		return Array_obj< int >::__new();
	}
	HX_STACK_LINE(485)
	Array< int > result = Array_obj< int >::__new();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(486)
	result[(pixels - (int)1)] = (int)0;
	HX_STACK_LINE(489)
	::native::display::BitmapData_obj::nme_bitmap_data_get_array(this->nmeHandle,rect,result);
	HX_STACK_LINE(496)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,getVector,return )

::native::utils::ByteArray BitmapData_obj::getPixels( ::native::geom::Rectangle rect){
	HX_STACK_PUSH("BitmapData::getPixels","native/display/BitmapData.hx",452);
	HX_STACK_THIS(this);
	HX_STACK_ARG(rect,"rect");
	HX_STACK_LINE(453)
	::native::utils::ByteArray result = ::native::display::BitmapData_obj::nme_bitmap_data_get_pixels(this->nmeHandle,rect);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(454)
	if (((result != null()))){
		HX_STACK_LINE(454)
		result->position = result->length;
	}
	HX_STACK_LINE(455)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,getPixels,return )

int BitmapData_obj::getPixel32( int x,int y){
	HX_STACK_PUSH("BitmapData::getPixel32","native/display/BitmapData.hx",443);
	HX_STACK_THIS(this);
	HX_STACK_ARG(x,"x");
	HX_STACK_ARG(y,"y");
	HX_STACK_LINE(443)
	return ::native::display::BitmapData_obj::nme_bitmap_data_get_pixel32(this->nmeHandle,x,y);
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,getPixel32,return )

int BitmapData_obj::getPixel( int x,int y){
	HX_STACK_PUSH("BitmapData::getPixel","native/display/BitmapData.hx",438);
	HX_STACK_THIS(this);
	HX_STACK_ARG(x,"x");
	HX_STACK_ARG(y,"y");
	HX_STACK_LINE(438)
	return ::native::display::BitmapData_obj::nme_bitmap_data_get_pixel(this->nmeHandle,x,y);
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,getPixel,return )

::native::geom::Rectangle BitmapData_obj::getColorBoundsRect( int mask,int color,hx::Null< bool >  __o_findColor){
bool findColor = __o_findColor.Default(true);
	HX_STACK_PUSH("BitmapData::getColorBoundsRect","native/display/BitmapData.hx",431);
	HX_STACK_THIS(this);
	HX_STACK_ARG(mask,"mask");
	HX_STACK_ARG(color,"color");
	HX_STACK_ARG(findColor,"findColor");
{
		HX_STACK_LINE(432)
		::native::geom::Rectangle result = ::native::geom::Rectangle_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(433)
		::native::display::BitmapData_obj::nme_bitmap_data_get_color_bounds_rect(this->nmeHandle,mask,color,findColor,result);
		HX_STACK_LINE(434)
		return result;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,getColorBoundsRect,return )

::native::geom::Rectangle BitmapData_obj::generateFilterRect( ::native::geom::Rectangle sourceRect,::native::filters::BitmapFilter filter){
	HX_STACK_PUSH("BitmapData::generateFilterRect","native/display/BitmapData.hx",424);
	HX_STACK_THIS(this);
	HX_STACK_ARG(sourceRect,"sourceRect");
	HX_STACK_ARG(filter,"filter");
	HX_STACK_LINE(425)
	::native::geom::Rectangle result = ::native::geom::Rectangle_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(426)
	::native::display::BitmapData_obj::nme_bitmap_data_generate_filter_rect(sourceRect,filter,result);
	HX_STACK_LINE(427)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,generateFilterRect,return )

int BitmapData_obj::_self_threshold( ::String operation,int threshold,hx::Null< int >  __o_color,hx::Null< int >  __o_mask){
int color = __o_color.Default(0);
int mask = __o_mask.Default(-1);
	HX_STACK_PUSH("BitmapData::_self_threshold","native/display/BitmapData.hx",375);
	HX_STACK_THIS(this);
	HX_STACK_ARG(operation,"operation");
	HX_STACK_ARG(threshold,"threshold");
	HX_STACK_ARG(color,"color");
	HX_STACK_ARG(mask,"mask");
{
		HX_STACK_LINE(376)
		int hits = (int)0;		HX_STACK_VAR(hits,"hits");
		HX_STACK_LINE(379)
		threshold = (int((int((int((int(((int(threshold) & int((int)255)))) << int((int)24))) | int((int(((int((int(threshold) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(threshold) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(threshold) >> int((int)24))) & int((int)255))));
		HX_STACK_LINE(380)
		color = (int((int((int((int(((int(color) & int((int)255)))) << int((int)24))) | int((int(((int((int(color) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(color) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(color) >> int((int)24))) & int((int)255))));
		HX_STACK_LINE(383)
		::native::utils::ByteArray mem = ::native::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(mem,"mem");
		HX_STACK_LINE(385)
		mem->setLength(((this->get_width() * this->get_height()) * (int)4));
		HX_STACK_LINE(388)
		::native::utils::ByteArray mem1 = this->getPixels(this->get_rect());		HX_STACK_VAR(mem1,"mem1");
		HX_STACK_LINE(389)
		mem1->position = (int)0;
		HX_STACK_LINE(392)
		::native::Memory_obj::select(mem1);
		HX_STACK_LINE(394)
		int thresh_mask = (int(threshold) & int(mask));		HX_STACK_VAR(thresh_mask,"thresh_mask");
		HX_STACK_LINE(396)
		{
			HX_STACK_LINE(396)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			int _g = this->get_height();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(396)
			while(((_g1 < _g))){
				HX_STACK_LINE(396)
				int yy = (_g1)++;		HX_STACK_VAR(yy,"yy");
				HX_STACK_LINE(397)
				int width_yy = (this->get_width() * yy);		HX_STACK_VAR(width_yy,"width_yy");
				HX_STACK_LINE(398)
				{
					HX_STACK_LINE(398)
					int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
					int _g2 = this->get_width();		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(398)
					while(((_g3 < _g2))){
						HX_STACK_LINE(398)
						int xx = (_g3)++;		HX_STACK_VAR(xx,"xx");
						HX_STACK_LINE(399)
						int pos = (((width_yy + xx)) * (int)4);		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(400)
						int pixelValue = ::native::Memory_obj::getI32(pos);		HX_STACK_VAR(pixelValue,"pixelValue");
						HX_STACK_LINE(401)
						int pix_mask = (int(pixelValue) & int(mask));		HX_STACK_VAR(pix_mask,"pix_mask");
						HX_STACK_LINE(403)
						int i = ::native::display::BitmapData_obj::ucompare(pix_mask,thresh_mask);		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(404)
						bool test = false;		HX_STACK_VAR(test,"test");
						HX_STACK_LINE(405)
						if (((operation == HX_CSTRING("==")))){
							HX_STACK_LINE(405)
							test = (i == (int)0);
						}
						else{
							HX_STACK_LINE(406)
							if (((operation == HX_CSTRING("<")))){
								HX_STACK_LINE(406)
								test = (i == (int)-1);
							}
							else{
								HX_STACK_LINE(407)
								if (((operation == HX_CSTRING(">")))){
									HX_STACK_LINE(407)
									test = (i == (int)1);
								}
								else{
									HX_STACK_LINE(408)
									if (((operation == HX_CSTRING("!=")))){
										HX_STACK_LINE(408)
										test = (i != (int)0);
									}
									else{
										HX_STACK_LINE(409)
										if (((operation == HX_CSTRING("<=")))){
											HX_STACK_LINE(409)
											test = (bool((i == (int)0)) || bool((i == (int)-1)));
										}
										else{
											HX_STACK_LINE(410)
											if (((operation == HX_CSTRING(">=")))){
												HX_STACK_LINE(410)
												test = (bool((i == (int)0)) || bool((i == (int)1)));
											}
										}
									}
								}
							}
						}
						HX_STACK_LINE(411)
						if ((test)){
							HX_STACK_LINE(412)
							::native::Memory_obj::setI32(pos,color);
							HX_STACK_LINE(413)
							(hits)++;
						}
					}
				}
			}
		}
		HX_STACK_LINE(417)
		mem1->position = (int)0;
		HX_STACK_LINE(418)
		this->setPixels(this->get_rect(),mem1);
		HX_STACK_LINE(419)
		::native::Memory_obj::select(null());
		HX_STACK_LINE(420)
		return hits;
	}
}


HX_DEFINE_DYNAMIC_FUNC4(BitmapData_obj,_self_threshold,return )

int BitmapData_obj::threshold( ::native::display::BitmapData sourceBitmapData,::native::geom::Rectangle sourceRect,::native::geom::Point destPoint,::String operation,int threshold,hx::Null< int >  __o_color,hx::Null< int >  __o_mask,hx::Null< bool >  __o_copySource){
int color = __o_color.Default(0);
int mask = __o_mask.Default(-1);
bool copySource = __o_copySource.Default(false);
	HX_STACK_PUSH("BitmapData::threshold","native/display/BitmapData.hx",215);
	HX_STACK_THIS(this);
	HX_STACK_ARG(sourceBitmapData,"sourceBitmapData");
	HX_STACK_ARG(sourceRect,"sourceRect");
	HX_STACK_ARG(destPoint,"destPoint");
	HX_STACK_ARG(operation,"operation");
	HX_STACK_ARG(threshold,"threshold");
	HX_STACK_ARG(color,"color");
	HX_STACK_ARG(mask,"mask");
	HX_STACK_ARG(copySource,"copySource");
{
		HX_STACK_LINE(218)
		if (((bool((bool((bool((sourceBitmapData == hx::ObjectPtr<OBJ_>(this))) && bool(sourceRect->equals(this->get_rect())))) && bool((destPoint->x == (int)0)))) && bool((destPoint->y == (int)0))))){
			HX_STACK_LINE(218)
			return this->_self_threshold(operation,threshold,color,mask);
		}
		HX_STACK_LINE(222)
		int sx = ::Std_obj::_int(sourceRect->x);		HX_STACK_VAR(sx,"sx");
		HX_STACK_LINE(223)
		int sy = ::Std_obj::_int(sourceRect->y);		HX_STACK_VAR(sy,"sy");
		HX_STACK_LINE(224)
		int sw = ::Std_obj::_int(sourceBitmapData->get_width());		HX_STACK_VAR(sw,"sw");
		HX_STACK_LINE(225)
		int sh = ::Std_obj::_int(sourceBitmapData->get_height());		HX_STACK_VAR(sh,"sh");
		HX_STACK_LINE(227)
		int dx = ::Std_obj::_int(destPoint->x);		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(228)
		int dy = ::Std_obj::_int(destPoint->y);		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(230)
		int bw = ((this->get_width() - sw) - dx);		HX_STACK_VAR(bw,"bw");
		HX_STACK_LINE(231)
		int bh = ((this->get_height() - sh) - dy);		HX_STACK_VAR(bh,"bh");
		HX_STACK_LINE(233)
		int dw = (  (((bw < (int)0))) ? int((sw + (((this->get_width() - sw) - dx)))) : int(sw) );		HX_STACK_VAR(dw,"dw");
		HX_STACK_LINE(234)
		int dh = (  (((bw < (int)0))) ? int((sh + (((this->get_height() - sh) - dy)))) : int(sh) );		HX_STACK_VAR(dh,"dh");
		HX_STACK_LINE(236)
		int hits = (int)0;		HX_STACK_VAR(hits,"hits");
		HX_STACK_LINE(239)
		threshold = (int((int((int((int(((int(threshold) & int((int)255)))) << int((int)24))) | int((int(((int((int(threshold) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(threshold) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(threshold) >> int((int)24))) & int((int)255))));
		HX_STACK_LINE(240)
		color = (int((int((int((int(((int(color) & int((int)255)))) << int((int)24))) | int((int(((int((int(color) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(color) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(color) >> int((int)24))) & int((int)255))));
		HX_STACK_LINE(245)
		int canvas_mem = ((sw * sh) * (int)4);		HX_STACK_VAR(canvas_mem,"canvas_mem");
		HX_STACK_LINE(246)
		int source_mem = (int)0;		HX_STACK_VAR(source_mem,"source_mem");
		HX_STACK_LINE(247)
		if ((copySource)){
			HX_STACK_LINE(247)
			source_mem = ((sw * sh) * (int)4);
		}
		HX_STACK_LINE(251)
		int total_mem = (canvas_mem + source_mem);		HX_STACK_VAR(total_mem,"total_mem");
		HX_STACK_LINE(252)
		::native::utils::ByteArray mem = ::native::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(mem,"mem");
		HX_STACK_LINE(253)
		mem->setLength(total_mem);
		HX_STACK_LINE(256)
		mem->position = (int)0;
		HX_STACK_LINE(257)
		::native::display::BitmapData bd1 = sourceBitmapData->clone();		HX_STACK_VAR(bd1,"bd1");
		HX_STACK_LINE(258)
		mem->writeBytes(bd1->getPixels(sourceRect),null(),null());
		HX_STACK_LINE(259)
		mem->position = canvas_mem;
		HX_STACK_LINE(260)
		if ((copySource)){
			HX_STACK_LINE(261)
			::native::display::BitmapData bd2 = sourceBitmapData->clone();		HX_STACK_VAR(bd2,"bd2");
			HX_STACK_LINE(262)
			mem->writeBytes(bd2->getPixels(sourceRect),null(),null());
		}
		HX_STACK_LINE(265)
		mem->position = (int)0;
		HX_STACK_LINE(268)
		::native::Memory_obj::select(mem);
		HX_STACK_LINE(270)
		int thresh_mask = (int(threshold) & int(mask));		HX_STACK_VAR(thresh_mask,"thresh_mask");
		HX_STACK_LINE(273)
		{
			HX_STACK_LINE(273)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(273)
			while(((_g < dh))){
				HX_STACK_LINE(273)
				int yy = (_g)++;		HX_STACK_VAR(yy,"yy");
				HX_STACK_LINE(274)
				{
					HX_STACK_LINE(274)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(274)
					while(((_g1 < dw))){
						HX_STACK_LINE(274)
						int xx = (_g1)++;		HX_STACK_VAR(xx,"xx");
						HX_STACK_LINE(275)
						int pos = ((((xx + sx) + (((yy + sy)) * sw))) * (int)4);		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(276)
						int pixelValue = ::native::Memory_obj::getI32(pos);		HX_STACK_VAR(pixelValue,"pixelValue");
						HX_STACK_LINE(277)
						int pix_mask = (int(pixelValue) & int(mask));		HX_STACK_VAR(pix_mask,"pix_mask");
						HX_STACK_LINE(279)
						int i = ::native::display::BitmapData_obj::ucompare(pix_mask,thresh_mask);		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(280)
						bool test = false;		HX_STACK_VAR(test,"test");
						HX_STACK_LINE(281)
						if (((operation == HX_CSTRING("==")))){
							HX_STACK_LINE(281)
							test = (i == (int)0);
						}
						else{
							HX_STACK_LINE(282)
							if (((operation == HX_CSTRING("<")))){
								HX_STACK_LINE(282)
								test = (i == (int)-1);
							}
							else{
								HX_STACK_LINE(283)
								if (((operation == HX_CSTRING(">")))){
									HX_STACK_LINE(283)
									test = (i == (int)1);
								}
								else{
									HX_STACK_LINE(284)
									if (((operation == HX_CSTRING("!=")))){
										HX_STACK_LINE(284)
										test = (i != (int)0);
									}
									else{
										HX_STACK_LINE(285)
										if (((operation == HX_CSTRING("<=")))){
											HX_STACK_LINE(285)
											test = (bool((i == (int)0)) || bool((i == (int)-1)));
										}
										else{
											HX_STACK_LINE(286)
											if (((operation == HX_CSTRING(">=")))){
												HX_STACK_LINE(286)
												test = (bool((i == (int)0)) || bool((i == (int)1)));
											}
										}
									}
								}
							}
						}
						HX_STACK_LINE(287)
						if ((test)){
							HX_STACK_LINE(288)
							::native::Memory_obj::setI32(pos,color);
							HX_STACK_LINE(289)
							(hits)++;
						}
						else{
							HX_STACK_LINE(290)
							if ((copySource)){
								HX_STACK_LINE(291)
								int source_color = ::native::Memory_obj::getI32((canvas_mem + pos));		HX_STACK_VAR(source_color,"source_color");
								HX_STACK_LINE(292)
								::native::Memory_obj::setI32(pos,source_color);
							}
						}
					}
				}
			}
		}
		HX_STACK_LINE(296)
		mem->position = (int)0;
		HX_STACK_LINE(297)
		bd1->setPixels(sourceRect,mem);
		HX_STACK_LINE(298)
		this->copyPixels(bd1,bd1->get_rect(),destPoint,null(),null(),null());
		HX_STACK_LINE(299)
		::native::Memory_obj::select(null());
		HX_STACK_LINE(300)
		return hits;
	}
}


HX_DEFINE_DYNAMIC_FUNC8(BitmapData_obj,threshold,return )

Void BitmapData_obj::floodFill( int x,int y,int color){
{
		HX_STACK_PUSH("BitmapData::floodFill","native/display/BitmapData.hx",185);
		HX_STACK_THIS(this);
		HX_STACK_ARG(x,"x");
		HX_STACK_ARG(y,"y");
		HX_STACK_ARG(color,"color");
		HX_STACK_LINE(185)
		::native::display::BitmapData_obj::nme_bitmap_data_flood_fill(this->nmeHandle,x,y,color);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,floodFill,(void))

Void BitmapData_obj::fillRectEx( ::native::geom::Rectangle rect,int inColour,hx::Null< int >  __o_inAlpha){
int inAlpha = __o_inAlpha.Default(255);
	HX_STACK_PUSH("BitmapData::fillRectEx","native/display/BitmapData.hx",171);
	HX_STACK_THIS(this);
	HX_STACK_ARG(rect,"rect");
	HX_STACK_ARG(inColour,"inColour");
	HX_STACK_ARG(inAlpha,"inAlpha");
{
		HX_STACK_LINE(171)
		::native::display::BitmapData_obj::nme_bitmap_data_fill(this->nmeHandle,rect,inColour,inAlpha);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,fillRectEx,(void))

Void BitmapData_obj::fillRect( ::native::geom::Rectangle rect,int inColour){
{
		HX_STACK_PUSH("BitmapData::fillRect","native/display/BitmapData.hx",164);
		HX_STACK_THIS(this);
		HX_STACK_ARG(rect,"rect");
		HX_STACK_ARG(inColour,"inColour");
		HX_STACK_LINE(165)
		int a = hx::UShr(inColour,(int)24);		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(166)
		int c = (int(inColour) & int((int)16777215));		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(167)
		::native::display::BitmapData_obj::nme_bitmap_data_fill(this->nmeHandle,rect,c,a);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,fillRect,(void))

::native::utils::ByteArray BitmapData_obj::encode( ::String inFormat,hx::Null< Float >  __o_inQuality){
Float inQuality = __o_inQuality.Default(0.9);
	HX_STACK_PUSH("BitmapData::encode","native/display/BitmapData.hx",141);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inFormat,"inFormat");
	HX_STACK_ARG(inQuality,"inQuality");
{
		HX_STACK_LINE(141)
		return ::native::display::BitmapData_obj::nme_bitmap_data_encode(this->nmeHandle,inFormat,inQuality);
	}
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,encode,return )

Void BitmapData_obj::dumpBits( ){
{
		HX_STACK_PUSH("BitmapData::dumpBits","native/display/BitmapData.hx",136);
		HX_STACK_THIS(this);
		HX_STACK_LINE(136)
		::native::display::BitmapData_obj::nme_bitmap_data_dump_bits(this->nmeHandle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,dumpBits,(void))

Void BitmapData_obj::draw( ::native::display::IBitmapDrawable source,::native::geom::Matrix matrix,::native::geom::ColorTransform colorTransform,::native::display::BlendMode blendMode,::native::geom::Rectangle clipRect,hx::Null< bool >  __o_smoothing){
bool smoothing = __o_smoothing.Default(false);
	HX_STACK_PUSH("BitmapData::draw","native/display/BitmapData.hx",131);
	HX_STACK_THIS(this);
	HX_STACK_ARG(source,"source");
	HX_STACK_ARG(matrix,"matrix");
	HX_STACK_ARG(colorTransform,"colorTransform");
	HX_STACK_ARG(blendMode,"blendMode");
	HX_STACK_ARG(clipRect,"clipRect");
	HX_STACK_ARG(smoothing,"smoothing");
{
		HX_STACK_LINE(131)
		source->nmeDrawToSurface(this->nmeHandle,matrix,colorTransform,::Std_obj::string(blendMode),clipRect,smoothing);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(BitmapData_obj,draw,(void))

Void BitmapData_obj::dispose( ){
{
		HX_STACK_PUSH("BitmapData::dispose","native/display/BitmapData.hx",126);
		HX_STACK_THIS(this);
		HX_STACK_LINE(126)
		this->nmeHandle = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,dispose,(void))

Void BitmapData_obj::destroyHardwareSurface( ){
{
		HX_STACK_PUSH("BitmapData::destroyHardwareSurface","native/display/BitmapData.hx",120);
		HX_STACK_THIS(this);
		HX_STACK_LINE(120)
		::native::display::BitmapData_obj::nme_bitmap_data_destroy_hardware_surface(this->nmeHandle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,destroyHardwareSurface,(void))

Void BitmapData_obj::createHardwareSurface( ){
{
		HX_STACK_PUSH("BitmapData::createHardwareSurface","native/display/BitmapData.hx",115);
		HX_STACK_THIS(this);
		HX_STACK_LINE(115)
		::native::display::BitmapData_obj::nme_bitmap_data_create_hardware_surface(this->nmeHandle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,createHardwareSurface,(void))

Void BitmapData_obj::copyPixels( ::native::display::BitmapData sourceBitmapData,::native::geom::Rectangle sourceRect,::native::geom::Point destPoint,::native::display::BitmapData alphaBitmapData,::native::geom::Point alphaPoint,hx::Null< bool >  __o_mergeAlpha){
bool mergeAlpha = __o_mergeAlpha.Default(false);
	HX_STACK_PUSH("BitmapData::copyPixels","native/display/BitmapData.hx",100);
	HX_STACK_THIS(this);
	HX_STACK_ARG(sourceBitmapData,"sourceBitmapData");
	HX_STACK_ARG(sourceRect,"sourceRect");
	HX_STACK_ARG(destPoint,"destPoint");
	HX_STACK_ARG(alphaBitmapData,"alphaBitmapData");
	HX_STACK_ARG(alphaPoint,"alphaPoint");
	HX_STACK_ARG(mergeAlpha,"mergeAlpha");
{
		HX_STACK_LINE(100)
		::native::display::BitmapData_obj::nme_bitmap_data_copy(sourceBitmapData->nmeHandle,sourceRect,this->nmeHandle,destPoint,mergeAlpha);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(BitmapData_obj,copyPixels,(void))

Void BitmapData_obj::copyChannel( ::native::display::BitmapData sourceBitmapData,::native::geom::Rectangle sourceRect,::native::geom::Point destPoint,int inSourceChannel,int inDestChannel){
{
		HX_STACK_PUSH("BitmapData::copyChannel","native/display/BitmapData.hx",95);
		HX_STACK_THIS(this);
		HX_STACK_ARG(sourceBitmapData,"sourceBitmapData");
		HX_STACK_ARG(sourceRect,"sourceRect");
		HX_STACK_ARG(destPoint,"destPoint");
		HX_STACK_ARG(inSourceChannel,"inSourceChannel");
		HX_STACK_ARG(inDestChannel,"inDestChannel");
		HX_STACK_LINE(95)
		::native::display::BitmapData_obj::nme_bitmap_data_copy_channel(sourceBitmapData->nmeHandle,sourceRect,this->nmeHandle,destPoint,inSourceChannel,inDestChannel);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(BitmapData_obj,copyChannel,(void))

Void BitmapData_obj::colorTransform( ::native::geom::Rectangle rect,::native::geom::ColorTransform colorTransform){
{
		HX_STACK_PUSH("BitmapData::colorTransform","native/display/BitmapData.hx",90);
		HX_STACK_THIS(this);
		HX_STACK_ARG(rect,"rect");
		HX_STACK_ARG(colorTransform,"colorTransform");
		HX_STACK_LINE(90)
		::native::display::BitmapData_obj::nme_bitmap_data_color_transform(this->nmeHandle,rect,colorTransform);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,colorTransform,(void))

::native::display::BitmapData BitmapData_obj::clone( ){
	HX_STACK_PUSH("BitmapData::clone","native/display/BitmapData.hx",83);
	HX_STACK_THIS(this);
	HX_STACK_LINE(84)
	::native::display::BitmapData bm = ::native::display::BitmapData_obj::__new((int)0,(int)0,null(),null(),null());		HX_STACK_VAR(bm,"bm");
	HX_STACK_LINE(85)
	bm->nmeHandle = ::native::display::BitmapData_obj::nme_bitmap_data_clone(this->nmeHandle);
	HX_STACK_LINE(86)
	return bm;
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,clone,return )

Void BitmapData_obj::clear( int color){
{
		HX_STACK_PUSH("BitmapData::clear","native/display/BitmapData.hx",78);
		HX_STACK_THIS(this);
		HX_STACK_ARG(color,"color");
		HX_STACK_LINE(78)
		::native::display::BitmapData_obj::nme_bitmap_data_clear(this->nmeHandle,color);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,clear,(void))

Void BitmapData_obj::applyFilter( ::native::display::BitmapData sourceBitmapData,::native::geom::Rectangle sourceRect,::native::geom::Point destPoint,::native::filters::BitmapFilter filter){
{
		HX_STACK_PUSH("BitmapData::applyFilter","native/display/BitmapData.hx",73);
		HX_STACK_THIS(this);
		HX_STACK_ARG(sourceBitmapData,"sourceBitmapData");
		HX_STACK_ARG(sourceRect,"sourceRect");
		HX_STACK_ARG(destPoint,"destPoint");
		HX_STACK_ARG(filter,"filter");
		HX_STACK_LINE(73)
		::native::display::BitmapData_obj::nme_bitmap_data_apply_filter(this->nmeHandle,sourceBitmapData->nmeHandle,sourceRect,destPoint,filter);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(BitmapData_obj,applyFilter,(void))

int BitmapData_obj::CLEAR;

int BitmapData_obj::BLACK;

int BitmapData_obj::WHITE;

int BitmapData_obj::RED;

int BitmapData_obj::GREEN;

int BitmapData_obj::BLUE;

int BitmapData_obj::TRANSPARENT;

int BitmapData_obj::HARDWARE;

int BitmapData_obj::FORMAT_8888;

int BitmapData_obj::FORMAT_4444;

int BitmapData_obj::FORMAT_565;

int BitmapData_obj::createColor( int inRGB,hx::Null< int >  __o_inAlpha){
int inAlpha = __o_inAlpha.Default(255);
	HX_STACK_PUSH("BitmapData::createColor","native/display/BitmapData.hx",105);
	HX_STACK_ARG(inRGB,"inRGB");
	HX_STACK_ARG(inAlpha,"inAlpha");
{
		HX_STACK_LINE(105)
		return (int(inRGB) | int((int(inAlpha) << int((int)24))));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,createColor,return )

int BitmapData_obj::extractAlpha( int v){
	HX_STACK_PUSH("BitmapData::extractAlpha","native/display/BitmapData.hx",146);
	HX_STACK_ARG(v,"v");
	HX_STACK_LINE(146)
	return hx::UShr(v,(int)24);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,extractAlpha,return )

int BitmapData_obj::extractColor( int v){
	HX_STACK_PUSH("BitmapData::extractColor","native/display/BitmapData.hx",155);
	HX_STACK_ARG(v,"v");
	HX_STACK_LINE(155)
	return (int(v) & int((int)16777215));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,extractColor,return )

bool BitmapData_obj::sameValue( int a,int b){
	HX_STACK_PUSH("BitmapData::sameValue","native/display/BitmapData.hx",176);
	HX_STACK_ARG(a,"a");
	HX_STACK_ARG(b,"b");
	HX_STACK_LINE(176)
	return (a == b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,sameValue,return )

int BitmapData_obj::flip_pixel4( int pix4){
	HX_STACK_PUSH("BitmapData::flip_pixel4","native/display/BitmapData.hx",195);
	HX_STACK_ARG(pix4,"pix4");
	HX_STACK_LINE(195)
	return (int((int((int((int(((int(pix4) & int((int)255)))) << int((int)24))) | int((int(((int((int(pix4) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(pix4) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(pix4) >> int((int)24))) & int((int)255))));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,flip_pixel4,return )

int BitmapData_obj::ucompare( int n1,int n2){
	HX_STACK_PUSH("BitmapData::ucompare","native/display/BitmapData.hx",312);
	HX_STACK_ARG(n1,"n1");
	HX_STACK_ARG(n2,"n2");
	HX_STACK_LINE(313)
	int tmp1;		HX_STACK_VAR(tmp1,"tmp1");
	HX_STACK_LINE(314)
	int tmp2;		HX_STACK_VAR(tmp2,"tmp2");
	HX_STACK_LINE(323)
	tmp1 = (int((int(n1) >> int((int)24))) & int((int)255));
	HX_STACK_LINE(324)
	tmp2 = (int((int(n2) >> int((int)24))) & int((int)255));
	HX_STACK_LINE(325)
	if (((tmp1 != tmp2))){
		HX_STACK_LINE(325)
		return (  (((tmp1 > tmp2))) ? int((int)1) : int((int)-1) );
	}
	else{
		HX_STACK_LINE(331)
		tmp1 = (int((int(n1) >> int((int)16))) & int((int)255));
		HX_STACK_LINE(332)
		tmp2 = (int((int(n2) >> int((int)16))) & int((int)255));
		HX_STACK_LINE(334)
		if (((tmp1 != tmp2))){
			HX_STACK_LINE(334)
			return (  (((tmp1 > tmp2))) ? int((int)1) : int((int)-1) );
		}
		else{
			HX_STACK_LINE(340)
			tmp1 = (int((int(n1) >> int((int)8))) & int((int)255));
			HX_STACK_LINE(341)
			tmp2 = (int((int(n2) >> int((int)8))) & int((int)255));
			HX_STACK_LINE(343)
			if (((tmp1 != tmp2))){
				HX_STACK_LINE(343)
				return (  (((tmp1 > tmp2))) ? int((int)1) : int((int)-1) );
			}
			else{
				HX_STACK_LINE(348)
				tmp1 = (int(n1) & int((int)255));
				HX_STACK_LINE(349)
				tmp2 = (int(n2) & int((int)255));
				HX_STACK_LINE(351)
				if (((tmp1 != tmp2))){
					HX_STACK_LINE(351)
					return (  (((tmp1 > tmp2))) ? int((int)1) : int((int)-1) );
				}
				else{
					HX_STACK_LINE(355)
					return (int)0;
				}
			}
		}
	}
	HX_STACK_LINE(325)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,ucompare,return )

::native::utils::ByteArray BitmapData_obj::getRGBAPixels( ::native::display::BitmapData bitmapData){
	HX_STACK_PUSH("BitmapData::getRGBAPixels","native/display/BitmapData.hx",459);
	HX_STACK_ARG(bitmapData,"bitmapData");
	HX_STACK_LINE(460)
	::native::utils::ByteArray p = bitmapData->getPixels(::native::geom::Rectangle_obj::__new((int)0,(int)0,bitmapData->get_width(),bitmapData->get_height()));		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(461)
	int num = (bitmapData->get_width() * bitmapData->get_height());		HX_STACK_VAR(num,"num");
	HX_STACK_LINE(463)
	{
		HX_STACK_LINE(463)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(463)
		while(((_g < num))){
			HX_STACK_LINE(463)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(465)
			int alpha = p->__get((i * (int)4));		HX_STACK_VAR(alpha,"alpha");
			HX_STACK_LINE(466)
			int red = p->__get(((i * (int)4) + (int)1));		HX_STACK_VAR(red,"red");
			HX_STACK_LINE(467)
			int green = p->__get(((i * (int)4) + (int)2));		HX_STACK_VAR(green,"green");
			HX_STACK_LINE(468)
			int blue = p->__get(((i * (int)4) + (int)3));		HX_STACK_VAR(blue,"blue");
			HX_STACK_LINE(470)
			hx::__ArrayImplRef(p,(i * (int)4)) = red;
			HX_STACK_LINE(471)
			hx::__ArrayImplRef(p,((i * (int)4) + (int)1)) = green;
			HX_STACK_LINE(472)
			hx::__ArrayImplRef(p,((i * (int)4) + (int)2)) = blue;
			HX_STACK_LINE(473)
			hx::__ArrayImplRef(p,((i * (int)4) + (int)3)) = alpha;
		}
	}
	HX_STACK_LINE(476)
	return p;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,getRGBAPixels,return )

::native::display::BitmapData BitmapData_obj::load( ::String inFilename,hx::Null< int >  __o_format){
int format = __o_format.Default(0);
	HX_STACK_PUSH("BitmapData::load","native/display/BitmapData.hx",500);
	HX_STACK_ARG(inFilename,"inFilename");
	HX_STACK_ARG(format,"format");
{
		HX_STACK_LINE(501)
		::native::display::BitmapData result = ::native::display::BitmapData_obj::__new((int)0,(int)0,null(),null(),null());		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(502)
		result->nmeHandle = ::native::display::BitmapData_obj::nme_bitmap_data_load(inFilename,format);
		HX_STACK_LINE(503)
		return result;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,load,return )

::native::display::BitmapData BitmapData_obj::loadFromBytes( ::native::utils::ByteArray inBytes,::native::utils::ByteArray inRawAlpha){
	HX_STACK_PUSH("BitmapData::loadFromBytes","native/display/BitmapData.hx",507);
	HX_STACK_ARG(inBytes,"inBytes");
	HX_STACK_ARG(inRawAlpha,"inRawAlpha");
	HX_STACK_LINE(508)
	::native::display::BitmapData result = ::native::display::BitmapData_obj::__new((int)0,(int)0,null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(509)
	result->nmeHandle = ::native::display::BitmapData_obj::nme_bitmap_data_from_bytes(inBytes,inRawAlpha);
	HX_STACK_LINE(510)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,loadFromBytes,return )

::native::display::BitmapData BitmapData_obj::loadFromHaxeBytes( ::haxe::io::Bytes inBytes,::haxe::io::Bytes inRawAlpha){
	HX_STACK_PUSH("BitmapData::loadFromHaxeBytes","native/display/BitmapData.hx",514);
	HX_STACK_ARG(inBytes,"inBytes");
	HX_STACK_ARG(inRawAlpha,"inRawAlpha");
	HX_STACK_LINE(514)
	return ::native::display::BitmapData_obj::loadFromBytes(::native::utils::ByteArray_obj::fromBytes(inBytes),(  (((inRawAlpha == null()))) ? ::native::utils::ByteArray(null()) : ::native::utils::ByteArray(::native::utils::ByteArray_obj::fromBytes(inRawAlpha)) ));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,loadFromHaxeBytes,return )

Dynamic BitmapData_obj::nme_bitmap_data_create;

Dynamic BitmapData_obj::nme_bitmap_data_load;

Dynamic BitmapData_obj::nme_bitmap_data_from_bytes;

Dynamic BitmapData_obj::nme_bitmap_data_clear;

Dynamic BitmapData_obj::nme_bitmap_data_clone;

Dynamic BitmapData_obj::nme_bitmap_data_apply_filter;

Dynamic BitmapData_obj::nme_bitmap_data_color_transform;

Dynamic BitmapData_obj::nme_bitmap_data_copy;

Dynamic BitmapData_obj::nme_bitmap_data_copy_channel;

Dynamic BitmapData_obj::nme_bitmap_data_fill;

Dynamic BitmapData_obj::nme_bitmap_data_get_pixels;

Dynamic BitmapData_obj::nme_bitmap_data_get_pixel;

Dynamic BitmapData_obj::nme_bitmap_data_get_pixel32;

Dynamic BitmapData_obj::nme_bitmap_data_get_pixel_rgba;

Dynamic BitmapData_obj::nme_bitmap_data_get_array;

Dynamic BitmapData_obj::nme_bitmap_data_get_color_bounds_rect;

Dynamic BitmapData_obj::nme_bitmap_data_scroll;

Dynamic BitmapData_obj::nme_bitmap_data_set_pixel;

Dynamic BitmapData_obj::nme_bitmap_data_set_pixel32;

Dynamic BitmapData_obj::nme_bitmap_data_set_pixel_rgba;

Dynamic BitmapData_obj::nme_bitmap_data_set_bytes;

Dynamic BitmapData_obj::nme_bitmap_data_set_format;

Dynamic BitmapData_obj::nme_bitmap_data_set_array;

Dynamic BitmapData_obj::nme_bitmap_data_create_hardware_surface;

Dynamic BitmapData_obj::nme_bitmap_data_destroy_hardware_surface;

Dynamic BitmapData_obj::nme_bitmap_data_generate_filter_rect;

Dynamic BitmapData_obj::nme_render_surface_to_surface;

Dynamic BitmapData_obj::nme_bitmap_data_height;

Dynamic BitmapData_obj::nme_bitmap_data_width;

Dynamic BitmapData_obj::nme_bitmap_data_get_transparent;

Dynamic BitmapData_obj::nme_bitmap_data_set_flags;

Dynamic BitmapData_obj::nme_bitmap_data_encode;

Dynamic BitmapData_obj::nme_bitmap_data_dump_bits;

Dynamic BitmapData_obj::nme_bitmap_data_noise;

Dynamic BitmapData_obj::nme_bitmap_data_flood_fill;


BitmapData_obj::BitmapData_obj()
{
}

void BitmapData_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BitmapData);
	HX_MARK_MEMBER_NAME(nmeHandle,"nmeHandle");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(transparent,"transparent");
	HX_MARK_MEMBER_NAME(rect,"rect");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_END_CLASS();
}

void BitmapData_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(nmeHandle,"nmeHandle");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(transparent,"transparent");
	HX_VISIT_MEMBER_NAME(rect,"rect");
	HX_VISIT_MEMBER_NAME(height,"height");
}

Dynamic BitmapData_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"RED") ) { return RED; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"BLUE") ) { return BLUE; }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		if (HX_FIELD_EQ(inName,"lock") ) { return lock_dyn(); }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"rect") ) { return inCallProp ? get_rect() : rect; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CLEAR") ) { return CLEAR; }
		if (HX_FIELD_EQ(inName,"BLACK") ) { return BLACK; }
		if (HX_FIELD_EQ(inName,"WHITE") ) { return WHITE; }
		if (HX_FIELD_EQ(inName,"GREEN") ) { return GREEN; }
		if (HX_FIELD_EQ(inName,"noise") ) { return noise_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"width") ) { return inCallProp ? get_width() : width; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"unlock") ) { return unlock_dyn(); }
		if (HX_FIELD_EQ(inName,"scroll") ) { return scroll_dyn(); }
		if (HX_FIELD_EQ(inName,"encode") ) { return encode_dyn(); }
		if (HX_FIELD_EQ(inName,"height") ) { return inCallProp ? get_height() : height; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"HARDWARE") ) { return HARDWARE; }
		if (HX_FIELD_EQ(inName,"ucompare") ) { return ucompare_dyn(); }
		if (HX_FIELD_EQ(inName,"get_rect") ) { return get_rect_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixel") ) { return setPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"setFlags") ) { return setFlags_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixel") ) { return getPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"fillRect") ) { return fillRect_dyn(); }
		if (HX_FIELD_EQ(inName,"dumpBits") ) { return dumpBits_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"sameValue") ) { return sameValue_dyn(); }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"setFormat") ) { return setFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"setVector") ) { return setVector_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixels") ) { return setPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"getVector") ) { return getVector_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixels") ) { return getPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"threshold") ) { return threshold_dyn(); }
		if (HX_FIELD_EQ(inName,"floodFill") ) { return floodFill_dyn(); }
		if (HX_FIELD_EQ(inName,"nmeHandle") ) { return nmeHandle; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"FORMAT_565") ) { return FORMAT_565; }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixel32") ) { return setPixel32_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixel32") ) { return getPixel32_dyn(); }
		if (HX_FIELD_EQ(inName,"fillRectEx") ) { return fillRectEx_dyn(); }
		if (HX_FIELD_EQ(inName,"copyPixels") ) { return copyPixels_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"TRANSPARENT") ) { return TRANSPARENT; }
		if (HX_FIELD_EQ(inName,"FORMAT_8888") ) { return FORMAT_8888; }
		if (HX_FIELD_EQ(inName,"FORMAT_4444") ) { return FORMAT_4444; }
		if (HX_FIELD_EQ(inName,"createColor") ) { return createColor_dyn(); }
		if (HX_FIELD_EQ(inName,"flip_pixel4") ) { return flip_pixel4_dyn(); }
		if (HX_FIELD_EQ(inName,"perlinNoise") ) { return perlinNoise_dyn(); }
		if (HX_FIELD_EQ(inName,"copyChannel") ) { return copyChannel_dyn(); }
		if (HX_FIELD_EQ(inName,"applyFilter") ) { return applyFilter_dyn(); }
		if (HX_FIELD_EQ(inName,"transparent") ) { return inCallProp ? get_transparent() : transparent; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"extractAlpha") ) { return extractAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"extractColor") ) { return extractColor_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getRGBAPixels") ) { return getRGBAPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"loadFromBytes") ) { return loadFromBytes_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"colorTransform") ) { return colorTransform_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_transparent") ) { return get_transparent_dyn(); }
		if (HX_FIELD_EQ(inName,"_self_threshold") ) { return _self_threshold_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"nmeLoadFromBytes") ) { return nmeLoadFromBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"nmeDrawToSurface") ) { return nmeDrawToSurface_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"loadFromHaxeBytes") ) { return loadFromHaxeBytes_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"getColorBoundsRect") ) { return getColorBoundsRect_dyn(); }
		if (HX_FIELD_EQ(inName,"generateFilterRect") ) { return generateFilterRect_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_load") ) { return nme_bitmap_data_load; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_copy") ) { return nme_bitmap_data_copy; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_fill") ) { return nme_bitmap_data_fill; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_clear") ) { return nme_bitmap_data_clear; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_clone") ) { return nme_bitmap_data_clone; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_width") ) { return nme_bitmap_data_width; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_noise") ) { return nme_bitmap_data_noise; }
		if (HX_FIELD_EQ(inName,"createHardwareSurface") ) { return createHardwareSurface_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_create") ) { return nme_bitmap_data_create; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_scroll") ) { return nme_bitmap_data_scroll; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_height") ) { return nme_bitmap_data_height; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_encode") ) { return nme_bitmap_data_encode; }
		if (HX_FIELD_EQ(inName,"destroyHardwareSurface") ) { return destroyHardwareSurface_dyn(); }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixel") ) { return nme_bitmap_data_get_pixel; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_array") ) { return nme_bitmap_data_get_array; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_pixel") ) { return nme_bitmap_data_set_pixel; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_bytes") ) { return nme_bitmap_data_set_bytes; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_array") ) { return nme_bitmap_data_set_array; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_flags") ) { return nme_bitmap_data_set_flags; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_dump_bits") ) { return nme_bitmap_data_dump_bits; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_from_bytes") ) { return nme_bitmap_data_from_bytes; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixels") ) { return nme_bitmap_data_get_pixels; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_format") ) { return nme_bitmap_data_set_format; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_flood_fill") ) { return nme_bitmap_data_flood_fill; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixel32") ) { return nme_bitmap_data_get_pixel32; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_pixel32") ) { return nme_bitmap_data_set_pixel32; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_apply_filter") ) { return nme_bitmap_data_apply_filter; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_copy_channel") ) { return nme_bitmap_data_copy_channel; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"nme_render_surface_to_surface") ) { return nme_render_surface_to_surface; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixel_rgba") ) { return nme_bitmap_data_get_pixel_rgba; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_pixel_rgba") ) { return nme_bitmap_data_set_pixel_rgba; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_color_transform") ) { return nme_bitmap_data_color_transform; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_transparent") ) { return nme_bitmap_data_get_transparent; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_generate_filter_rect") ) { return nme_bitmap_data_generate_filter_rect; }
		break;
	case 37:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_color_bounds_rect") ) { return nme_bitmap_data_get_color_bounds_rect; }
		break;
	case 39:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_create_hardware_surface") ) { return nme_bitmap_data_create_hardware_surface; }
		break;
	case 40:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_destroy_hardware_surface") ) { return nme_bitmap_data_destroy_hardware_surface; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BitmapData_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"RED") ) { RED=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"BLUE") ) { BLUE=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rect") ) { rect=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CLEAR") ) { CLEAR=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"BLACK") ) { BLACK=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"WHITE") ) { WHITE=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"GREEN") ) { GREEN=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"HARDWARE") ) { HARDWARE=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"nmeHandle") ) { nmeHandle=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"FORMAT_565") ) { FORMAT_565=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"TRANSPARENT") ) { TRANSPARENT=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FORMAT_8888") ) { FORMAT_8888=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FORMAT_4444") ) { FORMAT_4444=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"transparent") ) { transparent=inValue.Cast< bool >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_load") ) { nme_bitmap_data_load=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_copy") ) { nme_bitmap_data_copy=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_fill") ) { nme_bitmap_data_fill=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_clear") ) { nme_bitmap_data_clear=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_clone") ) { nme_bitmap_data_clone=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_width") ) { nme_bitmap_data_width=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_noise") ) { nme_bitmap_data_noise=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_create") ) { nme_bitmap_data_create=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_scroll") ) { nme_bitmap_data_scroll=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_height") ) { nme_bitmap_data_height=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_encode") ) { nme_bitmap_data_encode=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixel") ) { nme_bitmap_data_get_pixel=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_array") ) { nme_bitmap_data_get_array=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_pixel") ) { nme_bitmap_data_set_pixel=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_bytes") ) { nme_bitmap_data_set_bytes=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_array") ) { nme_bitmap_data_set_array=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_flags") ) { nme_bitmap_data_set_flags=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_dump_bits") ) { nme_bitmap_data_dump_bits=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_from_bytes") ) { nme_bitmap_data_from_bytes=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixels") ) { nme_bitmap_data_get_pixels=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_format") ) { nme_bitmap_data_set_format=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_flood_fill") ) { nme_bitmap_data_flood_fill=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixel32") ) { nme_bitmap_data_get_pixel32=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_pixel32") ) { nme_bitmap_data_set_pixel32=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_apply_filter") ) { nme_bitmap_data_apply_filter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_copy_channel") ) { nme_bitmap_data_copy_channel=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"nme_render_surface_to_surface") ) { nme_render_surface_to_surface=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_pixel_rgba") ) { nme_bitmap_data_get_pixel_rgba=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_set_pixel_rgba") ) { nme_bitmap_data_set_pixel_rgba=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_color_transform") ) { nme_bitmap_data_color_transform=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_transparent") ) { nme_bitmap_data_get_transparent=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_generate_filter_rect") ) { nme_bitmap_data_generate_filter_rect=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 37:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_get_color_bounds_rect") ) { nme_bitmap_data_get_color_bounds_rect=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 39:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_create_hardware_surface") ) { nme_bitmap_data_create_hardware_surface=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 40:
		if (HX_FIELD_EQ(inName,"nme_bitmap_data_destroy_hardware_surface") ) { nme_bitmap_data_destroy_hardware_surface=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BitmapData_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("nmeHandle"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("transparent"));
	outFields->push(HX_CSTRING("rect"));
	outFields->push(HX_CSTRING("height"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CLEAR"),
	HX_CSTRING("BLACK"),
	HX_CSTRING("WHITE"),
	HX_CSTRING("RED"),
	HX_CSTRING("GREEN"),
	HX_CSTRING("BLUE"),
	HX_CSTRING("TRANSPARENT"),
	HX_CSTRING("HARDWARE"),
	HX_CSTRING("FORMAT_8888"),
	HX_CSTRING("FORMAT_4444"),
	HX_CSTRING("FORMAT_565"),
	HX_CSTRING("createColor"),
	HX_CSTRING("extractAlpha"),
	HX_CSTRING("extractColor"),
	HX_CSTRING("sameValue"),
	HX_CSTRING("flip_pixel4"),
	HX_CSTRING("ucompare"),
	HX_CSTRING("getRGBAPixels"),
	HX_CSTRING("load"),
	HX_CSTRING("loadFromBytes"),
	HX_CSTRING("loadFromHaxeBytes"),
	HX_CSTRING("nme_bitmap_data_create"),
	HX_CSTRING("nme_bitmap_data_load"),
	HX_CSTRING("nme_bitmap_data_from_bytes"),
	HX_CSTRING("nme_bitmap_data_clear"),
	HX_CSTRING("nme_bitmap_data_clone"),
	HX_CSTRING("nme_bitmap_data_apply_filter"),
	HX_CSTRING("nme_bitmap_data_color_transform"),
	HX_CSTRING("nme_bitmap_data_copy"),
	HX_CSTRING("nme_bitmap_data_copy_channel"),
	HX_CSTRING("nme_bitmap_data_fill"),
	HX_CSTRING("nme_bitmap_data_get_pixels"),
	HX_CSTRING("nme_bitmap_data_get_pixel"),
	HX_CSTRING("nme_bitmap_data_get_pixel32"),
	HX_CSTRING("nme_bitmap_data_get_pixel_rgba"),
	HX_CSTRING("nme_bitmap_data_get_array"),
	HX_CSTRING("nme_bitmap_data_get_color_bounds_rect"),
	HX_CSTRING("nme_bitmap_data_scroll"),
	HX_CSTRING("nme_bitmap_data_set_pixel"),
	HX_CSTRING("nme_bitmap_data_set_pixel32"),
	HX_CSTRING("nme_bitmap_data_set_pixel_rgba"),
	HX_CSTRING("nme_bitmap_data_set_bytes"),
	HX_CSTRING("nme_bitmap_data_set_format"),
	HX_CSTRING("nme_bitmap_data_set_array"),
	HX_CSTRING("nme_bitmap_data_create_hardware_surface"),
	HX_CSTRING("nme_bitmap_data_destroy_hardware_surface"),
	HX_CSTRING("nme_bitmap_data_generate_filter_rect"),
	HX_CSTRING("nme_render_surface_to_surface"),
	HX_CSTRING("nme_bitmap_data_height"),
	HX_CSTRING("nme_bitmap_data_width"),
	HX_CSTRING("nme_bitmap_data_get_transparent"),
	HX_CSTRING("nme_bitmap_data_set_flags"),
	HX_CSTRING("nme_bitmap_data_encode"),
	HX_CSTRING("nme_bitmap_data_dump_bits"),
	HX_CSTRING("nme_bitmap_data_noise"),
	HX_CSTRING("nme_bitmap_data_flood_fill"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("get_transparent"),
	HX_CSTRING("get_height"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_rect"),
	HX_CSTRING("noise"),
	HX_CSTRING("setFormat"),
	HX_CSTRING("unlock"),
	HX_CSTRING("setVector"),
	HX_CSTRING("setPixels"),
	HX_CSTRING("setPixel32"),
	HX_CSTRING("setPixel"),
	HX_CSTRING("setFlags"),
	HX_CSTRING("scroll"),
	HX_CSTRING("perlinNoise"),
	HX_CSTRING("nmeLoadFromBytes"),
	HX_CSTRING("nmeDrawToSurface"),
	HX_CSTRING("lock"),
	HX_CSTRING("getVector"),
	HX_CSTRING("getPixels"),
	HX_CSTRING("getPixel32"),
	HX_CSTRING("getPixel"),
	HX_CSTRING("getColorBoundsRect"),
	HX_CSTRING("generateFilterRect"),
	HX_CSTRING("_self_threshold"),
	HX_CSTRING("threshold"),
	HX_CSTRING("floodFill"),
	HX_CSTRING("fillRectEx"),
	HX_CSTRING("fillRect"),
	HX_CSTRING("encode"),
	HX_CSTRING("dumpBits"),
	HX_CSTRING("draw"),
	HX_CSTRING("dispose"),
	HX_CSTRING("destroyHardwareSurface"),
	HX_CSTRING("createHardwareSurface"),
	HX_CSTRING("copyPixels"),
	HX_CSTRING("copyChannel"),
	HX_CSTRING("colorTransform"),
	HX_CSTRING("clone"),
	HX_CSTRING("clear"),
	HX_CSTRING("applyFilter"),
	HX_CSTRING("nmeHandle"),
	HX_CSTRING("width"),
	HX_CSTRING("transparent"),
	HX_CSTRING("rect"),
	HX_CSTRING("height"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BitmapData_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(BitmapData_obj::CLEAR,"CLEAR");
	HX_MARK_MEMBER_NAME(BitmapData_obj::BLACK,"BLACK");
	HX_MARK_MEMBER_NAME(BitmapData_obj::WHITE,"WHITE");
	HX_MARK_MEMBER_NAME(BitmapData_obj::RED,"RED");
	HX_MARK_MEMBER_NAME(BitmapData_obj::GREEN,"GREEN");
	HX_MARK_MEMBER_NAME(BitmapData_obj::BLUE,"BLUE");
	HX_MARK_MEMBER_NAME(BitmapData_obj::TRANSPARENT,"TRANSPARENT");
	HX_MARK_MEMBER_NAME(BitmapData_obj::HARDWARE,"HARDWARE");
	HX_MARK_MEMBER_NAME(BitmapData_obj::FORMAT_8888,"FORMAT_8888");
	HX_MARK_MEMBER_NAME(BitmapData_obj::FORMAT_4444,"FORMAT_4444");
	HX_MARK_MEMBER_NAME(BitmapData_obj::FORMAT_565,"FORMAT_565");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_create,"nme_bitmap_data_create");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_load,"nme_bitmap_data_load");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_from_bytes,"nme_bitmap_data_from_bytes");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_clear,"nme_bitmap_data_clear");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_clone,"nme_bitmap_data_clone");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_apply_filter,"nme_bitmap_data_apply_filter");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_color_transform,"nme_bitmap_data_color_transform");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_copy,"nme_bitmap_data_copy");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_copy_channel,"nme_bitmap_data_copy_channel");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_fill,"nme_bitmap_data_fill");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixels,"nme_bitmap_data_get_pixels");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixel,"nme_bitmap_data_get_pixel");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixel32,"nme_bitmap_data_get_pixel32");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixel_rgba,"nme_bitmap_data_get_pixel_rgba");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_array,"nme_bitmap_data_get_array");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_color_bounds_rect,"nme_bitmap_data_get_color_bounds_rect");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_scroll,"nme_bitmap_data_scroll");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_pixel,"nme_bitmap_data_set_pixel");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_pixel32,"nme_bitmap_data_set_pixel32");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_pixel_rgba,"nme_bitmap_data_set_pixel_rgba");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_bytes,"nme_bitmap_data_set_bytes");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_format,"nme_bitmap_data_set_format");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_array,"nme_bitmap_data_set_array");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_create_hardware_surface,"nme_bitmap_data_create_hardware_surface");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_destroy_hardware_surface,"nme_bitmap_data_destroy_hardware_surface");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_generate_filter_rect,"nme_bitmap_data_generate_filter_rect");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_render_surface_to_surface,"nme_render_surface_to_surface");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_height,"nme_bitmap_data_height");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_width,"nme_bitmap_data_width");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_transparent,"nme_bitmap_data_get_transparent");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_flags,"nme_bitmap_data_set_flags");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_encode,"nme_bitmap_data_encode");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_dump_bits,"nme_bitmap_data_dump_bits");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_noise,"nme_bitmap_data_noise");
	HX_MARK_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_flood_fill,"nme_bitmap_data_flood_fill");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BitmapData_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::CLEAR,"CLEAR");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::BLACK,"BLACK");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::WHITE,"WHITE");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::RED,"RED");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::GREEN,"GREEN");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::BLUE,"BLUE");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::TRANSPARENT,"TRANSPARENT");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::HARDWARE,"HARDWARE");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::FORMAT_8888,"FORMAT_8888");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::FORMAT_4444,"FORMAT_4444");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::FORMAT_565,"FORMAT_565");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_create,"nme_bitmap_data_create");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_load,"nme_bitmap_data_load");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_from_bytes,"nme_bitmap_data_from_bytes");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_clear,"nme_bitmap_data_clear");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_clone,"nme_bitmap_data_clone");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_apply_filter,"nme_bitmap_data_apply_filter");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_color_transform,"nme_bitmap_data_color_transform");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_copy,"nme_bitmap_data_copy");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_copy_channel,"nme_bitmap_data_copy_channel");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_fill,"nme_bitmap_data_fill");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixels,"nme_bitmap_data_get_pixels");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixel,"nme_bitmap_data_get_pixel");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixel32,"nme_bitmap_data_get_pixel32");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_pixel_rgba,"nme_bitmap_data_get_pixel_rgba");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_array,"nme_bitmap_data_get_array");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_color_bounds_rect,"nme_bitmap_data_get_color_bounds_rect");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_scroll,"nme_bitmap_data_scroll");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_pixel,"nme_bitmap_data_set_pixel");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_pixel32,"nme_bitmap_data_set_pixel32");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_pixel_rgba,"nme_bitmap_data_set_pixel_rgba");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_bytes,"nme_bitmap_data_set_bytes");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_format,"nme_bitmap_data_set_format");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_array,"nme_bitmap_data_set_array");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_create_hardware_surface,"nme_bitmap_data_create_hardware_surface");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_destroy_hardware_surface,"nme_bitmap_data_destroy_hardware_surface");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_generate_filter_rect,"nme_bitmap_data_generate_filter_rect");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_render_surface_to_surface,"nme_render_surface_to_surface");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_height,"nme_bitmap_data_height");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_width,"nme_bitmap_data_width");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_get_transparent,"nme_bitmap_data_get_transparent");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_set_flags,"nme_bitmap_data_set_flags");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_encode,"nme_bitmap_data_encode");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_dump_bits,"nme_bitmap_data_dump_bits");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_noise,"nme_bitmap_data_noise");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::nme_bitmap_data_flood_fill,"nme_bitmap_data_flood_fill");
};

Class BitmapData_obj::__mClass;

void BitmapData_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("native.display.BitmapData"), hx::TCanCast< BitmapData_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void BitmapData_obj::__boot()
{
	CLEAR= (int)0;
struct _Function_0_1{
	inline static int Block( ){
		HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",22);
		{
			HX_STACK_LINE(22)
			int inAlpha = (int)255;		HX_STACK_VAR(inAlpha,"inAlpha");
			HX_STACK_LINE(22)
			return (int((int)0) | int((int(inAlpha) << int((int)24))));
		}
		return null();
	}
};
	BLACK= _Function_0_1::Block();
struct _Function_0_2{
	inline static int Block( ){
		HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",23);
		{
			HX_STACK_LINE(23)
			int inAlpha = (int)255;		HX_STACK_VAR(inAlpha,"inAlpha");
			HX_STACK_LINE(23)
			return (int((int)0) | int((int(inAlpha) << int((int)24))));
		}
		return null();
	}
};
	WHITE= _Function_0_2::Block();
struct _Function_0_3{
	inline static int Block( ){
		HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",24);
		{
			HX_STACK_LINE(24)
			int inAlpha = (int)255;		HX_STACK_VAR(inAlpha,"inAlpha");
			HX_STACK_LINE(24)
			return (int((int)16711680) | int((int(inAlpha) << int((int)24))));
		}
		return null();
	}
};
	RED= _Function_0_3::Block();
struct _Function_0_4{
	inline static int Block( ){
		HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",25);
		{
			HX_STACK_LINE(25)
			int inAlpha = (int)255;		HX_STACK_VAR(inAlpha,"inAlpha");
			HX_STACK_LINE(25)
			return (int((int)65280) | int((int(inAlpha) << int((int)24))));
		}
		return null();
	}
};
	GREEN= _Function_0_4::Block();
struct _Function_0_5{
	inline static int Block( ){
		HX_STACK_PUSH("*::closure","native/display/BitmapData.hx",26);
		{
			HX_STACK_LINE(26)
			int inAlpha = (int)255;		HX_STACK_VAR(inAlpha,"inAlpha");
			HX_STACK_LINE(26)
			return (int((int)255) | int((int(inAlpha) << int((int)24))));
		}
		return null();
	}
};
	BLUE= _Function_0_5::Block();
	TRANSPARENT= (int)1;
	HARDWARE= (int)2;
	FORMAT_8888= (int)0;
	FORMAT_4444= (int)1;
	FORMAT_565= (int)2;
	nme_bitmap_data_create= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_create"),(int)-1);
	nme_bitmap_data_load= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_load"),(int)2);
	nme_bitmap_data_from_bytes= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_from_bytes"),(int)2);
	nme_bitmap_data_clear= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_clear"),(int)2);
	nme_bitmap_data_clone= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_clone"),(int)1);
	nme_bitmap_data_apply_filter= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_apply_filter"),(int)5);
	nme_bitmap_data_color_transform= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_color_transform"),(int)3);
	nme_bitmap_data_copy= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_copy"),(int)5);
	nme_bitmap_data_copy_channel= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_copy_channel"),(int)-1);
	nme_bitmap_data_fill= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_fill"),(int)4);
	nme_bitmap_data_get_pixels= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_pixels"),(int)2);
	nme_bitmap_data_get_pixel= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_pixel"),(int)3);
	nme_bitmap_data_get_pixel32= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_pixel32"),(int)3);
	nme_bitmap_data_get_pixel_rgba= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_pixel_rgba"),(int)3);
	nme_bitmap_data_get_array= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_array"),(int)3);
	nme_bitmap_data_get_color_bounds_rect= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_color_bounds_rect"),(int)5);
	nme_bitmap_data_scroll= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_scroll"),(int)3);
	nme_bitmap_data_set_pixel= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_pixel"),(int)4);
	nme_bitmap_data_set_pixel32= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_pixel32"),(int)4);
	nme_bitmap_data_set_pixel_rgba= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_pixel_rgba"),(int)4);
	nme_bitmap_data_set_bytes= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_bytes"),(int)4);
	nme_bitmap_data_set_format= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_format"),(int)2);
	nme_bitmap_data_set_array= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_array"),(int)3);
	nme_bitmap_data_create_hardware_surface= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_create_hardware_surface"),(int)1);
	nme_bitmap_data_destroy_hardware_surface= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_destroy_hardware_surface"),(int)1);
	nme_bitmap_data_generate_filter_rect= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_generate_filter_rect"),(int)3);
	nme_render_surface_to_surface= ::native::Loader_obj::load(HX_CSTRING("nme_render_surface_to_surface"),(int)-1);
	nme_bitmap_data_height= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_height"),(int)1);
	nme_bitmap_data_width= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_width"),(int)1);
	nme_bitmap_data_get_transparent= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_get_transparent"),(int)1);
	nme_bitmap_data_set_flags= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_set_flags"),(int)1);
	nme_bitmap_data_encode= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_encode"),(int)3);
	nme_bitmap_data_dump_bits= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_dump_bits"),(int)1);
	nme_bitmap_data_noise= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_noise"),(int)-1);
	nme_bitmap_data_flood_fill= ::native::Loader_obj::load(HX_CSTRING("nme_bitmap_data_flood_fill"),(int)4);
}

} // end namespace native
} // end namespace display
