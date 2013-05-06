#include <hxcpp.h>

#ifndef INCLUDED_format_swf_MorphObject
#include <format/swf/MorphObject.h>
#endif
#ifndef INCLUDED_format_swf_symbol_MorphShape
#include <format/swf/symbol/MorphShape.h>
#endif
#ifndef INCLUDED_native_display_DisplayObject
#include <native/display/DisplayObject.h>
#endif
#ifndef INCLUDED_native_display_DisplayObjectContainer
#include <native/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_native_display_Graphics
#include <native/display/Graphics.h>
#endif
#ifndef INCLUDED_native_display_IBitmapDrawable
#include <native/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_native_display_InteractiveObject
#include <native/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_native_display_Sprite
#include <native/display/Sprite.h>
#endif
#ifndef INCLUDED_native_events_EventDispatcher
#include <native/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_native_events_IEventDispatcher
#include <native/events/IEventDispatcher.h>
#endif
namespace format{
namespace swf{

Void MorphObject_obj::__construct(::format::swf::symbol::MorphShape data)
{
HX_STACK_PUSH("MorphObject::new","format/swf/MorphObject.hx",14);
{
	HX_STACK_LINE(16)
	super::__construct();
	HX_STACK_LINE(18)
	this->data = data;
}
;
	return null();
}

MorphObject_obj::~MorphObject_obj() { }

Dynamic MorphObject_obj::__CreateEmpty() { return  new MorphObject_obj; }
hx::ObjectPtr< MorphObject_obj > MorphObject_obj::__new(::format::swf::symbol::MorphShape data)
{  hx::ObjectPtr< MorphObject_obj > result = new MorphObject_obj();
	result->__construct(data);
	return result;}

Dynamic MorphObject_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MorphObject_obj > result = new MorphObject_obj();
	result->__construct(inArgs[0]);
	return result;}

bool MorphObject_obj::setRatio( int ratio){
	HX_STACK_PUSH("MorphObject::setRatio","format/swf/MorphObject.hx",23);
	HX_STACK_THIS(this);
	HX_STACK_ARG(ratio,"ratio");
	HX_STACK_LINE(27)
	this->get_graphics()->clear();
	HX_STACK_LINE(28)
	Float f = (Float(ratio) / Float(65536.0));		HX_STACK_VAR(f,"f");
	HX_STACK_LINE(30)
	return this->data->render(this->get_graphics(),f);
}


HX_DEFINE_DYNAMIC_FUNC1(MorphObject_obj,setRatio,return )


MorphObject_obj::MorphObject_obj()
{
}

void MorphObject_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MorphObject);
	HX_MARK_MEMBER_NAME(data,"data");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MorphObject_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(data,"data");
	super::__Visit(HX_VISIT_ARG);
}

Dynamic MorphObject_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { return data; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"setRatio") ) { return setRatio_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MorphObject_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { data=inValue.Cast< ::format::swf::symbol::MorphShape >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MorphObject_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("data"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("setRatio"),
	HX_CSTRING("data"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MorphObject_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MorphObject_obj::__mClass,"__mClass");
};

Class MorphObject_obj::__mClass;

void MorphObject_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.MorphObject"), hx::TCanCast< MorphObject_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void MorphObject_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
