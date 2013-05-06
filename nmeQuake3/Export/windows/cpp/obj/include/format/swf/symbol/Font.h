#ifndef INCLUDED_format_swf_symbol_Font
#define INCLUDED_format_swf_symbol_Font

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,data,SWFStream)
HX_DECLARE_CLASS3(format,swf,symbol,Font)
HX_DECLARE_CLASS2(native,display,Graphics)
HX_DECLARE_CLASS2(native,geom,Matrix)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  Font_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Font_obj OBJ_;
		Font_obj();
		Void __construct(::format::swf::data::SWFStream stream,int version);

	public:
		static hx::ObjectPtr< Font_obj > __new(::format::swf::data::SWFStream stream,int version);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Font_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Font"); }

		virtual Void renderGlyph( ::native::display::Graphics graphics,int index,::native::geom::Matrix matrix);
		Dynamic renderGlyph_dyn();

		virtual Float renderCharacter( ::native::display::Graphics graphics,int code,::native::geom::Matrix matrix);
		Dynamic renderCharacter_dyn();

		virtual Float getLeading( );
		Dynamic getLeading_dyn();

		virtual ::String getFontName( );
		Dynamic getFontName_dyn();

		virtual Float getDescent( );
		Dynamic getDescent_dyn();

		virtual Float getAscent( );
		Dynamic getAscent_dyn();

		virtual Float getAdvance( int characterCode,Dynamic next);
		Dynamic getAdvance_dyn();

		Float leading;
		Dynamic glyphsByIndex;
		Dynamic glyphsByCode;
		::String fontName;
		Float descent;
		Float ascent;
		Array< Float > advance;
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_Font */ 
