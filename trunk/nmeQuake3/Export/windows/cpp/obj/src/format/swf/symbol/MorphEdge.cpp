#include <hxcpp.h>

#ifndef INCLUDED_format_swf_symbol_MorphEdge
#include <format/swf/symbol/MorphEdge.h>
#endif
#ifndef INCLUDED_native_display_Graphics
#include <native/display/Graphics.h>
#endif
namespace format{
namespace swf{
namespace symbol{

::format::swf::symbol::MorphEdge  MorphEdge_obj::meCurve(Float cx,Float cy,Float x,Float y)
	{ return hx::CreateEnum< MorphEdge_obj >(HX_CSTRING("meCurve"),3,hx::DynamicArray(0,4).Add(cx).Add(cy).Add(x).Add(y)); }

::format::swf::symbol::MorphEdge  MorphEdge_obj::meLine(Float cx,Float cy,Float x,Float y)
	{ return hx::CreateEnum< MorphEdge_obj >(HX_CSTRING("meLine"),2,hx::DynamicArray(0,4).Add(cx).Add(cy).Add(x).Add(y)); }

::format::swf::symbol::MorphEdge  MorphEdge_obj::meMove(Float x,Float y)
	{ return hx::CreateEnum< MorphEdge_obj >(HX_CSTRING("meMove"),1,hx::DynamicArray(0,2).Add(x).Add(y)); }

::format::swf::symbol::MorphEdge  MorphEdge_obj::meStyle(Dynamic func)
	{ return hx::CreateEnum< MorphEdge_obj >(HX_CSTRING("meStyle"),0,hx::DynamicArray(0,1).Add(func)); }

HX_DEFINE_CREATE_ENUM(MorphEdge_obj)

int MorphEdge_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("meCurve")) return 3;
	if (inName==HX_CSTRING("meLine")) return 2;
	if (inName==HX_CSTRING("meMove")) return 1;
	if (inName==HX_CSTRING("meStyle")) return 0;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC4(MorphEdge_obj,meCurve,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC4(MorphEdge_obj,meLine,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(MorphEdge_obj,meMove,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(MorphEdge_obj,meStyle,return)

int MorphEdge_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("meCurve")) return 4;
	if (inName==HX_CSTRING("meLine")) return 4;
	if (inName==HX_CSTRING("meMove")) return 2;
	if (inName==HX_CSTRING("meStyle")) return 1;
	return super::__FindArgCount(inName);
}

Dynamic MorphEdge_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("meCurve")) return meCurve_dyn();
	if (inName==HX_CSTRING("meLine")) return meLine_dyn();
	if (inName==HX_CSTRING("meMove")) return meMove_dyn();
	if (inName==HX_CSTRING("meStyle")) return meStyle_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("meStyle"),
	HX_CSTRING("meMove"),
	HX_CSTRING("meLine"),
	HX_CSTRING("meCurve"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MorphEdge_obj::__mClass,"__mClass");
};

static ::String sMemberFields[] = { ::String(null()) };
Class MorphEdge_obj::__mClass;

Dynamic __Create_MorphEdge_obj() { return new MorphEdge_obj; }

void MorphEdge_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.MorphEdge"), hx::TCanCast< MorphEdge_obj >,sStaticFields,sMemberFields,
	&__Create_MorphEdge_obj, &__Create,
	&super::__SGetClass(), &CreateMorphEdge_obj, sMarkStatics, sVisitStatic);
}

void MorphEdge_obj::__boot()
{
}


} // end namespace format
} // end namespace swf
} // end namespace symbol
