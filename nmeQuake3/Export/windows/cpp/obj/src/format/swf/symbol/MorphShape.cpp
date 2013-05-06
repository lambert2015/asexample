#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
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
#ifndef INCLUDED_format_swf_symbol_MorphEdge
#include <format/swf/symbol/MorphEdge.h>
#endif
#ifndef INCLUDED_format_swf_symbol_MorphShape
#include <format/swf/symbol/MorphShape.h>
#endif
#ifndef INCLUDED_format_swf_symbol_Symbol
#include <format/swf/symbol/Symbol.h>
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

Void MorphShape_obj::__construct(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{
HX_STACK_PUSH("MorphShape::new","format/swf/symbol/MorphShape.hx",37);
{
	HX_STACK_LINE(39)
	this->swf = swf;
	HX_STACK_LINE(41)
	stream->alignBits();
	HX_STACK_LINE(43)
	this->commands = Dynamic( Array_obj<Dynamic>::__new());
	HX_STACK_LINE(44)
	this->bounds0 = stream->readRect();
	HX_STACK_LINE(45)
	this->bounds1 = stream->readRect();
	HX_STACK_LINE(46)
	this->waitingLoader = false;
	HX_STACK_LINE(48)
	if (((version == (int)2))){
		HX_STACK_LINE(50)
		stream->alignBits();
		HX_STACK_LINE(52)
		this->edgeBounds0 = stream->readRect();
		HX_STACK_LINE(53)
		this->edgeBounds1 = stream->readRect();
		HX_STACK_LINE(55)
		stream->alignBits();
		HX_STACK_LINE(56)
		stream->readBits((int)6,null());
		HX_STACK_LINE(58)
		this->hasNonScaled = stream->readBool();
		HX_STACK_LINE(59)
		this->hasScaled = stream->readBool();
	}
	else{
		HX_STACK_LINE(63)
		this->edgeBounds0 = this->bounds0;
		HX_STACK_LINE(64)
		this->edgeBounds1 = this->bounds1;
		HX_STACK_LINE(66)
		this->hasScaled = true;
		HX_STACK_LINE(67)
		this->hasNonScaled = true;
	}
	HX_STACK_LINE(71)
	stream->alignBits();
	HX_STACK_LINE(73)
	int offset = stream->readInt();		HX_STACK_VAR(offset,"offset");
	HX_STACK_LINE(74)
	int endStart = (stream->getBytesLeft() - offset);		HX_STACK_VAR(endStart,"endStart");
	HX_STACK_LINE(76)
	Dynamic fillStyles = this->readFillStyles(stream,version);		HX_STACK_VAR(fillStyles,"fillStyles");
	HX_STACK_LINE(77)
	Dynamic lineStyles = this->readLineStyles(stream,version);		HX_STACK_VAR(lineStyles,"lineStyles");
	HX_STACK_LINE(79)
	stream->alignBits();
	HX_STACK_LINE(81)
	int fillBits = stream->readBits((int)4,null());		HX_STACK_VAR(fillBits,"fillBits");
	HX_STACK_LINE(82)
	int lineBits = stream->readBits((int)4,null());		HX_STACK_VAR(lineBits,"lineBits");
	HX_STACK_LINE(84)
	::List edges = ::List_obj::__new();		HX_STACK_VAR(edges,"edges");
	HX_STACK_LINE(86)
	Float penX = 0.0;		HX_STACK_VAR(penX,"penX");
	HX_STACK_LINE(87)
	Float penY = 0.0;		HX_STACK_VAR(penY,"penY");
	HX_STACK_LINE(89)
	while((true)){
		HX_STACK_LINE(91)
		bool edge = stream->readBool();		HX_STACK_VAR(edge,"edge");
		HX_STACK_LINE(93)
		if ((!(edge))){
			HX_STACK_LINE(95)
			bool newStyles = stream->readBool();		HX_STACK_VAR(newStyles,"newStyles");
			HX_STACK_LINE(96)
			bool newLineStyle = stream->readBool();		HX_STACK_VAR(newLineStyle,"newLineStyle");
			HX_STACK_LINE(97)
			bool newFillStyle1 = stream->readBool();		HX_STACK_VAR(newFillStyle1,"newFillStyle1");
			HX_STACK_LINE(98)
			bool newFillStyle0 = stream->readBool();		HX_STACK_VAR(newFillStyle0,"newFillStyle0");
			HX_STACK_LINE(99)
			bool moveTo = stream->readBool();		HX_STACK_VAR(moveTo,"moveTo");
			HX_STACK_LINE(101)
			if (((bool((bool((bool((bool(!(moveTo)) && bool(!(newStyles)))) && bool(!(newLineStyle)))) && bool(!(newFillStyle1)))) && bool(!(newFillStyle0))))){
				HX_STACK_LINE(101)
				break;
			}
			HX_STACK_LINE(107)
			newStyles = false;
			HX_STACK_LINE(116)
			if ((moveTo)){
				HX_STACK_LINE(118)
				int bits = stream->readBits((int)5,null());		HX_STACK_VAR(bits,"bits");
				HX_STACK_LINE(119)
				penX = stream->readTwips(bits);
				HX_STACK_LINE(120)
				penY = stream->readTwips(bits);
				HX_STACK_LINE(121)
				edges->add(::format::swf::symbol::MorphEdge_obj::meMove(penX,penY));
			}
			HX_STACK_LINE(125)
			if ((newFillStyle0)){
				HX_STACK_LINE(127)
				int fillStyle = stream->readBits(fillBits,null());		HX_STACK_VAR(fillStyle,"fillStyle");
				HX_STACK_LINE(129)
				if (((fillStyle >= fillStyles->__Field(HX_CSTRING("length"),true)))){
					HX_STACK_LINE(129)
					hx::Throw (HX_CSTRING("Invalid fill style"));
				}
				HX_STACK_LINE(135)
				edges->add(::format::swf::symbol::MorphEdge_obj::meStyle(fillStyles->__GetItem(fillStyle)));
			}
			HX_STACK_LINE(139)
			if ((newFillStyle1)){
				HX_STACK_LINE(141)
				int fillStyle = stream->readBits(fillBits,null());		HX_STACK_VAR(fillStyle,"fillStyle");
				HX_STACK_LINE(143)
				if (((fillStyle >= fillStyles->__Field(HX_CSTRING("length"),true)))){
					HX_STACK_LINE(143)
					hx::Throw (HX_CSTRING("Invalid fill style"));
				}
				HX_STACK_LINE(149)
				edges->add(::format::swf::symbol::MorphEdge_obj::meStyle(fillStyles->__GetItem(fillStyle)));
			}
			HX_STACK_LINE(153)
			if ((newLineStyle)){
				HX_STACK_LINE(155)
				int lineStyle = stream->readBits(lineBits,null());		HX_STACK_VAR(lineStyle,"lineStyle");
				HX_STACK_LINE(157)
				if (((lineStyle >= lineStyles->__Field(HX_CSTRING("length"),true)))){
					HX_STACK_LINE(157)
					hx::Throw (((((((HX_CSTRING("Invalid line style: ") + lineStyle) + HX_CSTRING("/")) + lineStyles->__Field(HX_CSTRING("length"),true)) + HX_CSTRING(" (")) + lineBits) + HX_CSTRING(")")));
				}
				HX_STACK_LINE(163)
				edges->add(::format::swf::symbol::MorphEdge_obj::meStyle(lineStyles->__GetItem(lineStyle)));
			}
		}
		else{
			HX_STACK_LINE(167)
			if ((stream->readBool())){
				HX_STACK_LINE(172)
				int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
				HX_STACK_LINE(174)
				Float x0 = penX;		HX_STACK_VAR(x0,"x0");
				HX_STACK_LINE(175)
				Float y0 = penY;		HX_STACK_VAR(y0,"y0");
				HX_STACK_LINE(177)
				if ((stream->readBool())){
					HX_STACK_LINE(179)
					hx::AddEq(penX,stream->readTwips(deltaBits));
					HX_STACK_LINE(180)
					hx::AddEq(penY,stream->readTwips(deltaBits));
				}
				else{
					HX_STACK_LINE(182)
					if ((stream->readBool())){
						HX_STACK_LINE(182)
						hx::AddEq(penY,stream->readTwips(deltaBits));
					}
					else{
						HX_STACK_LINE(186)
						hx::AddEq(penX,stream->readTwips(deltaBits));
					}
				}
				HX_STACK_LINE(192)
				edges->add(::format::swf::symbol::MorphEdge_obj::meLine((((penX + x0)) * 0.5),(((penY + y0)) * 0.5),penX,penY));
			}
			else{
				HX_STACK_LINE(197)
				int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
				HX_STACK_LINE(198)
				Float cx = (penX + stream->readTwips(deltaBits));		HX_STACK_VAR(cx,"cx");
				HX_STACK_LINE(199)
				Float cy = (penY + stream->readTwips(deltaBits));		HX_STACK_VAR(cy,"cy");
				HX_STACK_LINE(200)
				Float px = (cx + stream->readTwips(deltaBits));		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(201)
				Float py = (cy + stream->readTwips(deltaBits));		HX_STACK_VAR(py,"py");
				HX_STACK_LINE(204)
				penX = px;
				HX_STACK_LINE(205)
				penY = py;
				HX_STACK_LINE(206)
				edges->add(::format::swf::symbol::MorphEdge_obj::meCurve(cx,cy,penX,penY));
			}
		}
	}
	HX_STACK_LINE(214)
	penX = 0.0;
	HX_STACK_LINE(215)
	penY = 0.0;
	HX_STACK_LINE(216)
	stream->alignBits();
	HX_STACK_LINE(218)
	if (((endStart != stream->getBytesLeft()))){
		HX_STACK_LINE(218)
		hx::Throw (HX_CSTRING("End offset mismatch"));
	}
	HX_STACK_LINE(224)
	fillBits = stream->readBits((int)4,null());
	HX_STACK_LINE(225)
	lineBits = stream->readBits((int)4,null());
	HX_STACK_LINE(227)
	if (((bool((fillBits != (int)0)) || bool((lineBits != (int)0))))){
		HX_STACK_LINE(227)
		hx::Throw (HX_CSTRING("Unexpected style data in morph"));
	}
	HX_STACK_LINE(233)
	while((true)){
		HX_STACK_LINE(235)
		bool edge = stream->readBool();		HX_STACK_VAR(edge,"edge");
		HX_STACK_LINE(237)
		if ((!(edge))){
			HX_STACK_LINE(239)
			bool newStyles = stream->readBool();		HX_STACK_VAR(newStyles,"newStyles");
			HX_STACK_LINE(240)
			bool newLineStyle = stream->readBool();		HX_STACK_VAR(newLineStyle,"newLineStyle");
			HX_STACK_LINE(241)
			bool newFillStyle1 = stream->readBool();		HX_STACK_VAR(newFillStyle1,"newFillStyle1");
			HX_STACK_LINE(242)
			bool newFillStyle0 = stream->readBool();		HX_STACK_VAR(newFillStyle0,"newFillStyle0");
			HX_STACK_LINE(243)
			bool moveTo = stream->readBool();		HX_STACK_VAR(moveTo,"moveTo");
			HX_STACK_LINE(245)
			if (((bool((bool((bool(newLineStyle) || bool(newFillStyle0))) || bool(newFillStyle1))) || bool(newStyles)))){
				HX_STACK_LINE(245)
				hx::Throw (HX_CSTRING("Style change in Morph"));
			}
			HX_STACK_LINE(252)
			if ((!(moveTo))){
				HX_STACK_LINE(252)
				break;
			}
		}
		HX_STACK_LINE(261)
		Array< Float > x = Array_obj< Float >::__new().Add((int)0);		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(262)
		Array< Float > y = Array_obj< Float >::__new().Add((int)0);		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(263)
		Array< Float > cx = Array_obj< Float >::__new().Add((int)0);		HX_STACK_VAR(cx,"cx");
		HX_STACK_LINE(264)
		Array< Float > cy = Array_obj< Float >::__new().Add((int)0);		HX_STACK_VAR(cy,"cy");
		HX_STACK_LINE(265)
		bool isMove = false;		HX_STACK_VAR(isMove,"isMove");
		HX_STACK_LINE(266)
		bool isCurve = false;		HX_STACK_VAR(isCurve,"isCurve");
		HX_STACK_LINE(267)
		bool isLine = false;		HX_STACK_VAR(isLine,"isLine");
		HX_STACK_LINE(269)
		bool edgeFound = false;		HX_STACK_VAR(edgeFound,"edgeFound");
		HX_STACK_LINE(271)
		while((!(edgeFound))){
			HX_STACK_LINE(273)
			::format::swf::symbol::MorphEdge original = edges->pop();		HX_STACK_VAR(original,"original");
			HX_STACK_LINE(274)
			if (((original == null()))){
				HX_STACK_LINE(274)
				hx::Throw (HX_CSTRING("Too few edges in first shape"));
			}
			HX_STACK_LINE(280)
			edgeFound = true;
			HX_STACK_LINE(282)
			{
				::format::swf::symbol::MorphEdge _switch_1 = (original);
				switch((_switch_1)->GetIndex()){
					case 1: {
						Float original_emeMove_1 = _switch_1->__Param(1);
						Float original_emeMove_0 = _switch_1->__Param(0);
{
							HX_STACK_LINE(286)
							x[(int)0] = original_emeMove_0;
							HX_STACK_LINE(287)
							y[(int)0] = original_emeMove_1;
							HX_STACK_LINE(288)
							isMove = true;
							HX_STACK_LINE(295)
							if ((edge)){
								HX_STACK_LINE(297)
								Float px = penX;		HX_STACK_VAR(px,"px");
								HX_STACK_LINE(298)
								Float py = penY;		HX_STACK_VAR(py,"py");
								HX_STACK_LINE(301)
								edgeFound = false;
							}
						}
					}
					;break;
					case 2: {
						Float original_emeLine_3 = _switch_1->__Param(3);
						Float original_emeLine_2 = _switch_1->__Param(2);
						Float original_emeLine_1 = _switch_1->__Param(1);
						Float original_emeLine_0 = _switch_1->__Param(0);
{
							HX_STACK_LINE(307)
							cx[(int)0] = original_emeLine_0;
							HX_STACK_LINE(308)
							cy[(int)0] = original_emeLine_1;
							HX_STACK_LINE(309)
							x[(int)0] = original_emeLine_2;
							HX_STACK_LINE(310)
							y[(int)0] = original_emeLine_3;
							HX_STACK_LINE(311)
							isLine = true;
						}
					}
					;break;
					case 3: {
						Float original_emeCurve_3 = _switch_1->__Param(3);
						Float original_emeCurve_2 = _switch_1->__Param(2);
						Float original_emeCurve_1 = _switch_1->__Param(1);
						Float original_emeCurve_0 = _switch_1->__Param(0);
{
							HX_STACK_LINE(317)
							cx[(int)0] = original_emeCurve_0;
							HX_STACK_LINE(318)
							cy[(int)0] = original_emeCurve_1;
							HX_STACK_LINE(319)
							x[(int)0] = original_emeCurve_2;
							HX_STACK_LINE(320)
							y[(int)0] = original_emeCurve_3;
							HX_STACK_LINE(321)
							isCurve = true;
						}
					}
					;break;
					case 0: {
						Dynamic original_emeStyle_0 = _switch_1->__Param(0);
{
							HX_STACK_LINE(326)
							this->commands->__Field(HX_CSTRING("push"),true)(original_emeStyle_0);
							HX_STACK_LINE(327)
							edgeFound = false;
						}
					}
					;break;
				}
			}
		}
		HX_STACK_LINE(334)
		if ((!(edge))){
			HX_STACK_LINE(336)
			if ((!(isMove))){
				HX_STACK_LINE(336)
				hx::Throw (HX_CSTRING("MorphShape: mismatched move"));
			}
			HX_STACK_LINE(342)
			int bits = stream->readBits((int)5,null());		HX_STACK_VAR(bits,"bits");
			HX_STACK_LINE(343)
			penX = stream->readTwips(bits);
			HX_STACK_LINE(344)
			penY = stream->readTwips(bits);
			HX_STACK_LINE(345)
			Array< Float > px = Array_obj< Float >::__new().Add(penX);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(346)
			Array< Float > py = Array_obj< Float >::__new().Add(penY);		HX_STACK_VAR(py,"py");

			HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_3_1,Array< Float >,py,Array< Float >,px,Array< Float >,y,Array< Float >,x)
			Void run(::native::display::Graphics g,Float f){
				HX_STACK_PUSH("*::_Function_3_1","format/swf/symbol/MorphShape.hx",348);
				HX_STACK_ARG(g,"g");
				HX_STACK_ARG(f,"f");
				{
					HX_STACK_LINE(348)
					g->moveTo((x->__get((int)0) + (((px->__get((int)0) - x->__get((int)0))) * f)),(y->__get((int)0) + (((py->__get((int)0) - y->__get((int)0))) * f)));
				}
				return null();
			}
			HX_END_LOCAL_FUNC2((void))

			HX_STACK_LINE(348)
			this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_3_1(py,px,y,x)));
		}
		else{
			HX_STACK_LINE(354)
			if ((stream->readBool())){
				HX_STACK_LINE(359)
				int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
				HX_STACK_LINE(361)
				Float x0 = penX;		HX_STACK_VAR(x0,"x0");
				HX_STACK_LINE(362)
				Float y0 = penY;		HX_STACK_VAR(y0,"y0");
				HX_STACK_LINE(364)
				if ((stream->readBool())){
					HX_STACK_LINE(366)
					hx::AddEq(penX,stream->readTwips(deltaBits));
					HX_STACK_LINE(367)
					hx::AddEq(penY,stream->readTwips(deltaBits));
				}
				else{
					HX_STACK_LINE(369)
					if ((stream->readBool())){
						HX_STACK_LINE(369)
						hx::AddEq(penY,stream->readTwips(deltaBits));
					}
					else{
						HX_STACK_LINE(373)
						hx::AddEq(penX,stream->readTwips(deltaBits));
					}
				}
				HX_STACK_LINE(379)
				Array< Float > px = Array_obj< Float >::__new().Add(penX);		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(380)
				Array< Float > py = Array_obj< Float >::__new().Add(penY);		HX_STACK_VAR(py,"py");
				HX_STACK_LINE(382)
				if ((!(isLine))){
					HX_STACK_LINE(384)
					Array< Float > cx2 = Array_obj< Float >::__new().Add((((px->__get((int)0) + x0)) * 0.5));		HX_STACK_VAR(cx2,"cx2");
					HX_STACK_LINE(385)
					Array< Float > cy2 = Array_obj< Float >::__new().Add((((py->__get((int)0) + y0)) * 0.5));		HX_STACK_VAR(cy2,"cy2");

					HX_BEGIN_LOCAL_FUNC_S8(hx::LocalFunc,_Function_5_1,Array< Float >,cx,Array< Float >,cx2,Array< Float >,y,Array< Float >,py,Array< Float >,cy2,Array< Float >,x,Array< Float >,px,Array< Float >,cy)
					Void run(::native::display::Graphics g,Float f){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/MorphShape.hx",387);
						HX_STACK_ARG(g,"g");
						HX_STACK_ARG(f,"f");
						{
							HX_STACK_LINE(387)
							g->curveTo((cx->__get((int)0) + (((cx2->__get((int)0) - cx->__get((int)0))) * f)),(cy->__get((int)0) + (((cy2->__get((int)0) - cy->__get((int)0))) * f)),(x->__get((int)0) + (((px->__get((int)0) - x->__get((int)0))) * f)),(y->__get((int)0) + (((py->__get((int)0) - y->__get((int)0))) * f)));
						}
						return null();
					}
					HX_END_LOCAL_FUNC2((void))

					HX_STACK_LINE(387)
					this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(cx,cx2,y,py,cy2,x,px,cy)));
				}
				else{

					HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_5_1,Array< Float >,py,Array< Float >,px,Array< Float >,y,Array< Float >,x)
					Void run(::native::display::Graphics g,Float f){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/MorphShape.hx",395);
						HX_STACK_ARG(g,"g");
						HX_STACK_ARG(f,"f");
						{
							HX_STACK_LINE(395)
							g->lineTo((x->__get((int)0) + (((px->__get((int)0) - x->__get((int)0))) * f)),(y->__get((int)0) + (((py->__get((int)0) - y->__get((int)0))) * f)));
						}
						return null();
					}
					HX_END_LOCAL_FUNC2((void))

					HX_STACK_LINE(393)
					this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(py,px,y,x)));
				}
			}
			else{
				HX_STACK_LINE(407)
				int deltaBits = (stream->readBits((int)4,null()) + (int)2);		HX_STACK_VAR(deltaBits,"deltaBits");
				HX_STACK_LINE(408)
				Array< Float > cx2 = Array_obj< Float >::__new().Add((penX + stream->readTwips(deltaBits)));		HX_STACK_VAR(cx2,"cx2");
				HX_STACK_LINE(409)
				Array< Float > cy2 = Array_obj< Float >::__new().Add((penY + stream->readTwips(deltaBits)));		HX_STACK_VAR(cy2,"cy2");
				HX_STACK_LINE(410)
				Array< Float > px = Array_obj< Float >::__new().Add((cx2->__get((int)0) + stream->readTwips(deltaBits)));		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(411)
				Array< Float > py = Array_obj< Float >::__new().Add((cy2->__get((int)0) + stream->readTwips(deltaBits)));		HX_STACK_VAR(py,"py");
				HX_STACK_LINE(416)
				penX = px->__get((int)0);
				HX_STACK_LINE(417)
				penY = py->__get((int)0);

				HX_BEGIN_LOCAL_FUNC_S8(hx::LocalFunc,_Function_4_1,Array< Float >,cx,Array< Float >,cx2,Array< Float >,y,Array< Float >,py,Array< Float >,cy2,Array< Float >,x,Array< Float >,px,Array< Float >,cy)
				Void run(::native::display::Graphics g,Float f){
					HX_STACK_PUSH("*::_Function_4_1","format/swf/symbol/MorphShape.hx",419);
					HX_STACK_ARG(g,"g");
					HX_STACK_ARG(f,"f");
					{
						HX_STACK_LINE(419)
						g->curveTo((cx->__get((int)0) + (((cx2->__get((int)0) - cx->__get((int)0))) * f)),(cy->__get((int)0) + (((cy2->__get((int)0) - cy->__get((int)0))) * f)),(x->__get((int)0) + (((px->__get((int)0) - x->__get((int)0))) * f)),(y->__get((int)0) + (((py->__get((int)0) - y->__get((int)0))) * f)));
					}
					return null();
				}
				HX_END_LOCAL_FUNC2((void))

				HX_STACK_LINE(419)
				this->commands->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_4_1(cx,cx2,y,py,cy2,x,px,cy)));
			}
		}
	}
	HX_STACK_LINE(431)
	for(::cpp::FastIterator_obj< ::format::swf::symbol::MorphEdge > *__it = ::cpp::CreateFastIterator< ::format::swf::symbol::MorphEdge >(edges->iterator());  __it->hasNext(); ){
		::format::swf::symbol::MorphEdge edge = __it->next();
		{
			HX_STACK_LINE(431)
			{
				::format::swf::symbol::MorphEdge _switch_2 = (edge);
				switch((_switch_2)->GetIndex()){
					case 0: {
						Dynamic edge_emeStyle_0 = _switch_2->__Param(0);
{
							HX_STACK_LINE(435)
							this->commands->__Field(HX_CSTRING("push"),true)(edge_emeStyle_0);
						}
					}
					;break;
					default: {
						HX_STACK_LINE(439)
						hx::Throw (HX_CSTRING("Edge count mismatch"));
					}
				}
			}
		}
;
	}
	HX_STACK_LINE(447)
	this->swf = null();
}
;
	return null();
}

