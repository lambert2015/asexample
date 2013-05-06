#include <hxcpp.h>

#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Bitmap
#include <format/swf/symbol/Bitmap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_native_display_BitmapData
#include <native/display/BitmapData.h>
#endif
#ifndef INCLUDED_native_display_IBitmapDrawable
#include <native/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_native_geom_Rectangle
#include <native/geom/Rectangle.h>
#endif
#ifndef INCLUDED_native_utils_ByteArray
#include <native/utils/ByteArray.h>
#endif
#ifndef INCLUDED_native_utils_CompressionAlgorithm
#include <native/utils/CompressionAlgorithm.h>
#endif
#ifndef INCLUDED_native_utils_IDataInput
#include <native/utils/IDataInput.h>
#endif
#ifndef INCLUDED_native_utils_IMemoryRange
#include <native/utils/IMemoryRange.h>
#endif
namespace format{
namespace swf{
namespace symbol{

Void Bitmap_obj::__construct(::format::swf::data::SWFStream stream,bool lossless,int version,::native::utils::ByteArray jpegTables)
{
HX_STACK_PUSH("Bitmap::new","format/swf/symbol/Bitmap.hx",27);
{
	HX_STACK_LINE(27)
	if ((lossless)){
		HX_STACK_LINE(31)
		int format = stream->readByte();		HX_STACK_VAR(format,"format");
		HX_STACK_LINE(41)
		if (((bool((version == (int)2)) && bool((format == (int)4))))){
			HX_STACK_LINE(41)
			hx::Throw (HX_CSTRING("No 15-bit format in DefineBitsLossless2"));
		}
		HX_STACK_LINE(47)
		int width = stream->readUInt16();		HX_STACK_VAR(width,"width");
		HX_STACK_LINE(48)
		int height = stream->readUInt16();		HX_STACK_VAR(height,"height");
		HX_STACK_LINE(49)
		int tableSize = (int)0;		HX_STACK_VAR(tableSize,"tableSize");
		HX_STACK_LINE(51)
		if (((format == (int)3))){
			HX_STACK_LINE(51)
			tableSize = (stream->readByte() + (int)1);
		}
		HX_STACK_LINE(57)
		::native::utils::ByteArray buffer = stream->readFlashBytes(stream->getBytesLeft());		HX_STACK_VAR(buffer,"buffer");
		HX_STACK_LINE(58)
		buffer->uncompress(null());
		HX_STACK_LINE(60)
		bool transparent = false;		HX_STACK_VAR(transparent,"transparent");
		HX_STACK_LINE(62)
		if (((version == (int)2))){
			HX_STACK_LINE(62)
			transparent = true;
		}
		HX_STACK_LINE(68)
		if (((format == (int)3))){
			HX_STACK_LINE(70)
			Array< int > colorTable = Array_obj< int >::__new();		HX_STACK_VAR(colorTable,"colorTable");
			HX_STACK_LINE(72)
			{
				HX_STACK_LINE(72)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(72)
				while(((_g < tableSize))){
					HX_STACK_LINE(72)
					int i = (_g)++;		HX_STACK_VAR(i,"i");
					struct _Function_5_1{
						inline static int Block( ::native::utils::ByteArray &buffer){
							HX_STACK_PUSH("*::closure","format/swf/symbol/Bitmap.hx",74);
							{
								HX_STACK_LINE(74)
								int val = (  (((buffer->position < buffer->length))) ? int(buffer->b->__get((buffer->position)++)) : int(buffer->ThrowEOFi()) );		HX_STACK_VAR(val,"val");
								HX_STACK_LINE(74)
								return (  (((((int(val) & int((int)128))) != (int)0))) ? int((val - (int)256)) : int(val) );
							}
							return null();
						}
					};
					HX_STACK_LINE(74)
					int r = _Function_5_1::Block(buffer);		HX_STACK_VAR(r,"r");
					struct _Function_5_2{
						inline static int Block( ::native::utils::ByteArray &buffer){
							HX_STACK_PUSH("*::closure","format/swf/symbol/Bitmap.hx",75);
							{
								HX_STACK_LINE(75)
								int val = (  (((buffer->position < buffer->length))) ? int(buffer->b->__get((buffer->position)++)) : int(buffer->ThrowEOFi()) );		HX_STACK_VAR(val,"val");
								HX_STACK_LINE(75)
								return (  (((((int(val) & int((int)128))) != (int)0))) ? int((val - (int)256)) : int(val) );
							}
							return null();
						}
					};
					HX_STACK_LINE(75)
					int g = _Function_5_2::Block(buffer);		HX_STACK_VAR(g,"g");
					struct _Function_5_3{
						inline static int Block( ::native::utils::ByteArray &buffer){
							HX_STACK_PUSH("*::closure","format/swf/symbol/Bitmap.hx",76);
							{
								HX_STACK_LINE(76)
								int val = (  (((buffer->position < buffer->length))) ? int(buffer->b->__get((buffer->position)++)) : int(buffer->ThrowEOFi()) );		HX_STACK_VAR(val,"val");
								HX_STACK_LINE(76)
								return (  (((((int(val) & int((int)128))) != (int)0))) ? int((val - (int)256)) : int(val) );
							}
							return null();
						}
					};
					HX_STACK_LINE(76)
					int b = _Function_5_3::Block(buffer);		HX_STACK_VAR(b,"b");
					HX_STACK_LINE(78)
					if ((transparent)){
						struct _Function_6_1{
							inline static int Block( ::native::utils::ByteArray &buffer){
								HX_STACK_PUSH("*::closure","format/swf/symbol/Bitmap.hx",80);
								{
									HX_STACK_LINE(80)
									int val = (  (((buffer->position < buffer->length))) ? int(buffer->b->__get((buffer->position)++)) : int(buffer->ThrowEOFi()) );		HX_STACK_VAR(val,"val");
									HX_STACK_LINE(80)
									return (  (((((int(val) & int((int)128))) != (int)0))) ? int((val - (int)256)) : int(val) );
								}
								return null();
							}
						};
						HX_STACK_LINE(80)
						int a = _Function_6_1::Block(buffer);		HX_STACK_VAR(a,"a");
						HX_STACK_LINE(81)
						colorTable->push((((((int(a) << int((int)24))) + ((int(r) << int((int)16)))) + ((int(g) << int((int)8)))) + b));
					}
					else{
						HX_STACK_LINE(83)
						colorTable->push(((((int(r) << int((int)16))) + ((int(g) << int((int)8)))) + b));
					}
				}
			}
			HX_STACK_LINE(91)
			::native::utils::ByteArray imageData = ::native::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(imageData,"imageData");
			HX_STACK_LINE(92)
			int padding = (::Math_obj::ceil((Float(width) / Float((int)4))) - ::Math_obj::floor((Float(width) / Float((int)4))));		HX_STACK_VAR(padding,"padding");
			HX_STACK_LINE(94)
			{
				HX_STACK_LINE(94)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(94)
				while(((_g < height))){
					HX_STACK_LINE(94)
					int y = (_g)++;		HX_STACK_VAR(y,"y");
					HX_STACK_LINE(96)
					{
						HX_STACK_LINE(96)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(96)
						while(((_g1 < width))){
							HX_STACK_LINE(96)
							int x = (_g1)++;		HX_STACK_VAR(x,"x");
							struct _Function_7_1{
								inline static int Block( ::native::utils::ByteArray &buffer){
									HX_STACK_PUSH("*::closure","format/swf/symbol/Bitmap.hx",98);
									{
										HX_STACK_LINE(98)
										int val = (  (((buffer->position < buffer->length))) ? int(buffer->b->__get((buffer->position)++)) : int(buffer->ThrowEOFi()) );		HX_STACK_VAR(val,"val");
										HX_STACK_LINE(98)
										return (  (((((int(val) & int((int)128))) != (int)0))) ? int((val - (int)256)) : int(val) );
									}
									return null();
								}
							};
							HX_STACK_LINE(98)
							imageData->writeUnsignedInt(colorTable->__get(_Function_7_1::Block(buffer)));
						}
					}
					HX_STACK_LINE(102)
					hx::AddEq(buffer->position,padding);
				}
			}
			HX_STACK_LINE(106)
			buffer = imageData;
			HX_STACK_LINE(107)
			buffer->position = (int)0;
		}
		HX_STACK_LINE(111)
		this->bitmapData = ::native::display::BitmapData_obj::__new(width,height,transparent,null(),null());
		HX_STACK_LINE(112)
		this->bitmapData->setPixels(::native::geom::Rectangle_obj::__new((int)0,(int)0,width,height),buffer);
	}
	else{
		HX_STACK_LINE(116)
		::native::utils::ByteArray buffer = null();		HX_STACK_VAR(buffer,"buffer");
		HX_STACK_LINE(117)
		::native::utils::ByteArray alpha = null();		HX_STACK_VAR(alpha,"alpha");
		HX_STACK_LINE(119)
		if (((bool((version == (int)1)) && bool((jpegTables != null()))))){
			HX_STACK_LINE(119)
			buffer = jpegTables;
		}
		else{
			HX_STACK_LINE(123)
			if (((version == (int)2))){
				HX_STACK_LINE(125)
				int size = stream->getBytesLeft();		HX_STACK_VAR(size,"size");
				HX_STACK_LINE(126)
				buffer = stream->readBytes(size);
			}
			else{
				HX_STACK_LINE(128)
				if (((version == (int)3))){
					HX_STACK_LINE(130)
					int size = stream->readInt();		HX_STACK_VAR(size,"size");
					HX_STACK_LINE(131)
					buffer = stream->readBytes(size);
					HX_STACK_LINE(133)
					alpha = stream->readFlashBytes(stream->getBytesLeft());
					HX_STACK_LINE(134)
					alpha->uncompress(null());
				}
			}
		}
		HX_STACK_LINE(148)
		this->bitmapData = ::native::display::BitmapData_obj::loadFromHaxeBytes(buffer,alpha);
		HX_STACK_LINE(150)
		if (((bool(!(lossless)) && bool((alpha != null()))))){
		}
	}
}
;
	return null();
}

Bitmap_obj::~Bitmap_obj() { }

Dynamic Bitmap_obj::__CreateEmpty() { return  new Bitmap_obj; }
hx::ObjectPtr< Bitmap_obj > Bitmap_obj::__new(::format::swf::data::SWFStream stream,bool lossless,int version,::native::utils::ByteArray jpegTables)
{  hx::ObjectPtr< Bitmap_obj > result = new Bitmap_obj();
	result->__construct(stream,lossless,version,jpegTables);
	return result;}

Dynamic Bitmap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Bitmap_obj > result = new Bitmap_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

::native::display::BitmapData Bitmap_obj::createWithAlpha( ::native::display::BitmapData data,::native::utils::ByteArray alpha){
	HX_STACK_PUSH("Bitmap::createWithAlpha","format/swf/symbol/Bitmap.hx",164);
	HX_STACK_THIS(this);
	HX_STACK_ARG(data,"data");
	HX_STACK_ARG(alpha,"alpha");
	HX_STACK_LINE(166)
	::native::display::BitmapData alphaBitmap = ::native::display::BitmapData_obj::__new(data->get_width(),data->get_height(),true,null(),null());		HX_STACK_VAR(alphaBitmap,"alphaBitmap");
	HX_STACK_LINE(167)
	int index = (int)0;		HX_STACK_VAR(index,"index");
	HX_STACK_LINE(169)
	{
		HX_STACK_LINE(169)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		int _g = data->get_height();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(169)
		while(((_g1 < _g))){
			HX_STACK_LINE(169)
			int y = (_g1)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(171)
			{
				HX_STACK_LINE(171)
				int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
				int _g2 = data->get_width();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(171)
				while(((_g3 < _g2))){
					HX_STACK_LINE(171)
					int x = (_g3)++;		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(175)
					alphaBitmap->setPixel32(x,y,(data->getPixel(x,y) + ((int(alpha->__get((index)++)) << int((int)24)))));
				}
			}
		}
	}
	HX_STACK_LINE(189)
	return alphaBitmap;
}


HX_DEFINE_DYNAMIC_FUNC2(Bitmap_obj,createWithAlpha,return )


Bitmap_obj::Bitmap_obj()
{
}

void Bitmap_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Bitmap);
	HX_MARK_MEMBER_NAME(bitmapData,"bitmapData");
	HX_MARK_END_CLASS();
}

void Bitmap_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bitmapData,"bitmapData");
}

Dynamic Bitmap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"bitmapData") ) { return bitmapData; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"createWithAlpha") ) { return createWithAlpha_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Bitmap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"bitmapData") ) { bitmapData=inValue.Cast< ::native::display::BitmapData >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Bitmap_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bitmapData"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("createWithAlpha"),
	HX_CSTRING("bitmapData"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Bitmap_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Bitmap_obj::__mClass,"__mClass");
};

Class Bitmap_obj::__mClass;

void Bitmap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.Bitmap"), hx::TCanCast< Bitmap_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Bitmap_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
