#ifndef INCLUDED_format_swf_data_DepthSlot
#define INCLUDED_format_swf_data_DepthSlot

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,data,DepthSlot)
HX_DECLARE_CLASS3(format,swf,data,DisplayAttributes)
HX_DECLARE_CLASS3(format,swf,symbol,Symbol)
HX_DECLARE_CLASS2(native,geom,ColorTransform)
HX_DECLARE_CLASS2(native,geom,Matrix)
namespace format{
namespace swf{
namespace data{


class HXCPP_CLASS_ATTRIBUTES  DepthSlot_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef DepthSlot_obj OBJ_;
		DepthSlot_obj();
		Void __construct(int symbolID,::format::swf::symbol::Symbol symbol,::format::swf::data::DisplayAttributes attributes);

	public:
		static hx::ObjectPtr< DepthSlot_obj > __new(int symbolID,::format::swf::symbol::Symbol symbol,::format::swf::data::DisplayAttributes attributes);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~DepthSlot_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("DepthSlot"); }

		virtual Void move( int frame,::native::geom::Matrix matrix,::native::geom::ColorTransform colorTransform,Dynamic ratio);
		Dynamic move_dyn();

		virtual int findClosestFrame( int hintFrame,int frame);
		Dynamic findClosestFrame_dyn();

		::format::swf::data::DisplayAttributes cacheAttributes;
		int symbolID;
		::format::swf::symbol::Symbol symbol;
		Array< ::Dynamic > attributes;
};

} // end namespace format
} // end namespace swf
} // end namespace data

#endif /* INCLUDED_format_swf_data_DepthSlot */ 
