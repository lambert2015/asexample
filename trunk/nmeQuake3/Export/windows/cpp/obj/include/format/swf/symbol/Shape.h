#ifndef INCLUDED_format_swf_symbol_Shape
#define INCLUDED_format_swf_symbol_Shape

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(format,SWF)
HX_DECLARE_CLASS3(format,swf,data,SWFStream)
HX_DECLARE_CLASS3(format,swf,symbol,Shape)
HX_DECLARE_CLASS3(format,swf,symbol,ShapeEdge)
HX_DECLARE_CLASS2(native,display,Graphics)
HX_DECLARE_CLASS2(native,geom,Rectangle)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  Shape_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Shape_obj OBJ_;
		Shape_obj();
		Void __construct(::format::SWF swf,::format::swf::data::SWFStream stream,int version);

	public:
		static hx::ObjectPtr< Shape_obj > __new(::format::SWF swf,::format::swf::data::SWFStream stream,int version);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Shape_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Shape"); }

		virtual bool render( ::native::display::Graphics graphics);
		Dynamic render_dyn();

		virtual Dynamic readLineStyles( ::format::swf::data::SWFStream stream,int version);
		Dynamic readLineStyles_dyn();

		virtual Dynamic readFillStyles( ::format::swf::data::SWFStream stream,int version);
		Dynamic readFillStyles_dyn();

		virtual Void flushCommands( Dynamic edges,Array< ::Dynamic > fills);
		Dynamic flushCommands_dyn();

		bool waitingLoader;
		::format::SWF swf;
		bool hasScaled;
		bool hasNonScaled;
		Dynamic fillStyles;
		::native::geom::Rectangle edgeBounds;
		Dynamic commands;
		::native::geom::Rectangle bounds;
		bool hasGradientFill;
		bool hasCurves;
		bool hasBitmapRepeat;
		static int ftSolid;
		static int ftLinear;
		static int ftRadial;
		static int ftRadialF;
		static int ftBitmapRepeatSmooth;
		static int ftBitmapClippedSmooth;
		static int ftBitmapRepeat;
		static int ftBitmapClipped;
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_Shape */ 
