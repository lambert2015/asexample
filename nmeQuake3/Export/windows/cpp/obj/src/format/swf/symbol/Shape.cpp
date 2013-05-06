#include <hxcpp.h>

#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_format_SWF
#include <format/SWF.h>
#endif
#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Bitmap
#include <format/swf/symbol/Bitmap.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Shape
#include <format/swf/symbol/Shape.h>
#endif
#ifndef INCLUDED_format_swf_symbol_ShapeEdge
#include <format/swf/symbol/ShapeEdge.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_native_display_BitmapData
#include <native/display/BitmapData.h>
#endif
#ifndef INCLUDED_native_display_CapsStyle
#include <native/display/CapsStyle.h>
#endif
#ifndef INCLUDED_native_display_GradientType
#include <native/display/GradientType.h>
#endif
#ifndef INCLUDED_native_display_Graphics
#include <native/display/Graphics.h>
#endif
#ifndef INCLUDED_native_display_IBitmapDrawable
#include <native/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_native_display_InterpolationMethod
#include <native/display/InterpolationMethod.h>
#endif
#ifndef INCLUDED_native_display_JointStyle
#include <native/display/JointStyle.h>
#endif
#ifndef INCLUDED_native_display_LineScaleMode
#include <native/display/LineScaleMode.h>
#endif
#ifndef INCLUDED_native_display_SpreadMethod
#include <native/display/SpreadMethod.h>
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

