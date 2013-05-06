#include <hxcpp.h>

#ifndef INCLUDED_format_swf_symbol_Bitmap
#include <format/swf/symbol/Bitmap.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Button
#include <format/swf/symbol/Button.h>
#endif
#ifndef INCLUDED_format_swf_symbol_EditText
#include <format/swf/symbol/EditText.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Font
#include <format/swf/symbol/Font.h>
#endif
#ifndef INCLUDED_format_swf_symbol_MorphShape
#include <format/swf/symbol/MorphShape.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Shape
#include <format/swf/symbol/Shape.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Sprite
#include <format/swf/symbol/Sprite.h>
#endif
#ifndef INCLUDED_format_swf_symbol_StaticText
#include <format/swf/symbol/StaticText.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
#endif
namespace format{
namespace swf{
namespace symbol{

::format::swf::symbol::Symbol  Symbol_obj::bitmapSymbol(::format::swf::symbol::Bitmap data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("bitmapSymbol"),3,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::buttonSymbol(::format::swf::symbol::Button data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("buttonSymbol"),7,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::editTextSymbol(::format::swf::symbol::EditText data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("editTextSymbol"),6,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::fontSymbol(::format::swf::symbol::Font data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("fontSymbol"),4,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::morphShapeSymbol(::format::swf::symbol::MorphShape data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("morphShapeSymbol"),1,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::shapeSymbol(::format::swf::symbol::Shape data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("shapeSymbol"),0,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::spriteSymbol(::format::swf::symbol::Sprite data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("spriteSymbol"),2,hx::DynamicArray(0,1).Add(data)); }

::format::swf::symbol::Symbol  Symbol_obj::staticTextSymbol(::format::swf::symbol::StaticText data)
	{ return hx::CreateEnum< Symbol_obj >(HX_CSTRING("staticTextSymbol"),5,hx::DynamicArray(0,1).Add(data)); }

HX_DEFINE_CREATE_ENUM(Symbol_obj)

int Symbol_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("bitmapSymbol")) return 3;
	if (inName==HX_CSTRING("buttonSymbol")) return 7;
	if (inName==HX_CSTRING("editTextSymbol")) return 6;
	if (inName==HX_CSTRING("fontSymbol")) return 4;
	if (inName==HX_CSTRING("morphShapeSymbol")) return 1;
	if (inName==HX_CSTRING("shapeSymbol")) return 0;
	if (inName==HX_CSTRING("spriteSymbol")) return 2;
	if (inName==HX_CSTRING("staticTextSymbol")) return 5;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,bitmapSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,buttonSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,editTextSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,fontSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,morphShapeSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,shapeSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,spriteSymbol,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Symbol_obj,staticTextSymbol,return)

int Symbol_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("bitmapSymbol")) return 1;
	if (inName==HX_CSTRING("buttonSymbol")) return 1;
	if (inName==HX_CSTRING("editTextSymbol")) return 1;
	if (inName==HX_CSTRING("fontSymbol")) return 1;
	if (inName==HX_CSTRING("morphShapeSymbol")) return 1;
	if (inName==HX_CSTRING("shapeSymbol")) return 1;
	if (inName==HX_CSTRING("spriteSymbol")) return 1;
	if (inName==HX_CSTRING("staticTextSymbol")) return 1;
	return super::__FindArgCount(inName);
}

Dynamic Symbol_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("bitmapSymbol")) return bitmapSymbol_dyn();
	if (inName==HX_CSTRING("buttonSymbol")) return buttonSymbol_dyn();
	if (inName==HX_CSTRING("editTextSymbol")) return editTextSymbol_dyn();
	if (inName==HX_CSTRING("fontSymbol")) return fontSymbol_dyn();
	if (inName==HX_CSTRING("morphShapeSymbol")) return morphShapeSymbol_dyn();
	if (inName==HX_CSTRING("shapeSymbol")) return shapeSymbol_dyn();
	if (inName==HX_CSTRING("spriteSymbol")) return spriteSymbol_dyn();
	if (inName==HX_CSTRING("staticTextSymbol")) return staticTextSymbol_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("shapeSymbol"),
	HX_CSTRING("morphShapeSymbol"),
	HX_CSTRING("spriteSymbol"),
	HX_CSTRING("bitmapSymbol"),
	HX_CSTRING("fontSymbol"),
	HX_CSTRING("staticTextSymbol"),
	HX_CSTRING("editTextSymbol"),
	HX_CSTRING("buttonSymbol"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Symbol_obj::__mClass,"__mClass");
};

static ::String sMemberFields[] = { ::String(null()) };
Class Symbol_obj::__mClass;

Dynamic __Create_Symbol_obj() { return new Symbol_obj; }

void Symbol_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.Symbol"), hx::TCanCast< Symbol_obj >,sStaticFields,sMemberFields,
	&__Create_Symbol_obj, &__Create,
	&super::__SGetClass(), &CreateSymbol_obj, sMarkStatics, sVisitStatic);
}

void Symbol_obj::__boot()
{
}


} // end namespace format
} // end namespace swf
} // end namespace symbol
