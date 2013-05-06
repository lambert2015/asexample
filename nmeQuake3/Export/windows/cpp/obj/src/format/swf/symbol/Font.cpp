#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Font
#include <format/swf/symbol/Font.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_native_display_Graphics
#include <native/display/Graphics.h>
#endif
#ifndef INCLUDED_native_geom_Matrix
#include <native/geom/Matrix.h>
#endif
namespace format{
namespace swf{
namespace symbol{

Void Font_obj::__construct(::format::swf::data::SWFStream stream,int version)
{
HX_STACK_PUSH("Font::new","format/swf/symbol/Font.hx",21);
{
	HX_STACK_LINE(23)
	this->glyphsByIndex = Dynamic( Array_obj<Dynamic>::__new());
	HX_STACK_LINE(25)
	stream->alignBits();
	HX_STACK_LINE(27)
	bool hasLayout = false;		HX_STACK_VAR(hasLayout,"hasLayout");
	HX_STACK_LINE(28)
	bool hasJIS = false;		HX_STACK_VAR(hasJIS,"hasJIS");
	HX_STACK_LINE(29)
	bool smallText = false;		HX_STACK_VAR(smallText,"smallText");
	HX_STACK_LINE(30)
	bool isANSI = false;		HX_STACK_VAR(isANSI,"isANSI");
	HX_STACK_LINE(31)
	bool wideOffsets = false;		HX_STACK_VAR(wideOffsets,"wideOffsets");
	HX_STACK_LINE(32)
	bool wideCodes = false;		HX_STACK_VAR(wideCodes,"wideCodes");
	HX_STACK_LINE(33)
	bool italic = false;		HX_STACK_VAR(italic,"italic");
	HX_STACK_LINE(34)
	bool bold = false;		HX_STACK_VAR(bold,"bold");
	HX_STACK_LINE(35)
	int languageCode = (int)0;		HX_STACK_VAR(languageCode,"languageCode");
	HX_STACK_LINE(36)
	this->fontName = HX_CSTRING("font");
	HX_STACK_LINE(38)
	if (((version > (int)1))){
		HX_STACK_LINE(40)
		hasLayout = stream->readBool();
		HX_STACK_LINE(41)
		hasJIS = stream->readBool();
		HX_STACK_LINE(42)
		smallText = stream->readBool();
		HX_STACK_LINE(43)
		isANSI = stream->readBool();
		HX_STACK_LINE(44)
		wideOffsets = stream->readBool();
		HX_STACK_LINE(45)
		wideCodes = stream->readBool();
		HX_STACK_LINE(46)
		italic = stream->readBool();
		HX_STACK_LINE(47)
		bold = stream->readBool();
		HX_STACK_LINE(48)
		languageCode = stream->readByte();
		HX_STACK_LINE(49)
		this->fontName = stream->readPascalString();
	}
	HX_STACK_LINE(53)
	int numGlyphs = (int)0;		HX_STACK_VAR(numGlyphs,"numGlyphs");
	HX_STACK_LINE(54)
	int fontBytes = (int)0;		HX_STACK_VAR(fontBytes,"fontBytes");
	HX_STACK_LINE(56)
	Array< int > offsets = Array_obj< int >::__new();		HX_STACK_VAR(offsets,"offsets");
	HX_STACK_LINE(57)
	int codeOffset = (int)0;		HX_STACK_VAR(codeOffset,"codeOffset");
	HX_STACK_LINE(58)
	Float v3scale = (  (((version > (int)2))) ? Float(1.0) : Float(0.05) );		HX_STACK_VAR(v3scale,"v3scale");
	HX_STACK_LINE(60)
	if (((version > (int)1))){
		HX_STACK_LINE(62)
		numGlyphs = stream->readUInt16();
		HX_STACK_LINE(63)
		fontBytes = stream->getBytesLeft();
		HX_STACK_LINE(65)
		{
			HX_STACK_LINE(65)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(65)
			while(((_g < numGlyphs))){
				HX_STACK_LINE(65)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(67)
				if ((wideOffsets)){
					HX_STACK_LINE(67)
					offsets->push(stream->readInt());
				}
				else{
					HX_STACK_LINE(71)
					offsets->push(stream->readUInt16());
				}
			}
		}
		HX_STACK_LINE(79)
		if ((wideOffsets)){
			HX_STACK_LINE(79)
			codeOffset = stream->readInt();
		}
		else{
			HX_STACK_LINE(83)
			codeOffset = stream->readUInt16();
		}
		HX_STACK_LINE(89)
		codeOffset = (  (((fontBytes > (int)0))) ? int((fontBytes - codeOffset)) : int((int)0) );
	}
	else{
		HX_STACK_LINE(93)
		fontBytes = stream->getBytesLeft();
		HX_STACK_LINE(94)
		int firstOffset = stream->readUInt16();		HX_STACK_VAR(firstOffset,"firstOffset");
		HX_STACK_LINE(98)
		numGlyphs = (int(firstOffset) >> int((int)1));
		HX_STACK_LINE(99)
		offsets->push(firstOffset);
		HX_STACK_LINE(101)
		{
			HX_STACK_LINE(101)
			int _g = (int)1;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(101)
			while(((_g < numGlyphs))){
				HX_STACK_LINE(101)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(103)
				offsets->push(stream->readUInt16());
			}
		}
	}
	HX_STACK_LINE(109)
	stream->alignBits();
	HX_STACK_LINE(111)
	{
		HX_STACK_LINE(111)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(111)
		while(((_g < numGlyphs))){
			HX_STACK_LINE(111)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(113)
			if (((stream->getBytesLeft() != (fontBytes - offsets->__get(i))))){
				HX_STACK_LINE(113)
				hx::Throw (((((HX_CSTRING("Bad offset in font stream (") + stream->getBytesLeft()) + HX_CSTRING(" != ")) + ((fontBytes - offsets->__get(i)))) + HX_CSTRING(")")));
			}
			HX_STACK_LINE(119)
			bool moved = false;		HX_STACK_VAR(moved,"moved");
			HX_STACK_LINE(121)
			Float penX = 0.0;		HX_STACK_VAR(penX,"penX");
			HX_STACK_LINE(122)
			Float penY = 0.0;		HX_STACK_VAR(penY,"penY");
			HX_STACK_LINE(124)
			Dynamic commands = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(commands,"commands");
			HX_STACK_LINE(126)
			stream->alignBits();
			HX_STACK_LINE(128)
			int fillBits = stream->readBits((int)4,null());		HX_STACK_VAR(fillBits,"fillBits");
			HX_STACK_LINE(129)
			int lineBits = stream->readBits((int)4,null());		HX_STACK_VAR(lineBits,"lineBits");
			HX_STACK_LINE(131)
			while((true)){
				HX_STACK_LINE(133)
				bool edge = stream->readBool();		HX_STACK_VAR(edge,"edge");
				HX_STACK_LINE(135)
				if ((!(edge))){
					HX_STACK_LINE(137)
					bool newStyles = stream->readBool();		HX_STACK_VAR(newStyles,"newStyles");
					HX_STACK_LINE(138)
					bool newLineStyle = stream->readBool();		HX_STACK_VAR(newLineStyle,"newLineStyle");
					HX_STACK_LINE(139)
					bool newFillStyle1 = stream->readBool();		HX_STACK_VAR(newFillStyle1,"newFillStyle1");
					HX_STACK_LINE(140)
					bool newFillStyle0 = stream->readBool();		HX_STACK_VAR(newFillStyle0,"newFillStyle0");
					HX_STACK_LINE(141)
					bool moveTo = stream->readBool();		HX_STACK_VAR(moveTo,"moveTo");
					HX_STACK_LINE(143)
					if (((bool(newStyles) || bool(newFillStyle1)))){
						HX_STACK_LINE(143)
						hx::Throw ((((HX_CSTRING("Fill style can't be changed here ") + ::Std_obj::string(newStyles)) + HX_CSTRING(", ")) + ::Std_obj::string(newFillStyle0)));
					}
					HX_STACK_LINE(149)
					if ((!(moveTo))){
						HX_STACK_LINE(149)
						break;
					}
					HX_STACK_LINE(155)
					if (((bool(!(newFillStyle0)) && bool((commands->__Field(HX_CSTRING("length"),true) == (int)0))))){
						HX_STACK_LINE(155)
						hx::Throw (HX_CSTRING("Fill style should be defined"));
					}
					HX_STACK_LINE(161)
					int position = stream->readBits((int)5,null());		HX_STACK_VAR(position,"position");
					HX_STACK_LINE(163)
					penX = (stream->readTwips(position) * v3scale);
					HX_STACK_LINE(164)
					penY = (stream->readTwips(position) * v3scale);
					HX_STACK_LINE(166)
					Array< Float > px = Array_obj< Float >::__new().Add(penX);		HX_STACK_VAR(px,"px");
					HX_STACK_LINE(167)
					Array< Float > py = Array_obj< Float >::__new().Add(penY);		HX_STACK_VAR(py,"py");

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_5_1,Array< Float >,px,Array< Float >,py)
					Void run(::native::display::Graphics g,::native::geom::Matrix m){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/Font.hx",169);
						HX_STACK_ARG(g,"g");
						HX_STACK_ARG(m,"m");
						{
							HX_STACK_LINE(169)
							g->moveTo((((px->__get((int)0) * m->a) + (py->__get((int)0) * m->c)) + m->tx),(((px->__get((int)0) * m->b) + (py->__get((int)0) * m->d)) + m->ty));
						}
						return null();
					}
					HX_END_LOCAL_FUNC2((void))

					HX_STACK_LINE(169)
					commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(px,py)));
					HX_STACK_LINE(175)
					if ((newFillStyle0)){
						HX_STACK_LINE(175)
						int fillStyle = stream->readBits((int)1,null());		HX_STACK_VAR(fillStyle,"fillStyle");
					}
				}
				else{
					HX_STACK_LINE(183)
					bool lineTo = stream->readBool();		HX_STACK_VAR(lineTo,"lineTo");
					HX_STACK_LINE(185)
					if ((lineTo)){
						HX_STACK_LINE(187)
						int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
						HX_STACK_LINE(189)
						if ((stream->readBool())){
							HX_STACK_LINE(191)
							hx::AddEq(penX,(stream->readTwips(deltaBits) * v3scale));
							HX_STACK_LINE(192)
							hx::AddEq(penY,(stream->readTwips(deltaBits) * v3scale));
						}
						else{
							HX_STACK_LINE(194)
							if ((stream->readBool())){
								HX_STACK_LINE(194)
								hx::AddEq(penY,(stream->readTwips(deltaBits) * v3scale));
							}
							else{
								HX_STACK_LINE(198)
								hx::AddEq(penX,(stream->readTwips(deltaBits) * v3scale));
							}
						}
						HX_STACK_LINE(204)
						Array< Float > px = Array_obj< Float >::__new().Add(penX);		HX_STACK_VAR(px,"px");
						HX_STACK_LINE(205)
						Array< Float > py = Array_obj< Float >::__new().Add(penY);		HX_STACK_VAR(py,"py");

						HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_6_1,Array< Float >,px,Array< Float >,py)
						Void run(::native::display::Graphics g,::native::geom::Matrix m){
							HX_STACK_PUSH("*::_Function_6_1","format/swf/symbol/Font.hx",207);
							HX_STACK_ARG(g,"g");
							HX_STACK_ARG(m,"m");
							{
								HX_STACK_LINE(207)
								g->lineTo((((px->__get((int)0) * m->a) + (py->__get((int)0) * m->c)) + m->tx),(((px->__get((int)0) * m->b) + (py->__get((int)0) * m->d)) + m->ty));
							}
							return null();
						}
						HX_END_LOCAL_FUNC2((void))

						HX_STACK_LINE(207)
						commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_6_1(px,py)));
					}
					else{
						HX_STACK_LINE(215)
						int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
						HX_STACK_LINE(217)
						Array< Float > cx = Array_obj< Float >::__new().Add((penX + (stream->readTwips(deltaBits) * v3scale)));		HX_STACK_VAR(cx,"cx");
						HX_STACK_LINE(218)
						Array< Float > cy = Array_obj< Float >::__new().Add((penY + (stream->readTwips(deltaBits) * v3scale)));		HX_STACK_VAR(cy,"cy");
						HX_STACK_LINE(219)
						Array< Float > px = Array_obj< Float >::__new().Add((cx->__get((int)0) + (stream->readTwips(deltaBits) * v3scale)));		HX_STACK_VAR(px,"px");
						HX_STACK_LINE(220)
						Array< Float > py = Array_obj< Float >::__new().Add((cy->__get((int)0) + (stream->readTwips(deltaBits) * v3scale)));		HX_STACK_VAR(py,"py");
						HX_STACK_LINE(222)
						penX = px->__get((int)0);
						HX_STACK_LINE(223)
						penY = py->__get((int)0);

						HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_6_1,Array< Float >,py,Array< Float >,cy,Array< Float >,px,Array< Float >,cx)
						Void run(::native::display::Graphics g,::native::geom::Matrix m){
							HX_STACK_PUSH("*::_Function_6_1","format/swf/symbol/Font.hx",225);
							HX_STACK_ARG(g,"g");
							HX_STACK_ARG(m,"m");
							{
								HX_STACK_LINE(225)
								g->curveTo((((cx->__get((int)0) * m->a) + (cy->__get((int)0) * m->c)) + m->tx),(((cx->__get((int)0) * m->b) + (cy->__get((int)0) * m->d)) + m->ty),(((px->__get((int)0) * m->a) + (py->__get((int)0) * m->c)) + m->tx),(((px->__get((int)0) * m->b) + (py->__get((int)0) * m->d)) + m->ty));
							}
							return null();
						}
						HX_END_LOCAL_FUNC2((void))