MorphShape_obj::~MorphShape_obj() { }

Dynamic MorphShape_obj::__CreateEmpty() { return  new MorphShape_obj; }
hx::ObjectPtr< MorphShape_obj > MorphShape_obj::__new(::format::SWF swf,::format::swf::data::SWFStream stream,int version)
{  hx::ObjectPtr< MorphShape_obj > result = new MorphShape_obj();
	result->__construct(swf,stream,version);
	return result;}

Dynamic MorphShape_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MorphShape_obj > result = new MorphShape_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

bool MorphShape_obj::render( ::native::display::Graphics graphics,Float f){
	HX_STACK_PUSH("MorphShape::render","format/swf/symbol/MorphShape.hx",830);
	HX_STACK_THIS(this);
	HX_STACK_ARG(graphics,"graphics");
	HX_STACK_ARG(f,"f");
	HX_STACK_LINE(832)
	this->waitingLoader = false;
	HX_STACK_LINE(834)
	{
		HX_STACK_LINE(834)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		Dynamic _g1 = this->commands;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(834)
		while(((_g < _g1->__Field(HX_CSTRING("length"),true)))){
			HX_STACK_LINE(834)
			Dynamic command = _g1->__GetItem(_g);		HX_STACK_VAR(command,"command");
			HX_STACK_LINE(834)
			++(_g);
			HX_STACK_LINE(836)
			command(graphics,f).Cast< Void >();
		}
	}
	HX_STACK_LINE(840)
	return this->waitingLoader;
}


