#include <hxcpp.h>

#ifndef INCLUDED_native_text_TextLineMetrics
#include <native/text/TextLineMetrics.h>
#endif
namespace native{
namespace text{

Void TextLineMetrics_obj::__construct(Dynamic in_x,Dynamic in_width,Dynamic in_height,Dynamic in_ascent,Dynamic in_descent,Dynamic in_leading)
{
HX_STACK_PUSH("TextLineMetrics::new","native/text/TextLineMetrics.hx",13);
{
	HX_STACK_LINE(14)
	this->x = in_x;
	HX_STACK_LINE(15)
	this->width = in_width;
	HX_STACK_LINE(16)
	this->height = in_height;
	HX_STACK_LINE(17)
	this->ascent = in_ascent;
	HX_STACK_LINE(18)
	this->descent = in_descent;
	HX_STACK_LINE(19)
	this->leading = in_leading;
}
;
	return null();
}

TextLineMetrics_obj::~TextLineMetrics_obj() { }

Dynamic TextLineMetrics_obj::__CreateEmpty() { return  new TextLineMetrics_obj; }
hx::ObjectPtr< TextLineMetrics_obj > TextLineMetrics_obj::__new(Dynamic in_x,Dynamic in_width,Dynamic in_height,Dynamic in_ascent,Dynamic in_descent,Dynamic in_leading)
{  hx::ObjectPtr< TextLineMetrics_obj > result = new TextLineMetrics_obj();
	result->__construct(in_x,in_width,in_height,in_ascent,in_descent,in_leading);
	return result;}

Dynamic TextLineMetrics_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TextLineMetrics_obj > result = new TextLineMetrics_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}


TextLineMetrics_obj::TextLineMetrics_obj()
{
}

void TextLineMetrics_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TextLineMetrics);
	HX_MARK_MEMBER_NAME(leading,"leading");
	HX_MARK_MEMBER_NAME(descent,"descent");
	HX_MARK_MEMBER_NAME(ascent,"ascent");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_END_CLASS();
}

void TextLineMetrics_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(leading,"leading");
	HX_VISIT_MEMBER_NAME(descent,"descent");
	HX_VISIT_MEMBER_NAME(ascent,"ascent");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(x,"x");
}

Dynamic TextLineMetrics_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"ascent") ) { return ascent; }
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"leading") ) { return leading; }
		if (HX_FIELD_EQ(inName,"descent") ) { return descent; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TextLineMetrics_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"ascent") ) { ascent=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"leading") ) { leading=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"descent") ) { descent=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TextLineMetrics_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("leading"));
	outFields->push(HX_CSTRING("descent"));
	outFields->push(HX_CSTRING("ascent"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("x"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("leading"),
	HX_CSTRING("descent"),
	HX_CSTRING("ascent"),
	HX_CSTRING("height"),
	HX_CSTRING("width"),
	HX_CSTRING("x"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextLineMetrics_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TextLineMetrics_obj::__mClass,"__mClass");
};

Class TextLineMetrics_obj::__mClass;

void TextLineMetrics_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("native.text.TextLineMetrics"), hx::TCanCast< TextLineMetrics_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void TextLineMetrics_obj::__boot()
{
}

} // end namespace native
} // end namespace text
