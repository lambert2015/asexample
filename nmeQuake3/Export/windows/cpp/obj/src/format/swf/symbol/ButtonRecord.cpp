#include <hxcpp.h>

#ifndef INCLUDED_format_swf_symbol_ButtonRecord
#include <format/swf/symbol/ButtonRecord.h>
#endif
#ifndef INCLUDED_format_swf_symbol_ButtonState
#include <format/swf/symbol/ButtonState.h>
#endif
namespace format{
namespace swf{
namespace symbol{

Void ButtonRecord_obj::__construct(int id,::format::swf::symbol::ButtonState state)
{
HX_STACK_PUSH("ButtonRecord::new","format/swf/symbol/Button.hx",206);
{
	HX_STACK_LINE(208)
	this->id = id;
	HX_STACK_LINE(209)
	this->state = state;
}
;
	return null();
}

ButtonRecord_obj::~ButtonRecord_obj() { }

Dynamic ButtonRecord_obj::__CreateEmpty() { return  new ButtonRecord_obj; }
hx::ObjectPtr< ButtonRecord_obj > ButtonRecord_obj::__new(int id,::format::swf::symbol::ButtonState state)
{  hx::ObjectPtr< ButtonRecord_obj > result = new ButtonRecord_obj();
	result->__construct(id,state);
	return result;}

Dynamic ButtonRecord_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ButtonRecord_obj > result = new ButtonRecord_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


ButtonRecord_obj::ButtonRecord_obj()
{
}

void ButtonRecord_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ButtonRecord);
	HX_MARK_MEMBER_NAME(state,"state");
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_END_CLASS();
}

void ButtonRecord_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(state,"state");
	HX_VISIT_MEMBER_NAME(id,"id");
}

Dynamic ButtonRecord_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"state") ) { return state; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ButtonRecord_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"state") ) { state=inValue.Cast< ::format::swf::symbol::ButtonState >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ButtonRecord_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("state"));
	outFields->push(HX_CSTRING("id"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("state"),
	HX_CSTRING("id"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ButtonRecord_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ButtonRecord_obj::__mClass,"__mClass");
};

Class ButtonRecord_obj::__mClass;

void ButtonRecord_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.ButtonRecord"), hx::TCanCast< ButtonRecord_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void ButtonRecord_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