HX_DEFINE_DYNAMIC_FUNC2(MorphShape_obj,render,return )

Dynamic MorphShape_obj::readLineStyles( ::format::swf::data::SWFStream stream,int version){
	HX_STACK_PUSH("MorphShape::readLineStyles","format/swf/symbol/MorphShape.hx",682);
	HX_STACK_THIS(this);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_ARG(version,"version");
	HX_STACK_LINE(684)
	Dynamic result = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(result,"result");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	Void run(::native::display::Graphics g,Float f){
		HX_STACK_PUSH("*::_Function_1_1","format/swf/symbol/MorphShape.hx",687);
		HX_STACK_ARG(g,"g");
		HX_STACK_ARG(f,"f");
		{
			HX_STACK_LINE(687)
			g->lineStyle(null(),null(),null(),null(),null(),null(),null(),null());
		}
		return null();
	}
	HX_END_LOCAL_FUNC2((void))

	HX_STACK_LINE(687)
	result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_1_1()));
	HX_STACK_LINE(693)
	int numStyles = stream->readArraySize(true);		HX_STACK_VAR(numStyles,"numStyles");
	HX_STACK_LINE(695)
	{
		HX_STACK_LINE(695)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(695)
		while(((_g < numStyles))){
			HX_STACK_LINE(695)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(697)
			if (((version == (int)1))){
				HX_STACK_LINE(699)
				stream->alignBits();
				HX_STACK_LINE(701)
				Array< Float > w0 = Array_obj< Float >::__new().Add((stream->readDepth() * 0.05));		HX_STACK_VAR(w0,"w0");
				HX_STACK_LINE(702)
				Array< Float > w1 = Array_obj< Float >::__new().Add((stream->readDepth() * 0.05));		HX_STACK_VAR(w1,"w1");
				HX_STACK_LINE(703)
				Array< int > RGB0 = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(RGB0,"RGB0");
				HX_STACK_LINE(704)
				Array< Float > A0 = Array_obj< Float >::__new().Add((Float(stream->readByte()) / Float(255.0)));		HX_STACK_VAR(A0,"A0");
				HX_STACK_LINE(705)
				Array< int > RGB1 = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(RGB1,"RGB1");
				HX_STACK_LINE(706)
				Array< Float > A1 = Array_obj< Float >::__new().Add((Float(stream->readByte()) / Float(255.0)));		HX_STACK_VAR(A1,"A1");

				HX_BEGIN_LOCAL_FUNC_S6(hx::LocalFunc,_Function_4_1,Array< Float >,w0,Array< Float >,A0,Array< int >,RGB1,Array< Float >,w1,Array< int >,RGB0,Array< Float >,A1)
				Void run(::native::display::Graphics g,Float f){
					HX_STACK_PUSH("*::_Function_4_1","format/swf/symbol/MorphShape.hx",708);
					HX_STACK_ARG(g,"g");
					HX_STACK_ARG(f,"f");
					{
						HX_STACK_LINE(708)
						g->lineStyle((w0->__get((int)0) + (((w1->__get((int)0) - w0->__get((int)0))) * f)),::format::swf::symbol::MorphShape_obj::interpolateColor(RGB0->__get((int)0),RGB1->__get((int)0),f),(A0->__get((int)0) + (((A1->__get((int)0) - A0->__get((int)0))) * f)),null(),null(),null(),null(),null());
					}
					return null();
				}
				HX_END_LOCAL_FUNC2((void))

				HX_STACK_LINE(708)
				result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_4_1(w0,A0,RGB1,w1,RGB0,A1)));
			}
			else{
				HX_STACK_LINE(718)
				stream->alignBits();
				HX_STACK_LINE(720)
				Array< Float > w0 = Array_obj< Float >::__new().Add((stream->readDepth() * 0.05));		HX_STACK_VAR(w0,"w0");
				HX_STACK_LINE(721)
				Array< Float > w1 = Array_obj< Float >::__new().Add((stream->readDepth() * 0.05));		HX_STACK_VAR(w1,"w1");
				HX_STACK_LINE(723)
				Array< ::Dynamic > startCaps = Array_obj< ::Dynamic >::__new().Add(stream->readCapsStyle());		HX_STACK_VAR(startCaps,"startCaps");
				HX_STACK_LINE(724)
				Array< ::Dynamic > joints = Array_obj< ::Dynamic >::__new().Add(stream->readJoinStyle());		HX_STACK_VAR(joints,"joints");
				HX_STACK_LINE(725)
				bool hasFill = stream->readBool();		HX_STACK_VAR(hasFill,"hasFill");
				HX_STACK_LINE(726)
				Array< ::Dynamic > scale = Array_obj< ::Dynamic >::__new().Add(stream->readScaleMode());		HX_STACK_VAR(scale,"scale");
				HX_STACK_LINE(727)
				Array< bool > pixelHint = Array_obj< bool >::__new().Add(stream->readBool());		HX_STACK_VAR(pixelHint,"pixelHint");
				HX_STACK_LINE(728)
				int reserved = stream->readBits((int)5,null());		HX_STACK_VAR(reserved,"reserved");
				HX_STACK_LINE(729)
				bool noClose = stream->readBool();		HX_STACK_VAR(noClose,"noClose");
				HX_STACK_LINE(730)
				::native::display::CapsStyle endCaps = stream->readCapsStyle();		HX_STACK_VAR(endCaps,"endCaps");
				HX_STACK_LINE(732)
				Array< Float > miter = Array_obj< Float >::__new().Add(1.0);		HX_STACK_VAR(miter,"miter");
				HX_STACK_LINE(734)
				if (((joints->__get((int)0).StaticCast< ::native::display::JointStyle >() == ::native::display::JointStyle_obj::MITER))){
					HX_STACK_LINE(734)
					miter[(int)0] = (Float(stream->readDepth()) / Float(256.0));
				}
				HX_STACK_LINE(740)
				if ((!(hasFill))){
					HX_STACK_LINE(742)
					Array< int > c0 = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(c0,"c0");
					HX_STACK_LINE(743)
					Array< Float > A0 = Array_obj< Float >::__new().Add((Float(stream->readByte()) / Float(255.0)));		HX_STACK_VAR(A0,"A0");
					HX_STACK_LINE(744)
					Array< int > c1 = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(c1,"c1");
					HX_STACK_LINE(745)
					Array< Float > A1 = Array_obj< Float >::__new().Add((Float(stream->readByte()) / Float(255.0)));		HX_STACK_VAR(A1,"A1");

					HX_BEGIN_LOCAL_FUNC_S11(hx::LocalFunc,_Function_5_1,Array< bool >,pixelHint,Array< Float >,w0,Array< Float >,miter,Array< int >,c1,Array< ::Dynamic >,scale,Array< int >,c0,Array< Float >,A1,Array< ::Dynamic >,startCaps,Array< Float >,A0,Array< ::Dynamic >,joints,Array< Float >,w1)
					Void run(::native::display::Graphics g,Float f){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/MorphShape.hx",747);
						HX_STACK_ARG(g,"g");
						HX_STACK_ARG(f,"f");
						{
							HX_STACK_LINE(747)
							g->lineStyle((w0->__get((int)0) + (((w1->__get((int)0) - w0->__get((int)0))) * f)),::format::swf::symbol::MorphShape_obj::interpolateColor(c0->__get((int)0),c1->__get((int)0),f),(A0->__get((int)0) + (((A1->__get((int)0) - A0->__get((int)0))) * f)),pixelHint->__get((int)0),scale->__get((int)0).StaticCast< ::native::display::LineScaleMode >(),startCaps->__get((int)0).StaticCast< ::native::display::CapsStyle >(),joints->__get((int)0).StaticCast< ::native::display::JointStyle >(),miter->__get((int)0));
						}
						return null();
					}
					HX_END_LOCAL_FUNC2((void))

					HX_STACK_LINE(747)
					result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(pixelHint,w0,miter,c1,scale,c0,A1,startCaps,A0,joints,w1)));
				}
				else{
					HX_STACK_LINE(755)
					int fill = stream->readByte();		HX_STACK_VAR(fill,"fill");
					HX_STACK_LINE(758)
					if (((((int(fill) & int((int)16))) != (int)0))){
						HX_STACK_LINE(760)
						Array< ::Dynamic > matrix0 = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix0,"matrix0");
						HX_STACK_LINE(762)
						stream->alignBits();
						HX_STACK_LINE(764)
						Array< ::Dynamic > matrix1 = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix1,"matrix1");
						HX_STACK_LINE(766)
						stream->alignBits();
						HX_STACK_LINE(771)
						Array< int > numColors = Array_obj< int >::__new().Add(stream->readBits((int)4,null()));		HX_STACK_VAR(numColors,"numColors");
						HX_STACK_LINE(773)
						Array< ::Dynamic > colors0 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(colors0,"colors0");
						HX_STACK_LINE(774)
						Array< ::Dynamic > colors1 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(colors1,"colors1");
						HX_STACK_LINE(775)
						Array< ::Dynamic > alphas0 = Array_obj< ::Dynamic >::__new().Add(Array_obj< Float >::__new());		HX_STACK_VAR(alphas0,"alphas0");
						HX_STACK_LINE(776)
						Array< ::Dynamic > alphas1 = Array_obj< ::Dynamic >::__new().Add(Array_obj< Float >::__new());		HX_STACK_VAR(alphas1,"alphas1");
						HX_STACK_LINE(777)
						Array< ::Dynamic > ratios0 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(ratios0,"ratios0");
						HX_STACK_LINE(778)
						Array< ::Dynamic > ratios1 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(ratios1,"ratios1");
						HX_STACK_LINE(780)
						{
							HX_STACK_LINE(780)
							int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(780)
							while(((_g1 < numColors->__get((int)0)))){
								HX_STACK_LINE(780)
								int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
								HX_STACK_LINE(782)
								ratios0->__get((int)0).StaticCast< Array< int > >()->push(stream->readByte());
								HX_STACK_LINE(783)
								colors0->__get((int)0).StaticCast< Array< int > >()->push(stream->readRGB());
								HX_STACK_LINE(784)
								alphas0->__get((int)0).StaticCast< Array< Float > >()->push((Float(stream->readByte()) / Float(255.0)));
								HX_STACK_LINE(785)
								ratios1->__get((int)0).StaticCast< Array< int > >()->push(stream->readByte());
								HX_STACK_LINE(786)
								colors1->__get((int)0).StaticCast< Array< int > >()->push(stream->readRGB());
								HX_STACK_LINE(787)
								alphas1->__get((int)0).StaticCast< Array< Float > >()->push((Float(stream->readByte()) / Float(255.0)));
							}
						}

						HX_BEGIN_LOCAL_FUNC_S9(hx::LocalFunc,_Function_6_1,Array< ::Dynamic >,ratios1,Array< ::Dynamic >,matrix0,Array< ::Dynamic >,ratios0,Array< ::Dynamic >,colors1,Array< ::Dynamic >,colors0,Array< ::Dynamic >,alphas1,Array< int >,numColors,Array< ::Dynamic >,alphas0,Array< ::Dynamic >,matrix1)
						Void run(::native::display::Graphics g,Float f){
							HX_STACK_PUSH("*::_Function_6_1","format/swf/symbol/MorphShape.hx",795);
							HX_STACK_ARG(g,"g");
							HX_STACK_ARG(f,"f");
							{
								HX_STACK_LINE(797)
								Array< int > cols = Array_obj< int >::__new();		HX_STACK_VAR(cols,"cols");
								HX_STACK_LINE(798)
								Array< Float > alphas = Array_obj< Float >::__new();		HX_STACK_VAR(alphas,"alphas");
								HX_STACK_LINE(799)
								Array< Float > ratios = Array_obj< Float >::__new();		HX_STACK_VAR(ratios,"ratios");
								HX_STACK_LINE(801)
								{
									HX_STACK_LINE(801)
									int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
									HX_STACK_LINE(801)
									while(((_g1 < numColors->__get((int)0)))){
										HX_STACK_LINE(801)
										int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
										HX_STACK_LINE(803)
										cols->push(::format::swf::symbol::MorphShape_obj::interpolateColor(colors0->__get((int)0).StaticCast< Array< int > >()->__get(i1),colors1->__get((int)0).StaticCast< Array< int > >()->__get(i1),f));
										HX_STACK_LINE(804)
										alphas->push((alphas0->__get((int)0).StaticCast< Array< Float > >()->__get(i1) + (((alphas1->__get((int)0).StaticCast< Array< Float > >()->__get(i1) - alphas0->__get((int)0).StaticCast< Array< Float > >()->__get(i1))) * f)));
										HX_STACK_LINE(805)
										ratios->push((ratios0->__get((int)0).StaticCast< Array< int > >()->__get(i1) + (((ratios1->__get((int)0).StaticCast< Array< int > >()->__get(i1) - ratios0->__get((int)0).StaticCast< Array< int > >()->__get(i1))) * f)));
									}
								}
								HX_STACK_LINE(809)
								g->lineGradientStyle(::native::display::GradientType_obj::LINEAR,cols,alphas,ratios,::format::swf::symbol::MorphShape_obj::interpolateMatrix(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >(),matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >(),f),null(),null(),null());
							}
							return null();
						}
						HX_END_LOCAL_FUNC2((void))

						HX_STACK_LINE(795)
						result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_6_1(ratios1,matrix0,ratios0,colors1,colors0,alphas1,numColors,alphas0,matrix1)));
					}
					else{
						HX_STACK_LINE(813)
						hx::Throw (((HX_CSTRING("Unknown fillstyle (") + fill) + HX_CSTRING(")")));
					}
				}
			}
		}
	}
	HX_STACK_LINE(825)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(MorphShape_obj,readLineStyles,return )