						HX_STACK_LINE(225)
						commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_6_1(py,cy,px,cx)));
					}
				}
			}

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_3_1)
			Void run(::native::display::Graphics g,::native::geom::Matrix m){
				HX_STACK_PUSH("*::_Function_3_1","format/swf/symbol/Font.hx",237);
				HX_STACK_ARG(g,"g");
				HX_STACK_ARG(m,"m");
				{
					HX_STACK_LINE(237)
					g->endFill();
				}
				return null();
			}
			HX_END_LOCAL_FUNC2((void))

			HX_STACK_LINE(237)
			commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_3_1()));
			struct _Function_3_2{
				inline static Dynamic Block( Dynamic &commands){
					HX_STACK_PUSH("*::closure","format/swf/symbol/Font.hx",243);
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("commands") , commands,false);
						__result->Add(HX_CSTRING("advance") , 1024.0,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(243)
			hx::IndexRef((this->glyphsByIndex).mPtr,i) = _Function_3_2::Block(commands);
		}
	}
	HX_STACK_LINE(247)
	if (((codeOffset != (int)0))){
		HX_STACK_LINE(249)
		stream->alignBits();
		HX_STACK_LINE(251)
		if (((stream->getBytesLeft() != codeOffset))){
			HX_STACK_LINE(251)
			hx::Throw (HX_CSTRING("Code offset miscalculation"));
		}
		HX_STACK_LINE(257)
		this->glyphsByCode = Dynamic( Array_obj<Dynamic>::__new() );
		HX_STACK_LINE(259)
		{
			HX_STACK_LINE(259)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(259)
			while(((_g < numGlyphs))){
				HX_STACK_LINE(259)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(261)
				int code = (int)0;		HX_STACK_VAR(code,"code");
				HX_STACK_LINE(263)
				if ((wideCodes)){
					HX_STACK_LINE(263)
					code = stream->readUInt16();
				}
				else{
					HX_STACK_LINE(267)
					code = stream->readByte();
				}
				HX_STACK_LINE(273)
				hx::IndexRef((this->glyphsByCode).mPtr,code) = this->glyphsByIndex->__GetItem(i);
			}
		}
	}
	else{
		HX_STACK_LINE(277)
		this->glyphsByCode = this->glyphsByIndex;
	}
	HX_STACK_LINE(283)
	if ((hasLayout)){
		HX_STACK_LINE(285)
		this->ascent = stream->readSTwips();
		HX_STACK_LINE(286)
		this->descent = stream->readSTwips();
		HX_STACK_LINE(287)
		this->leading = stream->readSTwips();
		HX_STACK_LINE(289)
		this->advance = Array_obj< Float >::__new();
		HX_STACK_LINE(291)
		{
			HX_STACK_LINE(291)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(291)
			while(((_g < numGlyphs))){
				HX_STACK_LINE(291)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(293)
				this->glyphsByIndex->__GetItem(i)->__FieldRef(HX_CSTRING("advance")) = stream->readSTwips();
			}
		}
	}
	else{
		HX_STACK_LINE(299)
		this->ascent = (int)800;
		HX_STACK_LINE(300)
		this->descent = (int)224;
		HX_STACK_LINE(301)
		this->leading = (int)0;
	}
}
;
	return null();
}

