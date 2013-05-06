#include <hxcpp.h>

#ifndef INCLUDED_format_SWF
#include <format/SWF.h>
#endif
#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Font
#include <format/swf/symbol/Font.h>
#endif
#ifndef INCLUDED_format_swf_symbol_StaticText
#include <format/swf/symbol/StaticText.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
#endif
#ifndef INCLUDED_native_display_CapsStyle
#include <native/display/CapsStyle.h>
#endif
#ifndef INCLUDED_native_display_Graphics
#include <native/display/Graphics.h>
#endif
#ifndef INCLUDED_native_display_JointStyle
#include <native/display/JointStyle.h>
#endif
#ifndef INCLUDED_native_display_LineScaleMode
#include <native/display/LineScaleMode.h>
#endif
#ifndef INCLUDED_native_geom_Matrix
#include <native/geom/Matrix.h>
#endif
#ifndef INCLUDED_native_geom_Rectangle
#include <native/geom/Rectangle.h>
#endif
namespace format{
namespace swf{
namespace symbol{

Void StaticText_obj::__construct(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{
HX_STACK_PUSH("StaticText::new","format/swf/symbol/StaticText.hx",20);
{
	HX_STACK_LINE(22)
	stream->alignBits();
	HX_STACK_LINE(24)
	this->records = Dynamic( Array_obj<Dynamic>::__new() );
	HX_STACK_LINE(25)
	this->bounds = stream->readRect();
	HX_STACK_LINE(26)
	this->textMatrix = stream->readMatrix();
	HX_STACK_LINE(28)
	int glyphBits = stream->readByte();		HX_STACK_VAR(glyphBits,"glyphBits");
	HX_STACK_LINE(29)
	int advanceBits = stream->readByte();		HX_STACK_VAR(advanceBits,"advanceBits");
	HX_STACK_LINE(30)
	::format::swf::symbol::Font font = null();		HX_STACK_VAR(font,"font");
	HX_STACK_LINE(31)
	Float height = 32.0;		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(32)
	int color = (int)0;		HX_STACK_VAR(color,"color");
	HX_STACK_LINE(33)
	Float alpha = 1.0;		HX_STACK_VAR(alpha,"alpha");
	HX_STACK_LINE(35)
	stream->alignBits();
	HX_STACK_LINE(37)
	int offsetY = (int)0;		HX_STACK_VAR(offsetY,"offsetY");
	HX_STACK_LINE(39)
	while((stream->readBool())){
		HX_STACK_LINE(41)
		stream->readBits((int)3,null());
		HX_STACK_LINE(43)
		bool hasFont = stream->readBool();		HX_STACK_VAR(hasFont,"hasFont");
		HX_STACK_LINE(44)
		bool hasColor = stream->readBool();		HX_STACK_VAR(hasColor,"hasColor");
		HX_STACK_LINE(45)
		bool hasY = stream->readBool();		HX_STACK_VAR(hasY,"hasY");
		HX_STACK_LINE(46)
		bool hasX = stream->readBool();		HX_STACK_VAR(hasX,"hasX");
		HX_STACK_LINE(48)
		if ((hasFont)){
			HX_STACK_LINE(50)
			int fontID = stream->readID();		HX_STACK_VAR(fontID,"fontID");
			HX_STACK_LINE(51)
			::format::swf::symbol::Symbol symbol = swf->getSymbol(fontID);		HX_STACK_VAR(symbol,"symbol");
			HX_STACK_LINE(53)
			{
				::format::swf::symbol::Symbol _switch_1 = (symbol);
				switch((_switch_1)->GetIndex()){
					case 4: {
						::format::swf::symbol::Font symbol_efontSymbol_0 = _switch_1->__Param(0);
{
							HX_STACK_LINE(55)
							font = symbol_efontSymbol_0;
						}
					}
					;break;
					default: {
						HX_STACK_LINE(59)
						hx::Throw (HX_CSTRING("Not font character"));
					}
				}
			}
		}
		else{
			HX_STACK_LINE(65)
			if (((font == null()))){
				HX_STACK_LINE(65)
				hx::Throw (HX_CSTRING("No font - not implemented"));
			}
		}
		HX_STACK_LINE(71)
		if ((hasColor)){
			HX_STACK_LINE(73)
			color = stream->readRGB();
			HX_STACK_LINE(75)
			if (((version >= (int)2))){
				HX_STACK_LINE(75)
				alpha = (Float(stream->readByte()) / Float(255.0));
			}
		}
		HX_STACK_LINE(83)
		int offsetX = (  ((hasX)) ? int(stream->readSInt16()) : int((int)0) );		HX_STACK_VAR(offsetX,"offsetX");
		HX_STACK_LINE(84)
		int offsetY1 = (  ((hasY)) ? int(stream->readSInt16()) : int((int)0) );		HX_STACK_VAR(offsetY1,"offsetY1");
		HX_STACK_LINE(86)
		if ((hasFont)){
			HX_STACK_LINE(86)
			height = (stream->readUInt16() * 0.05);
		}
		HX_STACK_LINE(92)
		int count = stream->readByte();		HX_STACK_VAR(count,"count");
		HX_STACK_LINE(93)
		Array< int > glyphs = Array_obj< int >::__new();		HX_STACK_VAR(glyphs,"glyphs");
		HX_STACK_LINE(94)
		Array< int > advances = Array_obj< int >::__new();		HX_STACK_VAR(advances,"advances");
		HX_STACK_LINE(96)
		{
			HX_STACK_LINE(96)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(96)
			while(((_g < count))){
				HX_STACK_LINE(96)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(98)
				glyphs->push(stream->readBits(glyphBits,null()));
				HX_STACK_LINE(99)
				advances->push(stream->readBits(advanceBits,true));
			}
		}
		struct _Function_2_1{
			inline static Dynamic Block( int &offsetX,int &color,bool &hasY,Array< int > &glyphs,Float &alpha,bool &hasFont,bool &hasX,Float &height,Array< int > &advances,bool &hasColor,::format::swf::symbol::Font &font,int &offsetY1){
				HX_STACK_PUSH("*::closure","format/swf/symbol/StaticText.hx",103);
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("setStyle") , (bool(hasColor) || bool(hasFont)),false);
					__result->Add(HX_CSTRING("setPosition") , (bool(hasX) && bool(hasY)),false);
					__result->Add(HX_CSTRING("swfFont") , font,false);
					__result->Add(HX_CSTRING("offsetX") , offsetX,false);
					__result->Add(HX_CSTRING("offsetY") , offsetY1,false);
					__result->Add(HX_CSTRING("glyphs") , glyphs,false);
					__result->Add(HX_CSTRING("color") , color,false);
					__result->Add(HX_CSTRING("alpha") , alpha,false);
					__result->Add(HX_CSTRING("height") , height,false);
					__result->Add(HX_CSTRING("advances") , advances,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(103)
		this->records->__Field(HX_CSTRING("push"),true)(_Function_2_1::Block(offsetX,color,hasY,glyphs,alpha,hasFont,hasX,height,advances,hasColor,font,offsetY1));
		HX_STACK_LINE(118)
		stream->alignBits();
	}
}
;
	return null();
}

StaticText_obj::~StaticText_obj() { }

Dynamic StaticText_obj::__CreateEmpty() { return  new StaticText_obj; }
hx::ObjectPtr< StaticText_obj > StaticText_obj::__new(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{  hx::ObjectPtr< StaticText_obj > result = new StaticText_obj();
	result->__construct(swf,stream,version);
	return result;}

Dynamic StaticText_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< StaticText_obj > result = new StaticText_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void StaticText_obj::render( ::native::display::Graphics graphics){
{
		HX_STACK_PUSH("StaticText::render","format/swf/symbol/StaticText.hx",125);
		HX_STACK_THIS(this);
		HX_STACK_ARG(graphics,"graphics");
		HX_STACK_LINE(127)
		::native::geom::Matrix matrix = null();		HX_STACK_VAR(matrix,"matrix");
		HX_STACK_LINE(128)
		::native::geom::Matrix cacheMatrix = null();		HX_STACK_VAR(cacheMatrix,"cacheMatrix");
		HX_STACK_LINE(130)
		{
			HX_STACK_LINE(130)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			Dynamic _g1 = this->records;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(130)
			while(((_g < _g1->__Field(HX_CSTRING("length"),true)))){
				HX_STACK_LINE(130)
				Dynamic record = _g1->__GetItem(_g);		HX_STACK_VAR(record,"record");
				HX_STACK_LINE(130)
				++(_g);
				HX_STACK_LINE(132)
				Float scale = (Float(record->__Field(HX_CSTRING("height"),true)) / Float((int)1024));		HX_STACK_VAR(scale,"scale");
				HX_STACK_LINE(134)
				cacheMatrix = matrix;
				HX_STACK_LINE(135)
				matrix = this->textMatrix->clone();
				HX_STACK_LINE(136)
				matrix->scale(scale,scale);
				HX_STACK_LINE(138)
				if (((bool((bool((cacheMatrix != null())) && bool(record->__Field(HX_CSTRING("setStyle"),true)))) && bool(!(record->__Field(HX_CSTRING("setPosition"),true)))))){
					HX_STACK_LINE(140)
					matrix->tx = cacheMatrix->tx;
					HX_STACK_LINE(141)
					matrix->ty = cacheMatrix->ty;
				}
				else{
					HX_STACK_LINE(145)
					matrix->tx = (this->textMatrix->tx + (record->__Field(HX_CSTRING("offsetX"),true) * 0.05));
					HX_STACK_LINE(146)
					matrix->ty = (this->textMatrix->ty + (record->__Field(HX_CSTRING("offsetY"),true) * 0.05));
				}
				HX_STACK_LINE(150)
				graphics->lineStyle(null(),null(),null(),null(),null(),null(),null(),null());
				HX_STACK_LINE(152)
				{
					HX_STACK_LINE(152)
					int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
					int _g2 = record->__Field(HX_CSTRING("glyphs"),true)->__Field(HX_CSTRING("length"),true);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(152)
					while(((_g3 < _g2))){
						HX_STACK_LINE(152)
						int i = (_g3)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(154)
						graphics->beginFill(record->__Field(HX_CSTRING("color"),true),record->__Field(HX_CSTRING("alpha"),true));
						HX_STACK_LINE(155)
						record->__Field(HX_CSTRING("swfFont"),true)->__Field(HX_CSTRING("renderGlyph"),true)(graphics,record->__Field(HX_CSTRING("glyphs"),true)->__GetItem(i),matrix);
						HX_STACK_LINE(156)
						graphics->endFill();
						HX_STACK_LINE(158)
						hx::AddEq(matrix->tx,(record->__Field(HX_CSTRING("advances"),true)->__GetItem(i) * 0.05));
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(StaticText_obj,render,(void))


StaticText_obj::StaticText_obj()
{
}

void StaticText_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(StaticText);
	HX_MARK_MEMBER_NAME(textMatrix,"textMatrix");
	HX_MARK_MEMBER_NAME(records,"records");
	HX_MARK_MEMBER_NAME(bounds,"bounds");
	HX_MARK_END_CLASS();
}

void StaticText_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(textMatrix,"textMatrix");
	HX_VISIT_MEMBER_NAME(records,"records");
	HX_VISIT_MEMBER_NAME(bounds,"bounds");
}

Dynamic StaticText_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		if (HX_FIELD_EQ(inName,"bounds") ) { return bounds; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"records") ) { return records; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"textMatrix") ) { return textMatrix; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic StaticText_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"bounds") ) { bounds=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"records") ) { records=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"textMatrix") ) { textMatrix=inValue.Cast< ::native::geom::Matrix >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void StaticText_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("textMatrix"));
	outFields->push(HX_CSTRING("records"));
	outFields->push(HX_CSTRING("bounds"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("render"),
	HX_CSTRING("textMatrix"),
	HX_CSTRING("records"),
	HX_CSTRING("bounds"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StaticText_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StaticText_obj::__mClass,"__mClass");
};

Class StaticText_obj::__mClass;

void StaticText_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.StaticText"), hx::TCanCast< StaticText_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void StaticText_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