Void Shape_obj::__construct(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{
HX_STACK_PUSH("Shape::new","format/swf/symbol/Shape.hx",40);
{
	HX_STACK_LINE(42)
	this->swf = swf;
	HX_STACK_LINE(44)
	stream->alignBits();
	HX_STACK_LINE(46)
	this->commands = Dynamic( Array_obj<Dynamic>::__new());
	HX_STACK_LINE(47)
	this->bounds = stream->readRect();
	HX_STACK_LINE(48)
	this->waitingLoader = false;
	HX_STACK_LINE(50)
	if (((version == (int)4))){
		HX_STACK_LINE(52)
		stream->alignBits();
		HX_STACK_LINE(54)
		this->edgeBounds = stream->readRect();
		HX_STACK_LINE(56)
		stream->alignBits();
		HX_STACK_LINE(58)
		stream->readBits((int)6,null());
		HX_STACK_LINE(59)
		this->hasNonScaled = stream->readBool();
		HX_STACK_LINE(60)
		this->hasScaled = stream->readBool();
	}
	else{
		HX_STACK_LINE(64)
		this->edgeBounds = this->bounds->clone();
		HX_STACK_LINE(65)
		this->hasScaled = true;
		HX_STACK_LINE(66)
		this->hasNonScaled = true;
	}
	HX_STACK_LINE(70)
	this->fillStyles = this->readFillStyles(stream,version);
	HX_STACK_LINE(71)
	Dynamic lineStyles = this->readLineStyles(stream,version);		HX_STACK_VAR(lineStyles,"lineStyles");
	HX_STACK_LINE(73)
	stream->alignBits();
	HX_STACK_LINE(75)
	int fillBits = stream->readBits((int)4,null());		HX_STACK_VAR(fillBits,"fillBits");
	HX_STACK_LINE(76)
	int lineBits = stream->readBits((int)4,null());		HX_STACK_VAR(lineBits,"lineBits");
	HX_STACK_LINE(78)
	Float penX = 0.0;		HX_STACK_VAR(penX,"penX");
	HX_STACK_LINE(79)
	Float penY = 0.0;		HX_STACK_VAR(penY,"penY");
	HX_STACK_LINE(81)
	int currentFill0 = (int)-1;		HX_STACK_VAR(currentFill0,"currentFill0");
	HX_STACK_LINE(82)
	int currentFill1 = (int)-1;		HX_STACK_VAR(currentFill1,"currentFill1");
	HX_STACK_LINE(83)
	int currentLine = (int)-1;		HX_STACK_VAR(currentLine,"currentLine");
	HX_STACK_LINE(85)
	Dynamic edges = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(edges,"edges");
	HX_STACK_LINE(86)
	Array< ::Dynamic > fills = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(fills,"fills");
	HX_STACK_LINE(88)
	while((true)){
		HX_STACK_LINE(90)
		bool edge = stream->readBool();		HX_STACK_VAR(edge,"edge");
		HX_STACK_LINE(92)
		if ((!(edge))){
			HX_STACK_LINE(94)
			bool newStyles = stream->readBool();		HX_STACK_VAR(newStyles,"newStyles");
			HX_STACK_LINE(95)
			bool newLineStyle = stream->readBool();		HX_STACK_VAR(newLineStyle,"newLineStyle");
			HX_STACK_LINE(96)
			bool newFillStyle1 = stream->readBool();		HX_STACK_VAR(newFillStyle1,"newFillStyle1");
			HX_STACK_LINE(97)
			bool newFillStyle0 = stream->readBool();		HX_STACK_VAR(newFillStyle0,"newFillStyle0");
			HX_STACK_LINE(98)
			bool moveTo = stream->readBool();		HX_STACK_VAR(moveTo,"moveTo");
			HX_STACK_LINE(101)
			if (((bool((bool((bool((bool(!(moveTo)) && bool(!(newStyles)))) && bool(!(newLineStyle)))) && bool(!(newFillStyle1)))) && bool(!(newFillStyle0))))){
				HX_STACK_LINE(101)
				break;
			}
			HX_STACK_LINE(107)
			if (((bool((version != (int)2)) && bool((version != (int)3))))){
			}
			HX_STACK_LINE(120)
			if ((moveTo)){
				HX_STACK_LINE(122)
				int bits = stream->readBits((int)5,null());		HX_STACK_VAR(bits,"bits");
				HX_STACK_LINE(123)
				Array< Float > px = Array_obj< Float >::__new().Add(stream->readTwips(bits));		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(124)
				Array< Float > py = Array_obj< Float >::__new().Add(stream->readTwips(bits));		HX_STACK_VAR(py,"py");

				HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_4_1,Array< Float >,px,Array< Float >,py)
				Void run(::native::display::Graphics g){
					HX_STACK_PUSH("*::_Function_4_1","format/swf/symbol/Shape.hx",126);
					HX_STACK_ARG(g,"g");
					{
						HX_STACK_LINE(126)
						g->moveTo(px->__get((int)0),py->__get((int)0));
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				HX_STACK_LINE(126)
				edges->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_4_1(px,py)));
				HX_STACK_LINE(132)
				penX = px->__get((int)0);
				HX_STACK_LINE(133)
				penY = py->__get((int)0);
			}
			HX_STACK_LINE(137)
			if ((newFillStyle0)){
				HX_STACK_LINE(137)
				currentFill0 = stream->readBits(fillBits,null());
			}
			HX_STACK_LINE(143)
			if ((newFillStyle1)){
				HX_STACK_LINE(143)
				currentFill1 = stream->readBits(fillBits,null());
			}
			HX_STACK_LINE(149)
			if ((newLineStyle)){
				HX_STACK_LINE(151)
				int lineStyle = stream->readBits(lineBits,null());		HX_STACK_VAR(lineStyle,"lineStyle");
				HX_STACK_LINE(153)
				if (((lineStyle >= lineStyles->__Field(HX_CSTRING("length"),true)))){
					HX_STACK_LINE(153)
					hx::Throw (((((((HX_CSTRING("Invalid line style: ") + lineStyle) + HX_CSTRING("/")) + lineStyles->__Field(HX_CSTRING("length"),true)) + HX_CSTRING(" (")) + lineBits) + HX_CSTRING(")")));
				}
				HX_STACK_LINE(159)
				Dynamic func = lineStyles->__GetItem(lineStyle);		HX_STACK_VAR(func,"func");
				HX_STACK_LINE(160)
				edges->__Field(HX_CSTRING("push"),true)(func);
				HX_STACK_LINE(161)
				currentLine = lineStyle;
			}
			HX_STACK_LINE(166)
			if ((newStyles)){
				HX_STACK_LINE(168)
				this->flushCommands(edges,fills);
				HX_STACK_LINE(170)
				if (((edges->__Field(HX_CSTRING("length"),true) > (int)0))){
					HX_STACK_LINE(170)
					edges = Dynamic( Array_obj<Dynamic>::__new());
				}
				HX_STACK_LINE(176)
				if (((fills->length > (int)0))){
					HX_STACK_LINE(176)
					fills = Array_obj< ::Dynamic >::__new();
				}
				HX_STACK_LINE(182)
				stream->alignBits();
				HX_STACK_LINE(184)
				this->fillStyles = this->readFillStyles(stream,version);
				HX_STACK_LINE(185)
				lineStyles = this->readLineStyles(stream,version);
				HX_STACK_LINE(186)
				fillBits = stream->readBits((int)4,null());
				HX_STACK_LINE(187)
				lineBits = stream->readBits((int)4,null());
				HX_STACK_LINE(189)
				currentLine = (int)-1;
				HX_STACK_LINE(190)
				currentFill0 = (int)-1;
				HX_STACK_LINE(191)
				currentFill1 = (int)-1;
			}
		}
		else{
			HX_STACK_LINE(195)
			if ((stream->readBool())){
				HX_STACK_LINE(203)
				Array< Float > px = Array_obj< Float >::__new().Add(penX);		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(204)
				Array< Float > py = Array_obj< Float >::__new().Add(penY);		HX_STACK_VAR(py,"py");
				HX_STACK_LINE(206)
				int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
				HX_STACK_LINE(208)
				if ((stream->readBool())){
					HX_STACK_LINE(210)
					hx::AddEq(px[(int)0],stream->readTwips(deltaBits));
					HX_STACK_LINE(211)
					hx::AddEq(py[(int)0],stream->readTwips(deltaBits));
				}
				else{
					HX_STACK_LINE(213)
					if ((stream->readBool())){
						HX_STACK_LINE(213)
						hx::AddEq(py[(int)0],stream->readTwips(deltaBits));
					}
					else{
						HX_STACK_LINE(217)
						hx::AddEq(px[(int)0],stream->readTwips(deltaBits));
					}
				}
				HX_STACK_LINE(223)
				if (((currentLine > (int)0))){

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_5_1,Array< Float >,px,Array< Float >,py)
					Void run(::native::display::Graphics g){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/Shape.hx",225);
						HX_STACK_ARG(g,"g");
						{
							HX_STACK_LINE(225)
							g->lineTo(px->__get((int)0),py->__get((int)0));
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(223)
					edges->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(px,py)));
				}
				else{

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_5_1,Array< Float >,px,Array< Float >,py)
					Void run(::native::display::Graphics g){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/Shape.hx",233);
						HX_STACK_ARG(g,"g");
						{
							HX_STACK_LINE(233)
							g->moveTo(px->__get((int)0),py->__get((int)0));
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(231)
					edges->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(px,py)));
				}
				HX_STACK_LINE(241)
				if (((currentFill0 > (int)0))){
					HX_STACK_LINE(241)
					fills->push(::format::swf::symbol::ShapeEdge_obj::line(currentFill0,penX,penY,px->__get((int)0),py->__get((int)0)));
				}
				HX_STACK_LINE(247)
				if (((currentFill1 > (int)0))){
					HX_STACK_LINE(247)
					fills->push(::format::swf::symbol::ShapeEdge_obj::line(currentFill1,px->__get((int)0),py->__get((int)0),penX,penY));
				}
				HX_STACK_LINE(253)
				penX = px->__get((int)0);
				HX_STACK_LINE(254)
				penY = py->__get((int)0);
			}
			else{
				HX_STACK_LINE(260)
				int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
				HX_STACK_LINE(261)
				Array< Float > cx = Array_obj< Float >::__new().Add((penX + stream->readTwips(deltaBits)));		HX_STACK_VAR(cx,"cx");
				HX_STACK_LINE(262)
				Array< Float > cy = Array_obj< Float >::__new().Add((penY + stream->readTwips(deltaBits)));		HX_STACK_VAR(cy,"cy");
				HX_STACK_LINE(263)
				Array< Float > px = Array_obj< Float >::__new().Add((cx->__get((int)0) + stream->readTwips(deltaBits)));		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(264)
				Array< Float > py = Array_obj< Float >::__new().Add((cy->__get((int)0) + stream->readTwips(deltaBits)));		HX_STACK_VAR(py,"py");
				HX_STACK_LINE(269)
				if (((currentLine > (int)0))){
					HX_STACK_LINE(271)
					this->hasCurves = true;

					HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_5_1,Array< Float >,py,Array< Float >,cy,Array< Float >,px,Array< Float >,cx)
					Void run(::native::display::Graphics g){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/Shape.hx",273);
						HX_STACK_ARG(g,"g");
						{
							HX_STACK_LINE(273)
							g->curveTo(cx->__get((int)0),cy->__get((int)0),px->__get((int)0),py->__get((int)0));
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(273)
					edges->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(py,cy,px,cx)));
				}
				HX_STACK_LINE(281)
				if (((currentFill0 > (int)0))){
					HX_STACK_LINE(281)
					fills->push(::format::swf::symbol::ShapeEdge_obj::curve(currentFill0,penX,penY,cx->__get((int)0),cy->__get((int)0),px->__get((int)0),py->__get((int)0)));
				}
				HX_STACK_LINE(287)
				if (((currentFill1 > (int)0))){
					HX_STACK_LINE(287)
					fills->push(::format::swf::symbol::ShapeEdge_obj::curve(currentFill1,px->__get((int)0),py->__get((int)0),cx->__get((int)0),cy->__get((int)0),penX,penY));
				}
				HX_STACK_LINE(293)
				penX = px->__get((int)0);
				HX_STACK_LINE(294)
				penY = py->__get((int)0);
			}
		}
	}
	HX_STACK_LINE(302)
	this->flushCommands(edges,fills);
	HX_STACK_LINE(304)
	this->swf = null();
}
;
	return null();
}

