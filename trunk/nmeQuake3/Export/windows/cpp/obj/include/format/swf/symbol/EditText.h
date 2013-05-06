#ifndef INCLUDED_format_swf_symbol_EditText
#define INCLUDED_format_swf_symbol_EditText

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(format,SWF)
HX_DECLARE_CLASS3(format,swf,data,SWFStream)
HX_DECLARE_CLASS3(format,swf,symbol,EditText)
HX_DECLARE_CLASS2(native,display,DisplayObject)
HX_DECLARE_CLASS2(native,display,IBitmapDrawable)
HX_DECLARE_CLASS2(native,display,InteractiveObject)
HX_DECLARE_CLASS2(native,events,EventDispatcher)
HX_DECLARE_CLASS2(native,events,IEventDispatcher)
HX_DECLARE_CLASS2(native,geom,Rectangle)
HX_DECLARE_CLASS2(native,text,TextField)
HX_DECLARE_CLASS2(native,text,TextFormat)
namespace format{
namespace swf{
namespace symbol{


class HXCPP_CLASS_ATTRIBUTES  EditText_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef EditText_obj OBJ_;
		EditText_obj();
		Void __construct(::format::SWF swf,::format::swf::data::SWFStream stream,int version);

	public:
		static hx::ObjectPtr< EditText_obj > __new(::format::SWF swf,::format::swf::data::SWFStream stream,int version);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~EditText_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("EditText"); }

		virtual Void apply( ::native::text::TextField textField);
		Dynamic apply_dyn();

		bool wordWrap;
		bool wasStatic;
		bool useOutlines;
		::native::text::TextFormat textFormat;
		::String text;
		::native::geom::Rectangle rect;
		bool readOnly;
		bool noSelect;
		bool multiline;
		int maxChars;
		bool html;
		bool displayAsPassword;
		bool border;
		bool autoSize;
		Float alpha;
};

} // end namespace format
} // end namespace swf
} // end namespace symbol

#endif /* INCLUDED_format_swf_symbol_EditText */ 
