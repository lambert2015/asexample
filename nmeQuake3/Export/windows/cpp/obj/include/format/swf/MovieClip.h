#ifndef INCLUDED_format_swf_MovieClip
#define INCLUDED_format_swf_MovieClip

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <format/display/MovieClip.h>
HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS1(format,SWF)
HX_DECLARE_CLASS2(format,display,MovieClip)
HX_DECLARE_CLASS2(format,swf,MovieClip)
HX_DECLARE_CLASS3(format,swf,data,Frame)
HX_DECLARE_CLASS3(format,swf,symbol,Sprite)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS2(native,display,DisplayObject)
HX_DECLARE_CLASS2(native,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(native,display,IBitmapDrawable)
HX_DECLARE_CLASS2(native,display,InteractiveObject)
HX_DECLARE_CLASS2(native,display,Sprite)
HX_DECLARE_CLASS2(native,events,Event)
HX_DECLARE_CLASS2(native,events,EventDispatcher)
HX_DECLARE_CLASS2(native,events,IEventDispatcher)
namespace format{
namespace swf{


class HXCPP_CLASS_ATTRIBUTES  MovieClip_obj : public ::format::display::MovieClip_obj{
	public:
		typedef ::format::display::MovieClip_obj super;
		typedef MovieClip_obj OBJ_;
		MovieClip_obj();
		Void __construct(::format::swf::symbol::Sprite data);

	public:
		static hx::ObjectPtr< MovieClip_obj > __new(::format::swf::symbol::Sprite data);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~MovieClip_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MovieClip"); }

		virtual Void this_onEnterFrame( ::native::events::Event event);
		Dynamic this_onEnterFrame_dyn();

		virtual Void updateObjects( );
		Dynamic updateObjects_dyn();

		virtual Void unflatten( );

		virtual Void stop( );

		virtual Void prevFrame( );

		virtual Void play( );

		virtual Void nextFrame( );

		virtual Void gotoAndStop( Dynamic frame,::String scene);

		virtual Void gotoAndPlay( Dynamic frame,::String scene);

		virtual Void flatten( );

		::format::SWF swf;
		bool playing;
		::haxe::ds::IntMap objectPool;
		Array< ::Dynamic > frames;
		Dynamic activeObjects;
};

} // end namespace format
} // end namespace swf

#endif /* INCLUDED_format_swf_MovieClip */ 