Shape_obj::~Shape_obj() { }

Dynamic Shape_obj::__CreateEmpty() { return  new Shape_obj; }
hx::ObjectPtr< Shape_obj > Shape_obj::__new(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{  hx::ObjectPtr< Shape_obj > result = new Shape_obj();
	result->__construct(swf,stream,version);
	return result;}

Dynamic Shape_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Shape_obj > result = new Shape_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

bool Shape_obj::render( ::native::display::Graphics graphics){
	HX_STACK_PUSH("Shape::render","format/swf/symbol/Shape.hx",693);
	HX_STACK_THIS(this);
	HX_STACK_ARG(graphics,"graphics");
	HX_STACK_LINE(695)
	this->waitingLoader = false;
	HX_STACK_LINE(697)
	{
		HX_STACK_LINE(697)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		Dynamic _g1 = this->commands;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(697)
		while(((_g < _g1->__Field(HX_CSTRING("length"),true)))){
			HX_STACK_LINE(697)
			Dynamic command = _g1->__GetItem(_g);		HX_STACK_VAR(command,"command");
			HX_STACK_LINE(697)
			++(_g);
			HX_STACK_LINE(699)
			command(graphics).Cast< Void >();
		}
	}
	HX_STACK_LINE(703)
	return this->waitingLoader;
}


HX_DEFINE_DYNAMIC_FUNC1(Shape_obj,render,return )

Dynamic Shape_obj::readLineStyles( ::format::swf::data::SWFStream stream,int version){
	HX_STACK_PUSH("Shape::readLineStyles","format/swf/symbol/Shape.hx",584);
	HX_STACK_THIS(this);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_ARG(version,"version");
	HX_STACK_LINE(586)
	Dynamic result = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(result,"result");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	Void run(::native::display::Graphics g){
		HX_STACK_PUSH("*::_Function_1_1","format/swf/symbol/Shape.hx",589);
		HX_STACK_ARG(g,"g");
		{
			HX_STACK_LINE(589)
			g->lineStyle(null(),null(),null(),null(),null(),null(),null(),null());
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_STACK_LINE(589)
	result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_1_1()));
	HX_STACK_LINE(595)
	int count = stream->readArraySize(true);		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(597)
	{
		HX_STACK_LINE(597)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(597)
		while(((_g < count))){
			HX_STACK_LINE(597)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(600)
			if (((version >= (int)4))){
				HX_STACK_LINE(602)
				stream->alignBits();
				HX_STACK_LINE(604)
				Array< Float > width = Array_obj< Float >::__new().Add((stream->readDepth() * 0.05));		HX_STACK_VAR(width,"width");
				HX_STACK_LINE(605)
				Array< ::Dynamic > startCaps = Array_obj< ::Dynamic >::__new().Add(stream->readCapsStyle());		HX_STACK_VAR(startCaps,"startCaps");
				HX_STACK_LINE(606)
				Array< ::Dynamic > joints = Array_obj< ::Dynamic >::__new().Add(stream->readJoinStyle());		HX_STACK_VAR(joints,"joints");
				HX_STACK_LINE(607)
				bool hasFill = stream->readBool();		HX_STACK_VAR(hasFill,"hasFill");
				HX_STACK_LINE(608)
				Array< ::Dynamic > scale = Array_obj< ::Dynamic >::__new().Add(stream->readScaleMode());		HX_STACK_VAR(scale,"scale");
				HX_STACK_LINE(609)
				Array< bool > pixelHint = Array_obj< bool >::__new().Add(stream->readBool());		HX_STACK_VAR(pixelHint,"pixelHint");
				HX_STACK_LINE(610)
				int reserved = stream->readBits((int)5,null());		HX_STACK_VAR(reserved,"reserved");
				HX_STACK_LINE(611)
				bool noClose = stream->readBool();		HX_STACK_VAR(noClose,"noClose");
				HX_STACK_LINE(612)
				::native::display::CapsStyle endCaps = stream->readCapsStyle();		HX_STACK_VAR(endCaps,"endCaps");
				HX_STACK_LINE(613)
				Array< Float > miter = Array_obj< Float >::__new().Add((  (((joints->__get((int)0).StaticCast< ::native::display::JointStyle >() == ::native::display::JointStyle_obj::MITER))) ? Float((Float(stream->readDepth()) / Float(256.0))) : Float((int)1) ));		HX_STACK_VAR(miter,"miter");
				HX_STACK_LINE(614)
				Array< int > color = Array_obj< int >::__new().Add((  ((hasFill)) ? int((int)0) : int(stream->readRGB()) ));		HX_STACK_VAR(color,"color");
				HX_STACK_LINE(615)
				Array< Float > A = Array_obj< Float >::__new().Add((  ((hasFill)) ? Float(1.0) : Float((Float(stream->readByte()) / Float(255.0))) ));		HX_STACK_VAR(A,"A");
				HX_STACK_LINE(617)
				if ((hasFill)){
					HX_STACK_LINE(619)
					int fill = stream->readByte();		HX_STACK_VAR(fill,"fill");
					HX_STACK_LINE(622)
					if (((((int(fill) & int((int)16))) != (int)0))){
						HX_STACK_LINE(624)
						Array< ::Dynamic > matrix = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix,"matrix");
						HX_STACK_LINE(626)
						stream->alignBits();
						HX_STACK_LINE(628)
						Array< ::Dynamic > spread = Array_obj< ::Dynamic >::__new().Add(stream->readSpreadMethod());		HX_STACK_VAR(spread,"spread");
						HX_STACK_LINE(629)
						Array< ::Dynamic > interp = Array_obj< ::Dynamic >::__new().Add(stream->readInterpolationMethod());		HX_STACK_VAR(interp,"interp");
						HX_STACK_LINE(630)
						int numColors = stream->readBits((int)4,null());		HX_STACK_VAR(numColors,"numColors");
						HX_STACK_LINE(632)
						Array< ::Dynamic > colors = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(colors,"colors");
						HX_STACK_LINE(633)
						Array< ::Dynamic > alphas = Array_obj< ::Dynamic >::__new().Add(Array_obj< Float >::__new());		HX_STACK_VAR(alphas,"alphas");
						HX_STACK_LINE(634)
						Array< ::Dynamic > ratios = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(ratios,"ratios");
						HX_STACK_LINE(636)
						{
							HX_STACK_LINE(636)
							int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(636)
							while(((_g1 < numColors))){
								HX_STACK_LINE(636)
								int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
								HX_STACK_LINE(638)
								ratios->__get((int)0).StaticCast< Array< int > >()->push(stream->readByte());
								HX_STACK_LINE(639)
								colors->__get((int)0).StaticCast< Array< int > >()->push(stream->readRGB());
								HX_STACK_LINE(640)
								alphas->__get((int)0).StaticCast< Array< Float > >()->push((Float(stream->readByte()) / Float(255.0)));
							}
						}
						HX_STACK_LINE(644)
						Array< Float > focus = Array_obj< Float >::__new().Add((  (((fill == ::format::swf::symbol::Shape_obj::ftRadialF))) ? Float((Float(stream->readByte()) / Float(255.0))) : Float(0.0) ));		HX_STACK_VAR(focus,"focus");
						HX_STACK_LINE(645)
						Array< ::Dynamic > type = Array_obj< ::Dynamic >::__new().Add((  (((fill == ::format::swf::symbol::Shape_obj::ftLinear))) ? ::native::display::GradientType(::native::display::GradientType_obj::LINEAR) : ::native::display::GradientType(::native::display::GradientType_obj::RADIAL) ));		HX_STACK_VAR(type,"type");

						HX_BEGIN_LOCAL_FUNC_S14(hx::LocalFunc,_Function_6_1,Array< bool >,pixelHint,Array< Float >,width,Array< Float >,miter,Array< Float >,focus,Array< ::Dynamic >,scale,Array< ::Dynamic >,ratios,Array< ::Dynamic >,alphas,Array< ::Dynamic >,startCaps,Array< ::Dynamic >,joints,Array< ::Dynamic >,spread,Array< ::Dynamic >,matrix,Array< ::Dynamic >,type,Array< ::Dynamic >,colors,Array< ::Dynamic >,interp)
						Void run(::native::display::Graphics g){
							HX_STACK_PUSH("*::_Function_6_1","format/swf/symbol/Shape.hx",647);
							HX_STACK_ARG(g,"g");
							{
								HX_STACK_LINE(649)
								g->lineStyle(width->__get((int)0),(int)0,(int)1,pixelHint->__get((int)0),scale->__get((int)0).StaticCast< ::native::display::LineScaleMode >(),startCaps->__get((int)0).StaticCast< ::native::display::CapsStyle >(),joints->__get((int)0).StaticCast< ::native::display::JointStyle >(),miter->__get((int)0));
								HX_STACK_LINE(650)
								g->lineGradientStyle(type->__get((int)0).StaticCast< ::native::display::GradientType >(),colors->__get((int)0).StaticCast< Array< int > >(),alphas->__get((int)0).StaticCast< Array< Float > >(),ratios->__get((int)0).StaticCast< Array< int > >(),matrix->__get((int)0).StaticCast< ::native::geom::Matrix >(),spread->__get((int)0).StaticCast< ::native::display::SpreadMethod >(),interp->__get((int)0).StaticCast< ::native::display::InterpolationMethod >(),focus->__get((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC1((void))

						HX_STACK_LINE(647)
						result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_6_1(pixelHint,width,miter,focus,scale,ratios,alphas,startCaps,joints,spread,matrix,type,colors,interp)));
					}
					else{
						HX_STACK_LINE(654)
						hx::Throw (HX_CSTRING("Unknown fillStyle"));
					}
				}
				else{

					HX_BEGIN_LOCAL_FUNC_S8(hx::LocalFunc,_Function_5_1,Array< bool >,pixelHint,Array< Float >,width,Array< Float >,miter,Array< int >,color,Array< ::Dynamic >,scale,Array< ::Dynamic >,startCaps,Array< ::Dynamic >,joints,Array< Float >,A)
					Void run(::native::display::Graphics g){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/Shape.hx",662);
						HX_STACK_ARG(g,"g");
						{
							HX_STACK_LINE(662)
							g->lineStyle(width->__get((int)0),color->__get((int)0),A->__get((int)0),pixelHint->__get((int)0),scale->__get((int)0).StaticCast< ::native::display::LineScaleMode >(),startCaps->__get((int)0).StaticCast< ::native::display::CapsStyle >(),joints->__get((int)0).StaticCast< ::native::display::JointStyle >(),miter->__get((int)0));
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(660)
					result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(pixelHint,width,miter,color,scale,startCaps,joints,A)));
				}
			}
			else{
				HX_STACK_LINE(672)
				stream->alignBits();
				HX_STACK_LINE(674)
				Array< Float > width = Array_obj< Float >::__new().Add((stream->readDepth() * 0.05));		HX_STACK_VAR(width,"width");
				HX_STACK_LINE(675)
				Array< int > RGB = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(RGB,"RGB");
				HX_STACK_LINE(676)
				Array< Float > A = Array_obj< Float >::__new().Add((  (((version >= (int)3))) ? Float((Float(stream->readByte()) / Float(255.0))) : Float(1.0) ));		HX_STACK_VAR(A,"A");

				HX_BEGIN_LOCAL_FUNC_S3(hx::LocalFunc,_Function_4_1,Array< Float >,A,Array< Float >,width,Array< int >,RGB)
				Void run(::native::display::Graphics g){
					HX_STACK_PUSH("*::_Function_4_1","format/swf/symbol/Shape.hx",678);
					HX_STACK_ARG(g,"g");
					{
						HX_STACK_LINE(678)
						g->lineStyle(width->__get((int)0),RGB->__get((int)0),A->__get((int)0),null(),null(),null(),null(),null());
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				HX_STACK_LINE(678)
				result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_4_1(A,width,RGB)));
			}
		}
	}
	HX_STACK_LINE(688)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(Shape_obj,readLineStyles,return )

Dynamic Shape_obj::readFillStyles( ::format::swf::data::SWFStream stream,int version){
	HX_STACK_PUSH("Shape::readFillStyles","format/swf/symbol/Shape.hx",409);
	HX_STACK_THIS(this);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_ARG(version,"version");
	HX_STACK_LINE(411)
	Dynamic result = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(result,"result");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	Void run(::native::display::Graphics g){
		HX_STACK_PUSH("*::_Function_1_1","format/swf/symbol/Shape.hx",414);
		HX_STACK_ARG(g,"g");
		{
			HX_STACK_LINE(414)
			g->endFill();
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_STACK_LINE(414)
	result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_1_1()));
	HX_STACK_LINE(420)
	int count = stream->readArraySize(true);		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(422)
	{
		HX_STACK_LINE(422)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(422)
		while(((_g < count))){
			HX_STACK_LINE(422)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(424)
			int fill = stream->readByte();		HX_STACK_VAR(fill,"fill");
			HX_STACK_LINE(426)
			if (((fill == ::format::swf::symbol::Shape_obj::ftSolid))){
				HX_STACK_LINE(428)
				Array< int > RGB = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(RGB,"RGB");
				HX_STACK_LINE(430)
				Array< Float > A = Array_obj< Float >::__new().Add((  (((version >= (int)3))) ? Float((Float(stream->readByte()) / Float(255.0))) : Float(1.0) ));		HX_STACK_VAR(A,"A");

				HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_4_1,Array< int >,RGB,Array< Float >,A)
				Void run(::native::display::Graphics g){
					HX_STACK_PUSH("*::_Function_4_1","format/swf/symbol/Shape.hx",432);
					HX_STACK_ARG(g,"g");
					{
						HX_STACK_LINE(432)
						g->beginFill(RGB->__get((int)0),A->__get((int)0));
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				HX_STACK_LINE(432)
				result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_4_1(RGB,A)));
			}
			else{
				HX_STACK_LINE(438)
				if (((bool((bool((fill == ::format::swf::symbol::Shape_obj::ftLinear)) || bool((fill == ::format::swf::symbol::Shape_obj::ftRadial)))) || bool((fill == ::format::swf::symbol::Shape_obj::ftRadialF))))){
					HX_STACK_LINE(442)
					Array< ::Dynamic > matrix = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix,"matrix");
					HX_STACK_LINE(444)
					stream->alignBits();
					HX_STACK_LINE(446)
					Array< ::Dynamic > spread = Array_obj< ::Dynamic >::__new().Add(stream->readSpreadMethod());		HX_STACK_VAR(spread,"spread");
					HX_STACK_LINE(447)
					Array< ::Dynamic > interp = Array_obj< ::Dynamic >::__new().Add(stream->readInterpolationMethod());		HX_STACK_VAR(interp,"interp");
					HX_STACK_LINE(448)
					int numColors = stream->readBits((int)4,null());		HX_STACK_VAR(numColors,"numColors");
					HX_STACK_LINE(450)
					Array< ::Dynamic > colors = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(colors,"colors");
					HX_STACK_LINE(451)
					Array< ::Dynamic > alphas = Array_obj< ::Dynamic >::__new().Add(Array_obj< Float >::__new());		HX_STACK_VAR(alphas,"alphas");
					HX_STACK_LINE(452)
					Array< ::Dynamic > ratios = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(ratios,"ratios");
					HX_STACK_LINE(454)
					{
						HX_STACK_LINE(454)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(454)
						while(((_g1 < numColors))){
							HX_STACK_LINE(454)
							int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
							HX_STACK_LINE(456)
							ratios->__get((int)0).StaticCast< Array< int > >()->push(stream->readByte());
							HX_STACK_LINE(457)
							colors->__get((int)0).StaticCast< Array< int > >()->push(stream->readRGB());
							HX_STACK_LINE(458)
							alphas->__get((int)0).StaticCast< Array< Float > >()->push((  (((version >= (int)3))) ? Float((Float(stream->readByte()) / Float(255.0))) : Float(1.0) ));
						}
					}
					HX_STACK_LINE(462)
					Array< Float > focus = Array_obj< Float >::__new().Add((  (((fill == ::format::swf::symbol::Shape_obj::ftRadialF))) ? Float(stream->readFixed8()) : Float(0.0) ));		HX_STACK_VAR(focus,"focus");
					HX_STACK_LINE(463)
					Array< ::Dynamic > type = Array_obj< ::Dynamic >::__new().Add((  (((fill == ::format::swf::symbol::Shape_obj::ftLinear))) ? ::native::display::GradientType(::native::display::GradientType_obj::LINEAR) : ::native::display::GradientType(::native::display::GradientType_obj::RADIAL) ));		HX_STACK_VAR(type,"type");
					HX_STACK_LINE(465)
					this->hasGradientFill = true;

					HX_BEGIN_LOCAL_FUNC_S8(hx::LocalFunc,_Function_5_1,Array< Float >,focus,Array< ::Dynamic >,ratios,Array< ::Dynamic >,alphas,Array< ::Dynamic >,spread,Array< ::Dynamic >,matrix,Array< ::Dynamic >,type,Array< ::Dynamic >,colors,Array< ::Dynamic >,interp)
					Void run(::native::display::Graphics g){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/Shape.hx",467);
						HX_STACK_ARG(g,"g");
						{
							HX_STACK_LINE(467)
							g->beginGradientFill(type->__get((int)0).StaticCast< ::native::display::GradientType >(),colors->__get((int)0).StaticCast< Array< int > >(),alphas->__get((int)0).StaticCast< Array< Float > >(),ratios->__get((int)0).StaticCast< Array< int > >(),matrix->__get((int)0).StaticCast< ::native::geom::Matrix >(),spread->__get((int)0).StaticCast< ::native::display::SpreadMethod >(),interp->__get((int)0).StaticCast< ::native::display::InterpolationMethod >(),focus->__get((int)0));
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(467)
					result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(focus,ratios,alphas,spread,matrix,type,colors,interp)));
				}
				else{
					HX_STACK_LINE(473)
					if (((bool((bool((bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapRepeatSmooth)) || bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapClippedSmooth)))) || bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapRepeat)))) || bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapClipped))))){
						HX_STACK_LINE(477)
						stream->alignBits();
						HX_STACK_LINE(479)
						Array< int > id = Array_obj< int >::__new().Add(stream->readID());		HX_STACK_VAR(id,"id");
						HX_STACK_LINE(480)
						Array< ::Dynamic > matrix = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix,"matrix");
						HX_STACK_LINE(484)
						hx::MultEq(matrix->__get((int)0).StaticCast< ::native::geom::Matrix >()->a,0.05);
						HX_STACK_LINE(485)
						hx::MultEq(matrix->__get((int)0).StaticCast< ::native::geom::Matrix >()->b,0.05);
						HX_STACK_LINE(486)
						hx::MultEq(matrix->__get((int)0).StaticCast< ::native::geom::Matrix >()->c,0.05);
						HX_STACK_LINE(487)
						hx::MultEq(matrix->__get((int)0).StaticCast< ::native::geom::Matrix >()->d,0.05);
						HX_STACK_LINE(489)
						stream->alignBits();
						HX_STACK_LINE(491)
						Array< bool > repeat = Array_obj< bool >::__new().Add((bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapRepeat)) || bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapRepeatSmooth))));		HX_STACK_VAR(repeat,"repeat");
						HX_STACK_LINE(492)
						Array< bool > smooth = Array_obj< bool >::__new().Add((bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapRepeatSmooth)) || bool((fill == ::format::swf::symbol::Shape_obj::ftBitmapClippedSmooth))));		HX_STACK_VAR(smooth,"smooth");
						HX_STACK_LINE(494)
						Array< ::Dynamic > bitmap = Array_obj< ::Dynamic >::__new().Add(null());		HX_STACK_VAR(bitmap,"bitmap");
						HX_STACK_LINE(496)
						if (((id->__get((int)0) != (int)65535))){
							HX_STACK_LINE(498)
							::format::swf::symbol::Symbol _g1 = this->swf->getSymbol(id->__get((int)0));		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(498)
							{
								::format::swf::symbol::Symbol _switch_1 = (_g1);
								switch((_switch_1)->GetIndex()){
									case 3: {
										::format::swf::symbol::Bitmap _g1_ebitmapSymbol_0 = _switch_1->__Param(0);
{
											HX_STACK_LINE(500)
											bitmap[(int)0] = _g1_ebitmapSymbol_0->bitmapData;
										}
									}
									;break;
									default: {
									}
								}
							}
						}
						HX_STACK_LINE(511)
						if (((bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >() != null()))){
							HX_STACK_LINE(513)
							if ((repeat->__get((int)0))){
								HX_STACK_LINE(513)
								this->hasBitmapRepeat = true;
							}

							HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_7_1,Array< bool >,repeat,Array< ::Dynamic >,bitmap,Array< ::Dynamic >,matrix,Array< bool >,smooth)
							Void run(::native::display::Graphics g){
								HX_STACK_PUSH("*::_Function_7_1","format/swf/symbol/Shape.hx",519);
								HX_STACK_ARG(g,"g");
								{
									HX_STACK_LINE(519)
									g->beginBitmapFill(bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >(),matrix->__get((int)0).StaticCast< ::native::geom::Matrix >(),repeat->__get((int)0),smooth->__get((int)0));
								}
								return null();
							}
							HX_END_LOCAL_FUNC1((void))

							HX_STACK_LINE(519)
							result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_7_1(repeat,bitmap,matrix,smooth)));
						}
						else{
							HX_STACK_LINE(529)
							Array< ::Dynamic > s = Array_obj< ::Dynamic >::__new().Add(this->swf);		HX_STACK_VAR(s,"s");
							HX_STACK_LINE(530)
							Array< ::Dynamic > me = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(me,"me");

							HX_BEGIN_LOCAL_FUNC_S7(hx::LocalFunc,_Function_7_1,Array< bool >,smooth,Array< ::Dynamic >,s,Array< ::Dynamic >,me,Array< int >,id,Array< bool >,repeat,Array< ::Dynamic >,matrix,Array< ::Dynamic >,bitmap)
							Void run(::native::display::Graphics g){
								HX_STACK_PUSH("*::_Function_7_1","format/swf/symbol/Shape.hx",532);
								HX_STACK_ARG(g,"g");
								{
									HX_STACK_LINE(534)
									if (((bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >() == null()))){
										HX_STACK_LINE(536)
										if (((id->__get((int)0) != (int)65535))){
											HX_STACK_LINE(538)
											::format::swf::symbol::Symbol _g1 = s->__get((int)0).StaticCast< ::format::SWF >()->getSymbol(id->__get((int)0));		HX_STACK_VAR(_g1,"_g1");
											HX_STACK_LINE(538)
											{
												::format::swf::symbol::Symbol _switch_2 = (_g1);
												switch((_switch_2)->GetIndex()){
													case 3: {
														::format::swf::symbol::Bitmap _g1_ebitmapSymbol_0 = _switch_2->__Param(0);
{
															HX_STACK_LINE(540)
															bitmap[(int)0] = _g1_ebitmapSymbol_0->bitmapData;
														}
													}
													;break;
													default: {
													}
												}
											}
										}
										HX_STACK_LINE(551)
										if (((bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >() == null()))){
											HX_STACK_LINE(553)
											me->__get((int)0).StaticCast< ::format::swf::symbol::Shape >()->waitingLoader = true;
											HX_STACK_LINE(554)
											g->endFill();
											HX_STACK_LINE(555)
											return null();
										}
										else{
											HX_STACK_LINE(557)
											me[(int)0] = null();
										}
									}
									HX_STACK_LINE(565)
									g->beginBitmapFill(bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >(),matrix->__get((int)0).StaticCast< ::native::geom::Matrix >(),repeat->__get((int)0),smooth->__get((int)0));
								}
								return null();
							}
							HX_END_LOCAL_FUNC1((void))

							HX_STACK_LINE(532)
							result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_7_1(smooth,s,me,id,repeat,matrix,bitmap)));
						}
					}
					else{
						HX_STACK_LINE(571)
						hx::Throw ((HX_CSTRING("Unknown fill style : 0x") + ::StringTools_obj::hex(fill,null())));
					}
				}
			}
		}
	}
	HX_STACK_LINE(579)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(Shape_obj,readFillStyles,return )

