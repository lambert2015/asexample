#ifndef INCLUDED_format_swf_symbol_ButtonState
#define INCLUDED_format_swf_symbol_ButtonState

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,symbol,ButtonState)
namespace format{
namespace swf{
namespace symbol{


class ButtonState_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef ButtonState_obj OBJ_;

	public:
		ButtonState_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("format.swf.symbol.ButtonState"); }
		::String __ToString() const { return HX_CSTRING("ButtonState.") + tag; }

		static ::format::swf::symbol::ButtonState DOWN;
		static inline ::format::swf::symbol::ButtonState DOWN_dyn() { return DOWN; }
		static ::format::swf::symbol::ButtonState HIT_TEST;
		static inline ::format::swf::symbol::ButtonState HIT_TEST_dyn() { return HIT_TEST; }
		static ::format::swf::symbol::ButtonState NONE;
		static inline ::format::swf::symbol::ButtonState NONE_dyn() { return NONE; }
		static ::format::swf::symbol::ButtonState OVER;
		static inline ::format::swf::symbol::ButtonState OVER_dyn() { return OVER; }
		static ::format::swf::symbol::ButtonState UP;
		static inline ::format::swf::symbol::ButtonState UP_dyn() { return UP; }
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_ButtonState */ 
