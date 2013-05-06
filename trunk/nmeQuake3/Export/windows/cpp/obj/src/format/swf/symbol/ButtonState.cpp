#include <hxcpp.h>

#ifndef INCLUDED_format_swf_symbol_ButtonState
#include <format/swf/symbol/ButtonState.h>
#endif
namespace format{
namespace swf{
namespace symbol{

::format::swf::symbol::ButtonState ButtonState_obj::DOWN;

::format::swf::symbol::ButtonState ButtonState_obj::HIT_TEST;

::format::swf::symbol::ButtonState ButtonState_obj::NONE;

::format::swf::symbol::ButtonState ButtonState_obj::OVER;

::format::swf::symbol::ButtonState ButtonState_obj::UP;

HX_DEFINE_CREATE_ENUM(ButtonState_obj)

int ButtonState_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("DOWN")) return 2;
	if (inName==HX_CSTRING("HIT_TEST")) return 3;
	if (inName==HX_CSTRING("NONE")) return 4;
	if (inName==HX_CSTRING("OVER")) return 1;
	if (inName==HX_CSTRING("UP")) return 0;
	return super::__FindIndex(inName);
}

int ButtonState_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("DOWN")) return 0;
	if (inName==HX_CSTRING("HIT_TEST")) return 0;
	if (inName==HX_CSTRING("NONE")) return 0;
	if (inName==HX_CSTRING("OVER")) return 0;
	if (inName==HX_CSTRING("UP")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic ButtonState_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("DOWN")) return DOWN;
	if (inName==HX_CSTRING("HIT_TEST")) return HIT_TEST;
	if (inName==HX_CSTRING("NONE")) return NONE;
	if (inName==HX_CSTRING("OVER")) return OVER;
	if (inName==HX_CSTRING("UP")) return UP;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("UP"),
	HX_CSTRING("OVER"),
	HX_CSTRING("DOWN"),
	HX_CSTRING("HIT_TEST"),
	HX_CSTRING("NONE"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ButtonState_obj::DOWN,"DOWN");
	HX_MARK_MEMBER_NAME(ButtonState_obj::HIT_TEST,"HIT_TEST");
	HX_MARK_MEMBER_NAME(ButtonState_obj::NONE,"NONE");
	HX_MARK_MEMBER_NAME(ButtonState_obj::OVER,"OVER");
	HX_MARK_MEMBER_NAME(ButtonState_obj::UP,"UP");
};

static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ButtonState_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ButtonState_obj::DOWN,"DOWN");
	HX_VISIT_MEMBER_NAME(ButtonState_obj::HIT_TEST,"HIT_TEST");
	HX_VISIT_MEMBER_NAME(ButtonState_obj::NONE,"NONE");
	HX_VISIT_MEMBER_NAME(ButtonState_obj::OVER,"OVER");
	HX_VISIT_MEMBER_NAME(ButtonState_obj::UP,"UP");
};

static ::String sMemberFields[] = { ::String(null()) };
Class ButtonState_obj::__mClass;

Dynamic __Create_ButtonState_obj() { return new ButtonState_obj; }

void ButtonState_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.ButtonState"), hx::TCanCast< ButtonState_obj >,sStaticFields,sMemberFields,
	&__Create_ButtonState_obj, &__Create,
	&super::__SGetClass(), &CreateButtonState_obj, sMarkStatics, sVisitStatic);
}

void ButtonState_obj::__boot()
{
hx::Static(DOWN) = hx::CreateEnum< ButtonState_obj >(HX_CSTRING("DOWN"),2);
hx::Static(HIT_TEST) = hx::CreateEnum< ButtonState_obj >(HX_CSTRING("HIT_TEST"),3);
hx::Static(NONE) = hx::CreateEnum< ButtonState_obj >(HX_CSTRING("NONE"),4);
hx::Static(OVER) = hx::CreateEnum< ButtonState_obj >(HX_CSTRING("OVER"),1);
hx::Static(UP) = hx::CreateEnum< ButtonState_obj >(HX_CSTRING("UP"),0);
}


} // end namespace format
} // end namespace swf
} // end namespace symbol
