#include <hxcpp.h>

#ifndef INCLUDED_format_SWF
#include <format/SWF.h>
#endif
#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_symbol_EditText
#include <format/swf/symbol/EditText.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Font
#include <format/swf/symbol/Font.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
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
#ifndef INCLUDED_native_events_EventDispatcher
#include <native/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_native_events_IEventDispatcher
#include <native/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_native_geom_Rectangle
#include <native/geom/Rectangle.h>
#endif
#ifndef INCLUDED_native_text_TextField
#include <native/text/TextField.h>
#endif
#ifndef INCLUDED_native_text_TextFieldAutoSize
#include <native/text/TextFieldAutoSize.h>
#endif
#ifndef INCLUDED_native_text_TextFieldType
#include <native/text/TextFieldType.h>
#endif
#ifndef INCLUDED_native_text_TextFormat
#include <native/text/TextFormat.h>
#endif
namespace format{
namespace swf{
namespace symbol{

Void EditText_obj::__construct(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{
HX_STACK_PUSH("EditText::new","format/swf/symbol/EditText.hx",33);
{
	HX_STACK_LINE(35)
	this->textFormat = ::native::text::TextFormat_obj::__new(null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null());
	HX_STACK_LINE(37)
	this->rect = stream->readRect();
	HX_STACK_LINE(39)
	stream->alignBits();
	HX_STACK_LINE(41)
	bool hasText = stream->readBool();		HX_STACK_VAR(hasText,"hasText");
	HX_STACK_LINE(43)
	this->wordWrap = stream->readBool();
	HX_STACK_LINE(44)
	this->multiline = stream->readBool();
	HX_STACK_LINE(45)
	this->displayAsPassword = stream->readBool();
	HX_STACK_LINE(46)
	this->readOnly = stream->readBool();
	HX_STACK_LINE(48)
	bool hasColor = stream->readBool();		HX_STACK_VAR(hasColor,"hasColor");
	HX_STACK_LINE(49)
	bool hasMaxChars = stream->readBool();		HX_STACK_VAR(hasMaxChars,"hasMaxChars");
	HX_STACK_LINE(50)
	bool hasFont = stream->readBool();		HX_STACK_VAR(hasFont,"hasFont");
	HX_STACK_LINE(51)
	bool hasFontClass = stream->readBool();		HX_STACK_VAR(hasFontClass,"hasFontClass");
	HX_STACK_LINE(53)
	this->autoSize = stream->readBool();
	HX_STACK_LINE(55)
	bool hasLayout = stream->readBool();		HX_STACK_VAR(hasLayout,"hasLayout");
	HX_STACK_LINE(57)
	this->noSelect = stream->readBool();
	HX_STACK_LINE(58)
	this->border = stream->readBool();
	HX_STACK_LINE(59)
	this->wasStatic = stream->readBool();
	HX_STACK_LINE(60)
	this->html = stream->readBool();
	HX_STACK_LINE(61)
	this->useOutlines = stream->readBool();
	HX_STACK_LINE(63)
	if ((hasFont)){
		HX_STACK_LINE(65)
		int fontID = stream->readID();		HX_STACK_VAR(fontID,"fontID");
		HX_STACK_LINE(67)
		{
			HX_STACK_LINE(67)
			::format::swf::symbol::Symbol _g = swf->getSymbol(fontID);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(67)
			{
				::format::swf::symbol::Symbol _switch_1 = (_g);
				switch((_switch_1)->GetIndex()){
					case 4: {
						::format::swf::symbol::Font _g_efontSymbol_0 = _switch_1->__Param(0);
{
							HX_STACK_LINE(69)
							this->textFormat->font = _g_efontSymbol_0->getFontName();
						}
					}
					;break;
					default: {
						HX_STACK_LINE(73)
						hx::Throw (HX_CSTRING("Specified font is incorrect type"));
					}
				}
			}
		}
		HX_STACK_LINE(79)
		this->textFormat->size = stream->readUTwips();
	}
	else{
		HX_STACK_LINE(81)
		if ((hasFontClass)){
			HX_STACK_LINE(83)
			::String fontName = stream->readString();		HX_STACK_VAR(fontName,"fontName");
			HX_STACK_LINE(84)
			hx::Throw ((HX_CSTRING("Can't reference external font: ") + fontName));
		}
	}
	HX_STACK_LINE(88)
	if ((hasColor)){
		HX_STACK_LINE(90)
		this->textFormat->color = stream->readRGB();
		HX_STACK_LINE(91)
		this->alpha = (Float(stream->readByte()) / Float(255.0));
	}
	HX_STACK_LINE(95)
	if ((hasMaxChars)){
		HX_STACK_LINE(95)
		this->maxChars = stream->readUInt16();
	}
	else{
		HX_STACK_LINE(99)
		this->maxChars = (int)0;
	}
	HX_STACK_LINE(105)
	if ((hasLayout)){
		HX_STACK_LINE(107)
		this->textFormat->align = stream->readAlign();
		HX_STACK_LINE(108)
		this->textFormat->leftMargin = stream->readUTwips();
		HX_STACK_LINE(109)
		this->textFormat->rightMargin = stream->readUTwips();
		HX_STACK_LINE(110)
		this->textFormat->indent = stream->readUTwips();
		HX_STACK_LINE(111)
		this->textFormat->leading = stream->readSTwips();
	}
	HX_STACK_LINE(115)
	::String variableName = stream->readString();		HX_STACK_VAR(variableName,"variableName");
	HX_STACK_LINE(117)
	if ((hasText)){
		HX_STACK_LINE(117)
		this->text = stream->readString();
	}
	else{
		HX_STACK_LINE(121)
		this->text = HX_CSTRING("");
	}
}
;
	return null();
}

EditText_obj::~EditText_obj() { }

Dynamic EditText_obj::__CreateEmpty() { return  new EditText_obj; }
hx::ObjectPtr< EditText_obj > EditText_obj::__new(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{  hx::ObjectPtr< EditText_obj > result = new EditText_obj();
	result->__construct(swf,stream,version);
	return result;}

Dynamic EditText_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EditText_obj > result = new EditText_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void EditText_obj::apply( ::native::text::TextField textField){
{
		HX_STACK_PUSH("EditText::apply","format/swf/symbol/EditText.hx",130);
		HX_STACK_THIS(this);
		HX_STACK_ARG(textField,"textField");
		HX_STACK_LINE(132)
		textField->set_wordWrap(this->wordWrap);
		HX_STACK_LINE(133)
		textField->set_multiline(this->multiline);
		HX_STACK_LINE(134)
		textField->set_width(this->rect->width);
		HX_STACK_LINE(135)
		textField->set_height(this->rect->height);
		HX_STACK_LINE(136)
		textField->set_displayAsPassword(this->displayAsPassword);
		HX_STACK_LINE(138)
		if (((this->maxChars > (int)0))){
			HX_STACK_LINE(138)
			textField->set_maxChars(this->maxChars);
		}
		HX_STACK_LINE(144)
		textField->set_border(this->border);
		HX_STACK_LINE(145)
		textField->set_borderColor((int)0);
		HX_STACK_LINE(147)
		if ((this->readOnly)){
			HX_STACK_LINE(147)
			textField->set_type(::native::text::TextFieldType_obj::DYNAMIC);
		}
		else{
			HX_STACK_LINE(151)
			textField->set_type(::native::text::TextFieldType_obj::INPUT);
		}
		HX_STACK_LINE(157)
		if ((this->autoSize)){
			HX_STACK_LINE(157)
			textField->set_autoSize(::native::text::TextFieldAutoSize_obj::CENTER);
		}
		else{
			HX_STACK_LINE(161)
			textField->set_autoSize(::native::text::TextFieldAutoSize_obj::NONE);
		}
		HX_STACK_LINE(167)
		textField->setTextFormat(this->textFormat,null(),null());
		HX_STACK_LINE(168)
		textField->set_selectable(!(this->noSelect));
		HX_STACK_LINE(172)
		if ((this->html)){
			HX_STACK_LINE(172)
			textField->set_htmlText(this->text);
		}
		else{
			HX_STACK_LINE(176)
			textField->set_text(this->text);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(EditText_obj,apply,(void))


EditText_obj::EditText_obj()
{
}

void EditText_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(EditText);
	HX_MARK_MEMBER_NAME(wordWrap,"wordWrap");
	HX_MARK_MEMBER_NAME(wasStatic,"wasStatic");
	HX_MARK_MEMBER_NAME(useOutlines,"useOutlines");
	HX_MARK_MEMBER_NAME(textFormat,"textFormat");
	HX_MARK_MEMBER_NAME(text,"text");
	HX_MARK_MEMBER_NAME(rect,"rect");
	HX_MARK_MEMBER_NAME(readOnly,"readOnly");
	HX_MARK_MEMBER_NAME(noSelect,"noSelect");
	HX_MARK_MEMBER_NAME(multiline,"multiline");
	HX_MARK_MEMBER_NAME(maxChars,"maxChars");
	HX_MARK_MEMBER_NAME(html,"html");
	HX_MARK_MEMBER_NAME(displayAsPassword,"displayAsPassword");
	HX_MARK_MEMBER_NAME(border,"border");
	HX_MARK_MEMBER_NAME(autoSize,"autoSize");
	HX_MARK_MEMBER_NAME(alpha,"alpha");
	HX_MARK_END_CLASS();
}

void EditText_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(wordWrap,"wordWrap");
	HX_VISIT_MEMBER_NAME(wasStatic,"wasStatic");
	HX_VISIT_MEMBER_NAME(useOutlines,"useOutlines");
	HX_VISIT_MEMBER_NAME(textFormat,"textFormat");
	HX_VISIT_MEMBER_NAME(text,"text");
	HX_VISIT_MEMBER_NAME(rect,"rect");
	HX_VISIT_MEMBER_NAME(readOnly,"readOnly");
	HX_VISIT_MEMBER_NAME(noSelect,"noSelect");
	HX_VISIT_MEMBER_NAME(multiline,"multiline");
	HX_VISIT_MEMBER_NAME(maxChars,"maxChars");
	HX_VISIT_MEMBER_NAME(html,"html");
	HX_VISIT_MEMBER_NAME(displayAsPassword,"displayAsPassword");
	HX_VISIT_MEMBER_NAME(border,"border");
	HX_VISIT_MEMBER_NAME(autoSize,"autoSize");
	HX_VISIT_MEMBER_NAME(alpha,"alpha");
}

Dynamic EditText_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"text") ) { return text; }
		if (HX_FIELD_EQ(inName,"rect") ) { return rect; }
		if (HX_FIELD_EQ(inName,"html") ) { return html; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"apply") ) { return apply_dyn(); }
		if (HX_FIELD_EQ(inName,"alpha") ) { return alpha; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"border") ) { return border; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"wordWrap") ) { return wordWrap; }
		if (HX_FIELD_EQ(inName,"readOnly") ) { return readOnly; }
		if (HX_FIELD_EQ(inName,"noSelect") ) { return noSelect; }
		if (HX_FIELD_EQ(inName,"maxChars") ) { return maxChars; }
		if (HX_FIELD_EQ(inName,"autoSize") ) { return autoSize; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"wasStatic") ) { return wasStatic; }
		if (HX_FIELD_EQ(inName,"multiline") ) { return multiline; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"textFormat") ) { return textFormat; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"useOutlines") ) { return useOutlines; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"displayAsPassword") ) { return displayAsPassword; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EditText_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"text") ) { text=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rect") ) { rect=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		if (HX_FIELD_EQ(inName,"html") ) { html=inValue.Cast< bool >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"alpha") ) { alpha=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"border") ) { border=inValue.Cast< bool >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"wordWrap") ) { wordWrap=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"readOnly") ) { readOnly=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"noSelect") ) { noSelect=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"maxChars") ) { maxChars=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"autoSize") ) { autoSize=inValue.Cast< bool >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"wasStatic") ) { wasStatic=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"multiline") ) { multiline=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"textFormat") ) { textFormat=inValue.Cast< ::native::text::TextFormat >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"useOutlines") ) { useOutlines=inValue.Cast< bool >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"displayAsPassword") ) { displayAsPassword=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void EditText_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("wordWrap"));
	outFields->push(HX_CSTRING("wasStatic"));
	outFields->push(HX_CSTRING("useOutlines"));
	outFields->push(HX_CSTRING("textFormat"));
	outFields->push(HX_CSTRING("text"));
	outFields->push(HX_CSTRING("rect"));
	outFields->push(HX_CSTRING("readOnly"));
	outFields->push(HX_CSTRING("noSelect"));
	outFields->push(HX_CSTRING("multiline"));
	outFields->push(HX_CSTRING("maxChars"));
	outFields->push(HX_CSTRING("html"));
	outFields->push(HX_CSTRING("displayAsPassword"));
	outFields->push(HX_CSTRING("border"));
	outFields->push(HX_CSTRING("autoSize"));
	outFields->push(HX_CSTRING("alpha"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("apply"),
	HX_CSTRING("wordWrap"),
	HX_CSTRING("wasStatic"),
	HX_CSTRING("useOutlines"),
	HX_CSTRING("textFormat"),
	HX_CSTRING("text"),
	HX_CSTRING("rect"),
	HX_CSTRING("readOnly"),
	HX_CSTRING("noSelect"),
	HX_CSTRING("multiline"),
	HX_CSTRING("maxChars"),
	HX_CSTRING("html"),
	HX_CSTRING("displayAsPassword"),
	HX_CSTRING("border"),
	HX_CSTRING("autoSize"),
	HX_CSTRING("alpha"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EditText_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EditText_obj::__mClass,"__mClass");
};

Class EditText_obj::__mClass;

void EditText_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.EditText"), hx::TCanCast< EditText_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void EditText_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
