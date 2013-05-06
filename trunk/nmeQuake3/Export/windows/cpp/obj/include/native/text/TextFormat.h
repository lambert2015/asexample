#ifndef INCLUDED_native_text_TextFormat
#define INCLUDED_native_text_TextFormat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(native,text,TextFormat)
namespace native{
namespace text{


class HXCPP_CLASS_ATTRIBUTES  TextFormat_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef TextFormat_obj OBJ_;
		TextFormat_obj();
		Void __construct(::String in_font,Dynamic in_size,Dynamic in_color,Dynamic in_bold,Dynamic in_italic,Dynamic in_underline,::String in_url,::String in_target,::String in_align,Dynamic in_leftMargin,Dynamic in_rightMargin,Dynamic in_indent,Dynamic in_leading);

	public:
		static hx::ObjectPtr< TextFormat_obj > __new(::String in_font,Dynamic in_size,Dynamic in_color,Dynamic in_bold,Dynamic in_italic,Dynamic in_underline,::String in_url,::String in_target,::String in_align,Dynamic in_leftMargin,Dynamic in_rightMargin,Dynamic in_indent,Dynamic in_leading);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~TextFormat_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TextFormat"); }

		::String url;
		Dynamic underline;
		::String target;
		Array< int > tabStops;
		Dynamic size;
		Dynamic rightMargin;
		Dynamic letterSpacing;
		Dynamic leftMargin;
		Dynamic leading;
		Dynamic kerning;
		Dynamic italic;
		Dynamic indent;
		::String font;
		::String display;
		Dynamic color;
		Dynamic bullet;
		Dynamic bold;
		Dynamic blockIndent;
		::String align;
};

} // end namespace native
} // end namespace text

#endif /* INCLUDED_native_text_TextFormat */ 
