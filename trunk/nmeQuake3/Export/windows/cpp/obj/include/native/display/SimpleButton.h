#ifndef INCLUDED_native_display_SimpleButton
#define INCLUDED_native_display_SimpleButton

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <native/display/InteractiveObject.h>
HX_DECLARE_CLASS2(native,display,DisplayObject)
HX_DECLARE_CLASS2(native,display,IBitmapDrawable)
HX_DECLARE_CLASS2(native,display,InteractiveObject)
HX_DECLARE_CLASS2(native,display,SimpleButton)
HX_DECLARE_CLASS2(native,events,EventDispatcher)
HX_DECLARE_CLASS2(native,events,IEventDispatcher)
namespace native{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  SimpleButton_obj : public ::native::display::InteractiveObject_obj{
	public:
		typedef ::native::display::InteractiveObject_obj super;
		typedef SimpleButton_obj OBJ_;
		SimpleButton_obj();
		Void __construct(::native::display::DisplayObject upState,::native::display::DisplayObject overState,::native::display::DisplayObject downState,::native::display::DisplayObject hitTestState);

	public:
		static hx::ObjectPtr< SimpleButton_obj > __new(::native::display::DisplayObject upState,::native::display::DisplayObject overState,::native::display::DisplayObject downState,::native::display::DisplayObject hitTestState);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~SimpleButton_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("SimpleButton"); }

		virtual ::native::display::DisplayObject set_upState( ::native::display::DisplayObject inState);
		Dynamic set_upState_dyn();

		virtual ::native::display::DisplayObject set_overState( ::native::display::DisplayObject inState);
		Dynamic set_overState_dyn();

		virtual ::native::display::DisplayObject set_hitTestState( ::native::display::DisplayObject inState);
		Dynamic set_hitTestState_dyn();

		virtual bool set_useHandCursor( bool inVal);
		Dynamic set_useHandCursor_dyn();

		virtual bool get_useHandCursor( );
		Dynamic get_useHandCursor_dyn();

		virtual bool set_enabled( bool inVal);
		Dynamic set_enabled_dyn();

		virtual bool get_enabled( );
		Dynamic get_enabled_dyn();

		virtual ::native::display::DisplayObject set_downState( ::native::display::DisplayObject inState);
		Dynamic set_downState_dyn();

		::native::display::DisplayObject upState;
		::native::display::DisplayObject overState;
		::native::display::DisplayObject hitTestState;
		::native::display::DisplayObject downState;
		static Dynamic nme_simple_button_set_state;
		static Dynamic &nme_simple_button_set_state_dyn() { return nme_simple_button_set_state;}
		static Dynamic nme_simple_button_get_enabled;
		static Dynamic &nme_simple_button_get_enabled_dyn() { return nme_simple_button_get_enabled;}
		static Dynamic nme_simple_button_set_enabled;
		static Dynamic &nme_simple_button_set_enabled_dyn() { return nme_simple_button_set_enabled;}
		static Dynamic nme_simple_button_get_hand_cursor;
		static Dynamic &nme_simple_button_get_hand_cursor_dyn() { return nme_simple_button_get_hand_cursor;}
		static Dynamic nme_simple_button_set_hand_cursor;
		static Dynamic &nme_simple_button_set_hand_cursor_dyn() { return nme_simple_button_set_hand_cursor;}
		static Dynamic nme_simple_button_create;
		static Dynamic &nme_simple_button_create_dyn() { return nme_simple_button_create;}
};

} // end namespace native
} // end namespace display

#endif /* INCLUDED_native_display_SimpleButton */ 
