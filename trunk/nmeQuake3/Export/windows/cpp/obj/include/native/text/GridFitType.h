#ifndef INCLUDED_native_text_GridFitType
#define INCLUDED_native_text_GridFitType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(native,text,GridFitType)
namespace native{
namespace text{


class GridFitType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef GridFitType_obj OBJ_;

	public:
		GridFitType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("native.text.GridFitType"); }
		::String __ToString() const { return HX_CSTRING("GridFitType.") + tag; }

		static ::native::text::GridFitType NONE;
		static inline ::native::text::GridFitType NONE_dyn() { return NONE; }
		static ::native::text::GridFitType PIXEL;
		static inline ::native::text::GridFitType PIXEL_dyn() { return PIXEL; }
		static ::native::text::GridFitType SUBPIXEL;
		static inline ::native::text::GridFitType SUBPIXEL_dyn() { return SUBPIXEL; }
};

} // end namespace native
} // end namespace text

#endif /* INCLUDED_native_text_GridFitType */ 
