#ifndef INCLUDED_format_swf_symbol_Bitmap
#define INCLUDED_format_swf_symbol_Bitmap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,data,SWFStream)
HX_DECLARE_CLASS3(format,swf,symbol,Bitmap)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(native,display,BitmapData)
HX_DECLARE_CLASS2(native,display,IBitmapDrawable)
HX_DECLARE_CLASS2(native,utils,ByteArray)
HX_DECLARE_CLASS2(native,utils,IDataInput)
HX_DECLARE_CLASS2(native,utils,IMemoryRange)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  Bitmap_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Bitmap_obj OBJ_;
		Bitmap_obj();
		Void __construct(::format::swf::data::SWFStream stream,bool lossless,int version,::native::utils::ByteArray jpegTables);

	public:
		static hx::ObjectPtr< Bitmap_obj > __new(::format::swf::data::SWFStream stream,bool lossless,int version,::native::utils::ByteArray jpegTables);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Bitmap_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Bitmap"); }

		virtual ::native::display::BitmapData createWithAlpha( ::native::display::BitmapData data,::native::utils::ByteArray alpha);
		Dynamic createWithAlpha_dyn();

		::native::display::BitmapData bitmapData;
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_Bitmap */ 
