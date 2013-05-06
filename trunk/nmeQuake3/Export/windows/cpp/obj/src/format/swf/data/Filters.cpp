#include <hxcpp.h>

#ifndef INCLUDED_format_swf_data_Filters
#include <format/swf/data/Filters.h>
#endif
#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_native_filters_BitmapFilter
#include <native/filters/BitmapFilter.h>
#endif
#ifndef INCLUDED_native_filters_BlurFilter
#include <native/filters/BlurFilter.h>
#endif
#ifndef INCLUDED_native_filters_DropShadowFilter
#include <native/filters/DropShadowFilter.h>
#endif
#ifndef INCLUDED_native_filters_GlowFilter
#include <native/filters/GlowFilter.h>
#endif
namespace format{
namespace swf{
namespace data{

Void Filters_obj::__construct()
{
	return null();
}

Filters_obj::~Filters_obj() { }

Dynamic Filters_obj::__CreateEmpty() { return  new Filters_obj; }
hx::ObjectPtr< Filters_obj > Filters_obj::__new()
{  hx::ObjectPtr< Filters_obj > result = new Filters_obj();
	result->__construct();
	return result;}

Dynamic Filters_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Filters_obj > result = new Filters_obj();
	result->__construct();
	return result;}

Array< ::Dynamic > Filters_obj::readFilters( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::readFilters","format/swf/data/Filters.hx",23);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(25)
	int count = stream->readByte();		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(26)
	Array< ::Dynamic > filters = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(filters,"filters");
	HX_STACK_LINE(28)
	{
		HX_STACK_LINE(28)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(28)
		while(((_g < count))){
			HX_STACK_LINE(28)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(30)
			int filterID = stream->readByte();		HX_STACK_VAR(filterID,"filterID");
			struct _Function_3_1{
				inline static ::native::filters::BitmapFilter Block( int &filterID,::format::swf::data::SWFStream &stream,int &count,int &i){
					HX_STACK_PUSH("*::closure","format/swf/data/Filters.hx",34);
					{
						HX_STACK_LINE(34)
						switch( (int)(filterID)){
							case (int)0: {
								HX_STACK_LINE(35)
								return ::format::swf::data::Filters_obj::createDropShadowFilter(stream);
							}
							;break;
							case (int)1: {
								HX_STACK_LINE(36)
								return ::format::swf::data::Filters_obj::createBlurFilter(stream);
							}
							;break;
							case (int)2: {
								HX_STACK_LINE(37)
								return ::format::swf::data::Filters_obj::createGlowFilter(stream);
							}
							;break;
							case (int)3: {
								HX_STACK_LINE(38)
								return ::format::swf::data::Filters_obj::createBevelFilter(stream);
							}
							;break;
							case (int)4: {
								HX_STACK_LINE(39)
								return ::format::swf::data::Filters_obj::createGradientGlowFilter(stream);
							}
							;break;
							case (int)5: {
								HX_STACK_LINE(40)
								return ::format::swf::data::Filters_obj::createConvolutionFilter(stream);
							}
							;break;
							case (int)6: {
								HX_STACK_LINE(41)
								return ::format::swf::data::Filters_obj::createColorMatrixFilter(stream);
							}
							;break;
							case (int)7: {
								HX_STACK_LINE(42)
								return ::format::swf::data::Filters_obj::createGradientBevelFilter(stream);
							}
							;break;
							default: {
								HX_STACK_LINE(43)
								return hx::Throw ((((((HX_CSTRING("Unknown filter : ") + filterID) + HX_CSTRING("  ")) + i) + HX_CSTRING("/")) + count));
							}
						}
					}
					return null();
				}
			};
			HX_STACK_LINE(32)
			filters->push(_Function_3_1::Block(filterID,stream,count,i));
		}
	}
	HX_STACK_LINE(50)
	return filters;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,readFilters,return )

::native::filters::BitmapFilter Filters_obj::createBevelFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createBevelFilter","format/swf/data/Filters.hx",55);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(57)
	int shadowColor = stream->readRGB();		HX_STACK_VAR(shadowColor,"shadowColor");
	HX_STACK_LINE(58)
	Float shadowAlpha = (Float(stream->readByte()) / Float(255.0));		HX_STACK_VAR(shadowAlpha,"shadowAlpha");
	HX_STACK_LINE(60)
	int highlightColor = stream->readRGB();		HX_STACK_VAR(highlightColor,"highlightColor");
	HX_STACK_LINE(61)
	Float highlightAlpha = (Float(stream->readByte()) / Float(255.0));		HX_STACK_VAR(highlightAlpha,"highlightAlpha");
	HX_STACK_LINE(63)
	Float blurX = stream->readFixed();		HX_STACK_VAR(blurX,"blurX");
	HX_STACK_LINE(64)
	Float blurY = stream->readFixed();		HX_STACK_VAR(blurY,"blurY");
	HX_STACK_LINE(65)
	Float angle = stream->readFixed();		HX_STACK_VAR(angle,"angle");
	HX_STACK_LINE(66)
	Float distance = stream->readFixed();		HX_STACK_VAR(distance,"distance");
	HX_STACK_LINE(68)
	Float strength = stream->readFixed8();		HX_STACK_VAR(strength,"strength");
	HX_STACK_LINE(70)
	bool innerShadow = stream->readBool();		HX_STACK_VAR(innerShadow,"innerShadow");
	HX_STACK_LINE(71)
	bool knockout = stream->readBool();		HX_STACK_VAR(knockout,"knockout");
	HX_STACK_LINE(72)
	bool compositeSource = stream->readBool();		HX_STACK_VAR(compositeSource,"compositeSource");
	HX_STACK_LINE(73)
	bool onTop = stream->readBool();		HX_STACK_VAR(onTop,"onTop");
	HX_STACK_LINE(75)
	int passes = stream->readBits((int)4,null());		HX_STACK_VAR(passes,"passes");
	HX_STACK_LINE(99)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createBevelFilter,return )

::native::filters::BitmapFilter Filters_obj::createBlurFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createBlurFilter","format/swf/data/Filters.hx",104);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(106)
	Float blurX = stream->readFixed();		HX_STACK_VAR(blurX,"blurX");
	HX_STACK_LINE(107)
	Float blurY = stream->readFixed();		HX_STACK_VAR(blurY,"blurY");
	HX_STACK_LINE(109)
	int passes = stream->readBits((int)5,null());		HX_STACK_VAR(passes,"passes");
	HX_STACK_LINE(110)
	int reserved = stream->readBits((int)3,null());		HX_STACK_VAR(reserved,"reserved");
	HX_STACK_LINE(112)
	return ::native::filters::BlurFilter_obj::__new(blurX,blurY,passes);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createBlurFilter,return )

