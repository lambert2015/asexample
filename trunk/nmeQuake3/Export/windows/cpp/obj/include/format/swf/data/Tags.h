#ifndef INCLUDED_format_swf_data_Tags
#define INCLUDED_format_swf_data_Tags

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(format,swf,data,Tags)
namespace format{
namespace swf{
namespace data{


class HXCPP_CLASS_ATTRIBUTES  Tags_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Tags_obj OBJ_;
		Tags_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Tags_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Tags_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Tags"); }

		static int End;
		static int ShowFrame;
		static int DefineShape;
		static int FreeCharacter;
		static int PlaceObject;
		static int RemoveObject;
		static int DefineBits;
		static int DefineButton;
		static int JPEGTables;
		static int SetBackgroundColor;
		static int DefineFont;
		static int DefineText;
		static int DoAction;
		static int DefineFontInfo;
		static int DefineSound;
		static int StartSound;
		static int StopSound;
		static int DefineButtonSound;
		static int SoundStreamHead;
		static int SoundStreamBlock;
		static int DefineBitsLossless;
		static int DefineBitsJPEG2;
		static int DefineShape2;
		static int DefineButtonCxform;
		static int Protect;
		static int PathsArePostScript;
		static int PlaceObject2;
		static int c27;
		static int RemoveObject2;
		static int SyncFrame;
		static int c30;
		static int FreeAll;
		static int DefineShape3;
		static int DefineText2;
		static int DefineButton2;
		static int DefineBitsJPEG3;
		static int DefineBitsLossless2;
		static int DefineEditText;
		static int DefineVideo;
		static int DefineSprite;
		static int NameCharacter;
		static int ProductInfo;
		static int DefineTextFormat;
		static int FrameLabel;
		static int DefineBehavior;
		static int SoundStreamHead2;
		static int DefineMorphShape;
		static int FrameTag;
		static int DefineFont2;
		static int GenCommand;
		static int DefineCommandObj;
		static int CharacterSet;
		static int FontRef;
		static int DefineFunction;
		static int PlaceFunction;
		static int GenTagObject;
		static int ExportAssets;
		static int ImportAssets;
		static int EnableDebugger;
		static int DoInitAction;
		static int DefineVideoStream;
		static int VideoFrame;
		static int DefineFontInfo2;
		static int DebugID;
		static int EnableDebugger2;
		static int ScriptLimits;
		static int SetTabIndex;
		static int DefineShape4_hmm;
		static int c68;
		static int FileAttributes;
		static int PlaceObject3;
		static int ImportAssets2;
		static int DoABC;
		static int DefineFontAlignZones;
		static int CSMTextSettings;
		static int DefineFont3;
		static int SymbolClass;
		static int MetaData;
		static int DefineScalingGrid;
		static int c79;
		static int c80;
		static int c81;
		static int DoABC2;
		static int DefineShape4;
		static int DefineMorphShape2;
		static int c85;
		static int DefineSceneAndFrameLabelData;
		static int DefineBinaryData;
		static int DefineFontName;
		static int StartSound2;
		static int LAST;
		static Array< ::String > tags;
		static ::String string( int i);
		static Dynamic string_dyn();

};

} // end namespace format
} // end namespace swf
} // end namespace data

#endif /* INCLUDED_format_swf_data_Tags */ 