Font_obj::~Font_obj() { }

Dynamic Font_obj::__CreateEmpty() { return  new Font_obj; }
hx::ObjectPtr< Font_obj > Font_obj::__new(::format::swf::data::SWFStream stream,int version)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(stream,version);
	return result;}

Dynamic Font_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void Font_obj::renderGlyph( ::native::display::Graphics graphics,int index,::native::geom::Matrix matrix){
{
		HX_STACK_PUSH("Font::renderGlyph","format/swf/symbol/Font.hx",383);
		HX_STACK_THIS(this);
		HX_STACK_ARG(graphics,"graphics");
		HX_STACK_ARG(index,"index");
		HX_STACK_ARG(matrix,"matrix");
		HX_STACK_LINE(383)
		if (((this->glyphsByIndex->__Field(HX_CSTRING("length"),true) > index))){
			HX_STACK_LINE(387)
			Dynamic commands = this->glyphsByIndex->__GetItem(index)->__Field(HX_CSTRING("commands"),true);		HX_STACK_VAR(commands,"commands");
			HX_STACK_LINE(389)
			{
				HX_STACK_LINE(389)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(389)
				while(((_g < commands->__Field(HX_CSTRING("length"),true)))){
					HX_STACK_LINE(389)
					Dynamic command = commands->__GetItem(_g);		HX_STACK_VAR(command,"command");
					HX_STACK_LINE(389)
					++(_g);
					HX_STACK_LINE(391)
					command(graphics,matrix).Cast< Void >();
				}
			}
		}
		else{
			HX_STACK_LINE(395)
			::haxe::Log_obj::trace((HX_CSTRING("Unsupported glyph: ") + ::String::fromCharCode(index)),hx::SourceInfo(HX_CSTRING("Font.hx"),397,HX_CSTRING("format.swf.symbol.Font"),HX_CSTRING("renderGlyph")));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Font_obj,renderGlyph,(void))

Float Font_obj::renderCharacter( ::native::display::Graphics graphics,int code,::native::geom::Matrix matrix){
	HX_STACK_PUSH("Font::renderCharacter","format/swf/symbol/Font.hx",358);
	HX_STACK_THIS(this);
	HX_STACK_ARG(graphics,"graphics");
	HX_STACK_ARG(code,"code");
	HX_STACK_ARG(matrix,"matrix");
	HX_STACK_LINE(360)
	if (((this->glyphsByCode->__Field(HX_CSTRING("length"),true) > code))){
		HX_STACK_LINE(362)
		Dynamic glyph = this->glyphsByCode->__GetItem(code);		HX_STACK_VAR(glyph,"glyph");
		HX_STACK_LINE(364)
		if (((glyph != null()))){
			HX_STACK_LINE(366)
			{
				HX_STACK_LINE(366)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				Dynamic _g1 = glyph->__Field(HX_CSTRING("commands"),true);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(366)
				while(((_g < _g1->__Field(HX_CSTRING("length"),true)))){
					HX_STACK_LINE(366)
					Dynamic command = _g1->__GetItem(_g);		HX_STACK_VAR(command,"command");
					HX_STACK_LINE(366)
					++(_g);
					HX_STACK_LINE(368)
					command(graphics,matrix).Cast< Void >();
				}
			}
			HX_STACK_LINE(372)
			return glyph->__Field(HX_CSTRING("advance"),true);
		}
	}
	HX_STACK_LINE(378)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC3(Font_obj,renderCharacter,return )

Float Font_obj::getLeading( ){
	HX_STACK_PUSH("Font::getLeading","format/swf/symbol/Font.hx",351);
	HX_STACK_THIS(this);
	HX_STACK_LINE(351)
	return this->leading;
}


HX_DEFINE_DYNAMIC_FUNC0(Font_obj,getLeading,return )

::String Font_obj::getFontName( ){
	HX_STACK_PUSH("Font::getFontName","format/swf/symbol/Font.hx",344);
	HX_STACK_THIS(this);
	HX_STACK_LINE(344)
	return this->fontName;
}


HX_DEFINE_DYNAMIC_FUNC0(Font_obj,getFontName,return )

Float Font_obj::getDescent( ){
	HX_STACK_PUSH("Font::getDescent","format/swf/symbol/Font.hx",337);
	HX_STACK_THIS(this);
	HX_STACK_LINE(337)
	return this->descent;
}


HX_DEFINE_DYNAMIC_FUNC0(Font_obj,getDescent,return )

Float Font_obj::getAscent( ){
	HX_STACK_PUSH("Font::getAscent","format/swf/symbol/Font.hx",330);
	HX_STACK_THIS(this);
	HX_STACK_LINE(330)
	return this->ascent;
}


HX_DEFINE_DYNAMIC_FUNC0(Font_obj,getAscent,return )

Float Font_obj::getAdvance( int characterCode,Dynamic next){
	HX_STACK_PUSH("Font::getAdvance","format/swf/symbol/Font.hx",311);
	HX_STACK_THIS(this);
	HX_STACK_ARG(characterCode,"characterCode");
	HX_STACK_ARG(next,"next");
	HX_STACK_LINE(313)
	if (((this->glyphsByCode->__Field(HX_CSTRING("length"),true) > characterCode))){
		HX_STACK_LINE(315)
		Dynamic glyph = this->glyphsByCode->__GetItem(characterCode);		HX_STACK_VAR(glyph,"glyph");
		HX_STACK_LINE(317)
		if (((glyph != null()))){
			HX_STACK_LINE(317)
			return glyph->__Field(HX_CSTRING("advance"),true);
		}
	}
	HX_STACK_LINE(325)
	return (int)1024;
}


HX_DEFINE_DYNAMIC_FUNC2(Font_obj,getAdvance,return )


Font_obj::Font_obj()
{
}

void Font_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Font);
	HX_MARK_MEMBER_NAME(leading,"leading");
	HX_MARK_MEMBER_NAME(glyphsByIndex,"glyphsByIndex");
	HX_MARK_MEMBER_NAME(glyphsByCode,"glyphsByCode");
	HX_MARK_MEMBER_NAME(fontName,"fontName");
	HX_MARK_MEMBER_NAME(descent,"descent");
	HX_MARK_MEMBER_NAME(ascent,"ascent");
	HX_MARK_MEMBER_NAME(advance,"advance");
	HX_MARK_END_CLASS();
}

void Font_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(leading,"leading");
	HX_VISIT_MEMBER_NAME(glyphsByIndex,"glyphsByIndex");
	HX_VISIT_MEMBER_NAME(glyphsByCode,"glyphsByCode");
	HX_VISIT_MEMBER_NAME(fontName,"fontName");
	HX_VISIT_MEMBER_NAME(descent,"descent");
	HX_VISIT_MEMBER_NAME(ascent,"ascent");
	HX_VISIT_MEMBER_NAME(advance,"advance");
}