Void Shape_obj::flushCommands( Dynamic edges,Array< ::Dynamic > fills){
{
		HX_STACK_PUSH("Shape::flushCommands","format/swf/symbol/Shape.hx",309);
		HX_STACK_THIS(this);
		HX_STACK_ARG(edges,"edges");
		HX_STACK_ARG(fills,"fills");
		HX_STACK_LINE(311)
		int left = fills->length;		HX_STACK_VAR(left,"left");
		HX_STACK_LINE(313)
		while(((left > (int)0))){
			HX_STACK_LINE(315)
			::format::swf::symbol::ShapeEdge first = fills->__get((int)0).StaticCast< ::format::swf::symbol::ShapeEdge >();		HX_STACK_VAR(first,"first");
			HX_STACK_LINE(316)
			fills[(int)0] = fills->__get(--(left)).StaticCast< ::format::swf::symbol::ShapeEdge >();
			HX_STACK_LINE(318)
			if (((first->fillStyle >= this->fillStyles->__Field(HX_CSTRING("length"),true)))){
				HX_STACK_LINE(318)
				hx::Throw (HX_CSTRING("Invalid fill style"));
			}
			HX_STACK_LINE(324)
			this->commands->__Field(HX_CSTRING("push"),true)(this->fillStyles->__GetItem(first->fillStyle));
			HX_STACK_LINE(326)
			Array< Float > mx = Array_obj< Float >::__new().Add(first->x0);		HX_STACK_VAR(mx,"mx");
			HX_STACK_LINE(327)
			Array< Float > my = Array_obj< Float >::__new().Add(first->y0);		HX_STACK_VAR(my,"my");

			HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_2_1,Array< Float >,mx,Array< Float >,my)
			Void run(::native::display::Graphics gfx){
				HX_STACK_PUSH("*::_Function_2_1","format/swf/symbol/Shape.hx",329);
				HX_STACK_ARG(gfx,"gfx");
				{
					HX_STACK_LINE(329)
					gfx->moveTo(mx->__get((int)0),my->__get((int)0));
				}
				return null();
			}
			HX_END_LOCAL_FUNC1((void))

			HX_STACK_LINE(329)
			this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_2_1(mx,my)));
			HX_STACK_LINE(335)
			this->commands->__Field(HX_CSTRING("push"),true)(first->asCommand());
			HX_STACK_LINE(337)
			::format::swf::symbol::ShapeEdge prev = first;		HX_STACK_VAR(prev,"prev");
			HX_STACK_LINE(338)
			bool loop = false;		HX_STACK_VAR(loop,"loop");
			HX_STACK_LINE(340)
			while((!(loop))){
				HX_STACK_LINE(342)
				bool found = false;		HX_STACK_VAR(found,"found");
				HX_STACK_LINE(344)
				{
					HX_STACK_LINE(344)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(344)
					while(((_g < left))){
						HX_STACK_LINE(344)
						int i = (_g)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(346)
						if ((prev->connects(fills->__get(i).StaticCast< ::format::swf::symbol::ShapeEdge >()))){
							HX_STACK_LINE(348)
							prev = fills->__get(i).StaticCast< ::format::swf::symbol::ShapeEdge >();
							HX_STACK_LINE(349)
							fills[i] = fills->__get(--(left)).StaticCast< ::format::swf::symbol::ShapeEdge >();
							HX_STACK_LINE(351)
							this->commands->__Field(HX_CSTRING("push"),true)(prev->asCommand());
							HX_STACK_LINE(353)
							found = true;
							HX_STACK_LINE(355)
							if ((prev->connects(first))){
								HX_STACK_LINE(355)
								loop = true;
							}
							HX_STACK_LINE(361)
							break;
						}
					}
				}
				HX_STACK_LINE(367)
				if ((!(found))){
					HX_STACK_LINE(369)
					::haxe::Log_obj::trace(HX_CSTRING("Remaining:"),hx::SourceInfo(HX_CSTRING("Shape.hx"),369,HX_CSTRING("format.swf.symbol.Shape"),HX_CSTRING("flushCommands")));
					HX_STACK_LINE(371)
					{
						HX_STACK_LINE(371)
						int _g = (int)0;		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(371)
						while(((_g < left))){
							HX_STACK_LINE(371)
							int f = (_g)++;		HX_STACK_VAR(f,"f");
							HX_STACK_LINE(372)
							fills->__get(f).StaticCast< ::format::swf::symbol::ShapeEdge >()->dump();
						}
					}
					HX_STACK_LINE(374)
					hx::Throw ((((((HX_CSTRING("Dangling fill : ") + prev->x1) + HX_CSTRING(",")) + prev->y1) + HX_CSTRING("  ")) + prev->fillStyle));
					HX_STACK_LINE(376)
					break;
				}
			}
		}
		HX_STACK_LINE(384)
		if (((fills->length > (int)0))){

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_1)
			Void run(::native::display::Graphics gfx){
				HX_STACK_PUSH("*::_Function_2_1","format/swf/symbol/Shape.hx",386);
				HX_STACK_ARG(gfx,"gfx");
				{
					HX_STACK_LINE(386)
					gfx->endFill();
				}
				return null();
			}
			HX_END_LOCAL_FUNC1((void))

			HX_STACK_LINE(384)
			this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_2_1()));
		}
		HX_STACK_LINE(394)
		this->commands = this->commands->__Field(HX_CSTRING("concat"),true)(edges);
		HX_STACK_LINE(396)
		if (((edges->__Field(HX_CSTRING("length"),true) > (int)0))){

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_1)
			Void run(::native::display::Graphics gfx){
				HX_STACK_PUSH("*::_Function_2_1","format/swf/symbol/Shape.hx",398);
				HX_STACK_ARG(gfx,"gfx");
				{
					HX_STACK_LINE(398)
					gfx->lineStyle(null(),null(),null(),null(),null(),null(),null(),null());
				}
				return null();
			}
			HX_END_LOCAL_FUNC1((void))

			HX_STACK_LINE(396)
			this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_2_1()));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Shape_obj,flushCommands,(void))

