#ifndef INCLUDED_format_swf_symbol_Sprite
#define INCLUDED_format_swf_symbol_Sprite

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS1(format,SWF)
HX_DECLARE_CLASS3(format,swf,data,Frame)
HX_DECLARE_CLASS3(format,swf,data,SWFStream)
HX_DECLARE_CLASS3(format,swf,symbol,Sprite)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(native,display,BlendMode)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  Sprite_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Sprite_obj OBJ_;
		Sprite_obj();
		Void __construct(::format::SWF swf,int id,int frameCount);

	public:
		static hx::ObjectPtr< Sprite_obj > __new(::format::SWF swf,int id,int frameCount);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Sprite_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Sprite"); }

		virtual Void showFrame( );
		Dynamic showFrame_dyn();

		virtual Void removeObject( ::format::swf::data::SWFStream stream,int version);
		Dynamic removeObject_dyn();

		virtual Void placeObject( ::format::swf::data::SWFStream stream,int version);
		Dynamic placeObject_dyn();

		virtual Void labelFrame( ::String name);
		Dynamic labelFrame_dyn();

		::String name;
		::format::swf::data::Frame frame;
		::String className;
		bool cacheAsBitmap;
		::native::display::BlendMode blendMode;
		::format::SWF swf;
		Array< ::Dynamic > frames;
		::haxe::ds::StringMap frameLabels;
		int frameCount;
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_Sprite */ 
