#ifndef INCLUDED_native_text_TextLineMetrics
#define INCLUDED_native_text_TextLineMetrics

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(native,text,TextLineMetrics)
namespace native{
namespace text{


class HXCPP_CLASS_ATTRIBUTES  TextLineMetrics_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef TextLineMetrics_obj OBJ_;
		TextLineMetrics_obj();
		Void __construct(Dynamic in_x,Dynamic in_width,Dynamic in_height,Dynamic in_ascent,Dynamic in_descent,Dynamic in_leading);

	public:
		static hx::ObjectPtr< TextLineMetrics_obj > __new(Dynamic in_x,Dynamic in_width,Dynamic in_height,Dynamic in_ascent,Dynamic in_descent,Dynamic in_leading);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~TextLineMetrics_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TextLineMetrics"); }

		Float leading;
		Float descent;
		Float ascent;
		Float height;
		Float width;
		Float x;
};

} // end namespace native
} // end namespace text

#endif /* INCLUDED_native_text_TextLineMetrics */ 