::native::filters::BitmapFilter Filters_obj::createColorMatrixFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createColorMatrixFilter","format/swf/data/Filters.hx",117);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(119)
	Array< Float > matrix = Array_obj< Float >::__new();		HX_STACK_VAR(matrix,"matrix");
	HX_STACK_LINE(121)
	{
		HX_STACK_LINE(121)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(121)
		while(((_g < (int)20))){
			HX_STACK_LINE(121)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(123)
			matrix->push(stream->readFloat());
		}
	}
	HX_STACK_LINE(133)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createColorMatrixFilter,return )

::native::filters::BitmapFilter Filters_obj::createConvolutionFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createConvolutionFilter","format/swf/data/Filters.hx",138);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(140)
	int width = stream->readByte();		HX_STACK_VAR(width,"width");
	HX_STACK_LINE(141)
	int height = stream->readByte();		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(143)
	Float divisor = stream->readFloat();		HX_STACK_VAR(divisor,"divisor");
	HX_STACK_LINE(144)
	Float bias = stream->readFloat();		HX_STACK_VAR(bias,"bias");
	HX_STACK_LINE(146)
	Array< Float > matrix = Array_obj< Float >::__new();		HX_STACK_VAR(matrix,"matrix");
	HX_STACK_LINE(148)
	{
		HX_STACK_LINE(148)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		int _g = (width * height);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(148)
		while(((_g1 < _g))){
			HX_STACK_LINE(148)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(150)
			matrix[i] = stream->readFloat();
		}
	}
	HX_STACK_LINE(154)
	int defaultColor = stream->readRGB();		HX_STACK_VAR(defaultColor,"defaultColor");
	HX_STACK_LINE(155)
	Float defaultAlpha = (Float(stream->readByte()) / Float(255.0));		HX_STACK_VAR(defaultAlpha,"defaultAlpha");
	HX_STACK_LINE(157)
	int reserved = stream->readBits((int)6,null());		HX_STACK_VAR(reserved,"reserved");
	HX_STACK_LINE(159)
	bool clamp = stream->readBool();		HX_STACK_VAR(clamp,"clamp");
	HX_STACK_LINE(160)
	bool preserveAlpha = stream->readBool();		HX_STACK_VAR(preserveAlpha,"preserveAlpha");
	HX_STACK_LINE(168)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createConvolutionFilter,return )

