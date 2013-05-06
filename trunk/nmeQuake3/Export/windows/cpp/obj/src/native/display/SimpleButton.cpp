#include <hxcpp.h>

#ifndef INCLUDED_native_Loader
#include <native/Loader.h>
#endif
#ifndef INCLUDED_native_display_DisplayObject
#include <native/display/DisplayObject.h>
#endif
#ifndef INCLUDED_native_display_IBitmapDrawable
#include <native/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_native_display_InteractiveObject
#include <native/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_native_display_SimpleButton
#include <native/display/SimpleButton.h>
#endif
#ifndef INCLUDED_native_events_EventDispatcher
#include <native/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_native_events_IEventDispatcher
#include <native/events/IEventDispatcher.h>
#endif
namespace native{
namespace display{

Void SimpleButton_obj::__construct(::native::display::DisplayObject upState,::native::display::DisplayObject overState,::native::display::DisplayObject downState,::native::display::DisplayObject hitTestState)
{
HX_STACK_PUSH("SimpleButton::new","native/display/SimpleButton.hx",18);
{
	HX_STACK_LINE(19)
	super::__construct(::native::display::SimpleButton_obj::nme_simple_button_create(),HX_CSTRING("SimpleButton"));
	HX_STACK_LINE(21)
	this->set_upState(upState);
	HX_STACK_LINE(22)
	this->set_overState(overState);
	HX_STACK_LINE(23)
	this->set_downState(downState);
	HX_STACK_LINE(24)
	this->set_hitTestState(hitTestState);
}
;
	return null();
}

SimpleButton_obj::~SimpleButton_obj() { }

Dynamic SimpleButton_obj::__CreateEmpty() { return  new SimpleButton_obj; }
hx::ObjectPtr< SimpleButton_obj > SimpleButton_obj::__new(::native::display::DisplayObject upState,::native::display::DisplayObject overState,::native::display::DisplayObject downState,::native::display::DisplayObject hitTestState)
{  hx::ObjectPtr< SimpleButton_obj > result = new SimpleButton_obj();
	result->__construct(upState,overState,downState,hitTestState);
	return result;}

Dynamic SimpleButton_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SimpleButton_obj > result = new SimpleButton_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

::native::display::DisplayObject SimpleButton_obj::set_upState( ::native::display::DisplayObject inState){
	HX_STACK_PUSH("SimpleButton::set_upState","native/display/SimpleButton.hx",64);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inState,"inState");
	HX_STACK_LINE(65)
	this->upState = inState;
	HX_STACK_LINE(66)
	::native::display::SimpleButton_obj::nme_simple_button_set_state(this->nmeHandle,(int)0,(  (((inState == null()))) ? Dynamic(null()) : Dynamic(inState->nmeHandle) ));
	HX_STACK_LINE(67)
	return inState;
}


HX_DEFINE_DYNAMIC_FUNC1(SimpleButton_obj,set_upState,return )

::native::display::DisplayObject SimpleButton_obj::set_overState( ::native::display::DisplayObject inState){
	HX_STACK_PUSH("SimpleButton::set_overState","native/display/SimpleButton.hx",57);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inState,"inState");
	HX_STACK_LINE(58)
	this->overState = inState;
	HX_STACK_LINE(59)
	::native::display::SimpleButton_obj::nme_simple_button_set_state(this->nmeHandle,(int)2,(  (((inState == null()))) ? Dynamic(null()) : Dynamic(inState->nmeHandle) ));
	HX_STACK_LINE(60)
	return inState;
}


HX_DEFINE_DYNAMIC_FUNC1(SimpleButton_obj,set_overState,return )

::native::display::DisplayObject SimpleButton_obj::set_hitTestState( ::native::display::DisplayObject inState){
	HX_STACK_PUSH("SimpleButton::set_hitTestState","native/display/SimpleButton.hx",50);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inState,"inState");
	HX_STACK_LINE(51)
	this->hitTestState = inState;
	HX_STACK_LINE(52)
	::native::display::SimpleButton_obj::nme_simple_button_set_state(this->nmeHandle,(int)3,(  (((inState == null()))) ? Dynamic(null()) : Dynamic(inState->nmeHandle) ));
	HX_STACK_LINE(53)
	return inState;
}


HX_DEFINE_DYNAMIC_FUNC1(SimpleButton_obj,set_hitTestState,return )

bool SimpleButton_obj::set_useHandCursor( bool inVal){
	HX_STACK_PUSH("SimpleButton::set_useHandCursor","native/display/SimpleButton.hx",44);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inVal,"inVal");
	HX_STACK_LINE(45)
	::native::display::SimpleButton_obj::nme_simple_button_set_hand_cursor(this->nmeHandle,inVal);
	HX_STACK_LINE(46)
	return inVal;
}


HX_DEFINE_DYNAMIC_FUNC1(SimpleButton_obj,set_useHandCursor,return )

