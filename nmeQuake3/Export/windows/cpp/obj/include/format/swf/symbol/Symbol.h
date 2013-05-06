#ifndef INCLUDED_format_swf_symbol_Symbol
#define INCLUDED_format_swf_symbol_Symbol

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,symbol,Bitmap)
HX_DECLARE_CLASS3(format,swf,symbol,Button)
HX_DECLARE_CLASS3(format,swf,symbol,EditText)
HX_DECLARE_CLASS3(format,swf,symbol,Font)
HX_DECLARE_CLASS3(format,swf,symbol,MorphShape)
HX_DECLARE_CLASS3(format,swf,symbol,Shape)
HX_DECLARE_CLASS3(format,swf,symbol,Sprite)
HX_DECLARE_CLASS3(format,swf,symbol,StaticText)
HX_DECLARE_CLASS3(format,swf,symbol,Symbol)
namespace format{
namespace swf{
namespace symbol{


class Symbol_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Symbol_obj OBJ_;

	public:
		Symbol_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("format.swf.symbol.Symbol"); }
		::String __ToString() const { return HX_CSTRING("Symbol.") + tag; }

		static ::format::swf::symbol::Symbol bitmapSymbol(::format::swf::symbol::Bitmap data);
		static Dynamic bitmapSymbol_dyn();
		static ::format::swf::symbol::Symbol buttonSymbol(::format::swf::symbol::Button data);
		static Dynamic buttonSymbol_dyn();
		static ::format::swf::symbol::Symbol editTextSymbol(::format::swf::symbol::EditText data);
		static Dynamic editTextSymbol_dyn();
		static ::format::swf::symbol::Symbol fontSymbol(::format::swf::symbol::Font data);
		static Dynamic fontSymbol_dyn();
		static ::format::swf::symbol::Symbol morphShapeSymbol(::format::swf::symbol::MorphShape data);
		static Dynamic morphShapeSymbol_dyn();
		static ::format::swf::symbol::Symbol shapeSymbol(::format::swf::symbol::Shape data);
		static Dynamic shapeSymbol_dyn();
		static ::format::swf::symbol::Symbol spriteSymbol(::format::swf::symbol::Sprite data);
		static Dynamic spriteSymbol_dyn();
		static ::format::swf::symbol::Symbol staticTextSymbol(::format::swf::symbol::StaticText data);
		static Dynamic staticTextSymbol_dyn();
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_Symbol */ 