::native::filters::BitmapFilter Filters_obj::createDropShadowFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createDropShadowFilter","format/swf/data/Filters.hx",173);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(175)
	int color = stream->readRGB();		HX_STACK_VAR(color,"color");
	HX_STACK_LINE(176)
	Float alpha = (Float(stream->readByte()) / Float(255.0));		HX_STACK_VAR(alpha,"alpha");
	HX_STACK_LINE(178)
	Float blurX = stream->readFixed();		HX_STACK_VAR(blurX,"blurX");
	HX_STACK_LINE(179)
	Float blurY = stream->readFixed();		HX_STACK_VAR(blurY,"blurY");
	HX_STACK_LINE(180)
	Float angle = (stream->readFixed() * ((Float((int)180) / Float(::Math_obj::PI))));		HX_STACK_VAR(angle,"angle");
	HX_STACK_LINE(181)
	Float distance = stream->readFixed();		HX_STACK_VAR(distance,"distance");
	HX_STACK_LINE(183)
	Float strength = stream->readFixed8();		HX_STACK_VAR(strength,"strength");
	HX_STACK_LINE(185)
	bool innerShadow = stream->readBool();		HX_STACK_VAR(innerShadow,"innerShadow");
	HX_STACK_LINE(186)
	bool knockout = stream->readBool();		HX_STACK_VAR(knockout,"knockout");
	HX_STACK_LINE(187)
	bool compositeSource = stream->readBool();		HX_STACK_VAR(compositeSource,"compositeSource");
	HX_STACK_LINE(189)
	int passes = stream->readBits((int)5,null());		HX_STACK_VAR(passes,"passes");
	HX_STACK_LINE(191)
	return ::native::filters::DropShadowFilter_obj::__new(distance,angle,color,alpha,blurX,blurY,strength,passes,innerShadow,knockout,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createDropShadowFilter,return )