int Shape_obj::ftSolid;

int Shape_obj::ftLinear;

int Shape_obj::ftRadial;

int Shape_obj::ftRadialF;

int Shape_obj::ftBitmapRepeatSmooth;

int Shape_obj::ftBitmapClippedSmooth;

int Shape_obj::ftBitmapRepeat;

int Shape_obj::ftBitmapClipped;


Shape_obj::Shape_obj()
{
}

void Shape_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Shape);
	HX_MARK_MEMBER_NAME(waitingLoader,"waitingLoader");
	HX_MARK_MEMBER_NAME(swf,"swf");
	HX_MARK_MEMBER_NAME(hasScaled,"hasScaled");
	HX_MARK_MEMBER_NAME(hasNonScaled,"hasNonScaled");
	HX_MARK_MEMBER_NAME(fillStyles,"fillStyles");
	HX_MARK_MEMBER_NAME(edgeBounds,"edgeBounds");
	HX_MARK_MEMBER_NAME(commands,"commands");
	HX_MARK_MEMBER_NAME(bounds,"bounds");
	HX_MARK_MEMBER_NAME(hasGradientFill,"hasGradientFill");
	HX_MARK_MEMBER_NAME(hasCurves,"hasCurves");
	HX_MARK_MEMBER_NAME(hasBitmapRepeat,"hasBitmapRepeat");
	HX_MARK_END_CLASS();
}

