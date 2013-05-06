#ifndef INCLUDED_format_swf_data_DisplayAttributes
#define INCLUDED_format_swf_data_DisplayAttributes

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,data,DisplayAttributes)
HX_DECLARE_CLASS2(native,display,DisplayObject)
HX_DECLARE_CLASS2(native,display,IBitmapDrawable)
HX_DECLARE_CLASS2(native,events,EventDispatcher)
HX_DECLARE_CLASS2(native,events,IEventDispatcher)
HX_DECLARE_CLASS2(native,filters,BitmapFilter)
HX_DECLARE_CLASS2(native,geom,ColorTransform)
HX_DECLARE_CLASS2(native,geom,Matrix)
namespace format{
namespace swf{
namespace data{


class HXCPP_CLASS_ATTRIBUTES  DisplayAttributes_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef DisplayAttributes_obj OBJ_;
		DisplayAttributes_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< DisplayAttributes_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~DisplayAttributes_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("DisplayAttributes"); }

		virtual ::format::swf::data::DisplayAttributes clone( );
		Dynamic clone_dyn();

		virtual bool apply( ::native::display::DisplayObject object);
		Dynamic apply_dyn();

		int symbolID;
		Dynamic ratio;
		::String name;
		::native::geom::Matrix matrix;
		int frame;
		Array< ::Dynamic > filters;
		::native::geom::ColorTransform colorTransform;
};

} // end namespace format
} // end namespace swf
} // end namespace data

#endif /* INCLUDED_format_swf_data_DisplayAttributes */ 