bool SimpleButton_obj::get_useHandCursor( ){
	HX_STACK_PUSH("SimpleButton::get_useHandCursor","native/display/SimpleButton.hx",42);
	HX_STACK_THIS(this);
	HX_STACK_LINE(42)
	return ::native::display::SimpleButton_obj::nme_simple_button_get_hand_cursor(this->nmeHandle);
}


HX_DEFINE_DYNAMIC_FUNC0(SimpleButton_obj,get_useHandCursor,return )

bool SimpleButton_obj::set_enabled( bool inVal){
	HX_STACK_PUSH("SimpleButton::set_enabled","native/display/SimpleButton.hx",37);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inVal,"inVal");
	HX_STACK_LINE(38)
	::native::display::SimpleButton_obj::nme_simple_button_set_enabled(this->nmeHandle,inVal);
	HX_STACK_LINE(39)
	return inVal;
}


HX_DEFINE_DYNAMIC_FUNC1(SimpleButton_obj,set_enabled,return )

bool SimpleButton_obj::get_enabled( ){
	HX_STACK_PUSH("SimpleButton::get_enabled","native/display/SimpleButton.hx",35);
	HX_STACK_THIS(this);
	HX_STACK_LINE(35)
	return ::native::display::SimpleButton_obj::nme_simple_button_get_enabled(this->nmeHandle);
}


HX_DEFINE_DYNAMIC_FUNC0(SimpleButton_obj,get_enabled,return )

::native::display::DisplayObject SimpleButton_obj::set_downState( ::native::display::DisplayObject inState){
	HX_STACK_PUSH("SimpleButton::set_downState","native/display/SimpleButton.hx",29);
	HX_STACK_THIS(this);
	HX_STACK_ARG(inState,"inState");
	HX_STACK_LINE(30)
	this->downState = inState;
	HX_STACK_LINE(31)
	::native::display::SimpleButton_obj::nme_simple_button_set_state(this->nmeHandle,(int)1,(  (((inState == null()))) ? Dynamic(null()) : Dynamic(inState->nmeHandle) ));
	HX_STACK_LINE(32)
	return inState;
}


HX_DEFINE_DYNAMIC_FUNC1(SimpleButton_obj,set_downState,return )

Dynamic SimpleButton_obj::nme_simple_button_set_state;

Dynamic SimpleButton_obj::nme_simple_button_get_enabled;

Dynamic SimpleButton_obj::nme_simple_button_set_enabled;

Dynamic SimpleButton_obj::nme_simple_button_get_hand_cursor;

Dynamic SimpleButton_obj::nme_simple_button_set_hand_cursor;

Dynamic SimpleButton_obj::nme_simple_button_create;


SimpleButton_obj::SimpleButton_obj()
{
}

void SimpleButton_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SimpleButton);
	HX_MARK_MEMBER_NAME(upState,"upState");
	HX_MARK_MEMBER_NAME(overState,"overState");
	HX_MARK_MEMBER_NAME(hitTestState,"hitTestState");
	HX_MARK_MEMBER_NAME(downState,"downState");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void SimpleButton_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(upState,"upState");
	HX_VISIT_MEMBER_NAME(overState,"overState");
	HX_VISIT_MEMBER_NAME(hitTestState,"hitTestState");
	HX_VISIT_MEMBER_NAME(downState,"downState");
	super::__Visit(HX_VISIT_ARG);
}

