#include <hxcpp.h>

#ifndef INCLUDED_format_swf_data_DepthSlot
#include <format/swf/data/DepthSlot.h>
#endif
#ifndef INCLUDED_format_swf_data_DisplayAttributes
#include <format/swf/data/DisplayAttributes.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
#endif
#ifndef INCLUDED_native_geom_ColorTransform
#include <native/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_native_geom_Matrix
#include <native/geom/Matrix.h>
#endif
namespace format{
namespace swf{
namespace data{

Void DepthSlot_obj::__construct(int symbolID,::format::swf::symbol::Symbol symbol,::format::swf::data::DisplayAttributes attributes)
{
HX_STACK_PUSH("DepthSlot::new","format/swf/data/DepthSlot.hx",19);
{
	HX_STACK_LINE(21)
	this->symbolID = symbolID;
	HX_STACK_LINE(22)
	this->symbol = symbol;
	HX_STACK_LINE(24)
	this->attributes = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(25)
	this->attributes->push(attributes);
	HX_STACK_LINE(27)
	this->cacheAttributes = attributes;
}
;
	return null();
}

DepthSlot_obj::~DepthSlot_obj() { }

Dynamic DepthSlot_obj::__CreateEmpty() { return  new DepthSlot_obj; }
hx::ObjectPtr< DepthSlot_obj > DepthSlot_obj::__new(int symbolID,::format::swf::symbol::Symbol symbol,::format::swf::data::DisplayAttributes attributes)
{  hx::ObjectPtr< DepthSlot_obj > result = new DepthSlot_obj();
	result->__construct(symbolID,symbol,attributes);
	return result;}

Dynamic DepthSlot_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DepthSlot_obj > result = new DepthSlot_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void DepthSlot_obj::move( int frame,::native::geom::Matrix matrix,::native::geom::ColorTransform colorTransform,Dynamic ratio){
{
		HX_STACK_PUSH("DepthSlot::move","format/swf/data/DepthSlot.hx",67);
		HX_STACK_THIS(this);
		HX_STACK_ARG(frame,"frame");
		HX_STACK_ARG(matrix,"matrix");
		HX_STACK_ARG(colorTransform,"colorTransform");
		HX_STACK_ARG(ratio,"ratio");
		HX_STACK_LINE(69)
		this->cacheAttributes = this->cacheAttributes->clone();
		HX_STACK_LINE(70)
		this->cacheAttributes->frame = frame;
		HX_STACK_LINE(72)
		if (((matrix != null()))){
			HX_STACK_LINE(72)
			this->cacheAttributes->matrix = matrix;
		}
		HX_STACK_LINE(78)
		if (((colorTransform != null()))){
			HX_STACK_LINE(78)
			this->cacheAttributes->colorTransform = colorTransform;
		}
		HX_STACK_LINE(84)
		if (((ratio != null()))){
			HX_STACK_LINE(84)
			this->cacheAttributes->ratio = ratio;
		}
		HX_STACK_LINE(90)
		this->attributes->push(this->cacheAttributes);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(DepthSlot_obj,move,(void))

int DepthSlot_obj::findClosestFrame( int hintFrame,int frame){
	HX_STACK_PUSH("DepthSlot::findClosestFrame","format/swf/data/DepthSlot.hx",32);
	HX_STACK_THIS(this);
	HX_STACK_ARG(hintFrame,"hintFrame");
	HX_STACK_ARG(frame,"frame");
	HX_STACK_LINE(34)
	int last = hintFrame;		HX_STACK_VAR(last,"last");
	HX_STACK_LINE(36)
	if (((last >= this->attributes->length))){
		HX_STACK_LINE(36)
		last = (int)0;
	}
	else{
		HX_STACK_LINE(40)
		if (((last > (int)0))){
			HX_STACK_LINE(40)
			if (((this->attributes->__get((last - (int)1)).StaticCast< ::format::swf::data::DisplayAttributes >()->frame > frame))){
				HX_STACK_LINE(42)
				last = (int)0;
			}
		}
	}
	HX_STACK_LINE(50)
	{
		HX_STACK_LINE(50)
		int _g1 = last;		HX_STACK_VAR(_g1,"_g1");
		int _g = this->attributes->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(50)
		while(((_g1 < _g))){
			HX_STACK_LINE(50)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(52)
			if (((this->attributes->__get(i).StaticCast< ::format::swf::data::DisplayAttributes >()->frame > frame))){
				HX_STACK_LINE(52)
				return last;
			}
			HX_STACK_LINE(58)
			last = i;
		}
	}
	HX_STACK_LINE(62)
	return last;
}


HX_DEFINE_DYNAMIC_FUNC2(DepthSlot_obj,findClosestFrame,return )


DepthSlot_obj::DepthSlot_obj()
{
}

void DepthSlot_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DepthSlot);
	HX_MARK_MEMBER_NAME(cacheAttributes,"cacheAttributes");
	HX_MARK_MEMBER_NAME(symbolID,"symbolID");
	HX_MARK_MEMBER_NAME(symbol,"symbol");
	HX_MARK_MEMBER_NAME(attributes,"attributes");
	HX_MARK_END_CLASS();
}

void DepthSlot_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(cacheAttributes,"cacheAttributes");
	HX_VISIT_MEMBER_NAME(symbolID,"symbolID");
	HX_VISIT_MEMBER_NAME(symbol,"symbol");
	HX_VISIT_MEMBER_NAME(attributes,"attributes");
}

Dynamic DepthSlot_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"move") ) { return move_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"symbol") ) { return symbol; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"symbolID") ) { return symbolID; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"attributes") ) { return attributes; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"cacheAttributes") ) { return cacheAttributes; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"findClosestFrame") ) { return findClosestFrame_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DepthSlot_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"symbol") ) { symbol=inValue.Cast< ::format::swf::symbol::Symbol >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"symbolID") ) { symbolID=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"attributes") ) { attributes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"cacheAttributes") ) { cacheAttributes=inValue.Cast< ::format::swf::data::DisplayAttributes >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DepthSlot_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("cacheAttributes"));
	outFields->push(HX_CSTRING("symbolID"));
	outFields->push(HX_CSTRING("symbol"));
	outFields->push(HX_CSTRING("attributes"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("move"),
	HX_CSTRING("findClosestFrame"),
	HX_CSTRING("cacheAttributes"),
	HX_CSTRING("symbolID"),
	HX_CSTRING("symbol"),
	HX_CSTRING("attributes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DepthSlot_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DepthSlot_obj::__mClass,"__mClass");
};

Class DepthSlot_obj::__mClass;

void DepthSlot_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.data.DepthSlot"), hx::TCanCast< DepthSlot_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void DepthSlot_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace data
