#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_format_SWF
#include <format/SWF.h>
#endif
#ifndef INCLUDED_format_swf_data_Filters
#include <format/swf/data/Filters.h>
#endif
#ifndef INCLUDED_format_swf_data_Frame
#include <format/swf/data/Frame.h>
#endif
#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Sprite
#include <format/swf/symbol/Sprite.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_native_display_BlendMode
#include <native/display/BlendMode.h>
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
namespace format{
namespace swf{
namespace symbol{

Void Sprite_obj::__construct(::format::SWF swf,int id,int frameCount)
{
HX_STACK_PUSH("Sprite::new","format/swf/symbol/Sprite.hx",37);
{
	HX_STACK_LINE(39)
	this->swf = swf;
	HX_STACK_LINE(40)
	this->frameCount = frameCount;
	HX_STACK_LINE(41)
	this->frames = Array_obj< ::Dynamic >::__new().Add(null());
	HX_STACK_LINE(43)
	this->frame = ::format::swf::data::Frame_obj::__new(null());
	HX_STACK_LINE(44)
	this->frameLabels = ::haxe::ds::StringMap_obj::__new();
	HX_STACK_LINE(45)
	this->name = (HX_CSTRING("Sprite ") + id);
	HX_STACK_LINE(46)
	this->cacheAsBitmap = false;
}
;
	return null();
}

Sprite_obj::~Sprite_obj() { }

Dynamic Sprite_obj::__CreateEmpty() { return  new Sprite_obj; }
hx::ObjectPtr< Sprite_obj > Sprite_obj::__new(::format::SWF swf,int id,int frameCount)
{  hx::ObjectPtr< Sprite_obj > result = new Sprite_obj();
	result->__construct(swf,id,frameCount);
	return result;}

Dynamic Sprite_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Sprite_obj > result = new Sprite_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void Sprite_obj::showFrame( ){
{
		HX_STACK_PUSH("Sprite::showFrame","format/swf/symbol/Sprite.hx",221);
		HX_STACK_THIS(this);
		HX_STACK_LINE(223)
		this->frames->push(this->frame);
		HX_STACK_LINE(224)
		this->frame = ::format::swf::data::Frame_obj::__new(this->frame);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,showFrame,(void))

Void Sprite_obj::removeObject( ::format::swf::data::SWFStream stream,int version){
{
		HX_STACK_PUSH("Sprite::removeObject","format/swf/symbol/Sprite.hx",207);
		HX_STACK_THIS(this);
		HX_STACK_ARG(stream,"stream");
		HX_STACK_ARG(version,"version");
		HX_STACK_LINE(209)
		if (((version == (int)1))){
			HX_STACK_LINE(209)
			stream->readID();
		}
		HX_STACK_LINE(215)
		int depth = stream->readDepth();		HX_STACK_VAR(depth,"depth");
		HX_STACK_LINE(216)
		this->frame->remove(depth);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,removeObject,(void))

Void Sprite_obj::placeObject( ::format::swf::data::SWFStream stream,int version){
{
		HX_STACK_PUSH("Sprite::placeObject","format/swf/symbol/Sprite.hx",58);
		HX_STACK_THIS(this);
		HX_STACK_ARG(stream,"stream");
		HX_STACK_ARG(version,"version");
		HX_STACK_LINE(58)
		if (((version == (int)1))){
			HX_STACK_LINE(62)
			int symbolID = stream->readID();		HX_STACK_VAR(symbolID,"symbolID");
			HX_STACK_LINE(63)
			::format::swf::symbol::Symbol symbol = this->swf->getSymbol(symbolID);		HX_STACK_VAR(symbol,"symbol");
			HX_STACK_LINE(64)
			int depth = stream->readDepth();		HX_STACK_VAR(depth,"depth");
			HX_STACK_LINE(65)
			::native::geom::Matrix matrix = stream->readMatrix();		HX_STACK_VAR(matrix,"matrix");
			HX_STACK_LINE(67)
			::native::geom::ColorTransform colorTransform = null();		HX_STACK_VAR(colorTransform,"colorTransform");
			HX_STACK_LINE(69)
			if (((stream->getBytesLeft() > (int)0))){
				HX_STACK_LINE(69)
				colorTransform = stream->readColorTransform(false);
			}
			HX_STACK_LINE(75)
			this->frame->place(symbolID,symbol,depth,matrix,colorTransform,null(),null(),null());
		}
		else{
			HX_STACK_LINE(77)
			if (((bool((version == (int)2)) || bool((version == (int)3))))){
				HX_STACK_LINE(79)
				stream->alignBits();
				HX_STACK_LINE(81)
				bool hasClipAction = stream->readBool();		HX_STACK_VAR(hasClipAction,"hasClipAction");
				HX_STACK_LINE(82)
				bool hasClipDepth = stream->readBool();		HX_STACK_VAR(hasClipDepth,"hasClipDepth");
				HX_STACK_LINE(83)
				bool hasName = stream->readBool();		HX_STACK_VAR(hasName,"hasName");
				HX_STACK_LINE(84)
				bool hasRatio = stream->readBool();		HX_STACK_VAR(hasRatio,"hasRatio");
				HX_STACK_LINE(85)
				bool hasColorTransform = stream->readBool();		HX_STACK_VAR(hasColorTransform,"hasColorTransform");
				HX_STACK_LINE(86)
				bool hasMatrix = stream->readBool();		HX_STACK_VAR(hasMatrix,"hasMatrix");
				HX_STACK_LINE(87)
				bool hasSymbol = stream->readBool();		HX_STACK_VAR(hasSymbol,"hasSymbol");
				HX_STACK_LINE(88)
				bool move = stream->readBool();		HX_STACK_VAR(move,"move");
				HX_STACK_LINE(90)
				bool hasImage = false;		HX_STACK_VAR(hasImage,"hasImage");
				HX_STACK_LINE(91)
				bool hasClassName = false;		HX_STACK_VAR(hasClassName,"hasClassName");
				HX_STACK_LINE(92)
				bool hasCacheAsBitmap = false;		HX_STACK_VAR(hasCacheAsBitmap,"hasCacheAsBitmap");
				HX_STACK_LINE(93)
				bool hasBlendMode = false;		HX_STACK_VAR(hasBlendMode,"hasBlendMode");
				HX_STACK_LINE(94)
				bool hasFilterList = false;		HX_STACK_VAR(hasFilterList,"hasFilterList");
				HX_STACK_LINE(96)
				if (((version == (int)3))){
					HX_STACK_LINE(98)
					stream->readBool();
					HX_STACK_LINE(99)
					stream->readBool();
					HX_STACK_LINE(100)
					stream->readBool();
					HX_STACK_LINE(102)
					hasImage = stream->readBool();
					HX_STACK_LINE(103)
					hasClassName = stream->readBool();
					HX_STACK_LINE(104)
					hasCacheAsBitmap = stream->readBool();
					HX_STACK_LINE(105)
					hasBlendMode = stream->readBool();
					HX_STACK_LINE(106)
					hasFilterList = stream->readBool();
				}
				HX_STACK_LINE(110)
				int depth = stream->readDepth();		HX_STACK_VAR(depth,"depth");
				HX_STACK_LINE(112)
				if ((hasClassName)){
					HX_STACK_LINE(112)
					this->className = stream->readString();
				}
				HX_STACK_LINE(118)
				int symbolID = (  ((hasSymbol)) ? int(stream->readID()) : int((int)0) );		HX_STACK_VAR(symbolID,"symbolID");
				HX_STACK_LINE(119)
				::native::geom::Matrix matrix = (  ((hasMatrix)) ? ::native::geom::Matrix(stream->readMatrix()) : ::native::geom::Matrix(null()) );		HX_STACK_VAR(matrix,"matrix");
				HX_STACK_LINE(120)
				::native::geom::ColorTransform colorTransform = (  ((hasColorTransform)) ? ::native::geom::ColorTransform(stream->readColorTransform(true)) : ::native::geom::ColorTransform(null()) );		HX_STACK_VAR(colorTransform,"colorTransform");
				HX_STACK_LINE(121)
				Dynamic ratio = (  ((hasRatio)) ? Dynamic(stream->readUInt16()) : Dynamic(null()) );		HX_STACK_VAR(ratio,"ratio");
				HX_STACK_LINE(122)
				::String name = null();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(124)
				if (((bool(hasName) || bool((bool(hasImage) && bool(hasSymbol)))))){
					HX_STACK_LINE(124)
					name = stream->readString();
				}
				HX_STACK_LINE(130)
				int clipDepth = (  ((hasClipDepth)) ? int(stream->readDepth()) : int((int)0) );		HX_STACK_VAR(clipDepth,"clipDepth");
				HX_STACK_LINE(131)
				Array< ::Dynamic > filters = null();		HX_STACK_VAR(filters,"filters");
				HX_STACK_LINE(133)
				if ((hasFilterList)){
					HX_STACK_LINE(133)
					filters = ::format::swf::data::Filters_obj::readFilters(stream);
				}
				HX_STACK_LINE(139)
				if ((hasBlendMode)){
					struct _Function_4_1{
						inline static ::native::display::BlendMode Block( ::format::swf::data::SWFStream &stream){
							HX_STACK_PUSH("*::closure","format/swf/symbol/Sprite.hx",141);
							{
								HX_STACK_LINE(141)
								int _g = stream->readByte();		HX_STACK_VAR(_g,"_g");
								struct _Function_5_1{
									inline static ::native::display::BlendMode Block( int &_g){
										HX_STACK_PUSH("*::closure","format/swf/symbol/Sprite.hx",141);
										{
											HX_STACK_LINE(141)
											switch( (int)(_g)){
												case (int)2: {
													HX_STACK_LINE(142)
													return ::native::display::BlendMode_obj::LAYER;
												}
												;break;
												case (int)3: {
													HX_STACK_LINE(143)
													return ::native::display::BlendMode_obj::MULTIPLY;
												}
												;break;
												case (int)4: {
													HX_STACK_LINE(144)
													return ::native::display::BlendMode_obj::SCREEN;
												}
												;break;
												case (int)5: {
													HX_STACK_LINE(145)
													return ::native::display::BlendMode_obj::LIGHTEN;
												}
												;break;
												case (int)6: {
													HX_STACK_LINE(146)
													return ::native::display::BlendMode_obj::DARKEN;
												}
												;break;
												case (int)7: {
													HX_STACK_LINE(147)
													return ::native::display::BlendMode_obj::DIFFERENCE;
												}
												;break;
												case (int)8: {
													HX_STACK_LINE(148)
													return ::native::display::BlendMode_obj::ADD;
												}
												;break;
												case (int)9: {
													HX_STACK_LINE(149)
													return ::native::display::BlendMode_obj::SUBTRACT;
												}
												;break;
												case (int)10: {
													HX_STACK_LINE(150)
													return ::native::display::BlendMode_obj::INVERT;
												}
												;break;
												case (int)11: {
													HX_STACK_LINE(151)
													return ::native::display::BlendMode_obj::ALPHA;
												}
												;break;
												case (int)12: {
													HX_STACK_LINE(152)
													return ::native::display::BlendMode_obj::ERASE;
												}
												;break;
												case (int)13: {
													HX_STACK_LINE(153)
													return ::native::display::BlendMode_obj::OVERLAY;
												}
												;break;
												case (int)14: {
													HX_STACK_LINE(154)
													return ::native::display::BlendMode_obj::HARDLIGHT;
												}
												;break;
												default: {
													HX_STACK_LINE(155)
													return ::native::display::BlendMode_obj::NORMAL;
												}
											}
										}
										return null();
									}
								};
								HX_STACK_LINE(141)
								return _Function_5_1::Block(_g);
							}
							return null();
						}
					};
					HX_STACK_LINE(139)
					this->blendMode = _Function_4_1::Block(stream);
				}
				HX_STACK_LINE(160)
				if ((hasBlendMode)){
					HX_STACK_LINE(160)
					this->cacheAsBitmap = (stream->readByte() > (int)0);
				}
				HX_STACK_LINE(166)
				if ((hasClipAction)){
					HX_STACK_LINE(168)
					int reserved = stream->readID();		HX_STACK_VAR(reserved,"reserved");
					HX_STACK_LINE(169)
					int actionFlags = stream->readID();		HX_STACK_VAR(actionFlags,"actionFlags");
					HX_STACK_LINE(171)
					hx::Throw (HX_CSTRING("clip action not implemented"));
				}
				HX_STACK_LINE(175)
				if ((move)){
					HX_STACK_LINE(175)
					if ((hasSymbol)){
						HX_STACK_LINE(177)
						this->frame->place(symbolID,this->swf->getSymbol(symbolID),depth,matrix,colorTransform,ratio,name,filters);
					}
					else{
						HX_STACK_LINE(182)
						this->frame->move(depth,matrix,colorTransform,ratio);
					}
				}
				else{
					HX_STACK_LINE(188)
					if ((this->swf->hasSymbol(symbolID))){
						HX_STACK_LINE(190)
						this->frame->place(symbolID,this->swf->getSymbol(symbolID),depth,matrix,colorTransform,ratio,name,filters);
					}
				}
			}
			else{
				HX_STACK_LINE(198)
				hx::Throw ((HX_CSTRING("Place object not implemented: ") + version));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,placeObject,(void))

Void Sprite_obj::labelFrame( ::String name){
{
		HX_STACK_PUSH("Sprite::labelFrame","format/swf/symbol/Sprite.hx",51);
		HX_STACK_THIS(this);
		HX_STACK_ARG(name,"name");
		HX_STACK_LINE(51)
		this->frameLabels->set(name,this->frame->frame);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,labelFrame,(void))


Sprite_obj::Sprite_obj()
{
}

void Sprite_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Sprite);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(frame,"frame");
	HX_MARK_MEMBER_NAME(className,"className");
	HX_MARK_MEMBER_NAME(cacheAsBitmap,"cacheAsBitmap");
	HX_MARK_MEMBER_NAME(blendMode,"blendMode");
	HX_MARK_MEMBER_NAME(swf,"swf");
	HX_MARK_MEMBER_NAME(frames,"frames");
	HX_MARK_MEMBER_NAME(frameLabels,"frameLabels");
	HX_MARK_MEMBER_NAME(frameCount,"frameCount");
	HX_MARK_END_CLASS();
}

void Sprite_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(frame,"frame");
	HX_VISIT_MEMBER_NAME(className,"className");
	HX_VISIT_MEMBER_NAME(cacheAsBitmap,"cacheAsBitmap");
	HX_VISIT_MEMBER_NAME(blendMode,"blendMode");
	HX_VISIT_MEMBER_NAME(swf,"swf");
	HX_VISIT_MEMBER_NAME(frames,"frames");
	HX_VISIT_MEMBER_NAME(frameLabels,"frameLabels");
	HX_VISIT_MEMBER_NAME(frameCount,"frameCount");
}

Dynamic Sprite_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"swf") ) { return swf; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { return frame; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { return frames; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"showFrame") ) { return showFrame_dyn(); }
		if (HX_FIELD_EQ(inName,"className") ) { return className; }
		if (HX_FIELD_EQ(inName,"blendMode") ) { return blendMode; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"labelFrame") ) { return labelFrame_dyn(); }
		if (HX_FIELD_EQ(inName,"frameCount") ) { return frameCount; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"placeObject") ) { return placeObject_dyn(); }
		if (HX_FIELD_EQ(inName,"frameLabels") ) { return frameLabels; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"removeObject") ) { return removeObject_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"cacheAsBitmap") ) { return cacheAsBitmap; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Sprite_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"swf") ) { swf=inValue.Cast< ::format::SWF >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { frame=inValue.Cast< ::format::swf::data::Frame >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { frames=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"className") ) { className=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"blendMode") ) { blendMode=inValue.Cast< ::native::display::BlendMode >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"frameCount") ) { frameCount=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"frameLabels") ) { frameLabels=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"cacheAsBitmap") ) { cacheAsBitmap=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Sprite_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("frame"));
	outFields->push(HX_CSTRING("className"));
	outFields->push(HX_CSTRING("cacheAsBitmap"));
	outFields->push(HX_CSTRING("blendMode"));
	outFields->push(HX_CSTRING("swf"));
	outFields->push(HX_CSTRING("frames"));
	outFields->push(HX_CSTRING("frameLabels"));
	outFields->push(HX_CSTRING("frameCount"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("showFrame"),
	HX_CSTRING("removeObject"),
	HX_CSTRING("placeObject"),
	HX_CSTRING("labelFrame"),
	HX_CSTRING("name"),
	HX_CSTRING("frame"),
	HX_CSTRING("className"),
	HX_CSTRING("cacheAsBitmap"),
	HX_CSTRING("blendMode"),
	HX_CSTRING("swf"),
	HX_CSTRING("frames"),
	HX_CSTRING("frameLabels"),
	HX_CSTRING("frameCount"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Sprite_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Sprite_obj::__mClass,"__mClass");
};

Class Sprite_obj::__mClass;

void Sprite_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.Sprite"), hx::TCanCast< Sprite_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Sprite_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