::native::filters::BitmapFilter Filters_obj::createGlowFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createGlowFilter","format/swf/data/Filters.hx",196);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(198)
	int color = stream->readRGB();		HX_STACK_VAR(color,"color");
	HX_STACK_LINE(199)
	Float alpha = (Float(stream->readByte()) / Float(255.0));		HX_STACK_VAR(alpha,"alpha");
	HX_STACK_LINE(201)
	Float blurX = stream->readFixed();		HX_STACK_VAR(blurX,"blurX");
	HX_STACK_LINE(202)
	Float blurY = stream->readFixed();		HX_STACK_VAR(blurY,"blurY");
	HX_STACK_LINE(204)
	Float strength = stream->readFixed8();		HX_STACK_VAR(strength,"strength");
	HX_STACK_LINE(206)
	bool innerGlow = stream->readBool();		HX_STACK_VAR(innerGlow,"innerGlow");
	HX_STACK_LINE(207)
	bool knockout = stream->readBool();		HX_STACK_VAR(knockout,"knockout");
	HX_STACK_LINE(208)
	bool compositeSource = stream->readBool();		HX_STACK_VAR(compositeSource,"compositeSource");
	HX_STACK_LINE(210)
	int passes = stream->readBits((int)5,null());		HX_STACK_VAR(passes,"passes");
	HX_STACK_LINE(212)
	return ::native::filters::GlowFilter_obj::__new(color,alpha,blurX,blurY,strength,passes,innerGlow,knockout);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createGlowFilter,return )

::native::filters::BitmapFilter Filters_obj::createGradientBevelFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createGradientBevelFilter","format/swf/data/Filters.hx",217);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(219)
	int numColors = stream->readByte();		HX_STACK_VAR(numColors,"numColors");
	HX_STACK_LINE(221)
	Array< int > gradientColors = Array_obj< int >::__new();		HX_STACK_VAR(gradientColors,"gradientColors");
	HX_STACK_LINE(222)
	Array< Float > gradientAlpha = Array_obj< Float >::__new();		HX_STACK_VAR(gradientAlpha,"gradientAlpha");
	HX_STACK_LINE(223)
	Array< int > gradientRatio = Array_obj< int >::__new();		HX_STACK_VAR(gradientRatio,"gradientRatio");
	HX_STACK_LINE(225)
	{
		HX_STACK_LINE(225)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(225)
		while(((_g < numColors))){
			HX_STACK_LINE(225)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(227)
			gradientColors->push(stream->readRGB());
			HX_STACK_LINE(228)
			gradientAlpha->push((Float(stream->readByte()) / Float(255.0)));
			HX_STACK_LINE(229)
			gradientRatio->push(stream->readByte());
		}
	}
	HX_STACK_LINE(233)
	Float blurX = stream->readFixed();		HX_STACK_VAR(blurX,"blurX");
	HX_STACK_LINE(234)
	Float blurY = stream->readFixed();		HX_STACK_VAR(blurY,"blurY");
	HX_STACK_LINE(235)
	Float angle = stream->readFixed();		HX_STACK_VAR(angle,"angle");
	HX_STACK_LINE(236)
	Float distance = stream->readFixed();		HX_STACK_VAR(distance,"distance");
	HX_STACK_LINE(238)
	Float strength = stream->readFixed8();		HX_STACK_VAR(strength,"strength");
	HX_STACK_LINE(240)
	bool innerShadow = stream->readBool();		HX_STACK_VAR(innerShadow,"innerShadow");
	HX_STACK_LINE(241)
	bool knockout = stream->readBool();		HX_STACK_VAR(knockout,"knockout");
	HX_STACK_LINE(242)
	bool compositeSource = stream->readBool();		HX_STACK_VAR(compositeSource,"compositeSource");
	HX_STACK_LINE(244)
	bool onTop = stream->readBool();		HX_STACK_VAR(onTop,"onTop");
	HX_STACK_LINE(246)
	int passes = stream->readBits((int)4,null());		HX_STACK_VAR(passes,"passes");
	HX_STACK_LINE(270)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createGradientBevelFilter,return )