Dynamic MorphShape_obj::readFillStyles( ::format::swf::data::SWFStream stream,int version){
	HX_STACK_PUSH("MorphShape::readFillStyles","format/swf/symbol/MorphShape.hx",481);
	HX_STACK_THIS(this);
	HX_STACK_ARG(stream,"stream");
	HX_STACK_ARG(version,"version");
	HX_STACK_LINE(483)
	Dynamic result = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(result,"result");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	Void run(::native::display::Graphics g,Float f){
		HX_STACK_PUSH("*::_Function_1_1","format/swf/symbol/MorphShape.hx",486);
		HX_STACK_ARG(g,"g");
		HX_STACK_ARG(f,"f");
		{
			HX_STACK_LINE(486)
			g->endFill();
		}
		return null();
	}
	HX_END_LOCAL_FUNC2((void))

	HX_STACK_LINE(486)
	result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_1_1()));
	HX_STACK_LINE(492)
	int count = stream->readArraySize(true);		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(494)
	{
		HX_STACK_LINE(494)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(494)
		while(((_g < count))){
			HX_STACK_LINE(494)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(496)
			int fill = stream->readByte();		HX_STACK_VAR(fill,"fill");
			HX_STACK_LINE(498)
			if (((fill == ::format::swf::symbol::MorphShape_obj::ftSolid))){
				HX_STACK_LINE(500)
				Array< int > RGB0 = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(RGB0,"RGB0");
				HX_STACK_LINE(501)
				Array< Float > A0 = Array_obj< Float >::__new().Add((Float(stream->readByte()) / Float(255.0)));		HX_STACK_VAR(A0,"A0");
				HX_STACK_LINE(502)
				Array< int > RGB1 = Array_obj< int >::__new().Add(stream->readRGB());		HX_STACK_VAR(RGB1,"RGB1");
				HX_STACK_LINE(503)
				Float A1 = (Float(stream->readByte()) / Float(255.0));		HX_STACK_VAR(A1,"A1");
				HX_STACK_LINE(504)
				Array< Float > dA = Array_obj< Float >::__new().Add((A1 - A0->__get((int)0)));		HX_STACK_VAR(dA,"dA");

				HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_4_1,Array< Float >,A0,Array< int >,RGB1,Array< int >,RGB0,Array< Float >,dA)
				Void run(::native::display::Graphics g,Float f){
					HX_STACK_PUSH("*::_Function_4_1","format/swf/symbol/MorphShape.hx",506);
					HX_STACK_ARG(g,"g");
					HX_STACK_ARG(f,"f");
					{
						HX_STACK_LINE(506)
						g->beginFill(::format::swf::symbol::MorphShape_obj::interpolateColor(RGB0->__get((int)0),RGB1->__get((int)0),f),(A0->__get((int)0) + (dA->__get((int)0) * f)));
					}
					return null();
				}
				HX_END_LOCAL_FUNC2((void))

				HX_STACK_LINE(506)
				result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_4_1(A0,RGB1,RGB0,dA)));
			}
			else{
				HX_STACK_LINE(512)
				if (((((int(fill) & int((int)16))) != (int)0))){
					HX_STACK_LINE(516)
					Array< ::Dynamic > matrix0 = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix0,"matrix0");
					HX_STACK_LINE(518)
					stream->alignBits();
					HX_STACK_LINE(520)
					Array< ::Dynamic > matrix1 = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix1,"matrix1");
					HX_STACK_LINE(522)
					stream->alignBits();
					HX_STACK_LINE(527)
					Array< int > numColors = Array_obj< int >::__new().Add(stream->readBits((int)4,null()));		HX_STACK_VAR(numColors,"numColors");
					HX_STACK_LINE(529)
					Array< ::Dynamic > colors0 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(colors0,"colors0");
					HX_STACK_LINE(530)
					Array< ::Dynamic > colors1 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(colors1,"colors1");
					HX_STACK_LINE(531)
					Array< ::Dynamic > alphas0 = Array_obj< ::Dynamic >::__new().Add(Array_obj< Float >::__new());		HX_STACK_VAR(alphas0,"alphas0");
					HX_STACK_LINE(532)
					Array< ::Dynamic > alphas1 = Array_obj< ::Dynamic >::__new().Add(Array_obj< Float >::__new());		HX_STACK_VAR(alphas1,"alphas1");
					HX_STACK_LINE(533)
					Array< ::Dynamic > ratios0 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(ratios0,"ratios0");
					HX_STACK_LINE(534)
					Array< ::Dynamic > ratios1 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(ratios1,"ratios1");
					HX_STACK_LINE(536)
					{
						HX_STACK_LINE(536)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(536)
						while(((_g1 < numColors->__get((int)0)))){
							HX_STACK_LINE(536)
							int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
							HX_STACK_LINE(538)
							ratios0->__get((int)0).StaticCast< Array< int > >()->push(stream->readByte());
							HX_STACK_LINE(539)
							colors0->__get((int)0).StaticCast< Array< int > >()->push(stream->readRGB());
							HX_STACK_LINE(540)
							alphas0->__get((int)0).StaticCast< Array< Float > >()->push((Float(stream->readByte()) / Float(255.0)));
							HX_STACK_LINE(541)
							ratios1->__get((int)0).StaticCast< Array< int > >()->push(stream->readByte());
							HX_STACK_LINE(542)
							colors1->__get((int)0).StaticCast< Array< int > >()->push(stream->readRGB());
							HX_STACK_LINE(543)
							alphas1->__get((int)0).StaticCast< Array< Float > >()->push((Float(stream->readByte()) / Float(255.0)));
						}
					}

					HX_BEGIN_LOCAL_FUNC_S9(hx::LocalFunc,_Function_5_1,Array< ::Dynamic >,ratios1,Array< ::Dynamic >,matrix0,Array< ::Dynamic >,ratios0,Array< ::Dynamic >,colors1,Array< ::Dynamic >,colors0,Array< ::Dynamic >,alphas1,Array< int >,numColors,Array< ::Dynamic >,alphas0,Array< ::Dynamic >,matrix1)
					Void run(::native::display::Graphics g,Float f){
						HX_STACK_PUSH("*::_Function_5_1","format/swf/symbol/MorphShape.hx",551);
						HX_STACK_ARG(g,"g");
						HX_STACK_ARG(f,"f");
						{
							HX_STACK_LINE(553)
							Array< int > cols = Array_obj< int >::__new();		HX_STACK_VAR(cols,"cols");
							HX_STACK_LINE(554)
							Array< Float > alphas = Array_obj< Float >::__new();		HX_STACK_VAR(alphas,"alphas");
							HX_STACK_LINE(555)
							Array< Float > ratios = Array_obj< Float >::__new();		HX_STACK_VAR(ratios,"ratios");
							HX_STACK_LINE(557)
							{
								HX_STACK_LINE(557)
								int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
								HX_STACK_LINE(557)
								while(((_g1 < numColors->__get((int)0)))){
									HX_STACK_LINE(557)
									int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
									HX_STACK_LINE(559)
									cols->push(::format::swf::symbol::MorphShape_obj::interpolateColor(colors0->__get((int)0).StaticCast< Array< int > >()->__get(i1),colors1->__get((int)0).StaticCast< Array< int > >()->__get(i1),f));
									HX_STACK_LINE(560)
									alphas->push((alphas0->__get((int)0).StaticCast< Array< Float > >()->__get(i1) + (((alphas1->__get((int)0).StaticCast< Array< Float > >()->__get(i1) - alphas0->__get((int)0).StaticCast< Array< Float > >()->__get(i1))) * f)));
									HX_STACK_LINE(561)
									ratios->push((ratios0->__get((int)0).StaticCast< Array< int > >()->__get(i1) + (((ratios1->__get((int)0).StaticCast< Array< int > >()->__get(i1) - ratios0->__get((int)0).StaticCast< Array< int > >()->__get(i1))) * f)));
								}
							}
							HX_STACK_LINE(565)
							g->beginGradientFill(::native::display::GradientType_obj::LINEAR,cols,alphas,ratios,::format::swf::symbol::MorphShape_obj::interpolateMatrix(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >(),matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >(),f),null(),null(),null());
						}
						return null();
					}
					HX_END_LOCAL_FUNC2((void))

					HX_STACK_LINE(551)
					result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_5_1(ratios1,matrix0,ratios0,colors1,colors0,alphas1,numColors,alphas0,matrix1)));
				}
				else{
					HX_STACK_LINE(569)
					if (((((int(fill) & int((int)64))) != (int)0))){
						HX_STACK_LINE(573)
						Array< int > id = Array_obj< int >::__new().Add(stream->readID());		HX_STACK_VAR(id,"id");
						HX_STACK_LINE(574)
						Array< ::Dynamic > bitmap = Array_obj< ::Dynamic >::__new().Add(null());		HX_STACK_VAR(bitmap,"bitmap");
						HX_STACK_LINE(576)
						if (((id->__get((int)0) != (int)65535))){
							HX_STACK_LINE(578)
							::format::swf::symbol::Symbol _g1 = this->swf->getSymbol(id->__get((int)0));		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(578)
							{
								::format::swf::symbol::Symbol _switch_3 = (_g1);
								switch((_switch_3)->GetIndex()){
									case 3: {
										::format::swf::symbol::Bitmap _g1_ebitmapSymbol_0 = _switch_3->__Param(0);
{
											HX_STACK_LINE(580)
											bitmap[(int)0] = _g1_ebitmapSymbol_0->bitmapData;
										}
									}
									;break;
									default: {
									}
								}
							}
						}
						HX_STACK_LINE(591)
						stream->alignBits();
						HX_STACK_LINE(593)
						Array< ::Dynamic > matrix0 = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix0,"matrix0");
						HX_STACK_LINE(597)
						hx::MultEq(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >()->a,0.05);
						HX_STACK_LINE(598)
						hx::MultEq(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >()->b,0.05);
						HX_STACK_LINE(599)
						hx::MultEq(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >()->c,0.05);
						HX_STACK_LINE(600)
						hx::MultEq(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >()->d,0.05);
						HX_STACK_LINE(602)
						stream->alignBits();
						HX_STACK_LINE(604)
						Array< ::Dynamic > matrix1 = Array_obj< ::Dynamic >::__new().Add(stream->readMatrix());		HX_STACK_VAR(matrix1,"matrix1");
						HX_STACK_LINE(608)
						hx::MultEq(matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >()->a,0.05);
						HX_STACK_LINE(609)
						hx::MultEq(matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >()->b,0.05);
						HX_STACK_LINE(610)
						hx::MultEq(matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >()->c,0.05);
						HX_STACK_LINE(611)
						hx::MultEq(matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >()->d,0.05);
						HX_STACK_LINE(613)
						stream->alignBits();
						HX_STACK_LINE(618)
						if (((bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >() != null()))){

							HX_BEGIN_LOCAL_FUNC_S3(hx::LocalFunc,_Function_7_1,Array< ::Dynamic >,matrix0,Array< ::Dynamic >,bitmap,Array< ::Dynamic >,matrix1)
							Void run(::native::display::Graphics g,Float f){
								HX_STACK_PUSH("*::_Function_7_1","format/swf/symbol/MorphShape.hx",620);
								HX_STACK_ARG(g,"g");
								HX_STACK_ARG(f,"f");
								{
									HX_STACK_LINE(620)
									g->beginBitmapFill(bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >(),::format::swf::symbol::MorphShape_obj::interpolateMatrix(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >(),matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >(),f),null(),null());
								}
								return null();
							}
							HX_END_LOCAL_FUNC2((void))

							HX_STACK_LINE(618)
							result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_7_1(matrix0,bitmap,matrix1)));
						}
						else{
							HX_STACK_LINE(630)
							Array< ::Dynamic > s = Array_obj< ::Dynamic >::__new().Add(this->swf);		HX_STACK_VAR(s,"s");
							HX_STACK_LINE(631)
							Array< ::Dynamic > me = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(me,"me");

							HX_BEGIN_LOCAL_FUNC_S6(hx::LocalFunc,_Function_7_1,Array< ::Dynamic >,matrix0,Array< ::Dynamic >,bitmap,Array< int >,id,Array< ::Dynamic >,s,Array< ::Dynamic >,me,Array< ::Dynamic >,matrix1)
							Void run(::native::display::Graphics g,Float f){
								HX_STACK_PUSH("*::_Function_7_1","format/swf/symbol/MorphShape.hx",633);
								HX_STACK_ARG(g,"g");
								HX_STACK_ARG(f,"f");
								{
									HX_STACK_LINE(635)
									if (((bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >() == null()))){
										HX_STACK_LINE(637)
										if (((id->__get((int)0) != (int)65535))){
											HX_STACK_LINE(639)
											::format::swf::symbol::Symbol _g1 = s->__get((int)0).StaticCast< ::format::SWF >()->getSymbol(id->__get((int)0));		HX_STACK_VAR(_g1,"_g1");
											HX_STACK_LINE(639)
											{
												::format::swf::symbol::Symbol _switch_4 = (_g1);
												switch((_switch_4)->GetIndex()){
													case 3: {
														::format::swf::symbol::Bitmap _g1_ebitmapSymbol_0 = _switch_4->__Param(0);
{
															HX_STACK_LINE(641)
															bitmap[(int)0] = _g1_ebitmapSymbol_0->bitmapData;
														}
													}
													;break;
													default: {
													}
												}
											}
										}
										HX_STACK_LINE(652)
										if (((bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >() == null()))){
											HX_STACK_LINE(654)
											me->__get((int)0).StaticCast< ::format::swf::symbol::MorphShape >()->waitingLoader = true;
											HX_STACK_LINE(655)
											g->endFill();
											HX_STACK_LINE(657)
											return null();
										}
										else{
											HX_STACK_LINE(659)
											me[(int)0] = null();
										}
									}
									HX_STACK_LINE(667)
									g->beginBitmapFill(bitmap->__get((int)0).StaticCast< ::native::display::BitmapData >(),::format::swf::symbol::MorphShape_obj::interpolateMatrix(matrix0->__get((int)0).StaticCast< ::native::geom::Matrix >(),matrix1->__get((int)0).StaticCast< ::native::geom::Matrix >(),f),null(),null());
								}
								return null();
							}
							HX_END_LOCAL_FUNC2((void))

							HX_STACK_LINE(633)
							result->__Field(HX_CSTRING("push"),true)( Dynamic(new _Function_7_1(matrix0,bitmap,id,s,me,matrix1)));
						}
					}
				}
			}
		}
	}
	HX_STACK_LINE(677)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(MorphShape_obj,readFillStyles,return )

