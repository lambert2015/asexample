#ifndef INCLUDED_native_filters_DropShadowFilter
#define INCLUDED_native_filters_DropShadowFilter

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <native/filters/BitmapFilter.h>
HX_DECLARE_CLASS2(native,filters,BitmapFilter)
HX_DECLARE_CLASS2(native,filters,DropShadowFilter)
namespace native{
namespace filters{


class HXCPP_CLASS_ATTRIBUTES  DropShadowFilter_obj : public ::native::filters::BitmapFilter_obj{
	public:
		typedef ::native::filters::BitmapFilter_obj super;
		typedef DropShadowFilter_obj OBJ_;
		DropShadowFilter_obj();
		Void __construct(hx::Null< Float >  __o_in_distance,hx::Null< Float >  __o_in_angle,hx::Null< int >  __o_in_color,hx::Null< Float >  __o_in_alpha,hx::Null< Float >  __o_in_blurX,hx::Null< Float >  __o_in_blurY,hx::Null< Float >  __o_in_strength,hx::Null< int >  __o_in_quality,hx::Null< bool >  __o_in_inner,hx::Null< bool >  __o_in_knockout,hx::Null< bool >  __o_in_hideObject);

	public:
		static hx::ObjectPtr< DropShadowFilter_obj > __new(hx::Null< Float >  __o_in_distance,hx::Null< Float >  __o_in_angle,hx::Null< int >  __o_in_color,hx::Null< Float >  __o_in_alpha,hx::Null< Float >  __o_in_blurX,hx::Null< Float >  __o_in_blurY,hx::Null< Float >  __o_in_strength,hx::Null< int >  __o_in_quality,hx::Null< bool >  __o_in_inner,hx::Null< bool >  __o_in_knockout,hx::Null< bool >  __o_in_hideObject);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~DropShadowFilter_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("DropShadowFilter"); }

		virtual ::native::filters::BitmapFilter clone( );

		Float strength;
		int quality;
		bool knockout;
		bool inner;
		bool hideObject;
		Float distance;
		int color;
		Float blurY;
		Float blurX;
		Float angle;
		Float alpha;
};

} // end namespace native
} // end namespace filters

#endif /* INCLUDED_native_filters_DropShadowFilter */ 
