#include <hxcpp.h>

#ifndef INCLUDED_native_filters_BitmapFilter
#include <native/filters/BitmapFilter.h>
#endif
#ifndef INCLUDED_native_filters_DropShadowFilter
#include <native/filters/DropShadowFilter.h>
#endif
namespace native{
namespace filters{

Void DropShadowFilter_obj::__construct(hx::Null< Float >  __o_in_distance,hx::Null< Float >  __o_in_angle,hx::Null< int >  __o_in_color,hx::Null< Float >  __o_in_alpha,hx::Null< Float >  __o_in_blurX,hx::Null< Float >  __o_in_blurY,hx::Null< Float >  __o_in_strength,hx::Null< int >  __o_in_quality,hx::Null< bool >  __o_in_inner,hx::Null< bool >  __o_in_knockout,hx::Null< bool >  __o_in_hideObject)
{
HX_STACK_PUSH("DropShadowFilter::new","native/filters/DropShadowFilter.hx",18);
Float in_distance = __o_in_distance.Default(4.0);
Float in_angle = __o_in_angle.Default(45.0);
int in_color = __o_in_color.Default(0);
Float in_alpha = __o_in_alpha.Default(1.0);
Float in_blurX = __o_in_blurX.Default(4.0);
Float in_blurY = __o_in_blurY.Default(4.0);
Float in_strength = __o_in_strength.Default(1.0);
int in_quality = __o_in_quality.Default(1);
bool in_inner = __o_in_inner.Default(false);
bool in_knockout = __o_in_knockout.Default(false);
bool in_hideObject = __o_in_hideObject.Default(false);
{
	HX_STACK_LINE(19)
	super::__construct(HX_CSTRING("DropShadowFilter"));
	HX_STACK_LINE(21)
	this->distance = in_distance;
	HX_STACK_LINE(22)
	this->angle = in_angle;
	HX_STACK_LINE(23)
	this->color = in_color;
	HX_STACK_LINE(24)
	this->alpha = in_alpha;
	HX_STACK_LINE(25)
	this->blurX = in_blurX;
	HX_STACK_LINE(26)
	this->blurY = in_blurY;
	HX_STACK_LINE(27)
	this->strength = in_strength;
	HX_STACK_LINE(28)
	this->quality = in_quality;
	HX_STACK_LINE(29)
	this->inner = in_inner;
	HX_STACK_LINE(30)
	this->knockout = in_knockout;
	HX_STACK_LINE(31)
	this->hideObject = in_hideObject;
}
;
	return null();
}

DropShadowFilter_obj::~DropShadowFilter_obj() { }

Dynamic DropShadowFilter_obj::__CreateEmpty() { return  new DropShadowFilter_obj; }
hx::ObjectPtr< DropShadowFilter_obj > DropShadowFilter_obj::__new(hx::Null< Float >  __o_in_distance,hx::Null< Float >  __o_in_angle,hx::Null< int >  __o_in_color,hx::Null< Float >  __o_in_alpha,hx::Null< Float >  __o_in_blurX,hx::Null< Float >  __o_in_blurY,hx::Null< Float >  __o_in_strength,hx::Null< int >  __o_in_quality,hx::Null< bool >  __o_in_inner,hx::Null< bool >  __o_in_knockout,hx::Null< bool >  __o_in_hideObject)
{  hx::ObjectPtr< DropShadowFilter_obj > result = new DropShadowFilter_obj();
	result->__construct(__o_in_distance,__o_in_angle,__o_in_color,__o_in_alpha,__o_in_blurX,__o_in_blurY,__o_in_strength,__o_in_quality,__o_in_inner,__o_in_knockout,__o_in_hideObject);
	return result;}

Dynamic DropShadowFilter_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DropShadowFilter_obj > result = new DropShadowFilter_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6],inArgs[7],inArgs[8],inArgs[9],inArgs[10]);
	return result;}

::native::filters::BitmapFilter DropShadowFilter_obj::clone( ){
	HX_STACK_PUSH("DropShadowFilter::clone","native/filters/DropShadowFilter.hx",35);
	HX_STACK_THIS(this);
	HX_STACK_LINE(35)
	return ::native::filters::DropShadowFilter_obj::__new(this->distance,this->angle,this->color,this->alpha,this->blurX,this->blurY,this->strength,this->quality,this->inner,this->knockout,this->hideObject);
}