int MorphShape_obj::ftSolid;

int MorphShape_obj::ftLinear;

int MorphShape_obj::ftRadial;

int MorphShape_obj::ftRadialF;

int MorphShape_obj::ftBitmapRepeat;

int MorphShape_obj::ftBitmapClipped;

int MorphShape_obj::ftBitmapRepeatR;

int MorphShape_obj::ftBitmapClippedR;

int MorphShape_obj::interpolateColor( int color0,int color1,Float f){
	HX_STACK_PUSH("MorphShape::interpolateColor","format/swf/symbol/MorphShape.hx",454);
	HX_STACK_ARG(color0,"color0");
	HX_STACK_ARG(color1,"color1");
	HX_STACK_ARG(f,"f");
	HX_STACK_LINE(456)
	int r0 = (int((int(color0) >> int((int)16))) & int((int)255));		HX_STACK_VAR(r0,"r0");
	HX_STACK_LINE(457)
	int g0 = (int((int(color0) >> int((int)8))) & int((int)255));		HX_STACK_VAR(g0,"g0");
	HX_STACK_LINE(458)
	int b0 = (int(color0) & int((int)255));		HX_STACK_VAR(b0,"b0");
	HX_STACK_LINE(460)
	return (int((int((int(::Std_obj::_int((r0 + (((((int((int(color1) >> int((int)16))) & int((int)255))) - r0)) * f)))) << int((int)16))) | int((int(::Std_obj::_int((g0 + (((((int((int(color1) >> int((int)8))) & int((int)255))) - g0)) * f)))) << int((int)8))))) | int(::Std_obj::_int((b0 + (((((int(color1) & int((int)255))) - b0)) * f)))));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(MorphShape_obj,interpolateColor,return )

::native::geom::Matrix MorphShape_obj::interpolateMatrix( ::native::geom::Matrix matrix0,::native::geom::Matrix matrix1,Float f){
	HX_STACK_PUSH("MorphShape::interpolateMatrix","format/swf/symbol/MorphShape.hx",465);
	HX_STACK_ARG(matrix0,"matrix0");
	HX_STACK_ARG(matrix1,"matrix1");
	HX_STACK_ARG(f,"f");
	HX_STACK_LINE(467)
	::native::geom::Matrix matrix = ::native::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(matrix,"matrix");
	HX_STACK_LINE(469)
	matrix->a = (matrix0->a + (((matrix1->a - matrix0->a)) * f));
	HX_STACK_LINE(470)
	matrix->b = (matrix0->b + (((matrix1->b - matrix0->b)) * f));
	HX_STACK_LINE(471)
	matrix->c = (matrix0->c + (((matrix1->c - matrix0->c)) * f));
	HX_STACK_LINE(472)
	matrix->d = (matrix0->d + (((matrix1->d - matrix0->d)) * f));
	HX_STACK_LINE(473)
	matrix->tx = (matrix0->tx + (((matrix1->tx - matrix0->tx)) * f));
	HX_STACK_LINE(474)
	matrix->ty = (matrix0->ty + (((matrix1->ty - matrix0->ty)) * f));
	HX_STACK_LINE(476)
	return matrix;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(MorphShape_obj,interpolateMatrix,return )


MorphShape_obj::MorphShape_obj()
{
}

void MorphShape_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MorphShape);
	HX_MARK_MEMBER_NAME(waitingLoader,"waitingLoader");
	HX_MARK_MEMBER_NAME(swf,"swf");
	HX_MARK_MEMBER_NAME(hasScaled,"hasScaled");
	HX_MARK_MEMBER_NAME(hasNonScaled,"hasNonScaled");
	HX_MARK_MEMBER_NAME(edgeBounds1,"edgeBounds1");
	HX_MARK_MEMBER_NAME(edgeBounds0,"edgeBounds0");
	HX_MARK_MEMBER_NAME(commands,"commands");
	HX_MARK_MEMBER_NAME(bounds1,"bounds1");
	HX_MARK_MEMBER_NAME(bounds0,"bounds0");
	HX_MARK_END_CLASS();
}

