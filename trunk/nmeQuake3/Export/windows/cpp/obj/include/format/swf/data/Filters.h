#ifndef INCLUDED_format_swf_data_Filters
#define INCLUDED_format_swf_data_Filters

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,data,Filters)
HX_DECLARE_CLASS3(format,swf,data,SWFStream)
HX_DECLARE_CLASS2(native,filters,BitmapFilter)
namespace format{
namespace swf{
namespace data{


class HXCPP_CLASS_ATTRIBUTES  Filters_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Filters_obj OBJ_;
		Filters_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Filters_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Filters_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Filters"); }

		static Array< ::Dynamic > readFilters( ::format::swf::data::SWFStream stream);
		static Dynamic readFilters_dyn();

		static ::native::filters::BitmapFilter createBevelFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createBevelFilter_dyn();

		static ::native::filters::BitmapFilter createBlurFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createBlurFilter_dyn();

		static ::native::filters::BitmapFilter createColorMatrixFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createColorMatrixFilter_dyn();

		static ::native::filters::BitmapFilter createConvolutionFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createConvolutionFilter_dyn();

		static ::native::filters::BitmapFilter createDropShadowFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createDropShadowFilter_dyn();

		static ::native::filters::BitmapFilter createGlowFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createGlowFilter_dyn();

		static ::native::filters::BitmapFilter createGradientBevelFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createGradientBevelFilter_dyn();

		static ::native::filters::BitmapFilter createGradientGlowFilter( ::format::swf::data::SWFStream stream);
		static Dynamic createGradientGlowFilter_dyn();

};

} // end namespace format
} // end namespace swf
} // end namespace data

#endif /* INCLUDED_format_swf_data_Filters */ 
