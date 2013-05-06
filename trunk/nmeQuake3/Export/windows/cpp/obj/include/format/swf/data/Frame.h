#ifndef INCLUDED_format_swf_data_Frame
#define INCLUDED_format_swf_data_Frame

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS3(format,swf,data,Frame)
HX_DECLARE_CLASS3(format,swf,symbol,Symbol)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS2(native,filters,BitmapFilter)
HX_DECLARE_CLASS2(native,geom,ColorTransform)
HX_DECLARE_CLASS2(native,geom,Matrix)
namespace format{
namespace swf{
namespace data{


class HXCPP_CLASS_ATTRIBUTES  Frame_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Frame_obj OBJ_;
		Frame_obj();
		Void __construct(::format::swf::data::Frame previous);

	public:
		static hx::ObjectPtr< Frame_obj > __new(::format::swf::data::Frame previous);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Frame_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Frame"); }

		virtual Void remove( int depth);
		Dynamic remove_dyn();

		virtual Void place( int symbolID,::format::swf::symbol::Symbol symbol,int depth,::native::geom::Matrix matrix,::native::geom::ColorTransform colorTransform,Dynamic ratio,::String name,Array< ::Dynamic > filters);
		Dynamic place_dyn();

		virtual Void move( int depth,::native::geom::Matrix matrix,::native::geom::ColorTransform colorTransform,Dynamic ratio);
		Dynamic move_dyn();

		virtual ::haxe::ds::IntMap copyObjectSet( );
		Dynamic copyObjectSet_dyn();

		::haxe::ds::IntMap objects;
		int frame;
};

} // end namespace format
} // end namespace swf
} // end namespace data

#endif /* INCLUDED_format_swf_data_Frame */ 