::native::filters::BitmapFilter Filters_obj::createGradientGlowFilter( ::format::swf::data::SWFStream stream){
	HX_STACK_PUSH("Filters::createGradientGlowFilter","format/swf/data/Filters.hx",275);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_LINE(277)
	int numColors = stream->readByte();		HX_STACK_VAR(numColors,"numColors");
	HX_STACK_LINE(279)
	Array< int > gradientColors = Array_obj< int >::__new();		HX_STACK_VAR(gradientColors,"gradientColors");
	HX_STACK_LINE(280)
	Array< Float > gradientAlpha = Array_obj< Float >::__new();		HX_STACK_VAR(gradientAlpha,"gradientAlpha");
	HX_STACK_LINE(281)
	Array< int > gradientRatio = Array_obj< int >::__new();		HX_STACK_VAR(gradientRatio,"gradientRatio");
	HX_STACK_LINE(283)
	{
		HX_STACK_LINE(283)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(283)
		while(((_g < numColors))){
			HX_STACK_LINE(283)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(285)
			gradientColors->push(stream->readRGB());
			HX_STACK_LINE(286)
			gradientAlpha->push((Float(stream->readByte()) / Float(255.0)));
			HX_STACK_LINE(287)
			gradientRatio->push(stream->readByte());
		}
	}
	HX_STACK_LINE(291)
	Float blurX = stream->readFixed();		HX_STACK_VAR(blurX,"blurX");
	HX_STACK_LINE(292)
	Float blurY = stream->readFixed();		HX_STACK_VAR(blurY,"blurY");
	HX_STACK_LINE(293)
	Float angle = stream->readFixed();		HX_STACK_VAR(angle,"angle");
	HX_STACK_LINE(294)
	Float distance = stream->readFixed();		HX_STACK_VAR(distance,"distance");
	HX_STACK_LINE(296)
	Float strength = stream->readFixed8();		HX_STACK_VAR(strength,"strength");
	HX_STACK_LINE(298)
	bool innerShadow = stream->readBool();		HX_STACK_VAR(innerShadow,"innerShadow");
	HX_STACK_LINE(299)
	bool knockout = stream->readBool();		HX_STACK_VAR(knockout,"knockout");
	HX_STACK_LINE(300)
	bool compositeSource = stream->readBool();		HX_STACK_VAR(compositeSource,"compositeSource");
	HX_STACK_LINE(302)
	bool onTop = stream->readBool();		HX_STACK_VAR(onTop,"onTop");
	HX_STACK_LINE(304)
	int passes = stream->readBits((int)4,null());		HX_STACK_VAR(passes,"passes");
	HX_STACK_LINE(328)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Filters_obj,createGradientGlowFilter,return )


Filters_obj::Filters_obj()
{
}

void Filters_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Filters);
	HX_MARK_END_CLASS();
}

void Filters_obj::__Visit(HX_VISIT_PARAMS)
{
}

Dynamic Filters_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 11:
		if (HX_FIELD_EQ(inName,"readFilters") ) { return readFilters_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"createBlurFilter") ) { return createBlurFilter_dyn(); }
		if (HX_FIELD_EQ(inName,"createGlowFilter") ) { return createGlowFilter_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"createBevelFilter") ) { return createBevelFilter_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"createDropShadowFilter") ) { return createDropShadowFilter_dyn(); }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"createColorMatrixFilter") ) { return createColorMatrixFilter_dyn(); }
		if (HX_FIELD_EQ(inName,"createConvolutionFilter") ) { return createConvolutionFilter_dyn(); }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"createGradientGlowFilter") ) { return createGradientGlowFilter_dyn(); }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"createGradientBevelFilter") ) { return createGradientBevelFilter_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Filters_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Filters_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("readFilters"),
	HX_CSTRING("createBevelFilter"),
	HX_CSTRING("createBlurFilter"),
	HX_CSTRING("createColorMatrixFilter"),
	HX_CSTRING("createConvolutionFilter"),
	HX_CSTRING("createDropShadowFilter"),
	HX_CSTRING("createGlowFilter"),
	HX_CSTRING("createGradientBevelFilter"),
	HX_CSTRING("createGradientGlowFilter"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Filters_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Filters_obj::__mClass,"__mClass");
};

Class Filters_obj::__mClass;

void Filters_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.data.Filters"), hx::TCanCast< Filters_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Filters_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace data
