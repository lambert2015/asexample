#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_format_swf_MorphObject
#include <format/swf/MorphObject.h>
#endif
#ifndef INCLUDED_format_swf_data_DisplayAttributes
#include <format/swf/data/DisplayAttributes.h>
#endif
#ifndef INCLUDED_native_display_DisplayObject
#include <native/display/DisplayObject.h>
#endif
#ifndef INCLUDED_native_display_DisplayObjectContainer
#include <native/display/DisplayObjectContainer.h>
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
#ifndef INCLUDED_native_filters_BitmapFilter
#include <native/filters/BitmapFilter.h>
#endif
#ifndef INCLUDED_native_geom_ColorTransform
#include <native/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_native_geom_Matrix
#include <native/geom/Matrix.h>
#endif
#ifndef INCLUDED_native_geom_Transform
#include <native/geom/Transform.h>
#endif
namespace format{
namespace swf{
namespace data{

Void DisplayAttributes_obj::__construct()
{
HX_STACK_PUSH("DisplayAttributes::new","format/swf/data/DisplayAttributes.hx",22);
{
}
;
	return null();
}

DisplayAttributes_obj::~DisplayAttributes_obj() { }

Dynamic DisplayAttributes_obj::__CreateEmpty() { return  new DisplayAttributes_obj; }
hx::ObjectPtr< DisplayAttributes_obj > DisplayAttributes_obj::__new()
{  hx::ObjectPtr< DisplayAttributes_obj > result = new DisplayAttributes_obj();
	result->__construct();
	return result;}

Dynamic DisplayAttributes_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DisplayAttributes_obj > result = new DisplayAttributes_obj();
	result->__construct();
	return result;}

::format::swf::data::DisplayAttributes DisplayAttributes_obj::clone( ){
	HX_STACK_PUSH("DisplayAttributes::clone","format/swf/data/DisplayAttributes.hx",63);
	HX_STACK_THIS(this);
	HX_STACK_LINE(65)
	::format::swf::data::DisplayAttributes copy = ::format::swf::data::DisplayAttributes_obj::__new();		HX_STACK_VAR(copy,"copy");
	HX_STACK_LINE(67)
	copy->frame = this->frame;
	HX_STACK_LINE(68)
	copy->matrix = this->matrix;
	HX_STACK_LINE(69)
	copy->colorTransform = this->colorTransform;
	HX_STACK_LINE(70)
	copy->ratio = this->ratio;
	HX_STACK_LINE(71)
	copy->name = this->name;
	HX_STACK_LINE(72)
	copy->symbolID = this->symbolID;
	HX_STACK_LINE(74)
	return copy;
}


HX_DEFINE_DYNAMIC_FUNC0(DisplayAttributes_obj,clone,return )

bool DisplayAttributes_obj::apply( ::native::display::DisplayObject object){
	HX_STACK_PUSH("DisplayAttributes::apply","format/swf/data/DisplayAttributes.hx",29);
	HX_STACK_THIS(this);
	HX_STACK_ARG(object,"object");
	HX_STACK_LINE(31)
	if (((this->matrix != null()))){
		HX_STACK_LINE(31)
		object->get_transform()->set_matrix(this->matrix->clone());
	}
	HX_STACK_LINE(37)
	if (((this->colorTransform != null()))){
		HX_STACK_LINE(37)
		object->get_transform()->set_colorTransform(this->colorTransform);
	}
	HX_STACK_LINE(43)
	object->set_name(this->name);
	HX_STACK_LINE(45)
	if (((object->get_filters() != this->filters))){
		HX_STACK_LINE(45)
		object->set_filters(this->filters);
	}
	HX_STACK_LINE(51)
	if (((bool((this->ratio != null())) && bool(::Std_obj::is(object,hx::ClassOf< ::format::swf::MorphObject >()))))){
		HX_STACK_LINE(53)
		::format::swf::MorphObject morph = object;		HX_STACK_VAR(morph,"morph");
		HX_STACK_LINE(54)
		return morph->setRatio(this->ratio);
	}
	HX_STACK_LINE(58)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayAttributes_obj,apply,return )


DisplayAttributes_obj::DisplayAttributes_obj()
{
}

void DisplayAttributes_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DisplayAttributes);
	HX_MARK_MEMBER_NAME(symbolID,"symbolID");
	HX_MARK_MEMBER_NAME(ratio,"ratio");
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(matrix,"matrix");
	HX_MARK_MEMBER_NAME(frame,"frame");
	HX_MARK_MEMBER_NAME(filters,"filters");
	HX_MARK_MEMBER_NAME(colorTransform,"colorTransform");
	HX_MARK_END_CLASS();
}

void DisplayAttributes_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(symbolID,"symbolID");
	HX_VISIT_MEMBER_NAME(ratio,"ratio");
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(matrix,"matrix");
	HX_VISIT_MEMBER_NAME(frame,"frame");
	HX_VISIT_MEMBER_NAME(filters,"filters");
	HX_VISIT_MEMBER_NAME(colorTransform,"colorTransform");
}

Dynamic DisplayAttributes_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"apply") ) { return apply_dyn(); }
		if (HX_FIELD_EQ(inName,"ratio") ) { return ratio; }
		if (HX_FIELD_EQ(inName,"frame") ) { return frame; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"matrix") ) { return matrix; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"filters") ) { return filters; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"symbolID") ) { return symbolID; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"colorTransform") ) { return colorTransform; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DisplayAttributes_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"ratio") ) { ratio=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"frame") ) { frame=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"matrix") ) { matrix=inValue.Cast< ::native::geom::Matrix >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"filters") ) { filters=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"symbolID") ) { symbolID=inValue.Cast< int >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"colorTransform") ) { colorTransform=inValue.Cast< ::native::geom::ColorTransform >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DisplayAttributes_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("symbolID"));
	outFields->push(HX_CSTRING("ratio"));
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("matrix"));
	outFields->push(HX_CSTRING("frame"));
	outFields->push(HX_CSTRING("filters"));
	outFields->push(HX_CSTRING("colorTransform"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("clone"),
	HX_CSTRING("apply"),
	HX_CSTRING("symbolID"),
	HX_CSTRING("ratio"),
	HX_CSTRING("name"),
	HX_CSTRING("matrix"),
	HX_CSTRING("frame"),
	HX_CSTRING("filters"),
	HX_CSTRING("colorTransform"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DisplayAttributes_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DisplayAttributes_obj::__mClass,"__mClass");
};

Class DisplayAttributes_obj::__mClass;

void DisplayAttributes_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.data.DisplayAttributes"), hx::TCanCast< DisplayAttributes_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void DisplayAttributes_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace data
