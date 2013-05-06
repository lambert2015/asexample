#ifndef INCLUDED_format_swf_symbol_MorphEdge
#define INCLUDED_format_swf_symbol_MorphEdge

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,symbol,MorphEdge)
HX_DECLARE_CLASS2(native,display,Graphics)
namespace format{
namespace swf{
namespace symbol{


class MorphEdge_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef MorphEdge_obj OBJ_;

	public:
		MorphEdge_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("format.swf.symbol.MorphEdge"); }
		::String __ToString() const { return HX_CSTRING("MorphEdge.") + tag; }

		static ::format::swf::symbol::MorphEdge meCurve(Float cx,Float cy,Float x,Float y);
		static Dynamic meCurve_dyn();
		static ::format::swf::symbol::MorphEdge meLine(Float cx,Float cy,Float x,Float y);
		static Dynamic meLine_dyn();
		static ::format::swf::symbol::MorphEdge meMove(Float x,Float y);
		static Dynamic meMove_dyn();
		static ::format::swf::symbol::MorphEdge meStyle(Dynamic func);
		static Dynamic meStyle_dyn();
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_MorphEdge */ 