DropShadowFilter_obj::DropShadowFilter_obj()
{
}

void DropShadowFilter_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DropShadowFilter);
	HX_MARK_MEMBER_NAME(strength,"strength");
	HX_MARK_MEMBER_NAME(quality,"quality");
	HX_MARK_MEMBER_NAME(knockout,"knockout");
	HX_MARK_MEMBER_NAME(inner,"inner");
	HX_MARK_MEMBER_NAME(hideObject,"hideObject");
	HX_MARK_MEMBER_NAME(distance,"distance");
	HX_MARK_MEMBER_NAME(color,"color");
	HX_MARK_MEMBER_NAME(blurY,"blurY");
	HX_MARK_MEMBER_NAME(blurX,"blurX");
	HX_MARK_MEMBER_NAME(angle,"angle");
	HX_MARK_MEMBER_NAME(alpha,"alpha");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void DropShadowFilter_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(strength,"strength");
	HX_VISIT_MEMBER_NAME(quality,"quality");
	HX_VISIT_MEMBER_NAME(knockout,"knockout");
	HX_VISIT_MEMBER_NAME(inner,"inner");
	HX_VISIT_MEMBER_NAME(hideObject,"hideObject");
	HX_VISIT_MEMBER_NAME(distance,"distance");
	HX_VISIT_MEMBER_NAME(color,"color");
	HX_VISIT_MEMBER_NAME(blurY,"blurY");
	HX_VISIT_MEMBER_NAME(blurX,"blurX");
	HX_VISIT_MEMBER_NAME(angle,"angle");
	HX_VISIT_MEMBER_NAME(alpha,"alpha");
	super::__Visit(HX_VISIT_ARG);
}

Dynamic DropShadowFilter_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"inner") ) { return inner; }
		if (HX_FIELD_EQ(inName,"color") ) { return color; }
		if (HX_FIELD_EQ(inName,"blurY") ) { return blurY; }
		if (HX_FIELD_EQ(inName,"blurX") ) { return blurX; }
		if (HX_FIELD_EQ(inName,"angle") ) { return angle; }
		if (HX_FIELD_EQ(inName,"alpha") ) { return alpha; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"quality") ) { return quality; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"strength") ) { return strength; }
		if (HX_FIELD_EQ(inName,"knockout") ) { return knockout; }
		if (HX_FIELD_EQ(inName,"distance") ) { return distance; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"hideObject") ) { return hideObject; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DropShadowFilter_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"inner") ) { inner=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"color") ) { color=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"blurY") ) { blurY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"blurX") ) { blurX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"angle") ) { angle=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alpha") ) { alpha=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"quality") ) { quality=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"strength") ) { strength=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"knockout") ) { knockout=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"distance") ) { distance=inValue.Cast< Float >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"hideObject") ) { hideObject=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DropShadowFilter_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("strength"));
	outFields->push(HX_CSTRING("quality"));
	outFields->push(HX_CSTRING("knockout"));
	outFields->push(HX_CSTRING("inner"));
	outFields->push(HX_CSTRING("hideObject"));
	outFields->push(HX_CSTRING("distance"));
	outFields->push(HX_CSTRING("color"));
	outFields->push(HX_CSTRING("blurY"));
	outFields->push(HX_CSTRING("blurX"));
	outFields->push(HX_CSTRING("angle"));
	outFields->push(HX_CSTRING("alpha"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("clone"),
	HX_CSTRING("strength"),
	HX_CSTRING("quality"),
	HX_CSTRING("knockout"),
	HX_CSTRING("inner"),
	HX_CSTRING("hideObject"),
	HX_CSTRING("distance"),
	HX_CSTRING("color"),
	HX_CSTRING("blurY"),
	HX_CSTRING("blurX"),
	HX_CSTRING("angle"),
	HX_CSTRING("alpha"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DropShadowFilter_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DropShadowFilter_obj::__mClass,"__mClass");
};

Class DropShadowFilter_obj::__mClass;

void DropShadowFilter_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("native.filters.DropShadowFilter"), hx::TCanCast< DropShadowFilter_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void DropShadowFilter_obj::__boot()
{
}

} // end namespace native
} // end namespace filters