void MorphShape_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(waitingLoader,"waitingLoader");
	HX_VISIT_MEMBER_NAME(swf,"swf");
	HX_VISIT_MEMBER_NAME(hasScaled,"hasScaled");
	HX_VISIT_MEMBER_NAME(hasNonScaled,"hasNonScaled");
	HX_VISIT_MEMBER_NAME(edgeBounds1,"edgeBounds1");
	HX_VISIT_MEMBER_NAME(edgeBounds0,"edgeBounds0");
	HX_VISIT_MEMBER_NAME(commands,"commands");
	HX_VISIT_MEMBER_NAME(bounds1,"bounds1");
	HX_VISIT_MEMBER_NAME(bounds0,"bounds0");
}

Dynamic MorphShape_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"swf") ) { return swf; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"ftSolid") ) { return ftSolid; }
		if (HX_FIELD_EQ(inName,"bounds1") ) { return bounds1; }
		if (HX_FIELD_EQ(inName,"bounds0") ) { return bounds0; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"ftLinear") ) { return ftLinear; }
		if (HX_FIELD_EQ(inName,"ftRadial") ) { return ftRadial; }
		if (HX_FIELD_EQ(inName,"commands") ) { return commands; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"ftRadialF") ) { return ftRadialF; }
		if (HX_FIELD_EQ(inName,"hasScaled") ) { return hasScaled; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"edgeBounds1") ) { return edgeBounds1; }
		if (HX_FIELD_EQ(inName,"edgeBounds0") ) { return edgeBounds0; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hasNonScaled") ) { return hasNonScaled; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"waitingLoader") ) { return waitingLoader; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"ftBitmapRepeat") ) { return ftBitmapRepeat; }
		if (HX_FIELD_EQ(inName,"readLineStyles") ) { return readLineStyles_dyn(); }
		if (HX_FIELD_EQ(inName,"readFillStyles") ) { return readFillStyles_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"ftBitmapClipped") ) { return ftBitmapClipped; }
		if (HX_FIELD_EQ(inName,"ftBitmapRepeatR") ) { return ftBitmapRepeatR; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"ftBitmapClippedR") ) { return ftBitmapClippedR; }
		if (HX_FIELD_EQ(inName,"interpolateColor") ) { return interpolateColor_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"interpolateMatrix") ) { return interpolateMatrix_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MorphShape_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"swf") ) { swf=inValue.Cast< ::format::SWF >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"ftSolid") ) { ftSolid=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bounds1") ) { bounds1=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bounds0") ) { bounds0=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"ftLinear") ) { ftLinear=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ftRadial") ) { ftRadial=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"commands") ) { commands=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"ftRadialF") ) { ftRadialF=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasScaled") ) { hasScaled=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"edgeBounds1") ) { edgeBounds1=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
		if (HX_FIELD_EQ(inName,"edgeBounds0") ) { edgeBounds0=inValue.Cast< ::native::geom::Rectangle >(); return inValue; }
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
		if (HX_FIELD_EQ(inName,"ftBitmapRepeatR") ) { ftBitmapRepeatR=inValue.Cast< int >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"ftBitmapClippedR") ) { ftBitmapClippedR=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MorphShape_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("waitingLoader"));
	outFields->push(HX_CSTRING("swf"));
	outFields->push(HX_CSTRING("hasScaled"));
	outFields->push(HX_CSTRING("hasNonScaled"));
	outFields->push(HX_CSTRING("edgeBounds1"));
	outFields->push(HX_CSTRING("edgeBounds0"));
	outFields->push(HX_CSTRING("commands"));
	outFields->push(HX_CSTRING("bounds1"));
	outFields->push(HX_CSTRING("bounds0"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ftSolid"),
	HX_CSTRING("ftLinear"),
	HX_CSTRING("ftRadial"),
	HX_CSTRING("ftRadialF"),
	HX_CSTRING("ftBitmapRepeat"),
	HX_CSTRING("ftBitmapClipped"),
	HX_CSTRING("ftBitmapRepeatR"),
	HX_CSTRING("ftBitmapClippedR"),
	HX_CSTRING("interpolateColor"),
	HX_CSTRING("interpolateMatrix"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("render"),
	HX_CSTRING("readLineStyles"),
	HX_CSTRING("readFillStyles"),
	HX_CSTRING("waitingLoader"),
	HX_CSTRING("swf"),
	HX_CSTRING("hasScaled"),
	HX_CSTRING("hasNonScaled"),
	HX_CSTRING("edgeBounds1"),
	HX_CSTRING("edgeBounds0"),
	HX_CSTRING("commands"),
	HX_CSTRING("bounds1"),
	HX_CSTRING("bounds0"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MorphShape_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftSolid,"ftSolid");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftLinear,"ftLinear");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftRadial,"ftRadial");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftRadialF,"ftRadialF");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftBitmapRepeat,"ftBitmapRepeat");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftBitmapClipped,"ftBitmapClipped");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftBitmapRepeatR,"ftBitmapRepeatR");
	HX_MARK_MEMBER_NAME(MorphShape_obj::ftBitmapClippedR,"ftBitmapClippedR");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MorphShape_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftSolid,"ftSolid");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftLinear,"ftLinear");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftRadial,"ftRadial");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftRadialF,"ftRadialF");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftBitmapRepeat,"ftBitmapRepeat");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftBitmapClipped,"ftBitmapClipped");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftBitmapRepeatR,"ftBitmapRepeatR");
	HX_VISIT_MEMBER_NAME(MorphShape_obj::ftBitmapClippedR,"ftBitmapClippedR");
};

Class MorphShape_obj::__mClass;

void MorphShape_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.symbol.MorphShape"), hx::TCanCast< MorphShape_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void MorphShape_obj::__boot()
{
	ftSolid= (int)0;
	ftLinear= (int)16;
	ftRadial= (int)18;
	ftRadialF= (int)19;
	ftBitmapRepeat= (int)64;
	ftBitmapClipped= (int)65;
	ftBitmapRepeatR= (int)66;
	ftBitmapClippedR= (int)67;
}

} // end namespace format
} // end namespace swf
} // end namespace symbol
