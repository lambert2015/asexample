#ifndef INCLUDED_format_swf_symbol_ShapeEdge
#define INCLUDED_format_swf_symbol_ShapeEdge

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,symbol,ShapeEdge)
HX_DECLARE_CLASS2(native,display,Graphics)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  ShapeEdge_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ShapeEdge_obj OBJ_;
		ShapeEdge_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< ShapeEdge_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~ShapeEdge_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ShapeEdge"); }

		virtual Void dump( );
		Dynamic dump_dyn();

		virtual bool connects( ::format::swf::symbol::ShapeEdge next);
		Dynamic connects_dyn();

		virtual Dynamic asCommand( );
		Dynamic asCommand_dyn();

		Float y1;
		Float y0;
		Float x1;
		Float x0;
		Float cy;
		Float cx;
		bool isQuadratic;
		int fillStyle;
		static ::format::swf::symbol::ShapeEdge curve( int style,Float x0,Float y0,Float cx,Float cy,Float x1,Float y1);
		static Dynamic curve_dyn();

		static ::format::swf::symbol::ShapeEdge line( int style,Float x0,Float y0,Float x1,Float y1);
		static Dynamic line_dyn();

};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_ShapeEdge */ 
