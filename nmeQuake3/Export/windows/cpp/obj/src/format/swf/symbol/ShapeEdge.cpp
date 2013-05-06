#include <hxcpp.h>

#ifndef INCLUDED_format_swf_symbol_ShapeEdge
#include <format/swf/symbol/ShapeEdge.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_native_display_Graphics
#include <native/display/Graphics.h>
#endif
namespace format{
namespace swf{
namespace symbol{

Void ShapeEdge_obj::__construct()
{
HX_STACK_PUSH("ShapeEdge::new","format/swf/symbol/Shape.hx",727);
{
}
;
	return null();
}

ShapeEdge_obj::~ShapeEdge_obj() { }

Dynamic ShapeEdge_obj::__CreateEmpty() { return  new ShapeEdge_obj; }
hx::ObjectPtr< ShapeEdge_obj > ShapeEdge_obj::__new()
{  hx::ObjectPtr< ShapeEdge_obj > result = new ShapeEdge_obj();
	result->__construct();
	return result;}

Dynamic ShapeEdge_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ShapeEdge_obj > result = new ShapeEdge_obj();
	result->__construct();
	return result;}

Void ShapeEdge_obj::dump( ){
{
		HX_STACK_PUSH("ShapeEdge::dump","format/swf/symbol/Shape.hx",782);
		HX_STACK_THIS(this);
		HX_STACK_LINE(782)
		::haxe::Log_obj::trace((((((((((this->x0 + HX_CSTRING(",")) + this->y0) + HX_CSTRING(" -> ")) + this->x1) + HX_CSTRING(",")) + this->y1) + HX_CSTRING(" (")) + this->fillStyle) + HX_CSTRING(")")),hx::SourceInfo(HX_CSTRING("Shape.hx"),784,HX_CSTRING("format.swf.symbol.ShapeEdge"),HX_CSTRING("dump")));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ShapeEdge_obj,dump,(void))

bool ShapeEdge_obj::connects( ::format::swf::symbol::ShapeEdge next){
	HX_STACK_PUSH("ShapeEdge::connects","format/swf/symbol/Shape.hx",757);
	HX_STACK_THIS(this);
	HX_STACK_ARG(next,"next");
	HX_STACK_LINE(757)
	return (bool((bool((this->fillStyle == next->fillStyle)) && bool((::Math_obj::abs((this->x1 - next->x0)) < 0.00001)))) && bool((::Math_obj::abs((this->y1 - next->y0)) < 0.00001)));
}


HX_DEFINE_DYNAMIC_FUNC1(ShapeEdge_obj,connects,return )

Dynamic ShapeEdge_obj::asCommand( ){
	HX_STACK_PUSH("ShapeEdge::asCommand","format/swf/symbol/Shape.hx",734);
	HX_STACK_THIS(this);
	HX_STACK_LINE(734)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(736)
	if ((this->isQuadratic)){

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Array< ::Dynamic >,_g)
		Void run(::native::display::Graphics gfx){
			HX_STACK_PUSH("*::_Function_2_1","format/swf/symbol/Shape.hx",738);
			HX_STACK_ARG(gfx,"gfx");
			{
				HX_STACK_LINE(738)
				gfx->curveTo(_g->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >()->cx,_g->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >()->cy,_g->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >()->x1,_g->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >()->y1);
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(736)
		return  Dynamic(new _Function_2_1(_g));
	}
	else{

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Array< ::Dynamic >,_g)
		Void run(::native::display::Graphics gfx){
			HX_STACK_PUSH("*::_Function_2_1","format/swf/symbol/Shape.hx",746);
			HX_STACK_ARG(gfx,"gfx");
			{
				HX_STACK_LINE(746)
				gfx->lineTo(_g->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >()->x1,_g->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >()->y1);
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(744)
		return  Dynamic(new _Function_2_1(_g));
	}
	HX_STACK_LINE(736)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ShapeEdge_obj,asCommand,return )

::format::swf::symbol::ShapeEdge ShapeEdge_obj::curve( int style,Float x0,Float y0,Float cx,Float cy,Float x1,Float y1){
	HX_STACK_PUSH("ShapeEdge::curve","format/swf/symbol/Shape.hx",764);
	HX_STACK_ARG(style,"style");
	HX_STACK_ARG(x0,"x0");
	HX_STACK_ARG(y0,"y0");
	HX_STACK_ARG(cx,"cx");
	HX_STACK_ARG(cy,"cy");
	HX_STACK_ARG(x1,"x1");
	HX_STACK_ARG(y1,"y1");
	HX_STACK_LINE(766)
	::format::swf::symbol::ShapeEdge result = ::format::swf::symbol::ShapeEdge_obj::__new();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(768)
	result->fillStyle = style;
	HX_STACK_LINE(769)
	result->x0 = x0;
	HX_STACK_LINE(770)
	result->y0 = y0;
	HX_STACK_LINE(771)
	result->cx = cx;
	HX_STACK_LINE(772)
	result->cy = cy;
	HX_STACK_LINE(773)
	result->x1 = x1;
	HX_STACK_LINE(774)
	result->y1 = y1;
	HX_STACK_LINE(775)
	result->isQuadratic = true;
	HX_STACK_LINE(777)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(ShapeEdge_obj,curve,return )

::format::swf::symbol::ShapeEdge ShapeEdge_obj::line( int style,Float x0,Float y0,Float x1,Float y1){
	HX_STACK_PUSH("ShapeEdge::line","format/swf/symbol/Shape.hx",789);
	HX_STACK_ARG(style,"style");
	HX_STACK_ARG(x0,"x0");
	HX_STACK_ARG(y0,"y0");
	HX_STACK_ARG(x1,"x1");
	HX_STACK_ARG(y1,"y1");
	HX_STACK_LINE(791)
	::format::swf::symbol::ShapeEdge result = ::format::swf::symbol::ShapeEdge_obj::__new();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(793)
	result->fillStyle = style;
	HX_STACK_LINE(794)
	result->x0 = x0;
	HX_STACK_LINE(795)
	result->y0 = y0;
	HX_STACK_LINE(796)
	result->x1 = x1;
	HX_STACK_LINE(797)
	result->y1 = y1;
	HX_STACK_LINE(798)
	result->isQuadratic = false;
	HX_STACK_LINE(800)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(ShapeEdge_obj,line,return )


ShapeEdge_obj::ShapeEdge_obj()
{
}

void ShapeEdge_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ShapeEdge);
	HX_MARK_MEMBER_NAME(y1,"y1");
	HX_MARK_MEMBER_NAME(y0,"y0");
	HX_MARK_MEMBER_NAME(x1,"x1");
	HX_MARK_MEMBER_NAME(x0,"x0");
	HX_MARK_MEMBER_NAME(cy,"cy");
	HX_MARK_MEMBER_NAME(cx,"cx");
	HX_MARK_MEMBER_NAME(isQuadratic,"isQuadratic");
	HX_MARK_MEMBER_NAME(fillStyle,"fillStyle");
	HX_MARK_END_CLASS();
}

void ShapeEdge_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(y1,"y1");
	HX_VISIT_MEMBER_NAME(y0,"y0");
	HX_VISIT_MEMBER_NAME(x1,"x1");
	HX_VISIT_MEMBER_NAME(x0,"x0");
	HX_VISIT_MEMBER_NAME(cy,"cy");
	HX_VISIT_MEMBER_NAME(cx,"cx");
	HX_VISIT_MEMBER_NAME(isQuadratic,"isQuadratic");
	HX_VISIT_MEMBER_NAME(fillStyle,"fillStyle");
}

Dynamic ShapeEdge_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"y1") ) { return y1; }
		if (HX_FIELD_EQ(inName,"y0") ) { return y0; }
		if (HX_FIELD_EQ(inName,"x1") ) { return x1; }
		if (HX_FIELD_EQ(inName,"x0") ) { return x0; }
		if (HX_FIELD_EQ(inName,"cy") ) { return cy; }
		if (HX_FIELD_EQ(inName,"cx") ) { return cx; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"line") ) { return line_dyn(); }
		if (HX_FIELD_EQ(inName,"dump") ) { return dump_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"curve") ) { return curve_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"connects") ) { return connects_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"asCommand") ) { return asCommand_dyn(); }
		if (HX_FIELD_EQ(inName,"fillStyle") ) { return fillStyle; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isQuadratic") ) { return isQuadratic; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ShapeEdge_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"y1") ) { y1=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y0") ) { y0=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"x1") ) { x1=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"x0") ) { x0=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"cy") ) { cy=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"cx") ) { cx=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fillStyle") ) { fillStyle=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isQuadratic") ) { isQuadratic=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ShapeEdge_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("y1"));
	outFields->push(HX_CSTRING("y0"));
	outFields->push(HX_CSTRING("x1"));
	outFields->push(HX_CSTRING("x0"));
	outFields->push(HX_CSTRING("cy"));
	outFields->push(HX_CSTRING("cx"));
	outFields->push(HX_CSTRING("isQuadratic"));
	outFields->push(HX_CSTRING("fillStyle"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("curve"),
	HX_CSTRING("line"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("dump"),
	HX_CSTRING("connects"),
	HX_CSTRING("asCommand"),
	HX_CSTRING("y1"),
	HX_CSTRING("y0"),
	HX_CSTRING("x1"),
	HX_CSTRING("x0"),
	HX_CSTRING("cy"),
	HX_CSTRING("cx"),
	HX_CSTRING("isQuadratic"),
	HX_CSTRING("fillStyle"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ShapeEdge_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ShapeEdge_obj::__mClass,"__mClass");
};

Class ShapeEdge_obj::__mClass;

void ShapeEdge_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.ShapeEdge"), hx::TCanCast< ShapeEdge_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void ShapeEdge_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