void Shape_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(waitingLoader,"waitingLoader");
	HX_VISIT_MEMBER_NAME(swf,"swf");
	HX_VISIT_MEMBER_NAME(hasScaled,"hasScaled");
	HX_VISIT_MEMBER_NAME(hasNonScaled,"hasNonScaled");
	HX_VISIT_MEMBER_NAME(fillStyles,"fillStyles");
	HX_VISIT_MEMBER_NAME(edgeBounds,"edgeBounds");
	HX_VISIT_MEMBER_NAME(commands,"commands");
	HX_VISIT_MEMBER_NAME(bounds,"bounds");
	HX_VISIT_MEMBER_NAME(hasGradientFill,"hasGradientFill");
	HX_VISIT_MEMBER_NAME(hasCurves,"hasCurves");
	HX_VISIT_MEMBER_NAME(hasBitmapRepeat,"hasBitmapRepeat");
}

Dynamic Shape_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"swf") ) { return swf; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		if (HX_FIELD_EQ(inName,"bounds") ) { return bounds; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"ftSolid") ) { return ftSolid; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"ftLinear") ) { return ftLinear; }
		if (HX_FIELD_EQ(inName,"ftRadial") ) { return ftRadial; }
		if (HX_FIELD_EQ(inName,"commands") ) { return commands; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"ftRadialF") ) { return ftRadialF; }
		if (HX_FIELD_EQ(inName,"hasScaled") ) { return hasScaled; }
		if (HX_FIELD_EQ(inName,"hasCurves") ) { return hasCurves; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fillStyles") ) { return fillStyles; }
		if (HX_FIELD_EQ(inName,"edgeBounds") ) { return edgeBounds; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hasNonScaled") ) { return hasNonScaled; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"flushCommands") ) { return flushCommands_dyn(); }
		if (HX_FIELD_EQ(inName,"waitingLoader") ) { return waitingLoader; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"ftBitmapRepeat") ) { return ftBitmapRepeat; }
		if (HX_FIELD_EQ(inName,"readLineStyles") ) { return readLineStyles_dyn(); }
		if (HX_FIELD_EQ(inName,"readFillStyles") ) { return readFillStyles_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"ftBitmapClipped") ) { return ftBitmapClipped; }
		if (HX_FIELD_EQ(inName,"hasGradientFill") ) { return hasGradientFill; }
		if (HX_FIELD_EQ(inName,"hasBitmapRepeat") ) { return hasBitmapRepeat; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"ftBitmapRepeatSmooth") ) { return ftBitmapRepeatSmooth; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"ftBitmapClippedSmooth") ) { return ftBitmapClippedSmooth; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Shape_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"swf") ) { swf=inValue.Cast< ::format::SWF >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"bounds") ) { bounds=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"ftSolid") ) { ftSolid=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"ftLinear") ) { ftLinear=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ftRadial") ) { ftRadial=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"commands") ) { commands=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"ftRadialF") ) { ftRadialF=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasScaled") ) { hasScaled=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasCurves") ) { hasCurves=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fillStyles") ) { fillStyles=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"edgeBounds") ) { edgeBounds=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hasNonScaled") ) { hasNonScaled=inValue.Cast< bool >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"waitingLoader") ) { waitingLoader=inValue.Cast< bool >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"ftBitmapRepeat") ) { ftBitmapRepeat=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"ftBitmapClipped") ) { ftBitmapClipped=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasGradientFill") ) { hasGradientFill=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasBitmapRepeat") ) { hasBitmapRepeat=inValue.Cast< bool >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"ftBitmapRepeatSmooth") ) { ftBitmapRepeatSmooth=inValue.Cast< int >(); return inValue; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"ftBitmapClippedSmooth") ) { ftBitmapClippedSmooth=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Shape_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("waitingLoader"));
	outFields->push(HX_CSTRING("swf"));
	outFields->push(HX_CSTRING("hasScaled"));
	outFields->push(HX_CSTRING("hasNonScaled"));
	outFields->push(HX_CSTRING("fillStyles"));
	outFields->push(HX_CSTRING("edgeBounds"));
	outFields->push(HX_CSTRING("commands"));
	outFields->push(HX_CSTRING("bounds"));
	outFields->push(HX_CSTRING("hasGradientFill"));
	outFields->push(HX_CSTRING("hasCurves"));
	outFields->push(HX_CSTRING("hasBitmapRepeat"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ftSolid"),
	HX_CSTRING("ftLinear"),
	HX_CSTRING("ftRadial"),
	HX_CSTRING("ftRadialF"),
	HX_CSTRING("ftBitmapRepeatSmooth"),
	HX_CSTRING("ftBitmapClippedSmooth"),
	HX_CSTRING("ftBitmapRepeat"),
	HX_CSTRING("ftBitmapClipped"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("render"),
	HX_CSTRING("readLineStyles"),
	HX_CSTRING("readFillStyles"),
	HX_CSTRING("flushCommands"),
	HX_CSTRING("waitingLoader"),
	HX_CSTRING("swf"),
	HX_CSTRING("hasScaled"),
	HX_CSTRING("hasNonScaled"),
	HX_CSTRING("fillStyles"),
	HX_CSTRING("edgeBounds"),
	HX_CSTRING("commands"),
	HX_CSTRING("bounds"),
	HX_CSTRING("hasGradientFill"),
	HX_CSTRING("hasCurves"),
	HX_CSTRING("hasBitmapRepeat"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Shape_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Shape_obj::ftSolid,"ftSolid");
	HX_MARK_MEMBER_NAME(Shape_obj::ftLinear,"ftLinear");
	HX_MARK_MEMBER_NAME(Shape_obj::ftRadial,"ftRadial");
	HX_MARK_MEMBER_NAME(Shape_obj::ftRadialF,"ftRadialF");
	HX_MARK_MEMBER_NAME(Shape_obj::ftBitmapRepeatSmooth,"ftBitmapRepeatSmooth");
	HX_MARK_MEMBER_NAME(Shape_obj::ftBitmapClippedSmooth,"ftBitmapClippedSmooth");
	HX_MARK_MEMBER_NAME(Shape_obj::ftBitmapRepeat,"ftBitmapRepeat");
	HX_MARK_MEMBER_NAME(Shape_obj::ftBitmapClipped,"ftBitmapClipped");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Shape_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftSolid,"ftSolid");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftLinear,"ftLinear");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftRadial,"ftRadial");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftRadialF,"ftRadialF");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftBitmapRepeatSmooth,"ftBitmapRepeatSmooth");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftBitmapClippedSmooth,"ftBitmapClippedSmooth");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftBitmapRepeat,"ftBitmapRepeat");
	HX_VISIT_MEMBER_NAME(Shape_obj::ftBitmapClipped,"ftBitmapClipped");
};

Class Shape_obj::__mClass;

void Shape_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.Shape"), hx::TCanCast< Shape_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Shape_obj::__boot()
{
	ftSolid= (int)0;
	ftLinear= (int)16;
	ftRadial= (int)18;
	ftRadialF= (int)19;
	ftBitmapRepeatSmooth= (int)64;
	ftBitmapClippedSmooth= (int)65;
	ftBitmapRepeat= (int)66;
	ftBitmapClipped= (int)67;
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
