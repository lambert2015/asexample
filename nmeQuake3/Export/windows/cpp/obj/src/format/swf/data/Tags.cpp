#include <hxcpp.h>

#ifndef INCLUDED_format_swf_data_Tags
#include <format/swf/data/Tags.h>
#endif
namespace format{
namespace swf{
namespace data{

Void Tags_obj::__construct()
{
	return null();
}

Tags_obj::~Tags_obj() { }

Dynamic Tags_obj::__CreateEmpty() { return  new Tags_obj; }
hx::ObjectPtr< Tags_obj > Tags_obj::__new()
{  hx::ObjectPtr< Tags_obj > result = new Tags_obj();
	result->__construct();
	return result;}

Dynamic Tags_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Tags_obj > result = new Tags_obj();
	result->__construct();
	return result;}

int Tags_obj::End;

int Tags_obj::ShowFrame;

int Tags_obj::DefineShape;

int Tags_obj::FreeCharacter;

int Tags_obj::PlaceObject;

int Tags_obj::RemoveObject;

int Tags_obj::DefineBits;

int Tags_obj::DefineButton;

int Tags_obj::JPEGTables;

int Tags_obj::SetBackgroundColor;

int Tags_obj::DefineFont;

int Tags_obj::DefineText;

int Tags_obj::DoAction;

int Tags_obj::DefineFontInfo;

int Tags_obj::DefineSound;

int Tags_obj::StartSound;

int Tags_obj::StopSound;

int Tags_obj::DefineButtonSound;

int Tags_obj::SoundStreamHead;

int Tags_obj::SoundStreamBlock;

int Tags_obj::DefineBitsLossless;

int Tags_obj::DefineBitsJPEG2;

int Tags_obj::DefineShape2;

int Tags_obj::DefineButtonCxform;

int Tags_obj::Protect;

int Tags_obj::PathsArePostScript;

int Tags_obj::PlaceObject2;

int Tags_obj::c27;

int Tags_obj::RemoveObject2;

int Tags_obj::SyncFrame;

int Tags_obj::c30;

int Tags_obj::FreeAll;

int Tags_obj::DefineShape3;

int Tags_obj::DefineText2;

int Tags_obj::DefineButton2;

int Tags_obj::DefineBitsJPEG3;

int Tags_obj::DefineBitsLossless2;

int Tags_obj::DefineEditText;

int Tags_obj::DefineVideo;

int Tags_obj::DefineSprite;

int Tags_obj::NameCharacter;

int Tags_obj::ProductInfo;

int Tags_obj::DefineTextFormat;

int Tags_obj::FrameLabel;

int Tags_obj::DefineBehavior;

int Tags_obj::SoundStreamHead2;

int Tags_obj::DefineMorphShape;

int Tags_obj::FrameTag;

int Tags_obj::DefineFont2;

int Tags_obj::GenCommand;

int Tags_obj::DefineCommandObj;

int Tags_obj::CharacterSet;

int Tags_obj::FontRef;

int Tags_obj::DefineFunction;

int Tags_obj::PlaceFunction;

int Tags_obj::GenTagObject;

int Tags_obj::ExportAssets;

int Tags_obj::ImportAssets;

int Tags_obj::EnableDebugger;

int Tags_obj::DoInitAction;

int Tags_obj::DefineVideoStream;

int Tags_obj::VideoFrame;

int Tags_obj::DefineFontInfo2;

int Tags_obj::DebugID;

int Tags_obj::EnableDebugger2;

int Tags_obj::ScriptLimits;

int Tags_obj::SetTabIndex;

int Tags_obj::DefineShape4_hmm;

int Tags_obj::c68;

int Tags_obj::FileAttributes;

int Tags_obj::PlaceObject3;

int Tags_obj::ImportAssets2;

int Tags_obj::DoABC;

int Tags_obj::DefineFontAlignZones;

int Tags_obj::CSMTextSettings;

int Tags_obj::DefineFont3;

int Tags_obj::SymbolClass;

int Tags_obj::MetaData;

int Tags_obj::DefineScalingGrid;

int Tags_obj::c79;

int Tags_obj::c80;

int Tags_obj::c81;

int Tags_obj::DoABC2;

int Tags_obj::DefineShape4;

int Tags_obj::DefineMorphShape2;

int Tags_obj::c85;

int Tags_obj::DefineSceneAndFrameLabelData;

int Tags_obj::DefineBinaryData;

int Tags_obj::DefineFontName;

int Tags_obj::StartSound2;

int Tags_obj::LAST;

Array< ::String > Tags_obj::tags;

::String Tags_obj::string( int i){
	HX_STACK_PUSH("Tags::string","format/swf/data/Tags.hx",244);
	HX_STACK_ARG(i,"i");
	HX_STACK_LINE(244)
	return ::format::swf::data::Tags_obj::tags->__get(i);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tags_obj,string,return )


Tags_obj::Tags_obj()
{
}

void Tags_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Tags);
	HX_MARK_END_CLASS();
}

void Tags_obj::__Visit(HX_VISIT_PARAMS)
{
}

