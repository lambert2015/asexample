#ifndef INCLUDED_format_swf_symbol_ButtonRecord
#define INCLUDED_format_swf_symbol_ButtonRecord

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,symbol,ButtonRecord)
HX_DECLARE_CLASS3(format,swf,symbol,ButtonState)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  ButtonRecord_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ButtonRecord_obj OBJ_;
		ButtonRecord_obj();
		Void __construct(int id,::format::swf::symbol::ButtonState state);

	public:
		static hx::ObjectPtr< ButtonRecord_obj > __new(int id,::format::swf::symbol::ButtonState state);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~ButtonRecord_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ButtonRecord"); }

		::format::swf::symbol::ButtonState state;
		int id;
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_ButtonRecord */ 