Dynamic Font_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"ascent") ) { return ascent; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"leading") ) { return leading; }
		if (HX_FIELD_EQ(inName,"descent") ) { return descent; }
		if (HX_FIELD_EQ(inName,"advance") ) { return advance; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fontName") ) { return fontName; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getAscent") ) { return getAscent_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getLeading") ) { return getLeading_dyn(); }
		if (HX_FIELD_EQ(inName,"getDescent") ) { return getDescent_dyn(); }
		if (HX_FIELD_EQ(inName,"getAdvance") ) { return getAdvance_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"renderGlyph") ) { return renderGlyph_dyn(); }
		if (HX_FIELD_EQ(inName,"getFontName") ) { return getFontName_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"glyphsByCode") ) { return glyphsByCode; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"glyphsByIndex") ) { return glyphsByIndex; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"renderCharacter") ) { return renderCharacter_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Font_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"ascent") ) { ascent=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"leading") ) { leading=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"descent") ) { descent=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"advance") ) { advance=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fontName") ) { fontName=inValue.Cast< ::String >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"glyphsByCode") ) { glyphsByCode=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"glyphsByIndex") ) { glyphsByIndex=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Font_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("leading"));
	outFields->push(HX_CSTRING("glyphsByIndex"));
	outFields->push(HX_CSTRING("glyphsByCode"));
	outFields->push(HX_CSTRING("fontName"));
	outFields->push(HX_CSTRING("descent"));
	outFields->push(HX_CSTRING("ascent"));
	outFields->push(HX_CSTRING("advance"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("renderGlyph"),
	HX_CSTRING("renderCharacter"),
	HX_CSTRING("getLeading"),
	HX_CSTRING("getFontName"),
	HX_CSTRING("getDescent"),
	HX_CSTRING("getAscent"),
	HX_CSTRING("getAdvance"),
	HX_CSTRING("leading"),
	HX_CSTRING("glyphsByIndex"),
	HX_CSTRING("glyphsByCode"),
	HX_CSTRING("fontName"),
	HX_CSTRING("descent"),
	HX_CSTRING("ascent"),
	HX_CSTRING("advance"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Font_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Font_obj::__mClass,"__mClass");
};

Class Font_obj::__mClass;

void Font_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.Font"), hx::TCanCast< Font_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Font_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