Dynamic Tags_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"End") ) { return End; }
		if (HX_FIELD_EQ(inName,"c27") ) { return c27; }
		if (HX_FIELD_EQ(inName,"c30") ) { return c30; }
		if (HX_FIELD_EQ(inName,"c68") ) { return c68; }
		if (HX_FIELD_EQ(inName,"c79") ) { return c79; }
		if (HX_FIELD_EQ(inName,"c80") ) { return c80; }
		if (HX_FIELD_EQ(inName,"c81") ) { return c81; }
		if (HX_FIELD_EQ(inName,"c85") ) { return c85; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"LAST") ) { return LAST; }
		if (HX_FIELD_EQ(inName,"tags") ) { return tags; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"DoABC") ) { return DoABC; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"DoABC2") ) { return DoABC2; }
		if (HX_FIELD_EQ(inName,"string") ) { return string_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"Protect") ) { return Protect; }
		if (HX_FIELD_EQ(inName,"FreeAll") ) { return FreeAll; }
		if (HX_FIELD_EQ(inName,"FontRef") ) { return FontRef; }
		if (HX_FIELD_EQ(inName,"DebugID") ) { return DebugID; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"DoAction") ) { return DoAction; }
		if (HX_FIELD_EQ(inName,"FrameTag") ) { return FrameTag; }
		if (HX_FIELD_EQ(inName,"MetaData") ) { return MetaData; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"ShowFrame") ) { return ShowFrame; }
		if (HX_FIELD_EQ(inName,"StopSound") ) { return StopSound; }
		if (HX_FIELD_EQ(inName,"SyncFrame") ) { return SyncFrame; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"DefineBits") ) { return DefineBits; }
		if (HX_FIELD_EQ(inName,"JPEGTables") ) { return JPEGTables; }
		if (HX_FIELD_EQ(inName,"DefineFont") ) { return DefineFont; }
		if (HX_FIELD_EQ(inName,"DefineText") ) { return DefineText; }
		if (HX_FIELD_EQ(inName,"StartSound") ) { return StartSound; }
		if (HX_FIELD_EQ(inName,"FrameLabel") ) { return FrameLabel; }
		if (HX_FIELD_EQ(inName,"GenCommand") ) { return GenCommand; }
		if (HX_FIELD_EQ(inName,"VideoFrame") ) { return VideoFrame; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"DefineShape") ) { return DefineShape; }
		if (HX_FIELD_EQ(inName,"PlaceObject") ) { return PlaceObject; }
		if (HX_FIELD_EQ(inName,"DefineSound") ) { return DefineSound; }
		if (HX_FIELD_EQ(inName,"DefineText2") ) { return DefineText2; }
		if (HX_FIELD_EQ(inName,"DefineVideo") ) { return DefineVideo; }
		if (HX_FIELD_EQ(inName,"ProductInfo") ) { return ProductInfo; }
		if (HX_FIELD_EQ(inName,"DefineFont2") ) { return DefineFont2; }
		if (HX_FIELD_EQ(inName,"SetTabIndex") ) { return SetTabIndex; }
		if (HX_FIELD_EQ(inName,"DefineFont3") ) { return DefineFont3; }
		if (HX_FIELD_EQ(inName,"SymbolClass") ) { return SymbolClass; }
		if (HX_FIELD_EQ(inName,"StartSound2") ) { return StartSound2; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"RemoveObject") ) { return RemoveObject; }
		if (HX_FIELD_EQ(inName,"DefineButton") ) { return DefineButton; }
		if (HX_FIELD_EQ(inName,"DefineShape2") ) { return DefineShape2; }
		if (HX_FIELD_EQ(inName,"PlaceObject2") ) { return PlaceObject2; }
		if (HX_FIELD_EQ(inName,"DefineShape3") ) { return DefineShape3; }
		if (HX_FIELD_EQ(inName,"DefineSprite") ) { return DefineSprite; }
		if (HX_FIELD_EQ(inName,"CharacterSet") ) { return CharacterSet; }
		if (HX_FIELD_EQ(inName,"GenTagObject") ) { return GenTagObject; }
		if (HX_FIELD_EQ(inName,"ExportAssets") ) { return ExportAssets; }
		if (HX_FIELD_EQ(inName,"ImportAssets") ) { return ImportAssets; }
		if (HX_FIELD_EQ(inName,"DoInitAction") ) { return DoInitAction; }
		if (HX_FIELD_EQ(inName,"ScriptLimits") ) { return ScriptLimits; }
		if (HX_FIELD_EQ(inName,"PlaceObject3") ) { return PlaceObject3; }
		if (HX_FIELD_EQ(inName,"DefineShape4") ) { return DefineShape4; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"FreeCharacter") ) { return FreeCharacter; }
		if (HX_FIELD_EQ(inName,"RemoveObject2") ) { return RemoveObject2; }
		if (HX_FIELD_EQ(inName,"DefineButton2") ) { return DefineButton2; }
		if (HX_FIELD_EQ(inName,"NameCharacter") ) { return NameCharacter; }
		if (HX_FIELD_EQ(inName,"PlaceFunction") ) { return PlaceFunction; }
		if (HX_FIELD_EQ(inName,"ImportAssets2") ) { return ImportAssets2; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"DefineFontInfo") ) { return DefineFontInfo; }
		if (HX_FIELD_EQ(inName,"DefineEditText") ) { return DefineEditText; }
		if (HX_FIELD_EQ(inName,"DefineBehavior") ) { return DefineBehavior; }
		if (HX_FIELD_EQ(inName,"DefineFunction") ) { return DefineFunction; }
		if (HX_FIELD_EQ(inName,"EnableDebugger") ) { return EnableDebugger; }
		if (HX_FIELD_EQ(inName,"FileAttributes") ) { return FileAttributes; }
		if (HX_FIELD_EQ(inName,"DefineFontName") ) { return DefineFontName; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"SoundStreamHead") ) { return SoundStreamHead; }
		if (HX_FIELD_EQ(inName,"DefineBitsJPEG2") ) { return DefineBitsJPEG2; }
		if (HX_FIELD_EQ(inName,"DefineBitsJPEG3") ) { return DefineBitsJPEG3; }
		if (HX_FIELD_EQ(inName,"DefineFontInfo2") ) { return DefineFontInfo2; }
		if (HX_FIELD_EQ(inName,"EnableDebugger2") ) { return EnableDebugger2; }
		if (HX_FIELD_EQ(inName,"CSMTextSettings") ) { return CSMTextSettings; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"SoundStreamBlock") ) { return SoundStreamBlock; }
		if (HX_FIELD_EQ(inName,"DefineTextFormat") ) { return DefineTextFormat; }
		if (HX_FIELD_EQ(inName,"SoundStreamHead2") ) { return SoundStreamHead2; }
		if (HX_FIELD_EQ(inName,"DefineMorphShape") ) { return DefineMorphShape; }
		if (HX_FIELD_EQ(inName,"DefineCommandObj") ) { return DefineCommandObj; }
		if (HX_FIELD_EQ(inName,"DefineShape4_hmm") ) { return DefineShape4_hmm; }
		if (HX_FIELD_EQ(inName,"DefineBinaryData") ) { return DefineBinaryData; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"DefineButtonSound") ) { return DefineButtonSound; }
		if (HX_FIELD_EQ(inName,"DefineVideoStream") ) { return DefineVideoStream; }
		if (HX_FIELD_EQ(inName,"DefineScalingGrid") ) { return DefineScalingGrid; }
		if (HX_FIELD_EQ(inName,"DefineMorphShape2") ) { return DefineMorphShape2; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"SetBackgroundColor") ) { return SetBackgroundColor; }
		if (HX_FIELD_EQ(inName,"DefineBitsLossless") ) { return DefineBitsLossless; }
		if (HX_FIELD_EQ(inName,"DefineButtonCxform") ) { return DefineButtonCxform; }
		if (HX_FIELD_EQ(inName,"PathsArePostScript") ) { return PathsArePostScript; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"DefineBitsLossless2") ) { return DefineBitsLossless2; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"DefineFontAlignZones") ) { return DefineFontAlignZones; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"DefineSceneAndFrameLabelData") ) { return DefineSceneAndFrameLabelData; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Tags_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"End") ) { End=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c27") ) { c27=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c30") ) { c30=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c68") ) { c68=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c79") ) { c79=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c80") ) { c80=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c81") ) { c81=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c85") ) { c85=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"LAST") ) { LAST=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tags") ) { tags=inValue.Cast< Array< ::String > >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"DoABC") ) { DoABC=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"DoABC2") ) { DoABC2=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"Protect") ) { Protect=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FreeAll") ) { FreeAll=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FontRef") ) { FontRef=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DebugID") ) { DebugID=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"DoAction") ) { DoAction=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FrameTag") ) { FrameTag=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"MetaData") ) { MetaData=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"ShowFrame") ) { ShowFrame=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"StopSound") ) { StopSound=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"SyncFrame") ) { SyncFrame=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"DefineBits") ) { DefineBits=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"JPEGTables") ) { JPEGTables=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineFont") ) { DefineFont=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineText") ) { DefineText=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"StartSound") ) { StartSound=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FrameLabel") ) { FrameLabel=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"GenCommand") ) { GenCommand=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"VideoFrame") ) { VideoFrame=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"DefineShape") ) { DefineShape=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"PlaceObject") ) { PlaceObject=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineSound") ) { DefineSound=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineText2") ) { DefineText2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineVideo") ) { DefineVideo=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ProductInfo") ) { ProductInfo=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineFont2") ) { DefineFont2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"SetTabIndex") ) { SetTabIndex=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineFont3") ) { DefineFont3=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"SymbolClass") ) { SymbolClass=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"StartSound2") ) { StartSound2=inValue.Cast< int >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"RemoveObject") ) { RemoveObject=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineButton") ) { DefineButton=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineShape2") ) { DefineShape2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"PlaceObject2") ) { PlaceObject2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineShape3") ) { DefineShape3=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineSprite") ) { DefineSprite=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"CharacterSet") ) { CharacterSet=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"GenTagObject") ) { GenTagObject=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ExportAssets") ) { ExportAssets=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ImportAssets") ) { ImportAssets=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DoInitAction") ) { DoInitAction=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ScriptLimits") ) { ScriptLimits=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"PlaceObject3") ) { PlaceObject3=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineShape4") ) { DefineShape4=inValue.Cast< int >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"FreeCharacter") ) { FreeCharacter=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"RemoveObject2") ) { RemoveObject2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineButton2") ) { DefineButton2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"NameCharacter") ) { NameCharacter=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"PlaceFunction") ) { PlaceFunction=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ImportAssets2") ) { ImportAssets2=inValue.Cast< int >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"DefineFontInfo") ) { DefineFontInfo=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineEditText") ) { DefineEditText=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineBehavior") ) { DefineBehavior=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineFunction") ) { DefineFunction=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"EnableDebugger") ) { EnableDebugger=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FileAttributes") ) { FileAttributes=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineFontName") ) { DefineFontName=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"SoundStreamHead") ) { SoundStreamHead=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineBitsJPEG2") ) { DefineBitsJPEG2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineBitsJPEG3") ) { DefineBitsJPEG3=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineFontInfo2") ) { DefineFontInfo2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"EnableDebugger2") ) { EnableDebugger2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"CSMTextSettings") ) { CSMTextSettings=inValue.Cast< int >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"SoundStreamBlock") ) { SoundStreamBlock=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineTextFormat") ) { DefineTextFormat=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"SoundStreamHead2") ) { SoundStreamHead2=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineMorphShape") ) { DefineMorphShape=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineCommandObj") ) { DefineCommandObj=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineShape4_hmm") ) { DefineShape4_hmm=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineBinaryData") ) { DefineBinaryData=inValue.Cast< int >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"DefineButtonSound") ) { DefineButtonSound=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineVideoStream") ) { DefineVideoStream=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineScalingGrid") ) { DefineScalingGrid=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineMorphShape2") ) { DefineMorphShape2=inValue.Cast< int >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"SetBackgroundColor") ) { SetBackgroundColor=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineBitsLossless") ) { DefineBitsLossless=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DefineButtonCxform") ) { DefineButtonCxform=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"PathsArePostScript") ) { PathsArePostScript=inValue.Cast< int >(); return inValue; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"DefineBitsLossless2") ) { DefineBitsLossless2=inValue.Cast< int >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"DefineFontAlignZones") ) { DefineFontAlignZones=inValue.Cast< int >(); return inValue; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"DefineSceneAndFrameLabelData") ) { DefineSceneAndFrameLabelData=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Tags_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("End"),
	HX_CSTRING("ShowFrame"),
	HX_CSTRING("DefineShape"),
	HX_CSTRING("FreeCharacter"),
	HX_CSTRING("PlaceObject"),
	HX_CSTRING("RemoveObject"),
	HX_CSTRING("DefineBits"),
	HX_CSTRING("DefineButton"),
	HX_CSTRING("JPEGTables"),
	HX_CSTRING("SetBackgroundColor"),
	HX_CSTRING("DefineFont"),
	HX_CSTRING("DefineText"),
	HX_CSTRING("DoAction"),
	HX_CSTRING("DefineFontInfo"),
	HX_CSTRING("DefineSound"),
	HX_CSTRING("StartSound"),
	HX_CSTRING("StopSound"),
	HX_CSTRING("DefineButtonSound"),
	HX_CSTRING("SoundStreamHead"),
	HX_CSTRING("SoundStreamBlock"),
	HX_CSTRING("DefineBitsLossless"),
	HX_CSTRING("DefineBitsJPEG2"),
	HX_CSTRING("DefineShape2"),
	HX_CSTRING("DefineButtonCxform"),
	HX_CSTRING("Protect"),
	HX_CSTRING("PathsArePostScript"),
	HX_CSTRING("PlaceObject2"),
	HX_CSTRING("c27"),
	HX_CSTRING("RemoveObject2"),
	HX_CSTRING("SyncFrame"),
	HX_CSTRING("c30"),
	HX_CSTRING("FreeAll"),
	HX_CSTRING("DefineShape3"),
	HX_CSTRING("DefineText2"),
	HX_CSTRING("DefineButton2"),
	HX_CSTRING("DefineBitsJPEG3"),
	HX_CSTRING("DefineBitsLossless2"),
	HX_CSTRING("DefineEditText"),
	HX_CSTRING("DefineVideo"),
	HX_CSTRING("DefineSprite"),
	HX_CSTRING("NameCharacter"),
	HX_CSTRING("ProductInfo"),
	HX_CSTRING("DefineTextFormat"),
	HX_CSTRING("FrameLabel"),
	HX_CSTRING("DefineBehavior"),
	HX_CSTRING("SoundStreamHead2"),
	HX_CSTRING("DefineMorphShape"),
	HX_CSTRING("FrameTag"),
	HX_CSTRING("DefineFont2"),
	HX_CSTRING("GenCommand"),
	HX_CSTRING("DefineCommandObj"),
	HX_CSTRING("CharacterSet"),
	HX_CSTRING("FontRef"),
	HX_CSTRING("DefineFunction"),
	HX_CSTRING("PlaceFunction"),
	HX_CSTRING("GenTagObject"),
	HX_CSTRING("ExportAssets"),
	HX_CSTRING("ImportAssets"),
	HX_CSTRING("EnableDebugger"),
	HX_CSTRING("DoInitAction"),
	HX_CSTRING("DefineVideoStream"),
	HX_CSTRING("VideoFrame"),
	HX_CSTRING("DefineFontInfo2"),
	HX_CSTRING("DebugID"),
	HX_CSTRING("EnableDebugger2"),
	HX_CSTRING("ScriptLimits"),
	HX_CSTRING("SetTabIndex"),
	HX_CSTRING("DefineShape4_hmm"),
	HX_CSTRING("c68"),
	HX_CSTRING("FileAttributes"),
	HX_CSTRING("PlaceObject3"),
	HX_CSTRING("ImportAssets2"),
	HX_CSTRING("DoABC"),
	HX_CSTRING("DefineFontAlignZones"),
	HX_CSTRING("CSMTextSettings"),
	HX_CSTRING("DefineFont3"),
	HX_CSTRING("SymbolClass"),
	HX_CSTRING("MetaData"),
	HX_CSTRING("DefineScalingGrid"),
	HX_CSTRING("c79"),
	HX_CSTRING("c80"),
	HX_CSTRING("c81"),
	HX_CSTRING("DoABC2"),
	HX_CSTRING("DefineShape4"),
	HX_CSTRING("DefineMorphShape2"),
	HX_CSTRING("c85"),
	HX_CSTRING("DefineSceneAndFrameLabelData"),
	HX_CSTRING("DefineBinaryData"),
	HX_CSTRING("DefineFontName"),
	HX_CSTRING("StartSound2"),
	HX_CSTRING("LAST"),
	HX_CSTRING("tags"),
	HX_CSTRING("string"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Tags_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Tags_obj::End,"End");
	HX_MARK_MEMBER_NAME(Tags_obj::ShowFrame,"ShowFrame");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineShape,"DefineShape");
	HX_MARK_MEMBER_NAME(Tags_obj::FreeCharacter,"FreeCharacter");
	HX_MARK_MEMBER_NAME(Tags_obj::PlaceObject,"PlaceObject");
	HX_MARK_MEMBER_NAME(Tags_obj::RemoveObject,"RemoveObject");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBits,"DefineBits");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineButton,"DefineButton");
	HX_MARK_MEMBER_NAME(Tags_obj::JPEGTables,"JPEGTables");
	HX_MARK_MEMBER_NAME(Tags_obj::SetBackgroundColor,"SetBackgroundColor");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFont,"DefineFont");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineText,"DefineText");
	HX_MARK_MEMBER_NAME(Tags_obj::DoAction,"DoAction");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFontInfo,"DefineFontInfo");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineSound,"DefineSound");
	HX_MARK_MEMBER_NAME(Tags_obj::StartSound,"StartSound");
	HX_MARK_MEMBER_NAME(Tags_obj::StopSound,"StopSound");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineButtonSound,"DefineButtonSound");
	HX_MARK_MEMBER_NAME(Tags_obj::SoundStreamHead,"SoundStreamHead");
	HX_MARK_MEMBER_NAME(Tags_obj::SoundStreamBlock,"SoundStreamBlock");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBitsLossless,"DefineBitsLossless");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBitsJPEG2,"DefineBitsJPEG2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineShape2,"DefineShape2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineButtonCxform,"DefineButtonCxform");
	HX_MARK_MEMBER_NAME(Tags_obj::Protect,"Protect");
	HX_MARK_MEMBER_NAME(Tags_obj::PathsArePostScript,"PathsArePostScript");
	HX_MARK_MEMBER_NAME(Tags_obj::PlaceObject2,"PlaceObject2");
	HX_MARK_MEMBER_NAME(Tags_obj::c27,"c27");
	HX_MARK_MEMBER_NAME(Tags_obj::RemoveObject2,"RemoveObject2");
	HX_MARK_MEMBER_NAME(Tags_obj::SyncFrame,"SyncFrame");
	HX_MARK_MEMBER_NAME(Tags_obj::c30,"c30");
	HX_MARK_MEMBER_NAME(Tags_obj::FreeAll,"FreeAll");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineShape3,"DefineShape3");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineText2,"DefineText2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineButton2,"DefineButton2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBitsJPEG3,"DefineBitsJPEG3");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBitsLossless2,"DefineBitsLossless2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineEditText,"DefineEditText");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineVideo,"DefineVideo");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineSprite,"DefineSprite");
	HX_MARK_MEMBER_NAME(Tags_obj::NameCharacter,"NameCharacter");
	HX_MARK_MEMBER_NAME(Tags_obj::ProductInfo,"ProductInfo");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineTextFormat,"DefineTextFormat");
	HX_MARK_MEMBER_NAME(Tags_obj::FrameLabel,"FrameLabel");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBehavior,"DefineBehavior");
	HX_MARK_MEMBER_NAME(Tags_obj::SoundStreamHead2,"SoundStreamHead2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineMorphShape,"DefineMorphShape");
	HX_MARK_MEMBER_NAME(Tags_obj::FrameTag,"FrameTag");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFont2,"DefineFont2");
	HX_MARK_MEMBER_NAME(Tags_obj::GenCommand,"GenCommand");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineCommandObj,"DefineCommandObj");
	HX_MARK_MEMBER_NAME(Tags_obj::CharacterSet,"CharacterSet");
	HX_MARK_MEMBER_NAME(Tags_obj::FontRef,"FontRef");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFunction,"DefineFunction");
	HX_MARK_MEMBER_NAME(Tags_obj::PlaceFunction,"PlaceFunction");
	HX_MARK_MEMBER_NAME(Tags_obj::GenTagObject,"GenTagObject");
	HX_MARK_MEMBER_NAME(Tags_obj::ExportAssets,"ExportAssets");
	HX_MARK_MEMBER_NAME(Tags_obj::ImportAssets,"ImportAssets");
	HX_MARK_MEMBER_NAME(Tags_obj::EnableDebugger,"EnableDebugger");
	HX_MARK_MEMBER_NAME(Tags_obj::DoInitAction,"DoInitAction");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineVideoStream,"DefineVideoStream");
	HX_MARK_MEMBER_NAME(Tags_obj::VideoFrame,"VideoFrame");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFontInfo2,"DefineFontInfo2");
	HX_MARK_MEMBER_NAME(Tags_obj::DebugID,"DebugID");
	HX_MARK_MEMBER_NAME(Tags_obj::EnableDebugger2,"EnableDebugger2");
	HX_MARK_MEMBER_NAME(Tags_obj::ScriptLimits,"ScriptLimits");
	HX_MARK_MEMBER_NAME(Tags_obj::SetTabIndex,"SetTabIndex");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineShape4_hmm,"DefineShape4_hmm");
	HX_MARK_MEMBER_NAME(Tags_obj::c68,"c68");
	HX_MARK_MEMBER_NAME(Tags_obj::FileAttributes,"FileAttributes");
	HX_MARK_MEMBER_NAME(Tags_obj::PlaceObject3,"PlaceObject3");
	HX_MARK_MEMBER_NAME(Tags_obj::ImportAssets2,"ImportAssets2");
	HX_MARK_MEMBER_NAME(Tags_obj::DoABC,"DoABC");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFontAlignZones,"DefineFontAlignZones");
	HX_MARK_MEMBER_NAME(Tags_obj::CSMTextSettings,"CSMTextSettings");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFont3,"DefineFont3");
	HX_MARK_MEMBER_NAME(Tags_obj::SymbolClass,"SymbolClass");
	HX_MARK_MEMBER_NAME(Tags_obj::MetaData,"MetaData");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineScalingGrid,"DefineScalingGrid");
	HX_MARK_MEMBER_NAME(Tags_obj::c79,"c79");
	HX_MARK_MEMBER_NAME(Tags_obj::c80,"c80");
	HX_MARK_MEMBER_NAME(Tags_obj::c81,"c81");
	HX_MARK_MEMBER_NAME(Tags_obj::DoABC2,"DoABC2");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineShape4,"DefineShape4");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineMorphShape2,"DefineMorphShape2");
	HX_MARK_MEMBER_NAME(Tags_obj::c85,"c85");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineSceneAndFrameLabelData,"DefineSceneAndFrameLabelData");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineBinaryData,"DefineBinaryData");
	HX_MARK_MEMBER_NAME(Tags_obj::DefineFontName,"DefineFontName");
	HX_MARK_MEMBER_NAME(Tags_obj::StartSound2,"StartSound2");
	HX_MARK_MEMBER_NAME(Tags_obj::LAST,"LAST");
	HX_MARK_MEMBER_NAME(Tags_obj::tags,"tags");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Tags_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Tags_obj::End,"End");
	HX_VISIT_MEMBER_NAME(Tags_obj::ShowFrame,"ShowFrame");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineShape,"DefineShape");
	HX_VISIT_MEMBER_NAME(Tags_obj::FreeCharacter,"FreeCharacter");
	HX_VISIT_MEMBER_NAME(Tags_obj::PlaceObject,"PlaceObject");
	HX_VISIT_MEMBER_NAME(Tags_obj::RemoveObject,"RemoveObject");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBits,"DefineBits");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineButton,"DefineButton");
	HX_VISIT_MEMBER_NAME(Tags_obj::JPEGTables,"JPEGTables");
	HX_VISIT_MEMBER_NAME(Tags_obj::SetBackgroundColor,"SetBackgroundColor");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFont,"DefineFont");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineText,"DefineText");
	HX_VISIT_MEMBER_NAME(Tags_obj::DoAction,"DoAction");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFontInfo,"DefineFontInfo");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineSound,"DefineSound");
	HX_VISIT_MEMBER_NAME(Tags_obj::StartSound,"StartSound");
	HX_VISIT_MEMBER_NAME(Tags_obj::StopSound,"StopSound");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineButtonSound,"DefineButtonSound");
	HX_VISIT_MEMBER_NAME(Tags_obj::SoundStreamHead,"SoundStreamHead");
	HX_VISIT_MEMBER_NAME(Tags_obj::SoundStreamBlock,"SoundStreamBlock");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBitsLossless,"DefineBitsLossless");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBitsJPEG2,"DefineBitsJPEG2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineShape2,"DefineShape2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineButtonCxform,"DefineButtonCxform");
	HX_VISIT_MEMBER_NAME(Tags_obj::Protect,"Protect");
	HX_VISIT_MEMBER_NAME(Tags_obj::PathsArePostScript,"PathsArePostScript");
	HX_VISIT_MEMBER_NAME(Tags_obj::PlaceObject2,"PlaceObject2");
	HX_VISIT_MEMBER_NAME(Tags_obj::c27,"c27");
	HX_VISIT_MEMBER_NAME(Tags_obj::RemoveObject2,"RemoveObject2");
	HX_VISIT_MEMBER_NAME(Tags_obj::SyncFrame,"SyncFrame");
	HX_VISIT_MEMBER_NAME(Tags_obj::c30,"c30");
	HX_VISIT_MEMBER_NAME(Tags_obj::FreeAll,"FreeAll");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineShape3,"DefineShape3");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineText2,"DefineText2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineButton2,"DefineButton2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBitsJPEG3,"DefineBitsJPEG3");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBitsLossless2,"DefineBitsLossless2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineEditText,"DefineEditText");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineVideo,"DefineVideo");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineSprite,"DefineSprite");
	HX_VISIT_MEMBER_NAME(Tags_obj::NameCharacter,"NameCharacter");
	HX_VISIT_MEMBER_NAME(Tags_obj::ProductInfo,"ProductInfo");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineTextFormat,"DefineTextFormat");
	HX_VISIT_MEMBER_NAME(Tags_obj::FrameLabel,"FrameLabel");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBehavior,"DefineBehavior");
	HX_VISIT_MEMBER_NAME(Tags_obj::SoundStreamHead2,"SoundStreamHead2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineMorphShape,"DefineMorphShape");
	HX_VISIT_MEMBER_NAME(Tags_obj::FrameTag,"FrameTag");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFont2,"DefineFont2");
	HX_VISIT_MEMBER_NAME(Tags_obj::GenCommand,"GenCommand");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineCommandObj,"DefineCommandObj");
	HX_VISIT_MEMBER_NAME(Tags_obj::CharacterSet,"CharacterSet");
	HX_VISIT_MEMBER_NAME(Tags_obj::FontRef,"FontRef");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFunction,"DefineFunction");
	HX_VISIT_MEMBER_NAME(Tags_obj::PlaceFunction,"PlaceFunction");
	HX_VISIT_MEMBER_NAME(Tags_obj::GenTagObject,"GenTagObject");
	HX_VISIT_MEMBER_NAME(Tags_obj::ExportAssets,"ExportAssets");
	HX_VISIT_MEMBER_NAME(Tags_obj::ImportAssets,"ImportAssets");
	HX_VISIT_MEMBER_NAME(Tags_obj::EnableDebugger,"EnableDebugger");
	HX_VISIT_MEMBER_NAME(Tags_obj::DoInitAction,"DoInitAction");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineVideoStream,"DefineVideoStream");
	HX_VISIT_MEMBER_NAME(Tags_obj::VideoFrame,"VideoFrame");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFontInfo2,"DefineFontInfo2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DebugID,"DebugID");
	HX_VISIT_MEMBER_NAME(Tags_obj::EnableDebugger2,"EnableDebugger2");
	HX_VISIT_MEMBER_NAME(Tags_obj::ScriptLimits,"ScriptLimits");
	HX_VISIT_MEMBER_NAME(Tags_obj::SetTabIndex,"SetTabIndex");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineShape4_hmm,"DefineShape4_hmm");
	HX_VISIT_MEMBER_NAME(Tags_obj::c68,"c68");
	HX_VISIT_MEMBER_NAME(Tags_obj::FileAttributes,"FileAttributes");
	HX_VISIT_MEMBER_NAME(Tags_obj::PlaceObject3,"PlaceObject3");
	HX_VISIT_MEMBER_NAME(Tags_obj::ImportAssets2,"ImportAssets2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DoABC,"DoABC");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFontAlignZones,"DefineFontAlignZones");
	HX_VISIT_MEMBER_NAME(Tags_obj::CSMTextSettings,"CSMTextSettings");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFont3,"DefineFont3");
	HX_VISIT_MEMBER_NAME(Tags_obj::SymbolClass,"SymbolClass");
	HX_VISIT_MEMBER_NAME(Tags_obj::MetaData,"MetaData");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineScalingGrid,"DefineScalingGrid");
	HX_VISIT_MEMBER_NAME(Tags_obj::c79,"c79");
	HX_VISIT_MEMBER_NAME(Tags_obj::c80,"c80");
	HX_VISIT_MEMBER_NAME(Tags_obj::c81,"c81");
	HX_VISIT_MEMBER_NAME(Tags_obj::DoABC2,"DoABC2");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineShape4,"DefineShape4");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineMorphShape2,"DefineMorphShape2");
	HX_VISIT_MEMBER_NAME(Tags_obj::c85,"c85");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineSceneAndFrameLabelData,"DefineSceneAndFrameLabelData");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineBinaryData,"DefineBinaryData");
	HX_VISIT_MEMBER_NAME(Tags_obj::DefineFontName,"DefineFontName");
	HX_VISIT_MEMBER_NAME(Tags_obj::StartSound2,"StartSound2");
	HX_VISIT_MEMBER_NAME(Tags_obj::LAST,"LAST");
	HX_VISIT_MEMBER_NAME(Tags_obj::tags,"tags");
};

