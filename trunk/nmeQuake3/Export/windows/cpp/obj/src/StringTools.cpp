#include <hxcpp.h>

#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif

Void StringTools_obj::__construct()
{
	return null();
}

StringTools_obj::~StringTools_obj() { }

Dynamic StringTools_obj::__CreateEmpty() { return  new StringTools_obj; }
hx::ObjectPtr< StringTools_obj > StringTools_obj::__new()
{  hx::ObjectPtr< StringTools_obj > result = new StringTools_obj();
	result->__construct();
	return result;}

Dynamic StringTools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< StringTools_obj > result = new StringTools_obj();
	result->__construct();
	return result;}

::String StringTools_obj::urlEncode( ::String s){
	HX_STACK_PUSH("StringTools::urlEncode","C:\\HaxeFoundation\\haxe/std/StringTools.hx",37);
	HX_STACK_ARG(s,"s");
	HX_STACK_LINE(37)
	return s.__URLEncode();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,urlEncode,return )

::String StringTools_obj::urlDecode( ::String s){
	HX_STACK_PUSH("StringTools::urlDecode","C:\\HaxeFoundation\\haxe/std/StringTools.hx",62);
	HX_STACK_ARG(s,"s");
	HX_STACK_LINE(62)
	return s.__URLDecode();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,urlDecode,return )

::String StringTools_obj::replace( ::String s,::String sub,::String by){
	HX_STACK_PUSH("StringTools::replace","C:\\HaxeFoundation\\haxe/std/StringTools.hx",288);
	HX_STACK_ARG(s,"s");
	HX_STACK_ARG(sub,"sub");
	HX_STACK_ARG(by,"by");
	HX_STACK_LINE(288)
	return s.split(sub)->join(by);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(StringTools_obj,replace,return )

::String StringTools_obj::hex( int n,Dynamic digits){
	HX_STACK_PUSH("StringTools::hex","C:\\HaxeFoundation\\haxe/std/StringTools.hx",310);
	HX_STACK_ARG(n,"n");
	HX_STACK_ARG(digits,"digits");
	HX_STACK_LINE(316)
	::String s = HX_CSTRING("");		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(317)
	::String hexChars = HX_CSTRING("0123456789ABCDEF");		HX_STACK_VAR(hexChars,"hexChars");
	HX_STACK_LINE(318)
	do{
		HX_STACK_LINE(319)
		s = (hexChars.charAt((int(n) & int((int)15))) + s);
		HX_STACK_LINE(320)
		hx::UShrEq(n,(int)4);
	}
while(((n > (int)0)));
	HX_STACK_LINE(323)
	if (((digits != null()))){
		HX_STACK_LINE(324)
		while(((s.length < digits))){
			HX_STACK_LINE(325)
			s = (HX_CSTRING("0") + s);
		}
	}
	HX_STACK_LINE(326)
	return s;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,hex,return )


StringTools_obj::StringTools_obj()
{
}

void StringTools_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(StringTools);
	HX_MARK_END_CLASS();
}

void StringTools_obj::__Visit(HX_VISIT_PARAMS)
{
}

Dynamic StringTools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"hex") ) { return hex_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"replace") ) { return replace_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"urlEncode") ) { return urlEncode_dyn(); }
		if (HX_FIELD_EQ(inName,"urlDecode") ) { return urlDecode_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic StringTools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void StringTools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("urlEncode"),
	HX_CSTRING("urlDecode"),
	HX_CSTRING("replace"),
	HX_CSTRING("hex"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StringTools_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StringTools_obj::__mClass,"__mClass");
};

Class StringTools_obj::__mClass;

void StringTools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("StringTools"), hx::TCanCast< StringTools_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void StringTools_obj::__boot()
{
}