Dynamic SimpleButton_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"upState") ) { return upState; }
		if (HX_FIELD_EQ(inName,"enabled") ) { return get_enabled(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"overState") ) { return overState; }
		if (HX_FIELD_EQ(inName,"downState") ) { return downState; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"set_upState") ) { return set_upState_dyn(); }
		if (HX_FIELD_EQ(inName,"set_enabled") ) { return set_enabled_dyn(); }
		if (HX_FIELD_EQ(inName,"get_enabled") ) { return get_enabled_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hitTestState") ) { return hitTestState; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"set_overState") ) { return set_overState_dyn(); }
		if (HX_FIELD_EQ(inName,"set_downState") ) { return set_downState_dyn(); }
		if (HX_FIELD_EQ(inName,"useHandCursor") ) { return get_useHandCursor(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"set_hitTestState") ) { return set_hitTestState_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"set_useHandCursor") ) { return set_useHandCursor_dyn(); }
		if (HX_FIELD_EQ(inName,"get_useHandCursor") ) { return get_useHandCursor_dyn(); }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"nme_simple_button_create") ) { return nme_simple_button_create; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"nme_simple_button_set_state") ) { return nme_simple_button_set_state; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"nme_simple_button_get_enabled") ) { return nme_simple_button_get_enabled; }
		if (HX_FIELD_EQ(inName,"nme_simple_button_set_enabled") ) { return nme_simple_button_set_enabled; }
		break;
	case 33:
		if (HX_FIELD_EQ(inName,"nme_simple_button_get_hand_cursor") ) { return nme_simple_button_get_hand_cursor; }
		if (HX_FIELD_EQ(inName,"nme_simple_button_set_hand_cursor") ) { return nme_simple_button_set_hand_cursor; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SimpleButton_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"upState") ) { if (inCallProp) return set_upState(inValue);upState=inValue.Cast< ::native::display::DisplayObject >(); return inValue; }
		if (HX_FIELD_EQ(inName,"enabled") ) { return set_enabled(inValue); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"overState") ) { if (inCallProp) return set_overState(inValue);overState=inValue.Cast< ::native::display::DisplayObject >(); return inValue; }
		if (HX_FIELD_EQ(inName,"downState") ) { if (inCallProp) return set_downState(inValue);downState=inValue.Cast< ::native::display::DisplayObject >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hitTestState") ) { if (inCallProp) return set_hitTestState(inValue);hitTestState=inValue.Cast< ::native::display::DisplayObject >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"useHandCursor") ) { return set_useHandCursor(inValue); }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"nme_simple_button_create") ) { nme_simple_button_create=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"nme_simple_button_set_state") ) { nme_simple_button_set_state=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"nme_simple_button_get_enabled") ) { nme_simple_button_get_enabled=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_simple_button_set_enabled") ) { nme_simple_button_set_enabled=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 33:
		if (HX_FIELD_EQ(inName,"nme_simple_button_get_hand_cursor") ) { nme_simple_button_get_hand_cursor=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_simple_button_set_hand_cursor") ) { nme_simple_button_set_hand_cursor=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SimpleButton_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("useHandCursor"));
	outFields->push(HX_CSTRING("upState"));
	outFields->push(HX_CSTRING("overState"));
	outFields->push(HX_CSTRING("hitTestState"));
	outFields->push(HX_CSTRING("enabled"));
	outFields->push(HX_CSTRING("downState"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("nme_simple_button_set_state"),
	HX_CSTRING("nme_simple_button_get_enabled"),
	HX_CSTRING("nme_simple_button_set_enabled"),
	HX_CSTRING("nme_simple_button_get_hand_cursor"),
	HX_CSTRING("nme_simple_button_set_hand_cursor"),
	HX_CSTRING("nme_simple_button_create"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("set_upState"),
	HX_CSTRING("set_overState"),
	HX_CSTRING("set_hitTestState"),
	HX_CSTRING("set_useHandCursor"),
	HX_CSTRING("get_useHandCursor"),
	HX_CSTRING("set_enabled"),
	HX_CSTRING("get_enabled"),
	HX_CSTRING("set_downState"),
	HX_CSTRING("upState"),
	HX_CSTRING("overState"),
	HX_CSTRING("hitTestState"),
	HX_CSTRING("downState"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SimpleButton_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(SimpleButton_obj::nme_simple_button_set_state,"nme_simple_button_set_state");
	HX_MARK_MEMBER_NAME(SimpleButton_obj::nme_simple_button_get_enabled,"nme_simple_button_get_enabled");
	HX_MARK_MEMBER_NAME(SimpleButton_obj::nme_simple_button_set_enabled,"nme_simple_button_set_enabled");
	HX_MARK_MEMBER_NAME(SimpleButton_obj::nme_simple_button_get_hand_cursor,"nme_simple_button_get_hand_cursor");
	HX_MARK_MEMBER_NAME(SimpleButton_obj::nme_simple_button_set_hand_cursor,"nme_simple_button_set_hand_cursor");
	HX_MARK_MEMBER_NAME(SimpleButton_obj::nme_simple_button_create,"nme_simple_button_create");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::nme_simple_button_set_state,"nme_simple_button_set_state");
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::nme_simple_button_get_enabled,"nme_simple_button_get_enabled");
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::nme_simple_button_set_enabled,"nme_simple_button_set_enabled");
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::nme_simple_button_get_hand_cursor,"nme_simple_button_get_hand_cursor");
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::nme_simple_button_set_hand_cursor,"nme_simple_button_set_hand_cursor");
	HX_VISIT_MEMBER_NAME(SimpleButton_obj::nme_simple_button_create,"nme_simple_button_create");
};

Class SimpleButton_obj::__mClass;

void SimpleButton_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("native.display.SimpleButton"), hx::TCanCast< SimpleButton_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void SimpleButton_obj::__boot()
{
	nme_simple_button_set_state= ::native::Loader_obj::load(HX_CSTRING("nme_simple_button_set_state"),(int)3);
	nme_simple_button_get_enabled= ::native::Loader_obj::load(HX_CSTRING("nme_simple_button_get_enabled"),(int)1);
	nme_simple_button_set_enabled= ::native::Loader_obj::load(HX_CSTRING("nme_simple_button_set_enabled"),(int)2);
	nme_simple_button_get_hand_cursor= ::native::Loader_obj::load(HX_CSTRING("nme_simple_button_get_hand_cursor"),(int)1);
	nme_simple_button_set_hand_cursor= ::native::Loader_obj::load(HX_CSTRING("nme_simple_button_set_hand_cursor"),(int)2);
	nme_simple_button_create= ::native::Loader_obj::load(HX_CSTRING("nme_simple_button_create"),(int)0);
}

} // end namespace native
} // end namespace display