Class Tags_obj::__mClass;

void Tags_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.data.Tags"), hx::TCanCast< Tags_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Tags_obj::__boot()
{
	End= (int)0;
	ShowFrame= (int)1;
	DefineShape= (int)2;
	FreeCharacter= (int)3;
	PlaceObject= (int)4;
	RemoveObject= (int)5;
	DefineBits= (int)6;
	DefineButton= (int)7;
	JPEGTables= (int)8;
	SetBackgroundColor= (int)9;
	DefineFont= (int)10;
	DefineText= (int)11;
	DoAction= (int)12;
	DefineFontInfo= (int)13;
	DefineSound= (int)14;
	StartSound= (int)15;
	StopSound= (int)16;
	DefineButtonSound= (int)17;
	SoundStreamHead= (int)18;
	SoundStreamBlock= (int)19;
	DefineBitsLossless= (int)20;
	DefineBitsJPEG2= (int)21;
	DefineShape2= (int)22;
	DefineButtonCxform= (int)23;
	Protect= (int)24;
	PathsArePostScript= (int)25;
	PlaceObject2= (int)26;
	c27= (int)27;
	RemoveObject2= (int)28;
	SyncFrame= (int)29;
	c30= (int)30;
	FreeAll= (int)31;
	DefineShape3= (int)32;
	DefineText2= (int)33;
	DefineButton2= (int)34;
	DefineBitsJPEG3= (int)35;
	DefineBitsLossless2= (int)36;
	DefineEditText= (int)37;
	DefineVideo= (int)38;
	DefineSprite= (int)39;
	NameCharacter= (int)40;
	ProductInfo= (int)41;
	DefineTextFormat= (int)42;
	FrameLabel= (int)43;
	DefineBehavior= (int)44;
	SoundStreamHead2= (int)45;
	DefineMorphShape= (int)46;
	FrameTag= (int)47;
	DefineFont2= (int)48;
	GenCommand= (int)49;
	DefineCommandObj= (int)50;
	CharacterSet= (int)51;
	FontRef= (int)52;
	DefineFunction= (int)53;
	PlaceFunction= (int)54;
	GenTagObject= (int)55;
	ExportAssets= (int)56;
	ImportAssets= (int)57;
	EnableDebugger= (int)58;
	DoInitAction= (int)59;
	DefineVideoStream= (int)60;
	VideoFrame= (int)61;
	DefineFontInfo2= (int)62;
	DebugID= (int)63;
	EnableDebugger2= (int)64;
	ScriptLimits= (int)65;
	SetTabIndex= (int)66;
	DefineShape4_hmm= (int)67;
	c68= (int)68;
	FileAttributes= (int)69;
	PlaceObject3= (int)70;
	ImportAssets2= (int)71;
	DoABC= (int)72;
	DefineFontAlignZones= (int)73;
	CSMTextSettings= (int)74;
	DefineFont3= (int)75;
	SymbolClass= (int)76;
	MetaData= (int)77;
	DefineScalingGrid= (int)78;
	c79= (int)79;
	c80= (int)80;
	c81= (int)81;
	DoABC2= (int)82;
	DefineShape4= (int)83;
	DefineMorphShape2= (int)84;
	c85= (int)85;
	DefineSceneAndFrameLabelData= (int)86;
	DefineBinaryData= (int)87;
	DefineFontName= (int)88;
	StartSound2= (int)89;
	LAST= (int)90;
	tags= Array_obj< ::String >::__new().Add(HX_CSTRING("End")).Add(HX_CSTRING("ShowFrame")).Add(HX_CSTRING("DefineShape")).Add(HX_CSTRING("FreeCharacter")).Add(HX_CSTRING("PlaceObject")).Add(HX_CSTRING("RemoveObject")).Add(HX_CSTRING("DefineBits")).Add(HX_CSTRING("DefineButton")).Add(HX_CSTRING("JPEGTables")).Add(HX_CSTRING("SetBackgroundColor")).Add(HX_CSTRING("DefineFont")).Add(HX_CSTRING("DefineText")).Add(HX_CSTRING("DoAction")).Add(HX_CSTRING("DefineFontInfo")).Add(HX_CSTRING("DefineSound")).Add(HX_CSTRING("StartSound")).Add(HX_CSTRING("StopSound")).Add(HX_CSTRING("DefineButtonSound")).Add(HX_CSTRING("SoundStreamHead")).Add(HX_CSTRING("SoundStreamBlock")).Add(HX_CSTRING("DefineBitsLossless")).Add(HX_CSTRING("DefineBitsJPEG2")).Add(HX_CSTRING("DefineShape2")).Add(HX_CSTRING("DefineButtonCxform")).Add(HX_CSTRING("Protect")).Add(HX_CSTRING("PathsArePostScript")).Add(HX_CSTRING("PlaceObject2")).Add(HX_CSTRING("27 (invalid)")).Add(HX_CSTRING("RemoveObject2")).Add(HX_CSTRING("SyncFrame")).Add(HX_CSTRING("30 (invalid)")).Add(HX_CSTRING("FreeAll")).Add(HX_CSTRING("DefineShape3")).Add(HX_CSTRING("DefineText2")).Add(HX_CSTRING("DefineButton2")).Add(HX_CSTRING("DefineBitsJPEG3")).Add(HX_CSTRING("DefineBitsLossless2")).Add(HX_CSTRING("DefineEditText")).Add(HX_CSTRING("DefineVideo")).Add(HX_CSTRING("DefineSprite")).Add(HX_CSTRING("NameCharacter")).Add(HX_CSTRING("ProductInfo")).Add(HX_CSTRING("DefineTextFormat")).Add(HX_CSTRING("FrameLabel")).Add(HX_CSTRING("DefineBehavior")).Add(HX_CSTRING("SoundStreamHead2")).Add(HX_CSTRING("DefineMorphShape")).Add(HX_CSTRING("FrameTag")).Add(HX_CSTRING("DefineFont2")).Add(HX_CSTRING("GenCommand")).Add(HX_CSTRING("DefineCommandObj")).Add(HX_CSTRING("CharacterSet")).Add(HX_CSTRING("FontRef")).Add(HX_CSTRING("DefineFunction")).Add(HX_CSTRING("PlaceFunction")).Add(HX_CSTRING("GenTagObject")).Add(HX_CSTRING("ExportAssets")).Add(HX_CSTRING("ImportAssets")).Add(HX_CSTRING("EnableDebugger")).Add(HX_CSTRING("DoInitAction")).Add(HX_CSTRING("DefineVideoStream")).Add(HX_CSTRING("VideoFrame")).Add(HX_CSTRING("DefineFontInfo2")).Add(HX_CSTRING("DebugID")).Add(HX_CSTRING("EnableDebugger2")).Add(HX_CSTRING("ScriptLimits")).Add(HX_CSTRING("SetTabIndex")).Add(HX_CSTRING("DefineShape4")).Add(HX_CSTRING("DefineMorphShape2")).Add(HX_CSTRING("FileAttributes")).Add(HX_CSTRING("PlaceObject3")).Add(HX_CSTRING("ImportAssets2")).Add(HX_CSTRING("DoABC")).Add(HX_CSTRING("DefineFontAlignZones")).Add(HX_CSTRING("CSMTextSettings")).Add(HX_CSTRING("DefineFont3")).Add(HX_CSTRING("SymbolClass")).Add(HX_CSTRING("Metadata")).Add(HX_CSTRING("DefineScalingGrid")).Add(HX_CSTRING("79 (invalid)")).Add(HX_CSTRING("80 (invalid)")).Add(HX_CSTRING("81 (invalid)")).Add(HX_CSTRING("DoABC2")).Add(HX_CSTRING("DefineShape4")).Add(HX_CSTRING("DefineMorphShape2")).Add(HX_CSTRING("c85")).Add(HX_CSTRING("DefineSceneAndFrameLabelData")).Add(HX_CSTRING("DefineBinaryData")).Add(HX_CSTRING("DefineFontName")).Add(HX_CSTRING("StartSound2")).Add(HX_CSTRING("LAST"));
}

} // end namespace format
} // end namespace swf
} // end namespace data
