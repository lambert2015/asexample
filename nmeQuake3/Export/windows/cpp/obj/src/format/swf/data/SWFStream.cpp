#include <hxcpp.h>

#ifndef INCLUDED_format_swf_data_SWFStream
#include <format/swf/data/SWFStream.h>
#endif
#ifndef INCLUDED_format_swf_data_Tags
#include <format/swf/data/Tags.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_native_display_CapsStyle
#include <native/display/CapsStyle.h>
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
#ifndef INCLUDED_native_geom_ColorTransform
#include <native/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_native_geom_Matrix
#include <native/geom/Matrix.h>
#endif
#ifndef INCLUDED_native_geom_Rectangle
#include <native/geom/Rectangle.h>
#endif
#ifndef INCLUDED_native_text_TextFormatAlign
#include <native/text/TextFormatAlign.h>
#endif
#ifndef INCLUDED_native_utils_ByteArray
#include <native/utils/ByteArray.h>
#endif
#ifndef INCLUDED_native_utils_CompressionAlgorithm
#include <native/utils/CompressionAlgorithm.h>
#endif
#ifndef INCLUDED_native_utils_IDataInput
#include <native/utils/IDataInput.h>
#endif
#ifndef INCLUDED_native_utils_IMemoryRange
#include <native/utils/IMemoryRange.h>
#endif
namespace format{
namespace swf{
namespace data{

Void SWFStream_obj::__construct(::native::utils::ByteArray bytes)
{
HX_STACK_PUSH("SWFStream::new","format/swf/data/SWFStream.hx",33);
{
	HX_STACK_LINE(35)
	this->stream = bytes;
	HX_STACK_LINE(36)
	this->stream->position = (int)0;
	HX_STACK_LINE(38)
	::String signature = HX_CSTRING("");		HX_STACK_VAR(signature,"signature");
	struct _Function_1_1{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",40);
			{
				HX_STACK_LINE(40)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(40)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(40)
	hx::AddEq(signature,::String::fromCharCode(_Function_1_1::Block(this)));
	struct _Function_1_2{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",41);
			{
				HX_STACK_LINE(41)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(41)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(41)
	hx::AddEq(signature,::String::fromCharCode(_Function_1_2::Block(this)));
	struct _Function_1_3{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",42);
			{
				HX_STACK_LINE(42)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(42)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(42)
	hx::AddEq(signature,::String::fromCharCode(_Function_1_3::Block(this)));
	HX_STACK_LINE(44)
	if (((bool((signature != HX_CSTRING("FWS"))) && bool((signature != HX_CSTRING("CWS")))))){
		HX_STACK_LINE(44)
		hx::Throw (HX_CSTRING("Invalid signature"));
	}
	struct _Function_1_4{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",50);
			{
				HX_STACK_LINE(50)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(50)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(50)
	this->version = _Function_1_4::Block(this);
	HX_STACK_LINE(51)
	int length = this->stream->readInt();		HX_STACK_VAR(length,"length");
	HX_STACK_LINE(53)
	if (((signature == HX_CSTRING("CWS")))){
		HX_STACK_LINE(55)
		::native::utils::ByteArray buffer = ::native::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(buffer,"buffer");
		HX_STACK_LINE(56)
		this->stream->readBytes(buffer,null(),null());
		HX_STACK_LINE(57)
		buffer->uncompress(null());
		HX_STACK_LINE(58)
		this->stream = buffer;
	}
	HX_STACK_LINE(62)
	this->stream->set_endian(HX_CSTRING("littleEndian"));
	HX_STACK_LINE(64)
	this->bitPosition = (int)0;
	HX_STACK_LINE(65)
	this->byteBuffer = (int)0;
	HX_STACK_LINE(66)
	this->tagRead = (int)0;
}
;
	return null();
}

SWFStream_obj::~SWFStream_obj() { }

Dynamic SWFStream_obj::__CreateEmpty() { return  new SWFStream_obj; }
hx::ObjectPtr< SWFStream_obj > SWFStream_obj::__new(::native::utils::ByteArray bytes)
{  hx::ObjectPtr< SWFStream_obj > result = new SWFStream_obj();
	result->__construct(bytes);
	return result;}

Dynamic SWFStream_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SWFStream_obj > result = new SWFStream_obj();
	result->__construct(inArgs[0]);
	return result;}

int SWFStream_obj::set_position( int value){
	HX_STACK_PUSH("SWFStream::set_position","format/swf/data/SWFStream.hx",624);
	HX_STACK_THIS(this);
	HX_STACK_ARG(value,"value");
	HX_STACK_LINE(624)
	return this->stream->position = value;
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,set_position,return )

int SWFStream_obj::get_position( ){
	HX_STACK_PUSH("SWFStream::get_position","format/swf/data/SWFStream.hx",617);
	HX_STACK_THIS(this);
	HX_STACK_LINE(617)
	return this->stream->position;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,get_position,return )

Float SWFStream_obj::readUTwips( ){
	HX_STACK_PUSH("SWFStream::readUTwips","format/swf/data/SWFStream.hx",603);
	HX_STACK_THIS(this);
	HX_STACK_LINE(603)
	return (this->readUInt16() * 0.05);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readUTwips,return )

int SWFStream_obj::readUInt16( ){
	HX_STACK_PUSH("SWFStream::readUInt16","format/swf/data/SWFStream.hx",595);
	HX_STACK_THIS(this);
	HX_STACK_LINE(597)
	hx::AddEq(this->tagRead,(int)2);
	HX_STACK_LINE(598)
	return this->stream->readUnsignedShort();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readUInt16,return )

Float SWFStream_obj::readTwips( int length){
	HX_STACK_PUSH("SWFStream::readTwips","format/swf/data/SWFStream.hx",588);
	HX_STACK_THIS(this);
	HX_STACK_ARG(length,"length");
	HX_STACK_LINE(588)
	return (this->readBits(length,true) * 0.05);
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,readTwips,return )

::String SWFStream_obj::readString( ){
	HX_STACK_PUSH("SWFStream::readString","format/swf/data/SWFStream.hx",565);
	HX_STACK_THIS(this);
	HX_STACK_LINE(567)
	::String result = HX_CSTRING("");		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(569)
	while((true)){
		HX_STACK_LINE(571)
		int code = this->readByte();		HX_STACK_VAR(code,"code");
		HX_STACK_LINE(573)
		if (((code == (int)0))){
			HX_STACK_LINE(573)
			return result;
		}
		HX_STACK_LINE(579)
		hx::AddEq(result,::String::fromCharCode(code));
	}
	HX_STACK_LINE(583)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readString,return )

::native::display::SpreadMethod SWFStream_obj::readSpreadMethod( ){
	HX_STACK_PUSH("SWFStream::readSpreadMethod","format/swf/data/SWFStream.hx",549);
	HX_STACK_THIS(this);
	HX_STACK_LINE(551)
	{
		HX_STACK_LINE(551)
		int _g = this->readBits((int)2,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(551)
		switch( (int)(_g)){
			case (int)0: {
				HX_STACK_LINE(553)
				return ::native::display::SpreadMethod_obj::PAD;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(554)
				return ::native::display::SpreadMethod_obj::REFLECT;
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(555)
				return ::native::display::SpreadMethod_obj::REPEAT;
			}
			;break;
			case (int)3: {
				HX_STACK_LINE(556)
				return ::native::display::SpreadMethod_obj::PAD;
			}
			;break;
		}
	}
	HX_STACK_LINE(560)
	return ::native::display::SpreadMethod_obj::REPEAT;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readSpreadMethod,return )

Float SWFStream_obj::readSTwips( ){
	HX_STACK_PUSH("SWFStream::readSTwips","format/swf/data/SWFStream.hx",542);
	HX_STACK_THIS(this);
	HX_STACK_LINE(542)
	return (this->readSInt16() * 0.05);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readSTwips,return )

int SWFStream_obj::readSInt16( ){
	HX_STACK_PUSH("SWFStream::readSInt16","format/swf/data/SWFStream.hx",534);
	HX_STACK_THIS(this);
	HX_STACK_LINE(536)
	hx::AddEq(this->tagRead,(int)2);
	HX_STACK_LINE(537)
	return this->stream->readShort();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readSInt16,return )

::native::display::LineScaleMode SWFStream_obj::readScaleMode( ){
	HX_STACK_PUSH("SWFStream::readScaleMode","format/swf/data/SWFStream.hx",518);
	HX_STACK_THIS(this);
	HX_STACK_LINE(520)
	{
		HX_STACK_LINE(520)
		int _g = this->readBits((int)2,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(520)
		switch( (int)(_g)){
			case (int)0: {
				HX_STACK_LINE(522)
				return ::native::display::LineScaleMode_obj::NORMAL;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(523)
				return ::native::display::LineScaleMode_obj::HORIZONTAL;
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(524)
				return ::native::display::LineScaleMode_obj::VERTICAL;
			}
			;break;
			case (int)3: {
				HX_STACK_LINE(525)
				return ::native::display::LineScaleMode_obj::NONE;
			}
			;break;
		}
	}
	HX_STACK_LINE(529)
	return ::native::display::LineScaleMode_obj::NORMAL;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readScaleMode,return )

int SWFStream_obj::readRGB( ){
	HX_STACK_PUSH("SWFStream::readRGB","format/swf/data/SWFStream.hx",507);
	HX_STACK_THIS(this);
	HX_STACK_LINE(509)
	hx::AddEq(this->tagRead,(int)3);
	struct _Function_1_1{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",510);
			{
				HX_STACK_LINE(510)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(510)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(510)
	int r = _Function_1_1::Block(this);		HX_STACK_VAR(r,"r");
	struct _Function_1_2{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",511);
			{
				HX_STACK_LINE(511)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(511)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(511)
	int g = _Function_1_2::Block(this);		HX_STACK_VAR(g,"g");
	struct _Function_1_3{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",512);
			{
				HX_STACK_LINE(512)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(512)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(512)
	int b = _Function_1_3::Block(this);		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(513)
	return (int((int((int(r) << int((int)16))) | int((int(g) << int((int)8))))) | int(b));
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readRGB,return )

::native::geom::Rectangle SWFStream_obj::readRect( ){
	HX_STACK_PUSH("SWFStream::readRect","format/swf/data/SWFStream.hx",491);
	HX_STACK_THIS(this);
	HX_STACK_LINE(493)
	this->alignBits();
	HX_STACK_LINE(495)
	int bits = this->readBits((int)5,null());		HX_STACK_VAR(bits,"bits");
	HX_STACK_LINE(497)
	Float x0 = this->readTwips(bits);		HX_STACK_VAR(x0,"x0");
	HX_STACK_LINE(498)
	Float x1 = this->readTwips(bits);		HX_STACK_VAR(x1,"x1");
	HX_STACK_LINE(499)
	Float y0 = this->readTwips(bits);		HX_STACK_VAR(y0,"y0");
	HX_STACK_LINE(500)
	Float y1 = this->readTwips(bits);		HX_STACK_VAR(y1,"y1");
	HX_STACK_LINE(502)
	return ::native::geom::Rectangle_obj::__new(x0,y0,(x1 - x0),(y1 - y0));
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readRect,return )

::String SWFStream_obj::readPascalString( ){
	HX_STACK_PUSH("SWFStream::readPascalString","format/swf/data/SWFStream.hx",469);
	HX_STACK_THIS(this);
	HX_STACK_LINE(471)
	int length = this->readByte();		HX_STACK_VAR(length,"length");
	HX_STACK_LINE(472)
	::String result = HX_CSTRING("");		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(474)
	{
		HX_STACK_LINE(474)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(474)
		while(((_g < length))){
			HX_STACK_LINE(474)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(476)
			int code = this->readByte();		HX_STACK_VAR(code,"code");
			HX_STACK_LINE(478)
			if (((code > (int)0))){
				HX_STACK_LINE(478)
				hx::AddEq(result,::String::fromCharCode(code));
			}
		}
	}
	HX_STACK_LINE(486)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readPascalString,return )

::native::geom::Matrix SWFStream_obj::readMatrix( ){
	HX_STACK_PUSH("SWFStream::readMatrix","format/swf/data/SWFStream.hx",441);
	HX_STACK_THIS(this);
	HX_STACK_LINE(443)
	::native::geom::Matrix result = ::native::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(445)
	this->alignBits();
	HX_STACK_LINE(447)
	bool hasScale = this->readBool();		HX_STACK_VAR(hasScale,"hasScale");
	HX_STACK_LINE(448)
	int scaleBits = (  ((hasScale)) ? int(this->readBits((int)5,null())) : int((int)0) );		HX_STACK_VAR(scaleBits,"scaleBits");
	HX_STACK_LINE(450)
	result->a = (  ((hasScale)) ? Float(this->readFixedBits(scaleBits)) : Float(1.0) );
	HX_STACK_LINE(451)
	result->d = (  ((hasScale)) ? Float(this->readFixedBits(scaleBits)) : Float(1.0) );
	HX_STACK_LINE(453)
	bool hasRotate = this->readBool();		HX_STACK_VAR(hasRotate,"hasRotate");
	HX_STACK_LINE(454)
	int rotateBits = (  ((hasRotate)) ? int(this->readBits((int)5,null())) : int((int)0) );		HX_STACK_VAR(rotateBits,"rotateBits");
	HX_STACK_LINE(456)
	result->b = (  ((hasRotate)) ? Float(this->readFixedBits(rotateBits)) : Float(0.0) );
	HX_STACK_LINE(457)
	result->c = (  ((hasRotate)) ? Float(this->readFixedBits(rotateBits)) : Float(0.0) );
	HX_STACK_LINE(459)
	int transBits = this->readBits((int)5,null());		HX_STACK_VAR(transBits,"transBits");
	HX_STACK_LINE(461)
	result->tx = this->readTwips(transBits);
	HX_STACK_LINE(462)
	result->ty = this->readTwips(transBits);
	HX_STACK_LINE(464)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readMatrix,return )

::native::display::JointStyle SWFStream_obj::readJoinStyle( ){
	HX_STACK_PUSH("SWFStream::readJoinStyle","format/swf/data/SWFStream.hx",426);
	HX_STACK_THIS(this);
	HX_STACK_LINE(428)
	{
		HX_STACK_LINE(428)
		int _g = this->readBits((int)2,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(428)
		switch( (int)(_g)){
			case (int)0: {
				HX_STACK_LINE(430)
				return ::native::display::JointStyle_obj::ROUND;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(431)
				return ::native::display::JointStyle_obj::BEVEL;
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(432)
				return ::native::display::JointStyle_obj::MITER;
			}
			;break;
		}
	}
	HX_STACK_LINE(436)
	return ::native::display::JointStyle_obj::ROUND;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readJoinStyle,return )

::native::display::InterpolationMethod SWFStream_obj::readInterpolationMethod( ){
	HX_STACK_PUSH("SWFStream::readInterpolationMethod","format/swf/data/SWFStream.hx",412);
	HX_STACK_THIS(this);
	HX_STACK_LINE(414)
	{
		HX_STACK_LINE(414)
		int _g = this->readBits((int)2,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(414)
		switch( (int)(_g)){
			case (int)0: {
				HX_STACK_LINE(416)
				return ::native::display::InterpolationMethod_obj::RGB;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(417)
				return ::native::display::InterpolationMethod_obj::LINEAR_RGB;
			}
			;break;
		}
	}
	HX_STACK_LINE(421)
	return ::native::display::InterpolationMethod_obj::RGB;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readInterpolationMethod,return )

int SWFStream_obj::readInt( ){
	HX_STACK_PUSH("SWFStream::readInt","format/swf/data/SWFStream.hx",404);
	HX_STACK_THIS(this);
	HX_STACK_LINE(406)
	hx::AddEq(this->tagRead,(int)4);
	HX_STACK_LINE(407)
	return this->stream->readInt();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readInt,return )

int SWFStream_obj::readID( ){
	HX_STACK_PUSH("SWFStream::readID","format/swf/data/SWFStream.hx",395);
	HX_STACK_THIS(this);
	HX_STACK_LINE(397)
	hx::AddEq(this->tagRead,(int)2);
	HX_STACK_LINE(399)
	return this->stream->readUnsignedShort();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readID,return )

int SWFStream_obj::readFrames( ){
	HX_STACK_PUSH("SWFStream::readFrames","format/swf/data/SWFStream.hx",388);
	HX_STACK_THIS(this);
	HX_STACK_LINE(388)
	return this->stream->readUnsignedShort();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readFrames,return )

Float SWFStream_obj::readFrameRate( ){
	HX_STACK_PUSH("SWFStream::readFrameRate","format/swf/data/SWFStream.hx",381);
	HX_STACK_THIS(this);
	HX_STACK_LINE(381)
	return (Float(this->stream->readUnsignedShort()) / Float(256.0));
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readFrameRate,return )

Float SWFStream_obj::readFloat( ){
	HX_STACK_PUSH("SWFStream::readFloat","format/swf/data/SWFStream.hx",373);
	HX_STACK_THIS(this);
	HX_STACK_LINE(375)
	hx::AddEq(this->tagRead,(int)4);
	HX_STACK_LINE(376)
	return this->stream->readInt();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readFloat,return )

::native::utils::ByteArray SWFStream_obj::readFlashBytes( int length){
	HX_STACK_PUSH("SWFStream::readFlashBytes","format/swf/data/SWFStream.hx",363);
	HX_STACK_THIS(this);
	HX_STACK_ARG(length,"length");
	HX_STACK_LINE(365)
	::native::utils::ByteArray bytes = ::native::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(366)
	this->stream->readBytes(bytes,(int)0,length);
	HX_STACK_LINE(367)
	hx::AddEq(this->tagRead,length);
	HX_STACK_LINE(368)
	return bytes;
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,readFlashBytes,return )

Float SWFStream_obj::readFixedBits( int length){
	HX_STACK_PUSH("SWFStream::readFixedBits","format/swf/data/SWFStream.hx",356);
	HX_STACK_THIS(this);
	HX_STACK_ARG(length,"length");
	HX_STACK_LINE(356)
	return (Float(this->readBits(length,true)) / Float(65536.0));
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,readFixedBits,return )

Float SWFStream_obj::readFixed8( ){
	HX_STACK_PUSH("SWFStream::readFixed8","format/swf/data/SWFStream.hx",346);
	HX_STACK_THIS(this);
	HX_STACK_LINE(348)
	this->alignBits();
	HX_STACK_LINE(350)
	Float frac = (Float(this->readByte()) / Float(256.0));		HX_STACK_VAR(frac,"frac");
	HX_STACK_LINE(351)
	return (this->readByte() + frac);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readFixed8,return )

Float SWFStream_obj::readFixed( ){
	HX_STACK_PUSH("SWFStream::readFixed","format/swf/data/SWFStream.hx",336);
	HX_STACK_THIS(this);
	HX_STACK_LINE(338)
	this->alignBits();
	HX_STACK_LINE(340)
	Float frac = (Float(this->readUInt16()) / Float(65536.0));		HX_STACK_VAR(frac,"frac");
	HX_STACK_LINE(341)
	return (this->readUInt16() + frac);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readFixed,return )

int SWFStream_obj::readDepth( ){
	HX_STACK_PUSH("SWFStream::readDepth","format/swf/data/SWFStream.hx",327);
	HX_STACK_THIS(this);
	HX_STACK_LINE(329)
	hx::AddEq(this->tagRead,(int)2);
	HX_STACK_LINE(331)
	return this->stream->readUnsignedShort();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readDepth,return )

::native::geom::ColorTransform SWFStream_obj::readColorTransform( bool withAlpha){
	HX_STACK_PUSH("SWFStream::readColorTransform","format/swf/data/SWFStream.hx",274);
	HX_STACK_THIS(this);
	HX_STACK_ARG(withAlpha,"withAlpha");
	HX_STACK_LINE(276)
	this->alignBits();
	HX_STACK_LINE(278)
	::native::geom::ColorTransform result = ::native::geom::ColorTransform_obj::__new(null(),null(),null(),null(),null(),null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(280)
	bool hasOffset = this->readBool();		HX_STACK_VAR(hasOffset,"hasOffset");
	HX_STACK_LINE(281)
	bool hasMultiplier = this->readBool();		HX_STACK_VAR(hasMultiplier,"hasMultiplier");
	HX_STACK_LINE(283)
	int length = this->readBits((int)4,null());		HX_STACK_VAR(length,"length");
	HX_STACK_LINE(285)
	if (((bool(!(hasOffset)) && bool(!(hasMultiplier))))){
		HX_STACK_LINE(287)
		this->alignBits();
		HX_STACK_LINE(288)
		return null();
	}
	HX_STACK_LINE(292)
	if ((hasMultiplier)){
		HX_STACK_LINE(294)
		result->redMultiplier = (Float(this->readBits(length,true)) / Float(256.0));
		HX_STACK_LINE(295)
		result->greenMultiplier = (Float(this->readBits(length,true)) / Float(256.0));
		HX_STACK_LINE(296)
		result->blueMultiplier = (Float(this->readBits(length,true)) / Float(256.0));
		HX_STACK_LINE(298)
		if ((withAlpha)){
			HX_STACK_LINE(298)
			result->alphaMultiplier = (Float(this->readBits(length,true)) / Float(256.0));
		}
	}
	HX_STACK_LINE(306)
	if ((hasOffset)){
		HX_STACK_LINE(308)
		result->redOffset = this->readBits(length,true);
		HX_STACK_LINE(309)
		result->greenOffset = this->readBits(length,true);
		HX_STACK_LINE(310)
		result->blueOffset = this->readBits(length,true);
		HX_STACK_LINE(312)
		if ((withAlpha)){
			HX_STACK_LINE(312)
			result->alphaOffset = this->readBits(length,true);
		}
	}
	HX_STACK_LINE(320)
	this->alignBits();
	HX_STACK_LINE(322)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,readColorTransform,return )

::native::display::CapsStyle SWFStream_obj::readCapsStyle( ){
	HX_STACK_PUSH("SWFStream::readCapsStyle","format/swf/data/SWFStream.hx",259);
	HX_STACK_THIS(this);
	HX_STACK_LINE(261)
	{
		HX_STACK_LINE(261)
		int _g = this->readBits((int)2,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(261)
		switch( (int)(_g)){
			case (int)0: {
				HX_STACK_LINE(263)
				return ::native::display::CapsStyle_obj::ROUND;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(264)
				return ::native::display::CapsStyle_obj::NONE;
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(265)
				return ::native::display::CapsStyle_obj::SQUARE;
			}
			;break;
		}
	}
	HX_STACK_LINE(269)
	return ::native::display::CapsStyle_obj::ROUND;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readCapsStyle,return )

::native::utils::ByteArray SWFStream_obj::readBytes( int length){
	HX_STACK_PUSH("SWFStream::readBytes","format/swf/data/SWFStream.hx",249);
	HX_STACK_THIS(this);
	HX_STACK_ARG(length,"length");
	HX_STACK_LINE(251)
	::native::utils::ByteArray bytes = ::native::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(252)
	this->stream->readBytes(bytes,(int)0,length);
	HX_STACK_LINE(253)
	hx::AddEq(this->tagRead,length);
	HX_STACK_LINE(254)
	return bytes;
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,readBytes,return )

int SWFStream_obj::readByte( ){
	HX_STACK_PUSH("SWFStream::readByte","format/swf/data/SWFStream.hx",241);
	HX_STACK_THIS(this);
	HX_STACK_LINE(243)
	(this->tagRead)++;
	struct _Function_1_1{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",244);
			{
				HX_STACK_LINE(244)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(244)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(244)
	return _Function_1_1::Block(this);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readByte,return )

bool SWFStream_obj::readBool( ){
	HX_STACK_PUSH("SWFStream::readBool","format/swf/data/SWFStream.hx",234);
	HX_STACK_THIS(this);
	HX_STACK_LINE(234)
	return (this->readBits((int)1,null()) == (int)1);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readBool,return )

int SWFStream_obj::readBits( int length,hx::Null< bool >  __o_isSigned){
bool isSigned = __o_isSigned.Default(false);
	HX_STACK_PUSH("SWFStream::readBits","format/swf/data/SWFStream.hx",190);
	HX_STACK_THIS(this);
	HX_STACK_ARG(length,"length");
	HX_STACK_ARG(isSigned,"isSigned");
{
		HX_STACK_LINE(192)
		int signBit = (length - (int)1);		HX_STACK_VAR(signBit,"signBit");
		HX_STACK_LINE(193)
		int result = (int)0;		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(194)
		int bitsLeft = length;		HX_STACK_VAR(bitsLeft,"bitsLeft");
		HX_STACK_LINE(196)
		while(((bitsLeft != (int)0))){
			HX_STACK_LINE(198)
			if (((this->bitPosition == (int)0))){
				struct _Function_3_1{
					inline static int Block( ::format::swf::data::SWFStream_obj *__this){
						HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",200);
						{
							HX_STACK_LINE(200)
							::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
							HX_STACK_LINE(200)
							return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
						}
						return null();
					}
				};
				HX_STACK_LINE(200)
				this->byteBuffer = _Function_3_1::Block(this);
				HX_STACK_LINE(201)
				(this->tagRead)++;
				HX_STACK_LINE(202)
				this->bitPosition = (int)8;
			}
			HX_STACK_LINE(206)
			while(((bool((this->bitPosition > (int)0)) && bool((bitsLeft > (int)0))))){
				HX_STACK_LINE(208)
				result = (int((int(result) << int((int)1))) | int((int((int(this->byteBuffer) >> int((int)7))) & int((int)1))));
				HX_STACK_LINE(209)
				(this->bitPosition)--;
				HX_STACK_LINE(210)
				(bitsLeft)--;
				HX_STACK_LINE(211)
				hx::ShlEq(this->byteBuffer,(int)1);
			}
		}
		HX_STACK_LINE(217)
		if ((isSigned)){
			HX_STACK_LINE(219)
			int mask = (int((int)1) << int(signBit));		HX_STACK_VAR(mask,"mask");
			HX_STACK_LINE(221)
			if (((((int(result) & int(mask))) != (int)0))){
				HX_STACK_LINE(221)
				hx::SubEq(result,(int((int)1) << int(length)));
			}
		}
		HX_STACK_LINE(229)
		return result;
	}
}


HX_DEFINE_DYNAMIC_FUNC2(SWFStream_obj,readBits,return )

int SWFStream_obj::readArraySize( bool extended){
	HX_STACK_PUSH("SWFStream::readArraySize","format/swf/data/SWFStream.hx",173);
	HX_STACK_THIS(this);
	HX_STACK_ARG(extended,"extended");
	HX_STACK_LINE(175)
	(this->tagRead)++;
	struct _Function_1_1{
		inline static int Block( ::format::swf::data::SWFStream_obj *__this){
			HX_STACK_PUSH("*::closure","format/swf/data/SWFStream.hx",176);
			{
				HX_STACK_LINE(176)
				::native::utils::ByteArray _this = __this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(176)
				return (  (((_this->position < _this->length))) ? int(_this->b->__get((_this->position)++)) : int(_this->ThrowEOFi()) );
			}
			return null();
		}
	};
	HX_STACK_LINE(176)
	int result = _Function_1_1::Block(this);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(178)
	if (((bool(extended) && bool((result == (int)255))))){
		HX_STACK_LINE(180)
		hx::AddEq(this->tagRead,(int)2);
		HX_STACK_LINE(181)
		result = this->stream->readUnsignedShort();
	}
	HX_STACK_LINE(185)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(SWFStream_obj,readArraySize,return )

::String SWFStream_obj::readAlign( ){
	HX_STACK_PUSH("SWFStream::readAlign","format/swf/data/SWFStream.hx",157);
	HX_STACK_THIS(this);
	HX_STACK_LINE(159)
	{
		HX_STACK_LINE(159)
		int _g = this->readByte();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(159)
		switch( (int)(_g)){
			case (int)0: {
				HX_STACK_LINE(161)
				return ::native::text::TextFormatAlign_obj::LEFT;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(162)
				return ::native::text::TextFormatAlign_obj::RIGHT;
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(163)
				return ::native::text::TextFormatAlign_obj::CENTER;
			}
			;break;
			case (int)3: {
				HX_STACK_LINE(164)
				return ::native::text::TextFormatAlign_obj::JUSTIFY;
			}
			;break;
		}
	}
	HX_STACK_LINE(168)
	return ::native::text::TextFormatAlign_obj::LEFT;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,readAlign,return )

Void SWFStream_obj::pushTag( ){
{
		HX_STACK_PUSH("SWFStream::pushTag","format/swf/data/SWFStream.hx",149);
		HX_STACK_THIS(this);
		HX_STACK_LINE(151)
		this->pushTagRead = this->tagRead;
		HX_STACK_LINE(152)
		this->pushTagSize = this->tagSize;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,pushTag,(void))

Void SWFStream_obj::popTag( ){
{
		HX_STACK_PUSH("SWFStream::popTag","format/swf/data/SWFStream.hx",140);
		HX_STACK_THIS(this);
		HX_STACK_LINE(143)
		this->tagRead = this->pushTagSize;
		HX_STACK_LINE(144)
		this->tagSize = this->pushTagSize;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,popTag,(void))

int SWFStream_obj::getVersion( ){
	HX_STACK_PUSH("SWFStream::getVersion","format/swf/data/SWFStream.hx",133);
	HX_STACK_THIS(this);
	HX_STACK_LINE(133)
	return this->version;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,getVersion,return )

int SWFStream_obj::getBytesLeft( ){
	HX_STACK_PUSH("SWFStream::getBytesLeft","format/swf/data/SWFStream.hx",126);
	HX_STACK_THIS(this);
	HX_STACK_LINE(126)
	return (this->tagSize - this->tagRead);
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,getBytesLeft,return )

Void SWFStream_obj::endTag( ){
{
		HX_STACK_PUSH("SWFStream::endTag","format/swf/data/SWFStream.hx",105);
		HX_STACK_THIS(this);
		HX_STACK_LINE(107)
		int read = this->tagRead;		HX_STACK_VAR(read,"read");
		HX_STACK_LINE(108)
		int size = this->tagSize;		HX_STACK_VAR(size,"size");
		HX_STACK_LINE(110)
		if (((read > size))){
			HX_STACK_LINE(110)
			hx::Throw (HX_CSTRING("Tag read overflow"));
		}
		HX_STACK_LINE(116)
		while(((read < size))){
			HX_STACK_LINE(118)
			{
				HX_STACK_LINE(118)
				::native::utils::ByteArray _this = this->stream;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(118)
				if (((_this->position < _this->length))){
					HX_STACK_LINE(118)
					_this->b->__get((_this->position)++);
				}
				else{
					HX_STACK_LINE(118)
					_this->ThrowEOFi();
				}
			}
			HX_STACK_LINE(119)
			(read)++;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,endTag,(void))

Void SWFStream_obj::close( ){
{
		HX_STACK_PUSH("SWFStream::close","format/swf/data/SWFStream.hx",98);
		HX_STACK_THIS(this);
		HX_STACK_LINE(98)
		this->stream = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,close,(void))

int SWFStream_obj::beginTag( ){
	HX_STACK_PUSH("SWFStream::beginTag","format/swf/data/SWFStream.hx",78);
	HX_STACK_THIS(this);
	HX_STACK_LINE(80)
	int data = this->stream->readUnsignedShort();		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(81)
	int tag = (int(data) >> int((int)6));		HX_STACK_VAR(tag,"tag");
	HX_STACK_LINE(82)
	int length = (int(data) & int((int)63));		HX_STACK_VAR(length,"length");
	HX_STACK_LINE(84)
	if (((tag >= ::format::swf::data::Tags_obj::LAST))){
		HX_STACK_LINE(85)
		return (int)0;
	}
	HX_STACK_LINE(87)
	if (((length == (int)63))){
		HX_STACK_LINE(88)
		length = this->stream->readUnsignedInt();
	}
	HX_STACK_LINE(90)
	this->tagSize = length;
	HX_STACK_LINE(91)
	this->tagRead = (int)0;
	HX_STACK_LINE(93)
	return tag;
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,beginTag,return )

Void SWFStream_obj::alignBits( ){
{
		HX_STACK_PUSH("SWFStream::alignBits","format/swf/data/SWFStream.hx",71);
		HX_STACK_THIS(this);
		HX_STACK_LINE(71)
		this->bitPosition = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SWFStream_obj,alignBits,(void))


SWFStream_obj::SWFStream_obj()
{
}

void SWFStream_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SWFStream);
	HX_MARK_MEMBER_NAME(pushTagSize,"pushTagSize");
	HX_MARK_MEMBER_NAME(pushTagRead,"pushTagRead");
	HX_MARK_MEMBER_NAME(version,"version");
	HX_MARK_MEMBER_NAME(tagSize,"tagSize");
	HX_MARK_MEMBER_NAME(tagRead,"tagRead");
	HX_MARK_MEMBER_NAME(stream,"stream");
	HX_MARK_MEMBER_NAME(byteBuffer,"byteBuffer");
	HX_MARK_MEMBER_NAME(bitPosition,"bitPosition");
	HX_MARK_END_CLASS();
}

void SWFStream_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(pushTagSize,"pushTagSize");
	HX_VISIT_MEMBER_NAME(pushTagRead,"pushTagRead");
	HX_VISIT_MEMBER_NAME(version,"version");
	HX_VISIT_MEMBER_NAME(tagSize,"tagSize");
	HX_VISIT_MEMBER_NAME(tagRead,"tagRead");
	HX_VISIT_MEMBER_NAME(stream,"stream");
	HX_VISIT_MEMBER_NAME(byteBuffer,"byteBuffer");
	HX_VISIT_MEMBER_NAME(bitPosition,"bitPosition");
}

Dynamic SWFStream_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"readID") ) { return readID_dyn(); }
		if (HX_FIELD_EQ(inName,"popTag") ) { return popTag_dyn(); }
		if (HX_FIELD_EQ(inName,"endTag") ) { return endTag_dyn(); }
		if (HX_FIELD_EQ(inName,"stream") ) { return stream; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"readRGB") ) { return readRGB_dyn(); }
		if (HX_FIELD_EQ(inName,"readInt") ) { return readInt_dyn(); }
		if (HX_FIELD_EQ(inName,"pushTag") ) { return pushTag_dyn(); }
		if (HX_FIELD_EQ(inName,"version") ) { return version; }
		if (HX_FIELD_EQ(inName,"tagSize") ) { return tagSize; }
		if (HX_FIELD_EQ(inName,"tagRead") ) { return tagRead; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"readRect") ) { return readRect_dyn(); }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		if (HX_FIELD_EQ(inName,"readBool") ) { return readBool_dyn(); }
		if (HX_FIELD_EQ(inName,"readBits") ) { return readBits_dyn(); }
		if (HX_FIELD_EQ(inName,"beginTag") ) { return beginTag_dyn(); }
		if (HX_FIELD_EQ(inName,"position") ) { return get_position(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"readTwips") ) { return readTwips_dyn(); }
		if (HX_FIELD_EQ(inName,"readFloat") ) { return readFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"readFixed") ) { return readFixed_dyn(); }
		if (HX_FIELD_EQ(inName,"readDepth") ) { return readDepth_dyn(); }
		if (HX_FIELD_EQ(inName,"readBytes") ) { return readBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"readAlign") ) { return readAlign_dyn(); }
		if (HX_FIELD_EQ(inName,"alignBits") ) { return alignBits_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"readUTwips") ) { return readUTwips_dyn(); }
		if (HX_FIELD_EQ(inName,"readUInt16") ) { return readUInt16_dyn(); }
		if (HX_FIELD_EQ(inName,"readString") ) { return readString_dyn(); }
		if (HX_FIELD_EQ(inName,"readSTwips") ) { return readSTwips_dyn(); }
		if (HX_FIELD_EQ(inName,"readSInt16") ) { return readSInt16_dyn(); }
		if (HX_FIELD_EQ(inName,"readMatrix") ) { return readMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"readFrames") ) { return readFrames_dyn(); }
		if (HX_FIELD_EQ(inName,"readFixed8") ) { return readFixed8_dyn(); }
		if (HX_FIELD_EQ(inName,"getVersion") ) { return getVersion_dyn(); }
		if (HX_FIELD_EQ(inName,"byteBuffer") ) { return byteBuffer; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"pushTagSize") ) { return pushTagSize; }
		if (HX_FIELD_EQ(inName,"pushTagRead") ) { return pushTagRead; }
		if (HX_FIELD_EQ(inName,"bitPosition") ) { return bitPosition; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"set_position") ) { return set_position_dyn(); }
		if (HX_FIELD_EQ(inName,"get_position") ) { return get_position_dyn(); }
		if (HX_FIELD_EQ(inName,"getBytesLeft") ) { return getBytesLeft_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"readScaleMode") ) { return readScaleMode_dyn(); }
		if (HX_FIELD_EQ(inName,"readJoinStyle") ) { return readJoinStyle_dyn(); }
		if (HX_FIELD_EQ(inName,"readFrameRate") ) { return readFrameRate_dyn(); }
		if (HX_FIELD_EQ(inName,"readFixedBits") ) { return readFixedBits_dyn(); }
		if (HX_FIELD_EQ(inName,"readCapsStyle") ) { return readCapsStyle_dyn(); }
		if (HX_FIELD_EQ(inName,"readArraySize") ) { return readArraySize_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"readFlashBytes") ) { return readFlashBytes_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"readSpreadMethod") ) { return readSpreadMethod_dyn(); }
		if (HX_FIELD_EQ(inName,"readPascalString") ) { return readPascalString_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"readColorTransform") ) { return readColorTransform_dyn(); }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"readInterpolationMethod") ) { return readInterpolationMethod_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SWFStream_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"stream") ) { stream=inValue.Cast< ::native::utils::ByteArray >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { version=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tagSize") ) { tagSize=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tagRead") ) { tagRead=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { return set_position(inValue); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"byteBuffer") ) { byteBuffer=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"pushTagSize") ) { pushTagSize=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pushTagRead") ) { pushTagRead=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bitPosition") ) { bitPosition=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SWFStream_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("pushTagSize"));
	outFields->push(HX_CSTRING("pushTagRead"));
	outFields->push(HX_CSTRING("version"));
	outFields->push(HX_CSTRING("tagSize"));
	outFields->push(HX_CSTRING("tagRead"));
	outFields->push(HX_CSTRING("stream"));
	outFields->push(HX_CSTRING("position"));
	outFields->push(HX_CSTRING("byteBuffer"));
	outFields->push(HX_CSTRING("bitPosition"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("set_position"),
	HX_CSTRING("get_position"),
	HX_CSTRING("readUTwips"),
	HX_CSTRING("readUInt16"),
	HX_CSTRING("readTwips"),
	HX_CSTRING("readString"),
	HX_CSTRING("readSpreadMethod"),
	HX_CSTRING("readSTwips"),
	HX_CSTRING("readSInt16"),
	HX_CSTRING("readScaleMode"),
	HX_CSTRING("readRGB"),
	HX_CSTRING("readRect"),
	HX_CSTRING("readPascalString"),
	HX_CSTRING("readMatrix"),
	HX_CSTRING("readJoinStyle"),
	HX_CSTRING("readInterpolationMethod"),
	HX_CSTRING("readInt"),
	HX_CSTRING("readID"),
	HX_CSTRING("readFrames"),
	HX_CSTRING("readFrameRate"),
	HX_CSTRING("readFloat"),
	HX_CSTRING("readFlashBytes"),
	HX_CSTRING("readFixedBits"),
	HX_CSTRING("readFixed8"),
	HX_CSTRING("readFixed"),
	HX_CSTRING("readDepth"),
	HX_CSTRING("readColorTransform"),
	HX_CSTRING("readCapsStyle"),
	HX_CSTRING("readBytes"),
	HX_CSTRING("readByte"),
	HX_CSTRING("readBool"),
	HX_CSTRING("readBits"),
	HX_CSTRING("readArraySize"),
	HX_CSTRING("readAlign"),
	HX_CSTRING("pushTag"),
	HX_CSTRING("popTag"),
	HX_CSTRING("getVersion"),
	HX_CSTRING("getBytesLeft"),
	HX_CSTRING("endTag"),
	HX_CSTRING("close"),
	HX_CSTRING("beginTag"),
	HX_CSTRING("alignBits"),
	HX_CSTRING("pushTagSize"),
	HX_CSTRING("pushTagRead"),
	HX_CSTRING("version"),
	HX_CSTRING("tagSize"),
	HX_CSTRING("tagRead"),
	HX_CSTRING("stream"),
	HX_CSTRING("byteBuffer"),
	HX_CSTRING("bitPosition"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SWFStream_obj::__mClass,"__mClass");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SWFStream_obj::__mClass,"__mClass");
};

Class SWFStream_obj::__mClass;

void SWFStream_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.swf.data.SWFStream"), hx::TCanCast< SWFStream_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void SWFStream_obj::__boot()
{
}

} // end namespace format
} // end namespace swf
} // end namespace data
