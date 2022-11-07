unit ArrayHelper;
{.$undef fpc}
{$ifndef fpc}{$mode delphi}{$endif}
{$H+}
{$M-}
{$ModeSwitch typehelpers}
{$ModeSwitch advancedrecords}
{$inline on}
{$SafeFPUExceptions OFF}
{$FPUTYPE avx2}
{.$define USE_THREADS}
{.$define USE_GPU}
{.$define USE_AVX2}

interface

uses
  Classes, SysUtils, Types, Math,ArrayHelperCommon,{$ifdef use_lcl_complex}ucomplex,{$endif}complexarray,
  fpexprpars, hirestimer, strutils
  {$if defined(darwin) and defined(USE_VDSP)} , vDSP{$endif}
  {$ifdef USE_AVX2}, oprs_simd {$endif}
  //{$ifdef USE_AVX2}, pblas {$endif}
  {$ifdef USE_GPU}, oprs_gpu {$endif}
  {$ifdef USE_OPENBLAS}, openblas {$endif}
  //{$ifdef Darwin},vDSP{$endif}
  //,dnn
  {$ifdef USE_MKL}
  ,mkl_cblas
  ,mkl_vml
  {$endif}
  ;

{$ifdef USE_VDSP}
{$LinkFramework Accelerate}
{$endif}
{$i ahdefines.inc}

type
  PRGBA=^TRGBA;
  TRGBA=packed record
    case byte of
      0:(R,G,B,A:byte);
      1:(P:longword)
  end;
  PBGRA=^TBGRA;
  TBGRA=packed record
    case byte of
      0:(B,G,R,A:byte);
      1:(P:longword)
  end;
  PARGB=^TARGB;
  TARGB=packed record
    case byte of
      0:(A,R,G,B:byte);
      1:(P:longword)
  end;
  PABGR=^TABGR;
  TABGR=packed record
    case byte of
      0:(A,B,G,R:byte);
      1:(P:longword)
  end;

  PColorRec=^TColorRec;
  {$ifdef DARWIN}
    TColorRec=TARGB;
  {$else}
  TColorRec=TBGRA;
  {$endif}


  TSingles=TSingleDynArray;
  TDoubles=TDoubleDynArray;
  TSingles2D=TSingleArrayArray;
  TDoubles2D=TDoubleArrayArray;

  TExtendeds=TExtendedDynArray;
  TIntegers=TIntegerDynarray;
  TShorts=TIntegerDynarray;
//  {$ifdef fpc}generic{$endif} TFilterFunc<T>=function (const a:T;const i:Integer; Arr:array of T):boolean ;


  TMapIntFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<Integer>;
  TReduceIntFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<integer>;
  TSimpleMapIntFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<integer>;
  TSimpleReduceIntFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<integer>;

  TMapStringFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<string>;
  TReduceStringFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<string>;
  TSimpleMapStringFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<string>;
  TSimpleReduceStringFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<string>;

  TMapSingleFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<Single>;
  TReduceSingleFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Single>;
  TSimpleMapSingleFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<single>;
  TSimpleReduceSingleFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<single>;

  TMapDoubleFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<Double>;
  TReduceDoubleFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Double>;
  TSimpleMapDoubleFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<Double>;
  TSimpleReduceDoubleFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Double>;

  {$ifdef SUPPORT_EXTENDED}
  TMapExtendedFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<Extended>;
  TReduceExtendedFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Extended>;
  TSimpleMapExtendedFunc={$ifdef fpc}specialize{$endif} TSimpleMapCallback<Extended>;
  TSimpleReduceExtendedFunc={$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Extended>;
  {$endif}

  { TStringArrayArrayHelper }



    {$define Number:=Byte}
    {$define TNumberArrayHelper:=TByteArrayHelper}
    {$define TNumberDynArray:=TByteDynArray}
    {$define TNumberArrayArray:=TByteArrayArray}
    {$define TNumberArrayArrayHelper:=TByteArrayArrayHelper}
       {$I arraynumh.inc}
    {$UnDef Number}
    {$UnDef TNumberDynArray}
    {$UnDef TNumberArrayHelper}
    {$UnDef TNumberArrayArray}
    {$UnDef TNumberArrayArrayHelper}

    {$define Number:=Integer}
    {$define TNumberArrayHelper:=TIntegerArrayHelper}
    {$define TNumberDynArray:=TIntegerDynArray}
    {$define TNumberArrayArray:=TIntegerArrayArray}
    {$define TNumberArrayArrayHelper:=TIntegerArrayArrayHelper}
       {$I arraynumh.inc}
    {$UnDef Number}
    {$UnDef TNumberDynArray}
    {$UnDef TNumberArrayHelper}
    {$UnDef TNumberArrayArray}
    {$UnDef TNumberArrayArrayHelper}

    {$define Number:=Int64}
    {$define TNumberArrayHelper:=TInt64ArrayHelper}
    {$define TNumberDynArray:=TInt64DynArray}
    {$define TNumberArrayArray:=TInt64ArrayArray}
    {$define TNumberArrayArrayHelper:=TInt64ArrayArrayHelper}
       {$I arraynumh.inc}
    {$UnDef Number}
    {$UnDef TNumberDynArray}
    {$UnDef TNumberArrayHelper}
    {$UnDef TNumberArrayArray}
    {$UnDef TNumberArrayArrayHelper}

    {$define Float:=Single}
    {$define PFloat:=PSingle}
    {$define TFloatArrayHelper:=TSingleArrayHelper}
    {$define TFloatDynArray:=TSingleDynArray}
    {$define TFloatArrayArray:=TSingleArrayArray}
    {$define TFloatArrayArrayHelper:=TSingleArrayArrayHelper}
    {$define Complex:=ComplexF}
    {$define TComplexArray:=TComplexArrayF}
    {$define TComplexArrayArray:=TComplexArrayArrayF}
      {$I arrayfloath.inc}
    {$undef TComplexArray}
    {$undef TComplexArrayArray}
    {$undef Complex}
    {$UnDef Float}
    {$UnDef PFloat}
    {$UnDef TFloatDynArray}
    {$UnDef TFloatArrayHelper}
    {$UnDef TFloatArrayArray}
    {$UnDef TFloatArrayArrayHelper}

    {$define Float:=Double}
    {$define PFloat:=PDouble}
    {$define TFloatArrayHelper:=TDoubleArrayHelper}
    {$define TFloatDynArray:=TDoubleDynArray}
    {$define TFloatArrayArray:=TDoubleArrayArray}
    {$define TFloatArrayArrayHelper:=TDoubleArrayArrayHelper}
    {$define Complex:=ComplexD}
    {$define TComplexArray:=TComplexArrayD}
    {$define TComplexArrayArray:=TComplexArrayArrayD}
      {$I arrayfloath.inc}
    {$undef TComplexArray}
    {$undef TComplexArrayArray}
    {$undef Complex}
    {$UnDef Float}
    {$UnDef PFloat}
    {$UnDef TFloatDynArray}
    {$UnDef TFloatArrayHelper}
    {$UnDef TFloatArrayArray}
    {$UnDef TFloatArrayArrayHelper}

    //{$define Float:=Currency}
    //{$define TFloatArrayHelper:=TCurrencyArrayHelper}
    //{$define TFloatDynArray:=TCurrencyArray}
    //{$define TFloatArrayArray:=TCurrencyArrayArray}
    //{$define TFloatArrayArrayHelper:=TCurrencyArrayArrayHelper}
    //   {$I arrayfloath.inc}
    //{$UnDef Float}
    //{$UnDef TFloatDynArray}
    //{$UnDef TFloatArrayHelper}
    //{$UnDef TFloatArrayArray}
    //{$UnDef TFloatArrayArrayHelper}
    {$ifdef SUPPORT_EXTENDED}
    {$define Float:=Extended}
    {$define PFloat:=PExtended}
    {$define TFloatArrayHelper:=TExtendedArrayHelper}
    {$define TFloatDynArray:=TExtendedDynArray}
    {$define TFloatArrayArray:=TExtendedArrayArray}
    {$define TFloatArrayArrayHelper:=TExtendedArrayArrayHelper}
    {$define Complex:=ComplexE}
    {$define TComplexArray:=TComplexArrayE}
    {$define TComplexArrayArray:=TComplexArrayArrayE}
      {$I arrayfloath.inc}
    {$undef TComplexArray}
    {$undef TComplexArrayArray}
    {$undef Complex}
    {$UnDef Float}
    {$UnDef PFloat}
    {$UnDef TFloatDynArray}
    {$UnDef TFloatArrayHelper}
    {$UnDef TFloatArrayArray}
    {$UnDef TFloatArrayArrayHelper}
    {$endif}

type

  { TStringArrayHelper }

  TStringArrayHelper=type helper for TStringDynArray
  type
    PType=^TType;
    TType=string;
    TCompareFuncStr={$ifdef fpc}specialize{$endif} TCompareFunc<string>;
  private
    procedure SetCount(AValue: integer);
  public
    function reduce(func: {$ifdef fpc}specialize{$endif} TReduceCallback<string>; const init: string): string;
    function GetCount:Integer;
    function Sort(const CompareFunc:TCompareFuncStr = nil):TStringDynArray;
    function Sorted(const CompareFunc:TCompareFuncStr = nil):TStringDynArray;
    function isSorted(const descending:boolean =false; CompareFunc:TCompareFuncStr = nil):boolean;

    function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<string>):TStringDynArray;          overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<string>):TStringDynArray;    overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<string>):TStringDynArray;    overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TMapCallbackVar<string>):TVariantArray;      overload;
    function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<string,PString>):TStringDynArray;
    //function Filter(func:{$ifdef fpc}specialize{$endif} TFilterFunc<string>):TStringDynArray;
    function FilterStr(val:string;partialMatch:boolean=true):TStringDynArray;
    function FilterText(val:string;partialMatch:boolean=true):TStringDynArray;
    function Lookup(const val:string):integer;
    // heap operations are costy use them carfully
    function Push(v:string):string;
    function Pop():string;
    function UnShift(v:string):string;
    function Shift():string;
    function Slice(start,_end:integer):TStringDynArray;
    function Splice(start,deleteCount:integer;Items:TStringDynArray):TStringDynArray;
    function concat(Items:TStringDynArray):TStringDynArray;
    function unique():TStringDynArray;
    function ToString(const Seperator: string=', '; const quote: string='"'): string;
    property Count:integer read GetCount write SetCount;
    function as2d(const Columns:integer;const Transposed:boolean=true):TStringArrayArray; _inline
    function Transpose(const Width:integer):TStringDynArray;
    function indexOf(const val: string): integer;
    class function Fill(const cnt:integer;str:string):TStringDynArray;static;
    function Extract(const Indecies:TIntegerDynArray):TStringDynArray;
    procedure Scatter(const indecies:TIntegerDynArray;const Values:TStringDynArray);
    function Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<String>):TIntegerDynArray;   overload;
    function Find(const values:TStringDynArray):TIntegerDynArray;                                              overload;
    function Find(const value:String):TIntegerDynArray;                                                        overload;
    function Intersect(const Other:TStringDynArray;const binSearch:boolean=false):TStringDynArray; _inline
    function Difference(const Other:TStringDynArray;const binSearch:boolean=false):TStringDynArray; _inline
    function Mode():string;
    function reverse():TStringDynArray;
    function ToDoubles:TDoubleDynArray;
    function ToSingles:TSingleDynArray;
    function ToIntegers:TIntegerDynArray;
    function ToInt64:TInt64DynArray;
    function ToBytes:TByteDynArray;
    function ToWords:TWordDynArray;
    function ToLongWords:TLongWordDynArray;
    function ToQWords:TQWordDynArray;
    generic function ToType<T>(const Conv:{$ifdef fpc}specialize{$endif} TConvertCallback<string,T>):{$ifdef fpc}specialize{$endif} TArray<T>;
    class function cmp(const a, b: string): integer; static;inline;
    class function Every(const dst:PString; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<string,PString>):boolean; static;inline;overload;
    class function Some(const dst:PString; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<string,PString>):boolean; static;inline;overload;
  private
    class procedure QuickSort(var Arr: TStringDynArray; const L, R: Longint;const Compare: TCompareFuncStr); static;
    class function uniqueFilt(const a:string;const i:integer;arr:PString):boolean;static;inline;

  end;

  TStringArrayArrayHelper=type helper for TStringArrayArray
  type
    PType=^TType;
    TType=TStringDynArray;
    TCompareFuncStringAA={$ifdef fpc}specialize{$endif} TCompareFunc<TStringDynArray>;
    PStringArray=^TStringDynArray;
  private
    function GetCount: integer;
    procedure SetCount(AValue: integer);
  public
    function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TStringDynArray>;const init:TStringDynArray=nil):TStringDynArray;   overload;
    function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TStringDynArray>):TStringDynArray;                         overload;
    function Sort(CompareFunc:TCompareFuncStringAA= nil):TStringArrayArray;
    function Sorted(CompareFunc:TCompareFuncStringAA= nil):TStringArrayArray;
    function Lookup(const val:TStringDynArray):integer;
    function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TStringDynArray>):TStringArrayArray;          overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TStringDynArray>):TStringArrayArray;    overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TStringDynArray>):TStringArrayArray;    overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TMapCallbackVar<TStringDynArray>):TVariantArray;           overload;
    function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TStringDynArray, PStringArray>):TStringArrayArray;
    function unique():TStringArrayArray;
    function Transpose:TStringArrayArray;
    property Count:integer read GetCount write SetCount;
    // heap operations are costy use carfully
    function Push(v:TStringDynArray):TStringDynArray;
    function Pop():TStringDynArray;
    function UnShift(v:TStringDynArray):TStringDynArray;
    function Shift():TStringDynArray;
    function Slice(start,_end:integer):TStringArrayArray;
    function Splice(start,deleteCount:integer;Items:TStringArrayArray):TStringArrayArray;
    function concat(Items:TStringArrayArray):TStringArrayArray;
    function ToString(const Seperator: string=', '; const quote: string='"'): string;
    class function cmp(const a, b: TStringDynArray): integer; static;_inline
    class function FromDelimtedText(const Str:string;const LineBreak:string=LineEnding;const Delimiter:Char=',';const Quote:char='"'):TStringArrayArray;  static; overload;
    class function FromDelimtedText(const Str:string;const LineBreak:string;const Delimiter:Char;const StartingQuote,EndingQuote:Char):TStringArrayArray; static; overload;
  private
    class procedure QuickSort(var Arr: TStringArrayArray; const L, R: Longint;const Compare: TCompareFuncStringAA); static;
    class function uniqueFilt(const a:TStringDynArray;const i:integer;arr:PStringArray):boolean;static;
  end;


  TVariantArrayHelper=type helper for TVariantArray
  type

    PPType=^PType;
    PType=^TType;
    TType=Variant;
    TSelf=TVariantArray;
    TCompare={$ifdef fpc}specialize{$endif} TComparefunc<TType>;
  private
    function GetCount: integer;
    procedure SetCount(AValue: integer);
  public
    function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TType>;const init:TType):TType;   overload;
    function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TType>):TType;                         overload;
    function Sort(CompareFunc:TCompare= nil):TSelf;
    function Sorted(CompareFunc:TCompare= nil):TSelf;
    function Lookup(const val:TType):integer;
    function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TType>):TSelf;          overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TType>):TSelf;    overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TType>):TSelf;    overload;
    function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TType, PType>):TSelf;
    function unique():TSelf;
    property Count:integer read GetCount write SetCount;
    // heap operations are costy use carfully
    function Push(v:TType):TType;
    function Pop():TType;
    function UnShift(v:TType):TType;
    function Shift():TType;
    function Slice(start,_end:integer):TSelf;
    function Splice(start,deleteCount:integer;Items:TSelf):TSelf;
    function concat(Items:TSelf):TSelf;

    function indexOf(const val: TType): integer;        overload;
    function indexOf(const val: string): integer;       overload;
    class function Fill(const cnt:integer;val:TType):TSelf;static;
    function Extract(const Indecies:TIntegerDynArray):TSelf;
    procedure Scatter(const indecies:TIntegerDynArray;const Values:TSelf);
    function Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<TType>):TIntegerDynArray;   overload;
    function Find(const values:TSelf):TIntegerDynArray;                                              overload;
    function Find(const value:TType):TIntegerDynArray;                                                        overload;
    function Intersect(const Other:TSelf;const binSearch:boolean=false):TSelf; _inline
    function Difference(const Other:TSelf;const binSearch:boolean=false):TSelf; _inline
    function Mode():TType;
    function reverse():TSelf;
    function ToString(const Seperator: string=', '; const quote: string='"';const Brackets:boolean=true): string;
    class function cmp(const a, b: TType): integer;static;
    class procedure QuickSort(var Arr: TSelf; const L, R: Longint;const Compare: TCompare); static;
    class function uniqueFilt(const a:TType;const i:integer;arr:PType):boolean;static;

  end;

  TVariantArray2DHelper=type helper for TVariantArrayArray
  type

    PPType=^PType;
    PType=^TType;
    TType=TVariantArray;
    TSelf=TVariantArrayArray;
    TCompare={$ifdef fpc}specialize{$endif} TComparefunc<TType>;
  private
    function GetCount: integer;
    procedure SetCount(AValue: integer);
  public
    function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TType>;const init:TType):TType;   overload;
    function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TType>):TType;                         overload;
    function Sort(CompareFunc:TCompare= nil):TSelf;
    function Sorted(CompareFunc:TCompare= nil):TSelf;
    function Lookup(const val:TType):integer;
    function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TType>):TSelf;          overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TType>):TSelf;    overload;
    function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TType>):TSelf;    overload;
    function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TType, PType>):TSelf;
    function unique():TSelf;
    property Count:integer read GetCount write SetCount;
    function Transpose:TSelf;
    // heap operations are costy use carfully
    function Push(v:TType):TType;
    function Pop():TType;
    function UnShift(v:TType):TType;
    function Shift():TType;
    function Slice(start,_end:integer):TSelf;
    function Splice(start,deleteCount:integer;Items:TSelf):TSelf;
    function concat(Items:TSelf):TSelf;
    function ToString(const Seperator: string=', '; const quote: string='"';const Brackets:boolean=true): string;
    class function cmp(const a, b: TType): integer;static;
    class procedure QuickSort(var Arr: TSelf; const L, R: Longint;const Compare: TCompare); static;
    class function uniqueFilt(const a:TType;const i:integer;arr:PType):boolean;static;

  end;


{ TKeyValueList<TK,TR> }
{$ifdef fpc}generic{$endif} TKeyValueList<TK,TV>=record
  type
    PK= array of TK;
  var
    Keys:{$ifdef fpc}specialize{$endif} TArray<TK>;
    ValueList:{$ifdef fpc}specialize{$endif} TArray<TV>;
  private
    function GetValues(const key: TK): TV;
    procedure SetValues(const key: TK; const AValue: TV);
  public
    function KeyExists(key: TK): boolean;
    property Values[key:TK]:TV read GetValues write SetValues ;default;
    function Count:integer;
    procedure Remove(const index:integer);
  end;


{$ifdef fpc}
operator :=(const Arr:TStringDynArray):string;
operator :=(const Arr:TStringArrayArray):string;
//operator :=(const Arr:TComplexArray):string;                               //      inline;
operator :=(const i:Integer):string; inline;
operator :=(const s:string):integer; inline;
operator :=(const f:extended):string; inline;
operator :=(const s:string):extended; inline;
operator +(const Arr, Arr2: TStringDynArray): TStringDynArray;
operator +(const Arr, Arr2: TStringArrayArray): TStringArrayArray;
operator +(const Arr: TStringDynArray       ;   const v: String ): TStringDynArray;
operator +(const Arr: TStringArrayArray  ;   const v: TStringDynArray ): TStringArrayArray;//{$ifdef fpc}generic{$endif} procedure QuickSort<T>(Arr: TStringDynArray; L, R : Longint; Compare: {$ifdef fpc}specialize{$endif} TComparefunc<T>);
operator +(const v: String ;const Arr: TStringDynArray       ): TStringDynArray;
operator +(const v: TStringDynArray ;const Arr: TStringArrayArray  ): TStringArrayArray;
{$endif}

//var
  //bulkAdd_s   :TProcFFF;
  //bulkAdd_d   :TProcDDD;
  //bulkAdd_ss  :TProcFFV;
  //bulkAdd_sd  :TProcDDV;
  //bulkSub_s   :TProcFFF;
  //bulkSub_d   :TProcDDD;
  //bulkSub_ss  :TProcFFV;
  //bulkSub_sd  :TProcDDV;
  //bulkMul_s   :TProcFFF;
  //bulkMul_d   :TProcDDD;
  //bulkMul_ss  :TProcFFV;
  //bulkMul_sd  :TProcDDV;
  //bulkDiv_s   :TProcFFF;
  //bulkDiv_d   :TProcDDD;
  //bulkDiv_ss  :TProcFFV;
  //bulkDiv_sd  :TProcDDV;
  //bulkDot_s   :TFuncFFV;
  //bulkDot_d   :TFuncDDV;
  //interleave_s:TProcFFF;
  //interleave_d:TProcFFF;

{$ifdef fpc}generic{$endif} procedure Add<ARR>(const dst,a,b:ARR;const aCount:integer);                      overload;
{$ifdef fpc}generic{$endif} procedure Subtract<ARR>(const dst,a,b:ARR;const aCount:integer);                 overload;
{$ifdef fpc}generic{$endif} procedure Multiply<ARR>(const dst,a,b:ARR;const aCount:integer);                 overload;
{$ifdef fpc}generic{$endif} procedure Divide<ARR>(const dst,a,b:ARR;const aCount:integer);                   overload;
{$ifdef fpc}generic{$endif} procedure DivInt<ARR>(const dst,a,b:ARR;const aCount:integer);                   overload;
{$ifdef fpc}generic{$endif} procedure ModInt<ARR>(const dst,a,b:ARR;const aCount:integer);                   overload;

//{$ifdef fpc}generic{$endif} procedure Add<T>( dst,a:array of T;const b:T);         overload;
//{$ifdef fpc}generic{$endif} procedure Subtract<T>( dst,a:array of T;const b:T);    overload;
//{$ifdef fpc}generic{$endif} procedure Multiply<T>( dst,a:array of T;const b:T);    overload;
//{$ifdef fpc}generic{$endif} procedure Divide<T>( dst,a:array of T;const b:T);      overload;
//{$ifdef fpc}generic{$endif} procedure DivInt<T>( dst,a:array of T;const b:T);      overload;
//{$ifdef fpc}generic{$endif} procedure ModInt<T>( dst,a:array of T;const b:T);      overload;
{$ifdef fpc}generic{$endif} function Push<T>(var Self:{$ifdef fpc}specialize{$endif} TArray<T>;const v:T):T;
{$ifdef fpc}generic{$endif} function Pop<T>(var Self:array of T):T;
{$ifdef fpc}generic{$endif} function Shift<T>(var Self:array of T):T;
{$ifdef fpc}generic{$endif} function UnShift<T>(var Self:array of T;const v:T):T;
{$ifdef fpc}generic{$endif} function Concat<ARR>(const Self:ARR;const Items:ARR):ARR;
{$ifdef fpc}generic{$endif} function Splice<ARR>(var Self:ARR; start,deleteCount:integer;const Items:ARR):ARR;
{$ifdef fpc}generic{$endif} function Slice<ARR>(const Self:ARR; start,_end:integer):ARR;
{$ifdef fpc}generic{$endif} function Extract<ARR>(const Self:ARR; const Indecies:TIntegerDynArray):ARR;
{$ifdef fpc}generic{$endif} procedure Scatter<ARR>(const Self:ARR; const Indecies:TIntegerDynArray;const Values:ARR);
{$ifdef fpc}generic{$endif} function Find<T>(const Self:array of T; const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallback<T>):TIntegerDynArray;  {$ifdef delphi}overload;{$endif}
{$ifdef fpc}generic{$endif} function Find<T>(const Self:array of T; const Values:array of T):TIntegerDynArray;                                             {$ifdef delphi}overload;{$endif}
{$ifdef fpc}generic{$endif} function Find<T>(const Self:array of T; const Value:T):TIntegerDynArray;                                                       {$ifdef delphi}overload;{$endif}
{$ifdef fpc}generic{$endif} function Intersect<T>(const Self,other:{$ifdef fpc}specialize{$endif} TArray<T>;const binSearch:boolean=false):{$ifdef fpc}specialize{$endif} TArray<T>;
{$ifdef fpc}generic{$endif} function Difference<T>(const Self,other:{$ifdef fpc}specialize{$endif} TArray<T>;const binSearch:boolean=false):{$ifdef fpc}specialize{$endif} TArray<T>;



{$ifdef fpc}generic{$endif} function Reduce<T>(const Self:array of T;func:{$ifdef fpc}specialize{$endif} TReduceCallback<T>;const init:T):T;            overload;
{$ifdef fpc}generic{$endif} function Reduce<T>(const Self:array of T;func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<T>;const init:T):T;      overload;
{$ifdef fpc}generic{$endif} function Reduce<T>(const Self:array of T;func:{$ifdef fpc}specialize{$endif} TReduceCallback<T>):T;      overload;

{$ifdef fpc}generic{$endif} procedure Reverse<T>(const Self:{$ifdef fpc}specialize{$endif}TArray<T>; const  N : integer);
{$ifdef fpc}generic{$endif} function Map<T,R>(const Self:array of T;func: {$ifdef fpc}specialize{$endif} TMapCallbackR<T,R>):{$ifdef fpc}specialize {$endif}TArray<R>;  overload;
{$ifdef fpc}generic{$endif} function Filter<ARR,T>(const Self:ARR;const func:{$ifdef fpc}specialize {$endif}TFilterCallback<T,ARR>):ARR;     overload;

{$ifdef fpc}generic{$endif} function IndexOf<T>(const Self:array of T; const val:T):integer;                     overload;
{$ifdef fpc}generic{$endif} function IndexOf<ARR,T>(const Self:ARR;    const val:T;const aCount:integer):integer;overload;
{$ifdef fpc}generic{$endif} procedure Fill<T>(Self:array of T;const Val:T);                                      overload;
{$ifdef fpc}generic{$endif} procedure Fill<ARR,T>(Self:ARR;const aCount:integer;const Val:T);                    overload;
{$ifdef fpc}generic{$endif} function Fill<T>(const aCount:integer;const Val:T):{$ifdef fpc}specialize {$endif}TArray<T>; overload;
{$ifdef fpc}generic {$endif}function MaxNumber<T>(const Data:array of T):T;overload;
{$ifdef fpc}generic {$endif}function MinNumber<T>(const Data:array of T):T;overload;
{$ifdef fpc}generic {$endif}function SumNumber<T, R>(const Data:array of T):R;overload;
{$ifdef fpc}generic{$endif} function Mode<T>(const Self:array of T):T;

//{$ifdef fpc}generic {$endif}function SumNumber<T>(const Data:array of T):T;overload;

function dotest(pa:integer):string;

implementation
{ TKeyValueList }

function TKeyValueList{$ifndef fpc}<TK,TV>{$endif}.Count: integer;
begin
  result:=Length(Keys)
end;

procedure TKeyValueList{$ifndef fpc}<TK,TV>{$endif}.Remove(const index: integer);
begin
  if (index>=0) and (index<Count) then begin
    Delete(Keys,index,1);
    Delete(ValueList,index,1);
  end;
end;

function TKeyValueList{$ifndef fpc}<TK,TV>{$endif}.GetValues(const key: TK): TV;
var i:integer;
begin
  i:={$ifdef fpc}specialize{$endif} _BinSearch<TK, PK>(Keys ,key,Length(Keys));
  if i>=0 then
    result:=ValueList[i]
end;

procedure TKeyValueList{$ifndef fpc}<TK,TV>{$endif}.SetValues(const key: TK; const AValue: TV);
var i:integer;
begin
  i:={$ifdef fpc}specialize{$endif} _BinSearch<TK,PK>(Keys,key,Length(Keys));
  if i<0 then
    begin
      i:=-(i+1);
      Insert(key, Keys,i);
      Insert(AValue,ValueList,i)
    end
  else
    //begin
      ValueList[i]:=AValue
    //end;
end;

function TKeyValueList{$ifndef fpc}<TK,TV>{$endif}.KeyExists(key: TK): boolean;
begin
  result:={$ifdef fpc}specialize{$endif} _BinSearch<TK,PK>(Keys,key,Length(Keys))>=0;
end;

{ TVariantArrayHelper }

procedure TVariantArrayHelper.SetCount(AValue: integer);
begin
  SetLength(Self,AValue)
end;

function TVariantArrayHelper.GetCount: integer;
begin
  result:=Length(Self)
end;

function TVariantArrayHelper.reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TType>;const init:TType):TType; _REDUCE_;
//begin
//  result:=ArrayHelper.Reduce<TType>(Self,Func,init)
//end;

function TVariantArrayHelper.reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TType>):TType;  _SIMPLEREDUCE_;
//begin
//
//end;
//
function TVariantArrayHelper.Sort(CompareFunc:TCompare):TSelf;   _DOSORT_;
//begin
//
//end;

function TVariantArrayHelper.Sorted(CompareFunc:TCompare):TSelf; _SORTED_;
//begin
//
//end;

function TVariantArrayHelper.Lookup(const val:TType):integer;
begin
  result:={$ifdef fpc}specialize{$endif} _BinSearch<TType,PType>(@Self[0],Val,Length(Self),TCompare({$ifdef fpc}@{$endif}Self.cmp));

end;

function TVariantArrayHelper.Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TType>):TSelf;   _DOMAP_;
//begin
//
//end;

function TVariantArrayHelper.Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TType>):TSelf;   _SIMPLEMAP_  ;
//begin
//
//end;

function TVariantArrayHelper.Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TType>):TSelf;   _SIMPLEMAP_;
//begin
//
//end;

function TVariantArrayHelper.Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TType, PType>):TSelf;_FILTER_;

function TVariantArrayHelper.unique():TSelf;
begin
  result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<TType,PType>({$ifdef fpc}@{$endif}uniqueFilt));

end;

function TVariantArrayHelper.Push(v:TType):TType;     _PUSH_;
//begin
//
//end;

function TVariantArrayHelper.Pop():TType;            _POP_;
//begin
//
//end;

function TVariantArrayHelper.UnShift(v:TType):TType;         _UNSHIFT_;
//begin
//
//end;

function TVariantArrayHelper.Shift():TType;                 _SHIFT_;
//begin
//
//end;

function TVariantArrayHelper.Slice(start,_end:integer):TSelf;   //   _SLICE_;
var i,C:integer;
begin
  C:=Length(Self);
  if start<0 then start:=C+start;
  if _end<0 then _end:=C + _end;
  result:=copy(Self,start,_end - start)
end ;

function TVariantArrayHelper.Splice(start,deleteCount:integer;Items:TVariantArray):TSelf;   _SPLICE_ ;
//begin
//
//end;

function TVariantArrayHelper.concat(Items:TSelf):TSelf;                                 //  _CONCAT_;
var l,i,C:integer;
begin
  C:=Length(Self);
  l:=Length(Items);
  setLength(Result,C+l);
  if (Self<>Result) and (C>0)then Move(Self[0],Result[0],C*SizeOf(Result[0]));
  for i:=0 to l-1 do Result[C+i]:=Items[i]
end;

function TVariantArrayHelper.indexOf(const val: TType): integer;   _INDEXOF_;

function TVariantArrayHelper.indexOf(const val: string): integer;
var i:integer;
begin
  result:=-1;
  for i:=0 to High(Self) do
    if string(Self[i])=val then begin
      result:=i;
      exit;
    end;
end;

class function TVariantArrayHelper.Fill(const cnt:integer;val:TType):TSelf;
begin
  result:={$ifdef fpc}specialize{$endif} Fill<TType>(cnt,val)
end;

function TVariantArrayHelper.Extract(const Indecies:TIntegerDynArray):TSelf;
begin
    result:={$ifdef fpc}specialize{$endif} Extract<TSelf>(Self,indecies);
end;

procedure TVariantArrayHelper.Scatter(const indecies:TIntegerDynArray;const Values:TSelf);
begin
  {$ifdef fpc}specialize{$endif}Scatter<TSelf>(Self,indecies,Values);
end;

function TVariantArrayHelper.Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<TType>):TIntegerDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Find<TType>(Self,func)
end;

function TVariantArrayHelper.Find(const values:TSelf):TIntegerDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Find<TType>(Self,Values)
end;

function TVariantArrayHelper.Find(const value:TType):TIntegerDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Find<TType>(Self,Value)
end;

function TVariantArrayHelper.Intersect(const Other:TSelf;const binSearch:boolean=false):TSelf;
begin
  result:={$ifdef fpc}specialize{$endif} Intersect<TType>(Self,Other,BinSearch)
end;

function TVariantArrayHelper.Difference(const Other:TSelf;const binSearch:boolean=false):TSelf;
begin
  result:={$ifdef fpc}specialize{$endif} Difference<TType>(Self,Other,BinSearch)
end;

function TVariantArrayHelper.Mode():TType;
begin
  result:={$ifdef fpc}specialize{$endif} Mode<TType>(Self)
end;

function TVariantArrayHelper.reverse():TSelf; _REVERSE_;

function TVariantArrayHelper.ToString(const Seperator: string=', '; const quote: string='"';const Brackets:boolean=true): string;
var i:integer;
begin
  result:='';
  for i:=0 to Count-1 do
    result:=Result+Seperator+quote+string(Self[i])+quote ;
  delete(result,1,Length(Seperator));
  if Brackets then result:='['+result+']';
end;

class function TVariantArrayHelper.cmp(const a, b: TType): integer;
begin
  result:=1;
  if a<b then result:=-1
  else if a=b then result:=0
end;

class procedure TVariantArrayHelper.QuickSort(var Arr: TSelf; const L, R: Longint;const Compare: TCompare); static;
begin
  {$ifdef fpc}specialize{$endif} _QuickSort<TType,PType>(@Arr[0],L,R,Compare)  ;
end;

class function TVariantArrayHelper.uniqueFilt(const a:TType;const i:integer;arr:PType):boolean;static;
begin
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;


procedure TVariantArray2DHelper.SetCount(AValue: integer);
begin
  SetLength(Self,AValue)
end;

function TVariantArray2DHelper.GetCount: integer;
begin
  Result:=Length(Self)
end;

function TVariantArray2DHelper.reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TType>;const init:TType):TType;  _REDUCE_;


function TVariantArray2DHelper.reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TType>):TType;  _SIMPLEREDUCE_;

function TVariantArray2DHelper.Sort(CompareFunc:TCompare= nil):TSelf;  _DOSORT_;

function TVariantArray2DHelper.Sorted(CompareFunc:TCompare= nil):TSelf;  _SORTED_;

function TVariantArray2DHelper.Lookup(const val:TType):integer;
begin
  result:={$ifdef fpc}specialize{$endif} _BinSearch<TType,PType>(@Self[0],Val,Length(Self),TCompare({$ifdef fpc}@{$endif}Self.cmp));
end;

function TVariantArray2DHelper.Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TType>):TSelf;   _DOMAP_;

function TVariantArray2DHelper.Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TType>):TSelf;   _SIMPLEMAP_;

function TVariantArray2DHelper.Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TType>):TSelf;   _SIMPLEMAP_;

function TVariantArray2DHelper.Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TType, PType>):TSelf;   _FILTER_;

function TVariantArray2DHelper.unique():TSelf;
begin
    result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<TType,PType>({$ifdef fpc}@{$endif}uniqueFilt));
end;

function TVariantArray2DHelper.Transpose:TSelf;   _TRANSPOSE_;

function TVariantArray2DHelper.Push(v:TType):TType;    _PUSH_;

function TVariantArray2DHelper.Pop():TType;                   _POP_;

function TVariantArray2DHelper.UnShift(v:TType):TType;       _UNSHIFT_  ;

function TVariantArray2DHelper.Shift():TType;                         _SHIFT_;

function TVariantArray2DHelper.Slice(start,_end:integer):TSelf;       _SLICE_;

function TVariantArray2DHelper.Splice(start,deleteCount:integer;Items:TSelf):TSelf;  _SPLICE_;

function TVariantArray2DHelper.concat(Items:TSelf):TSelf;                _CONCAT_;

function TVariantArray2DHelper.ToString(const Seperator: string; const quote: string; const Brackets:boolean): string;
var i:integer;
begin
  result:='';
  for i:=0 to Count-1 do
    result:=Result+Seperator+LineEnding+Self[i].ToString(Seperator,Quote, Brackets) ;
  delete(result,1,Length(Seperator)+1);
  if Brackets then result:='['+result+']';
end;


class function TVariantArray2DHelper.cmp(const a, b: TType): integer;static;
var i:integer ;
begin
  for i:=0 to Min(high(a),high(b)) do begin
    result:=TType.cmp(a[i],b[i]);
    if result<>0 then exit;
  end;
  if Length(a)>Length(b) then result:=1
  else if Length(a)<Length(b) then result:=-1
  else result:=0;
end;

class procedure TVariantArray2DHelper.QuickSort(var Arr: TSelf; const L, R: Longint;const Compare: TCompare); static;
begin
  {$ifdef fpc}specialize{$endif} _QuickSort<TType,PType>(@Arr[0],L,R,Compare)  ;
end;

class function TVariantArray2DHelper.uniqueFilt(const a:TType;const i:integer;arr:PType):boolean;static;
begin
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;


{$ifdef fpc}generic {$endif}function MaxNumber<T>(const Data:array of T):T;
var i:integer;
begin
  Result := Data[Low(Data)];
  For I := Succ(Low(Data)) To High(Data) Do
    If Data[I] > Result Then Result := Data[I];
end;

{$ifdef fpc}generic {$endif}function MinNumber<T>(const Data:array of T):T;
var i:integer;
begin
  Result := Data[Low(Data)];
  For I := Succ(Low(Data)) To High(Data) Do
    If Data[I] < Result Then Result := Data[I];
end;

{$ifdef fpc}generic {$endif}function SumNumber<T, R>(const Data:array of T):R;
var i:integer;
begin
  Result:=0;
  For I := Low(Data) To High(Data) Do
    Result := Result+ Data[I];
end;

//{$ifdef fpc}generic {$endif}function SumNumber<T>(const Data:array of T):T;
//var i:integer;
//begin
//  Result:=0;
//  For I := Low(Data) To High(Data) Do
//    Result := Result+ Data[I];
//end;



{$ifdef fpc}generic{$endif} procedure Add<ARR>(const dst,a,b:ARR;const aCount:integer);        var i:integer;   begin  for i:=0 to aCount-1 do dst[i]:=a[i]+b[i]     end;
{$ifdef fpc}generic{$endif} procedure Subtract<ARR>(const dst,a,b:ARR;const aCount:integer);   var i:integer;   begin  for i:=0 to aCount-1 do dst[i]:=a[i]-b[i]     end;
{$ifdef fpc}generic{$endif} procedure Multiply<ARR>(const dst,a,b:ARR;const aCount:integer);   var i:integer;   begin  for i:=0 to aCount-1 do dst[i]:=a[i]*b[i]     end;
{$ifdef fpc}generic{$endif} procedure Divide<ARR>(const dst,a,b:ARR;const aCount:integer);     var i:integer;   begin  for i:=0 to aCount-1 do dst[i]:=a[i]/b[i]     end;
{$ifdef fpc}generic{$endif} procedure DivInt<ARR>(const dst,a,b:ARR;const aCount:integer);     var i:integer;   begin  for i:=0 to aCount-1 do dst[i]:=a[i] div b[i] end;
{$ifdef fpc}generic{$endif} procedure ModInt<ARR>(const dst,a,b:ARR;const aCount:integer);     var i:integer;   begin  for i:=0 to aCount-1 do dst[i]:=a[i] mod b[i] end;
//{$ifdef fpc}generic{$endif} procedure Add<T>( dst,a:array of T;const b:T);          var i:integer;   begin  for i:=0 to High(dst) do dst[i]:=a[i]+b     end;
//{$ifdef fpc}generic{$endif} procedure Subtract<T>( dst,a:array of T;const b:T);     var i:integer;   begin  for i:=0 to High(dst) do dst[i]:=a[i]-b     end;
//{$ifdef fpc}generic{$endif} procedure Multiply<T>( dst,a:array of T;const b:T);     var i:integer;   begin  for i:=0 to High(dst) do dst[i]:=a[i]*b     end;
//{$ifdef fpc}generic{$endif} procedure Divide<T>( dst,a:array of T;const b:T);       var i:integer;   begin  for i:=0 to High(dst) do dst[i]:=a[i]/b     end;
//{$ifdef fpc}generic{$endif} procedure DivInt<T>( dst,a:array of T;const b:T);       var i:integer;   begin  for i:=0 to High(dst) do dst[i]:=a[i] div b end;
//{$ifdef fpc}generic{$endif} procedure ModInt<T>( dst,a:array of T;const b:T);       var i:integer;   begin  for i:=0 to High(dst) do dst[i]:=a[i] mod b end;

{$ifdef fpc}generic{$endif} function Push<T>(var Self:{$ifdef fpc}specialize{$endif} TArray<T>;const v:T):T;                     //                   _PUSH_;
//var C:integer;
begin
  insert(v,Self,length(Self))
  //c:=Length(Self)+1;
  //setLength(Self,C);
  //Self[C-1]:=v;
  //result:=v
end;

{$ifdef fpc}generic{$endif} function Pop<T>(var Self:array of T):T;                                                   _POP_;
{$ifdef fpc}generic{$endif} function Shift<T>(var Self:array of T):T;                                                 _SHIFT_;
{$ifdef fpc}generic{$endif} function UnShift<T>(var Self:array of T;const v:T):T;                                     _UNSHIFT_;
{$ifdef fpc}generic{$endif} function Concat<ARR>(const Self:ARR;const Items:ARR):ARR;                                 _CONCAT_;
{$ifdef fpc}generic{$endif} function Splice<ARR>(var Self:ARR; start,deleteCount:integer;const Items:ARR):ARR;        _SPLICE_;
{$ifdef fpc}generic{$endif} function Slice<ARR>(const Self:ARR; start,_end:integer):ARR;                              _SLICE_;
{$ifdef fpc}generic{$endif} function Extract<ARR>(const Self:ARR; const Indecies:TIntegerDynArray):ARR;               _EXTRACT_;
{$ifdef fpc}generic{$endif} procedure Scatter<ARR>(const Self:ARR; const Indecies:TIntegerDynArray;const Values:ARR); _SCATTER_;
{$ifdef fpc}generic{$endif} function Reduce<T>(const Self:array of T;func:{$ifdef fpc}specialize{$endif} TReduceCallback<T>;const init:T):T;  //_REDUCE_;
var i,l:integer;
begin
  l:=Length(Self);
  if l>0 then
    result:=func(init,self[0],0,Self);
  if l>1 then
     begin
//       result:=self[0];
       for i:=1 to l-1 do
         result:=func(result,self[i],i,self)
     end
end;

{$ifdef fpc}generic{$endif} function Reduce<T>(const Self:array of T;func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<T>;const init:T):T;//  _SIMPLEREDUCE_;
var i,l:integer;
begin
  l:=Length(Self);
  if l>0 then
    result:=func(init,self[0]);
  if l>1 then
     begin
//       result:=self[0];
       for i:=1 to l-1 do
         result:=func(result,self[i])
     end
end;

{$ifdef fpc}generic{$endif} function Reduce<T>(const Self:array of T;func:{$ifdef fpc}specialize{$endif} TReduceCallback<T>):T;//  _SIMPLEREDUCE_;
var i:integer;
begin
  if High(Self)>-1 then
    result:=Self[0];
  for i:=1 to high(self) do
    result:=func(result,Self[i],i,Self)
end;

{$ifdef fpc}generic{$endif} procedure Reverse<T>(const Self:{$ifdef fpc}specialize{$endif}TArray<T>; const  N : integer);
var first,last:integer; v:T;
begin
  first :=0;  last := N-1;
  while first < last do begin
    V := Self[first];
    Self[first] := Self[last];
    Self[last]  := V;
    inc(first);
    dec(last)
  end;
end;

{$ifdef fpc}generic{$endif} function Map<T,R>(const Self:array of T;const func: {$ifdef fpc}specialize{$endif} TMapCallbackR<T,R>):{$ifdef fpc}specialize {$endif}TArray<R>; _DOMAP_;
//var i,C:integer;
//begin
//  C:=Length(Self);
//  setLength(result,C);
//  for i:=0 To C-1 do
//    Result[i]:=func(Self[i],i,Self);
//end;

{$ifdef fpc}generic{$endif} function Filter<ARR,T>(const Self:ARR;const func:{$ifdef fpc}specialize {$endif}TFilterCallback<T,ARR>):ARR;_FILTER_;

{$ifdef fpc}generic{$endif} function IndexOf<T>(const Self:array of T; const val:T):integer;                         _INDEXOF_;
{$ifdef fpc}generic{$endif} function IndexOf<ARR,T>(const Self:ARR;    const val:T;  const aCount:integer):integer;var i:integer;     begin result := -1 ; for i:=0 to aCount-1 do if Self[i]=val then exit(i) end;
{$ifdef fpc}generic{$endif} procedure Fill<T>(Self:array of T;const Val:T); var i:integer;
begin
  for i:=0 to High(Self) do Self[i]:=Val
end;

{$ifdef fpc}generic{$endif} procedure Fill<ARR,T>(Self:ARR;const aCount:integer;const Val:T); var i:integer;
begin
  for i:=0 to aCount-1 do Self[i]:=Val
end;

{$ifdef fpc}generic{$endif} function Fill<T>(const aCount:integer;const Val:T):{$ifdef fpc}specialize {$endif}TArray<T>;
var i:integer;
begin
  setLength(result,aCount);
  for i:=0 to aCount-1 do result[i]:=Val
end;


{$ifdef fpc}generic{$endif} function Find<T>(const Self:array of T; const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallback<T>):TIntegerDynArray;  _FIND_;
{$ifdef fpc}generic{$endif} function Find<T>(const Self:array of T; const Values:array of T):TIntegerDynArray;                                _FINDVALS1_;
{$ifdef fpc}generic{$endif} function Find<T>(const Self:array of T; const Value:T):TIntegerDynArray;                                          _FINDVALS2_;

{$ifdef fpc}generic{$endif} function Intersect<T>(const Self,other:{$ifdef fpc}specialize{$endif} TArray<T>;const binSearch:boolean):{$ifdef fpc}specialize{$endif} TArray<T>;
type PT=^T;
var i,j:integer; tmp,tmp2:{$ifdef fpc}specialize{$endif} TArray<T>;  // compare:{$ifdef fpc}specialize{$endif}TCompareFuncNested<T>;
//  function cmp(const a,b:T):integer;begin result:=-1; if a=b then result:=0 else if b>a then result:=1 end;
begin
  if Length(Self)>Length(Other) then    // search in the smallest array to imporove perfomance?
    begin tmp:=Other;tmp2:=Self end
  else
    begin tmp:=Self;tmp2:=Other end;
  setLength(Result,length(tmp)) ;
  j:=0;
  if binSearch then begin
    for i:=0 to High(tmp) do
      if {$ifdef fpc}specialize{$endif} _BinSearch<T,PT>(@tmp2[0],tmp[i],length(tmp2))>=0 then begin
        result[j]:=tmp[i]  ;
        inc(j)
      end else
  end else
    for i:=0 to High(tmp) do
      if {$ifdef fpc}specialize{$endif} Indexof<T>(tmp2,tmp[i])>=0 then begin
        result[j]:=tmp[i] ;
        inc(j)
      end ;
  setLength(result,j)
end;

{$ifdef fpc}generic{$endif} function Difference<T>(const Self,other:{$ifdef fpc}specialize{$endif} TArray<T>;const binSearch:boolean=false):{$ifdef fpc}specialize{$endif} TArray<T>;
type PT=^T;
var i,j:integer;
//function cmp(const a,b:T):integer;begin result:=-1; if a=b then result:=0 else if b>a then result:=1 end;
begin
  setLength(Result,Length(Self));j:=0;
  if binSearch then
    for i:=0 to High(Self) do
      if {$ifdef fpc}specialize{$endif} _BinSearch<T,PT>(@Other[0],Self[i],length(other))<0 then begin
        Result[j]:=Self[i];
        inc(j)
      end else
  else
    for i:=0 to High(Self) do
      if {$ifdef fpc}specialize{$endif} IndexOf<T>(Other,Self[i])<0 then begin
        Result[j]:=Self[i];
        inc(j)
      end;
  setLength(result,j)
end;

{$ifdef fpc}generic{$endif} function Mode<T>(const Self:array of T):T;
var
  i,r,c:integer;
  LS:{$ifdef fpc}specialize {$endif}TKeyValueList<T,integer>;
begin
  r:=0;
  for i:=0 to High(Self) do begin
    if LS.KeyExists(Self[i]) then
      c:=LS[Self[i]]+1
    else
      c:=1;
    LS[Self[i]]:=c;
    if r<c then begin
      r:=c;
      result:=Self[i]
    end;
    if c=551 then
      beep
  end;
end;


(*
function expre0 (const z : real) : complex ;inline;
  { exponantial : r := exp(z) }
  { exp(x + iy) = exp(x).exp(iy) = exp(x).[cos(y) + i sin(y)] }
//var expz : real;
begin
   //expz := system.exp(z.re);
   result.re := {expz *} cos(z{.im});
   result.im := {expz *} sin(z{.im});
end;

procedure cexp (var z:complex;const z1:complex) ;inline;
  { exponantial : r := exp(z) }
  { exp(x + iy) = exp(x).exp(iy) = exp(x).[cos(y) + i sin(y)] }
var expz : real;
begin
   expz := system.exp(z1.re);
   z.re := expz * cos(z1.im);
   z.im := expz * sin(z1.im);
end;

procedure cmul(var z1:complex;const z2 : complex); inline;
{ multiplication : z := z1 * z2 }
begin
   z1.re := (z1.re * z2.re) - (z1.im * z2.im);
   z1.im := (z1.re * z2.im) + (z1.im * z2.re);
end;
*)
{$define Number:=Byte}
{$define TNumberArrayHelper:=TByteArrayHelper}
{$define TNumberDynArray:=TByteDynArray}
{$define TNumberArrayArray:=TByteArrayArray}
{$define TNumberArrayArrayHelper:=TByteArrayArrayHelper}
   {$I arraynumimp.inc}
{$UnDef Number}
{$UnDef TNumberDynArray}
{$UnDef TNumberArrayHelper}
{$UnDef TNumberArrayArray}
{$UnDef TNumberArrayArrayHelper}

{$define Number:=Integer}
{$define TNumberArrayHelper:=TIntegerArrayHelper}
{$define TNumberDynArray:=TIntegerDynArray}
{$define TNumberArrayArray:=TIntegerArrayArray}
{$define TNumberArrayArrayHelper:=TIntegerArrayArrayHelper}
   {$I arraynumimp.inc}
{$UnDef Number}
{$UnDef TNumberDynArray}
{$UnDef TNumberArrayHelper}
{$UnDef TNumberArrayArray}
{$UnDef TNumberArrayArrayHelper}

{$define Number:=Int64}
{$define TNumberArrayHelper:=TInt64ArrayHelper}
{$define TNumberDynArray:=TInt64DynArray}
{$define TNumberArrayArray:=TInt64ArrayArray}
{$define TNumberArrayArrayHelper:=TInt64ArrayArrayHelper}
   {$I arraynumimp.inc}
{$UnDef Number}
{$UnDef TNumberDynArray}
{$UnDef TNumberArrayHelper}
{$UnDef TNumberArrayArray}
{$UnDef TNumberArrayArrayHelper}

{$define Float:=Single}
{$define PFloat:=PSingle}
{$define TFloatArrayHelper:=TSingleArrayHelper}
{$define TFloatDynArray:=TSingleDynArray}
{$define TFloatArrayArray:=TSingleArrayArray}
{$define TFloatArrayArrayHelper:=TSingleArrayArrayHelper}
{$define Complex:=ComplexF}
{$define TComplexArray:=TComplexArrayF}
{$define TComplexArrayArray:=TComplexArrayArrayF}
  {$I arrayfloatimp.inc}
{$undef TComplexArray}
{$undef TComplexArrayArray}
{$undef Complex}
{$UnDef Float}
{$UnDef PFloat}
{$UnDef TFloatDynArray}
{$UnDef TFloatArrayHelper}
{$UnDef TFloatArrayArray}
{$UnDef TFloatArrayArrayHelper}

{$define Float:=Double}
{$define PFloat:=PDouble}
{$define TFloatArrayHelper:=TDoubleArrayHelper}
{$define TFloatDynArray:=TDoubleDynArray}
{$define TFloatArrayArray:=TDoubleArrayArray}
{$define TFloatArrayArrayHelper:=TDoubleArrayArrayHelper}
{$define Complex:=ComplexD}
{$define TComplexArray:=TComplexArrayD}
{$define TComplexArrayArray:=TComplexArrayArrayD}
  {$I arrayfloatimp.inc}
{$undef TComplexArray}
{$undef TComplexArrayArray}
{$undef Complex}
{$UnDef Float}
{$UnDef PFloat}
{$UnDef TFloatDynArray}
{$UnDef TFloatArrayHelper}
{$UnDef TFloatArrayArray}
{$UnDef TFloatArrayArrayHelper}

//{$define Float:=Currency}
//{$define TFloatArrayHelper:=TCurrencyArrayHelper}
//{$define TFloatDynArray:=TCurrencyArray}
//{$define TFloatArrayArray:=TCurrencyArrayArray}
//{$define TFloatArrayArrayHelper:=TCurrencyArrayArrayHelper}
//   {$I arrayfloatimp.inc}
//{$UnDef Float}
//{$UnDef TFloatDynArray}
//{$UnDef TFloatArrayHelper}
//{$UnDef TFloatArrayArray}
//{$UnDef TFloatArrayArrayHelper}
{$ifdef SUPPORT_EXTENDED}
{$define Float:=Extended}
{$define PFloat:=PExtended}
{$define TFloatArrayHelper:=TExtendedArrayHelper}
{$define TFloatDynArray:=TExtendedDynArray}
{$define TFloatArrayArray:=TExtendedArrayArray}
{$define TFloatArrayArrayHelper:=TExtendedArrayArrayHelper}
{$define Complex:=ComplexE}
{$define TComplexArray:=TComplexArrayE}
{$define TComplexArrayArray:=TComplexArrayArrayE}
  {$I arrayfloatimp.inc}
{$undef TComplexArray}
{$undef TComplexArrayArray}
{$undef Complex}
{$UnDef Float}
{$UnDef PFloat}
{$UnDef TFloatDynArray}
{$UnDef TFloatArrayHelper}
{$UnDef TFloatArrayArray}
{$UnDef TFloatArrayArrayHelper}
{$endif}

{$ifdef fpc}
operator:=(const Arr: TStringDynArray): string;
begin
    result:=Arr.toString
end;
operator:=(const Arr: TStringArrayArray): string;
begin
  result:=Arr.toString
end;

//operator:=(const Arr: TComplexArray): string;
//var i,C:integer;
//begin
// result:='';C:=Length(Arr);
//  for i:=0 to C-1 do
//    //Result:=Result+', '+FloatToStr(Arr[i].re)+' '+FloatToStr(Arr[i].im)+'i';
//    if Arr[i].im<0 then
//      Result:=Result+format(', %f%s%fi',[Arr[i].re,'' ,Arr[i].im])
//    else
//      Result:=Result+format(', %f%s%fi',[Arr[i].re,'+' ,Arr[i].im]);
//  delete(result,1,1);
//  result:='['+result+']';
//end;
operator:=(const i: Integer): string;
begin
  result:=IntToStr(i)
end;

operator:=(const s: string): integer;
begin
  result:=StrToInt(s)
end;

operator:=(const f: extended): string;
begin
  result:=FloatToStr(f);
end;

operator:=(const s: string): extended;
begin
  result:=StrToFloat(s);
end;
operator+(const Arr, Arr2: TStringDynArray): TStringDynArray;                             _AADD_;
operator+(const Arr, Arr2: TStringArrayArray): TStringArrayArray;                   _AADD_;
operator+(const Arr: TStringDynArray       ;   const v: String ): TStringDynArray;        _ADD_;
operator+(const Arr: TStringArrayArray  ;   const v: TStringDynArray ): TStringArrayArray;   _ADD_;
operator+(const v: String ;const Arr: TStringDynArray       ): TStringDynArray;           var i:integer;begin setLength(result,Length(Arr));for i:=0 to High(Arr) do result[i]:=v+Arr[i] end;
operator+(const v: TStringDynArray ;const Arr: TStringArrayArray  ): TStringArrayArray;var i:integer;begin setLength(result,Length(Arr));for i:=0 to High(Arr) do result[i]:=v+Arr[i] end;
{$endif}

{ TStringArrayArrayHelper }

function TStringArrayArrayHelper.GetCount: integer;_DOCOUNT_;

procedure TStringArrayArrayHelper.SetCount(AValue: integer);_SETCOUNT_;

function TStringArrayArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TReduceCallback<TStringDynArray>;const init: TStringDynArray): TStringDynArray;_REDUCE_;

function TStringArrayArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TStringDynArray>): TStringDynArray;_SIMPLEREDUCE_;

function TStringArrayArrayHelper.Sort(CompareFunc: TCompareFuncStringAA):TStringArrayArray;  _DOSORT_;
function TStringArrayArrayHelper.Sorted(CompareFunc: TCompareFuncStringAA): TStringArrayArray;_SORTED_;

function TStringArrayArrayHelper.Lookup(const val:TStringDynArray):integer;
begin
  // assuming that the array is sorted
  result:={$ifdef fpc}specialize{$endif} _BinSearch<TStringDynArray,PStringArray>(@Self[0],Val,Length(Self),TCompareFuncStringAA({$ifdef fpc}@{$endif}Self.cmp));
end;

function TStringArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<TStringDynArray>): TStringArrayArray;_DOMAP_;

function TStringArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<TStringDynArray> ): TStringArrayArray; _SIMPLEMAP_;

function TStringArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TStringDynArray> ): TStringArrayArray; _SIMPLEMAP_;

function TStringArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<TStringDynArray>): TVariantArray;_DOMAP_;

function TStringArrayArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<TStringDynArray,PStringArray> ): TStringArrayArray;_FILTER_;

function TStringArrayArrayHelper.Transpose: TStringArrayArray;_TRANSPOSE_;

function TStringArrayArrayHelper.Push(v: TStringDynArray): TStringDynArray; _PUSH_;

function TStringArrayArrayHelper.Pop(): TStringDynArray; _POP_;

function TStringArrayArrayHelper.UnShift(v: TStringDynArray): TStringDynArray;_UNSHIFT_;

function TStringArrayArrayHelper.Shift(): TStringDynArray;_SHIFT_;

function TStringArrayArrayHelper.Slice(start, _end: integer): TStringArrayArray;_SLICE_;

function TStringArrayArrayHelper.Splice(start, deleteCount: integer; Items: TStringArrayArray): TStringArrayArray; _SPLICE_;

function TStringArrayArrayHelper.concat(Items: TStringArrayArray): TStringArrayArray; _CONCAT_;

function TStringArrayArrayHelper.ToString(const Seperator: string;
  const quote: string): string;
var i:integer;
begin
  result:='';
  for i:=0 to Count-1 do
    result:=Result+Seperator+LineEnding+Self[i].ToString(Seperator,Quote) ;
  delete(result,1,Length(Seperator)+2);
  result:='['+result+']';
end;

class function TStringArrayArrayHelper.cmp(const a, b: TStringDynArray): integer;
var i:integer ;
begin
  for i:=0 to Min(high(a),high(b)) do begin
    result:=TStringDynArray.cmp(a[i],b[i]);
    if result<>0 then exit;
  end;
  if Length(a)>Length(b) then result:=1
  else if Length(a)<Length(b) then result:=-1
  else result:=0;
end;

class function TStringArrayArrayHelper.FromDelimtedText(const Str:string;const LineBreak:string=LineEnding;const Delimiter:Char=',';const Quote:char='"'):TStringArrayArray;
var sLines:TStringDynArray;i:SizeInt;
begin
  sLines:=Str.Split([LineBreak]);
  setLength(Result,Length(sLines));
  for i:=0 to High(Result) do
    Result[i]:=sLines[i].Split([Delimiter],Quote);
end;

class function TStringArrayArrayHelper.FromDelimtedText(const Str:string;const LineBreak:string;const Delimiter:Char;const StartingQuote,EndingQuote:Char):TStringArrayArray;
var sLines:TStringDynArray;i:SizeInt;
begin
  sLines:=Str.Split([LineBreak]);
  setLength(Result,Length(sLines));
  for i:=0 to High(Result) do
    Result[i]:=sLines[i].Split([Delimiter],StartingQuote,EndingQuote);
end;

class procedure TStringArrayArrayHelper.QuickSort(var Arr: TStringArrayArray;
  const L, R: Longint; const Compare: TCompareFuncStringAA);
begin
    {$ifdef fpc}specialize{$endif} _QuickSort<TStringDynArray,PStringArray>(@Arr[0],L,R,Compare)  ;
end;

class function TStringArrayArrayHelper.uniqueFilt(const a:TStringDynArray;const i:integer;arr:PStringArray):boolean;
begin;
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;

function TStringArrayArrayHelper.unique():TStringArrayArray;
begin
  result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<TStringDynArray,PStringArray>({$ifdef fpc}@{$endif}uniqueFilt));
end;

{ TStringArrayHelper }

procedure TStringArrayHelper.SetCount(AValue: integer); _SETCOUNT_;

function TStringArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TReduceCallback<string>; const init: string): string; _REDUCE_;

function TStringArrayHelper.GetCount: Integer;   _DOCOUNT_;

function TStringArrayHelper.Sort(const CompareFunc: TCompareFuncStr):TStringDynArray; _DOSORT_ ;

function TStringArrayHelper.Lookup(const val:string):integer;
begin
  // assuming that the array is sorted
  result:={$ifdef fpc}specialize{$endif} _BinSearch<string,PString>(@Self[0],Val,Length(Self),TCompareFuncStr({$ifdef fpc}@{$endif}Self.cmp));
end;

function TStringArrayHelper.Sorted(const CompareFunc: TCompareFuncStr): TStringDynArray;_SORTED_;

function TStringArrayHelper.isSorted(const descending:boolean;  CompareFunc: TCompareFuncStr): boolean;_ISSORTED_;

function TStringArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<string>): TStringDynArray; _DOMAP_;

function TStringArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<string> ): TStringDynArray;_SIMPLEMAP_;

function TStringArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<string> ): TStringDynArray;_SIMPLEMAP_;

function TStringArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<string>): TVariantArray;_DOMAP_;


function TStringArrayHelper.FilterStr(val: string; partialMatch: boolean
  ): TStringDynArray;
var i,j,C:integer;
begin
  C:=Count;  j:=0;
  //result:=nil;
  setLength(result,C);
  if partialMatch then begin
      for i:=0 to C-1 do
        if Self[i].Contains(val) then begin
          result[j]:=Self[i];
          inc(j);
        end;
  end else
    for i:=0 to C-1 do
      if Self[i]=val then begin
        result[j]:=Self[i];
        inc(j);
      end;
  setLength(result,j);
end;

function TStringArrayHelper.FilterText(val: string; partialMatch: boolean
  ): TStringDynArray;
var i,j,C:integer;
begin
 // result:=nil;
  C:=Count;  j:=0;
  setLength(result,C);
  val:=val.ToLower;
  if partialMatch then begin
    for i:=0 to C-1 do
      if Self[i].ToLower.Contains(val) then
      begin
        result[j]:=Self[i];
        inc(j);
      end;
  end else
    for i:=0 to C-1 do
      if Self[i].ToLower=val then begin
        result[j]:=Self[i];
        inc(j)
      end;
  setLength(result,j);
end;

function TStringArrayHelper.indexOf(const val: string): integer; _INDEXOF_;

function TStringArrayHelper.Intersect(const Other:TStringDynArray;const binSearch:boolean):TStringDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Intersect<string>(Self,Other,binSearch);
end;

function TStringArrayHelper.Difference(const Other:TStringDynArray;const binSearch:boolean):TStringDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Difference<string>(Self,Other,binSearch);
end;


function TStringArrayHelper.mode():string;
var i,C,e,r:integer;vs:TStringDynArray;a:TIntegerDynArray;
begin
  C:=Count;
  r:=0;
  for i:=0 to C-1 do
    begin
      e:=vs.Lookup(Self[i]);
      if e<0 then begin
        vs.Splice(e+1,0,[Self[i]]);
        a.Splice(e+1,0,[1]);
        if r<1 then r:=1;
      end else
        begin
          a[e]:=a[e]+1;
          if r<a[e] then r:=e
        end;
    end;
  result:=vs[r]
end;

function TStringArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<string,PString> ): TStringDynArray; _FILTER_;

//function TStringArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterFunc<string> ): TStringDynArray; _FILTER_;

class function TStringArrayHelper.uniqueFilt(const a:string;const i:integer;arr:PString):boolean;
begin;
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;

function TStringArrayHelper.unique():TStringDynArray;
begin
  result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<string,PString>({$ifdef fpc}@{$endif}uniqueFilt));
end;

function TStringArrayHelper.Push(v: string): string; _PUSH_;

function TStringArrayHelper.reverse():TStringDynArray;_REVERSE_;

function TStringArrayHelper.Pop(): string; _POP_;

function TStringArrayHelper.UnShift(v: string): string; _UNSHIFT_;

function TStringArrayHelper.Shift(): string; _SHIFT_;

function TStringArrayHelper.Slice(start, _end: integer): TStringDynArray; _SLICE_;

function TStringArrayHelper.Splice(start, deleteCount: integer; Items: TStringDynArray): TStringDynArray;_SPLICE_;

function TStringArrayHelper.Extract(const Indecies:TIntegerDynArray): TStringDynArray; _EXTRACT_;

procedure TStringArrayHelper.Scatter(const indecies:TIntegerDynArray;const Values:TStringDynArray);   _SCATTER_;

function TStringArrayHelper.Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<String>):TIntegerDynArray; _FIND_;

function TStringArrayHelper.Find(const values:TStringDynArray):TIntegerDynArray;    _FINDVALS1_;

function TStringArrayHelper.Find(const value:String):TIntegerDynArray;              _FINDVALS2_;

function TStringArrayHelper.concat(Items: TStringDynArray): TStringDynArray; _CONCAT_;

class function TStringArrayHelper.Fill(const cnt:integer;str:string):TStringDynArray;
var i:integer;
begin
  setLength(Result,cnt);
  i:=0;
  while i<Result.Count do begin
    result[i]:=Str;
    inc(i)
  end;
end;

function TStringArrayHelper.ToString(const Seperator: string;
  const quote: string): string;
var i:integer;
begin
  Result:='';
  if quote='' then
    for i:=0 to Count-1 do
      Result:=Result+Seperator+Self[i]
  else
    for i:=0 to Count-1 do
      Result:=Result+Seperator+quote+StringReplace(Self[i],quote,'\'+quote,[rfReplaceAll])+quote;
  if Count>0 then delete(result,1,length(Seperator));
  result:='['+result+']';
end ;

class function TStringArrayHelper.cmp(const a, b: string): integer;
begin
  result:=CompareStr(a,b)
end;

class procedure TStringArrayHelper.QuickSort(var Arr: TStringDynArray; const L,
  R: Longint; const Compare: TCompareFuncStr);
begin
  {$ifdef fpc}specialize{$endif} _QuickSort<string,PString>(@Arr[0],L,R,Compare)
end;

function TStringArrayHelper.as2d(const Columns:integer;const Transposed:boolean):TStringArrayArray;
var i,C,M,R,Rows:integer;
begin
  c:=Count;
  Rows:=system.trunc(C/Columns);
  c:=Columns*Rows;
  setLength(result,Rows,Columns);
  if transposed then
  for i:=0 to C-1 do
    begin
      DivMod(i,Rows,r,M);
      //if result[r]=nil then
      //  setLength(result[r],Columns);
      result[M,r]:=Self[i]
    end
  else for i:=0 to C-1 do
    begin
      DivMod(i,Columns,r,M);
      //if result[M]=nil then
      //  setLength(result[M],Columns);
      result[r,M]:=Self[i]
    end;
end;

function TStringArrayHelper.Transpose(const Width:integer):TStringDynArray;
var x,y,H:integer;
begin
  setLength(Result,Length(Self));
  H:=Length(Self) div width;
  for y:=0 to H-1 do
    for x:=0 to Width-1 do
      result[x*width+y]:=self[y*width+x]
end;

function StrToByte(const str:string):byte; _inline
begin
  result:=StrToInt(str)
end;

function StrToWord(const str:string):Word; _inline
begin
  result:=StrToInt(str)
end;

function StrToSingle(const str:string):Single; _inline
begin
  result:=StrToFloat(str)
end;

function StrToDouble(const str:string):Double; _inline
begin
  result:=StrToFloat(str)
end;

function TStringArrayHelper.ToDoubles:TDoubleDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<Double>({$ifdef fpc}@{$endif}StrToDouble)
end;

function TStringArrayHelper.ToSingles:TSingleDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<Single>({$ifdef fpc}@{$endif}StrToSingle)
end;

function TStringArrayHelper.ToIntegers:TIntegerDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<Integer>({$ifdef fpc}@{$endif}StrToInt)
end;

function TStringArrayHelper.ToInt64:TInt64DynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<Int64>({$ifdef fpc}@{$endif}StrToInt64)
end;

function TStringArrayHelper.ToBytes:TByteDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<Byte>({$ifdef fpc}@{$endif}StrToByte)
end;

function TStringArrayHelper.ToWords:TWordDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<Word>({$ifdef fpc}@{$endif}StrToWord)
end;

function TStringArrayHelper.ToLongWords:TLongWordDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<LongWord>({$ifdef fpc}@{$endif}StrToDWord)
end;

function TStringArrayHelper.ToQWords:TQWordDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} ToType<QWord>({$ifdef fpc}@{$endif}StrToQWord)
end;

generic function TStringArrayHelper.ToType<T>(const Conv:{$ifdef fpc}specialize{$endif} TConvertCallback<string,T>):{$ifdef fpc}specialize{$endif} TArray<T>;
var i:integer;
begin
  setLength(Result,Length(Self));
  for i:=0 to High(Self) do
    result[i]:=Conv(Self[i])
end;

class function TStringArrayHelper.Every(const dst:PString; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<string,PString>):boolean;  _EVERY_;

class function TStringArrayHelper.Some(const dst:PString; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<string,PString>):boolean;  _SOME_;


function SameValue(const aa,bb:PSingle;const N:integer=0;const epsilon:single=1e-4):integer; overload;
var i:integer;
begin
  result:=-1;
  for i:=0 to N-1 do if not SameValue(aa[i],bb[i],epsilon) then
    begin
      result:=i;
      exit
    end
end;

function SameValue(const aa,bb:PDouble;const N:integer=0;const epsilon:single=1e-12):integer; overload;
var i:integer;
begin
  result:=-1;
  for i:=0 to N-1 do if not SameValue(aa[i],bb[i],epsilon) then
     begin
       result:=i;
       exit
     end
end;

function LogStr(oprStr:string;factor:double;Count:integer;tp,ts:double;a,b:TSingleDynArray):string;overload;
var comp:integer;
begin
  comp := SameValue(PSingle(a),PSingle(b),ifthen(Count=0,Length(a),Count));
  result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'%s[%s]'+LineEnding,[oprstr,factor,ifthen(Count=0,Length(a),Count),tp,ts,ifthen(comp>-1,'@Index: '+comp),ifthen(comp=-1,'OK','FAIL('+a[comp].ToString()+', '+b[comp].ToString()+')')]);
end;

function LogStr(oprStr:string;factor:double;Count:integer;tp,ts:double;a,b:TDoubleDynArray):string;overload;
var comp:integer;
begin
  comp := SameValue(PDouble(a),PDouble(b),ifthen(Count=0,Length(a),Count));
  result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'%s[%s]'+LineEnding,[oprstr,factor,ifthen(Count=0,Length(a),Count),tp,ts,ifthen(comp>-1,'@Index: '+comp),ifthen(comp=-1,'OK','FAIL('+a[comp].ToString()+', '+b[comp].ToString()+')')]);
end;

function LogStr(oprStr:string;factor:double;Count:integer;tp,ts:double;a,b:single):string;overload;
begin
      result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'[%s]'+LineEnding,[oprstr,factor,Count,tp,ts,ifthen(SameValue(a,b),'OK','FAIL('+a.ToString()+', '+b.ToString()+')')]);
end;

function LogStr(oprStr:string;factor:double;Count:integer;tp,ts:double;a,b:double):string;overload;
begin
      result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'[%s]'+LineEnding,[oprstr,factor,Count,tp,ts,ifthen(SameValue(a,b),'OK','FAIL('+a.ToString()+', '+b.ToString()+')')]);
end;

function LogStr(oprStr:string;factor:double;Count:integer;tp,ts:double;a,b:string):string;overload;
begin
      result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'[%s]'+LineEnding,[oprstr,factor,Count,tp,ts,ifthen(a=b,'OK','FAIL('+a+', '+b+')')]);
end;


function dotest(pa: integer): string;
var
  i,j,k,l,stride,x,y:int64;
  a,b,c,d:TSingleDynArray;ad,bd,cd,dd:TDoubleDynArray;
  ac,bc,cc,dc:TComplexArrayF;
  az,bz,cz,dz:TComplexArrayD;
  zs1,zs2:ComplexF;
  zd1,zd2:ComplexD;

  s1,s2:Single; d1,d2:Double;
  t1,t2,t3:uInt64;vals,vals2:single; vald,vald2:double;
  const N=$200000+24+3; F=5;W=trunc(SQRT(N));
begin
  result:='';
  {$ifdef USE_AVX2}
    vals:=random()*3;
    vald:=Random()*3;
    vals2:=random()*3;
    vald2:=Random()*3;
    //s:=mmloadu(TIntegerDynArray([1,666,3,4,5,6,7,8]));
    //result:='load Integer result: '+s+#13#10;
    //
    //s:=mmloadu(TSingleDynArray([111,666,333,4,5,6,7,8]));
    //result+='load Single result: '+s+#13#10;
    //
    //s:=mm_maskload_epi64(TInt64DynArray([11,22,33,44,55,66,77,88]),Tint64DynArray([-1,-1,1,1]));
    //result+='mask Single result: '+s+#13#10;
//    setLength(a,10,20);
//    a:=TSingleDynArray.fill(20,1,1).concat(TSingleDynArray.fill(20,21,1))  ;
  //   a.normal(1,0.5);
//    result:=a.as2d(20).Count;

    a:=TSingleDynArray.Uniform(N,1,-1);
    b:=TSingleDynArray.Uniform(N,1,-1);
    //a:=TSingleDynArray.fill(N,0,1);
    //b:=TSingleDynArray.fill(N,0,2);
    c.Count:=N;
    d.Count:=N;
    ad:=TDoubleDynArray.Uniform(N,1,-1);
    bd:=TDoubleDynArray.Uniform(N,1,-1);
    cd.Count:=N;
    dd.Count:=N;

    result:=('Operation'#9'Factor'#9'Elements'#9'Elapsed No SIMD/ SIMD'#9'Result'#13#10);

    (*
    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vadd(@a[0],1,@b[0],1,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=a[i]+b[i];
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector + Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsub(@b[0],1,@a[0],1,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=a[i]-b[i];
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector - Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vmul(@a[0],1,@b[0],1,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=a[i]*b[i];
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector * Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vdiv(@b[0],1,@a[0],1,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=a[i]/b[i];
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector / Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsadd(@a[0],1,@vals,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=a[i]+vals;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar + Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=vals - a[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar - Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsmul(@a[0],1,@vals,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=a[i]*vals;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar * Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=vals / a[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar / Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_maxv(@a[0],1,@s1,N);
    {$else}
    s1:= MaxValue(a) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMax_s(@s2,@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Max(Vector)',t2/t3,a.Count,t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_minv(@a[0],1,@s1,N);
    {$else}
    s1:= MinValue(a) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMin_s(@s2,@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Min(Vector)',t2/t3,a.Count,t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_svemg(@a[0],1,@s1,N);
    {$else}
    //s1:=0;
    //for i:=0 to N-1 do
    //  s1:=s1+Abs(a[i]);
    s1:=sum(a);
    s1:=cblas_sasum(N,@a[0],1);
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSumAbs_s(@s2,@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Sum(Abs(Vector))',t2/t3,a.Count,t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_svesq(@a[0],1,@s1,N);
    {$else}
    s1:= SumOfSquares(a) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSumSqr_s(@s2,@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Sum(Vector^2)',t2/t3,a.Count,t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vabs(@a[0],1,@c[0],1,N);
    {$else}
    for i:=0 to N-1 do
      c[i]:=abs(a[i])  ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAbs_s(@d[0],@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Abs(Vector)',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsma(@a[0],1,@vals,@c[0],1,@c[0],1,N);
    {$else}
    cblas_saxpy(N,vals,@a[0],1,@c[0],1);
    //move(c[0],b[0],N*sizeOf(single));
    //for i:=0 to High(a) do
    //  c[i]:=vals*a[i]+c[i] ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAXPY_s(@d[0],@a[0],@d[0],N,@vals);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : AXPY a * Vector + Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
//    cblas_saxpby(N,vals,@a[0],1,vals2,@c[0],1);
    //for i:=0 to High(a) do
    //  c[i]:=vals*a[i]+vals2*b[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAXPBY_s(@d[0],@a[0],@d[0],N,@vals,@vals2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : AXPBY a * Vector + b * Vector',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_dotpr(@a[0],1,@b[0],1,@s1,N);
    {$else}
    s1:=cblas_sdot(N,@a[0],1,@b[0],1);
    //s1:=0;
    //for i:=0 to High(a) do
    //  s1+=a[i]*b[i] ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    s2:=bulkDot_s(@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr(format('SINGLE : Vector DOT Vector',[s1,s2]),t2/t3,a.Count,t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_dotpr(@a[0],1,@b[0],F,@s1,N div F);
    {$else}
    s1:=cblas_sdot(n div F,@a[0],1,@b[0],F);
    //s1:=0;
    //for i:=0 to N div F-1 do
    //  s1+=a[i]*b[i*F] ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    s2:=bulkDot_s(@a[0],@b[0],F,N div F);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr(format('SINGLE : Vector DOT Strided Vector',[s1,s2]),t2/t3,N div F,t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=Sqr(a[i]-b[i]) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiffSqr_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : (Vector - Vector)^2',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=Sqr(a[i]-vals) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiffSqr_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : (Scalar - Vector)^2',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsq(@a[0],1,@c[0],1,N);
    {$else}
    for i:=0 to High(a) do
      c[i]:=Sqr(a[i]) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSqr_s(@d[0],@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector^2',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=Sqrt(a[i]*a[i]) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSqr_s(@d[0],@a[0],N);
    bulkSqrt_s(@d[0],@d[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector^0.5',t2/t3,a.Count,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N div F -1 do
      c[i]:=a[i*F] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkGathera_s(@d[0],@a[0],F,N div F);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Gather',t2/t3,N div F,t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[i]+bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_ccs(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector + ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[i]-bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_ccs(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector - ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[i]*bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_ccs(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector * ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[i]/bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_ccs(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector / ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[0]+bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_css(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : Complex + ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[0]-bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_css(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : Complex - ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[0]*bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_css(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : Complex * ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    ac:=TComplexArrayF(a);bc:=TComplexArrayF(b);cc:=TComplexArrayF(c);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[0]/bc[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_css(@d[0],@ac[0],@bc[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : Complex / ZVector',t2/t3,2*(N div 2),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cc[i]:=ac[i]*b[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_cvs(@d[0],@b[0],@ac[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector * Vector',t2/t3,2*(N div 2),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    zs1:=0;
    for i:=0 to N div 2 -1 do
      zs1.add(ac[i]*b[i]);
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDot_cvs(@zs2,@b[0],@ac[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector Dot Vector',t2/t3,N div 2,t2,t3,zs1,zs2);

    t1:=HighResTimer.NanoSeconds;
    zs1:=0;
    for i:=0 to N div 2 -1 do
      zs1.add(ac[i]*bc[i]);
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDot_ccs(@zs2,@bc[0],@ac[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : ZVector Dot ZVector',t2/t3,N div 2,t2,t3,zs1,zs2);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N div 2 -1 do
      c[i]:=ac[i].mag;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMag_cs(@d[0],@ac[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE Complex : Mag(ZVector)',t2/t3,N div 2,t2,t3,c,d);



        //c.fill(0);d.fill(0);
        t1:=HighResTimer.NanoSeconds;
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_conv(@a[0],1,@b[0],1,@c[0],1,N,F);
        {$else}
        for i:=0 to N -F do
          c[i]:=a[i]*b[0];
        for j:=1 to F-1 do
          for i:=0 to N -F do
            c[i]:=c[i]+a[i+j]*b[j];
        {$endif}
        //bulkConv_s(@c[0],@a[0],@b[0],N -5,5);
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        bulkConv_s(@d[0],@a[0],@b[0],N,F);
        //vDSP_conv(@a[0],1,@b[0],1,@d[0],1,N -15,15);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('SINGLE Convolution : Conv(Vector, Vector)',t2/t3,N-F+1,t2,t3,c,d);

        t1:=HighResTimer.NanoSeconds;
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_imgfir(@a[0],W,W,@b[0],@c[0],F,F);
        {$else}
        FillDWord(c[0],W*W,0);
        for y:=0 to W-F do
          for i:=0 to F-1 do
            for j:=0 to F-1 do
              for k:=0 to W -F do
                c[(y+(F-1) div 2)*W+(F-1) div 2 + k]:=c[(y+(F-1) div 2)*W+(F-1) div 2 + k]+a[y*W+i*W + k+j]*b[i*F + j];
        {$endif}
        //bulkConv_s(@c[0],@a[0],@b[0],N -15,15);
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        FillDWord(d[0],W*W,0);
        bulkConv2d_s(@d[0],@a[0],@b[0],W,W,F,F);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('SINGLE Convolution 2D : Conv2D(Vector, Vector)',t2/t3,w*w,t2,t3,c,d);

        t1:=HighResTimer.NanoSeconds;
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_mtrans(@a[0],1,@c[0],1,w,w);
        {$else}
        for i:=0 to w-1 do
          for j:=0 to w-1 do
            c[j*w+i]:=a[i*w+j];
        {$endif}
        //for i:=0 to w-1 do
        //  bulkGathera_s(@c[i*w],@a[i],w,w);
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        for i:=0 to w-1 do
          bulkGathera_s(@d[i*w],@a[i],w,w);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('SINGLE Transpose : Transpose(Matrix)',t2/t3,N div 2,t2,t3,c,d);


        t1:=HighResTimer.NanoSeconds;
        //FillDWord(c[0],w*w,0);
        //c.fill(0.0,0.0);
        //TSingles.gemm_nn(w,w,w,1,@a[0],w,@b[0],w,@c[0],w);
        //vDSP_mmul(@a[0],1,@b[0],1,@c[0],1,w,w,w);
        cblas_sgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,w,w,w,1,@a[0],w,@b[0],w,0,@c[0],w);
        //for y:=0 to w-1 do
        //  for i:=0 to w-1 do begin
        //    s1:=a[y*w+i];
        //    for x:=0 to w-1 do
        //    //begin
        //      //c[y*w+x]:=0;
        //        c[y*w+x]:=c[y*w+x]+s1*b[i*w+x]
        //    end;
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        FillDWord(d[0],w*w,0);
        //d.fill(0.0,0.0);
//        for i:=0 to 1000 do
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_mmul(@a[0],1,@b[0],1,@d[0],1,w,w,w);
        {$else}
        TSingles.gemm_nn(w,w,w,1,@a[0],w,@b[0],w,@d[0],w);
        {$endif}
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('SINGLE GEMM: GEMM(Matrix, Matrix)',t2/t3,w*w,t2,t3,c,d);

// Test Double Operations ************************

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N-1 do
      cd[i]:=ad[i]+bd[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_d(@dd[0],@ad[0],@bd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Vector + Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=ad[i]-bd[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_d(@dd[0],@ad[0],@bd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Vector - Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=ad[i]*bd[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_d(@dd[0],@ad[0],@bd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Vector * Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=ad[i]/bd[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_d(@dd[0],@ad[0],@bd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Vector / Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=ad[i]+vald;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_sd(@dd[0],@ad[0],@vald,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Scalar + Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=vald - ad[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_sd(@dd[0],@ad[0],@vald,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Scalar - Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=ad[i]*vald;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_sd(@dd[0],@ad[0],@vald,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Scalar * Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=vald / ad[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_sd(@dd[0],@ad[0],@vald,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Scalar / Vector',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    d1:= MaxValue(ad) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMax_d(@d2,@ad[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Max(Vector)',t2/t3,ad.Count,t2,t3,d1,d2);

    t1:=HighResTimer.NanoSeconds;
    d1:= MinValue(ad) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMin_d(@d2,@ad[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Min(Vector)',t2/t3,ad.Count,t2,t3,d1,d2);

    t1:=HighResTimer.NanoSeconds;
    //d1:=0;
    //for i:=0 to N-1 do
    //  d1:=d1+ad[i];
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_svemgD(@ad[0],1,@d1,N);
    {$else}
    d1:=cblas_dasum(N,@ad[0],1) ;//Sum(ad) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSumAbs_d(@d2,@ad[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Sum(Abs(Vector))',t2/t3,ad.Count,t2,t3,d1,d2);

    t1:=HighResTimer.NanoSeconds;
    d1:= SumOfSquares(ad) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSumSqr_d(@d2,@ad[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Sum(Vector^2)',t2/t3,ad.Count,t2,t3,d1,d2);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N-1 do
      cd[i]:=abs(ad[i])  ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAbs_d(@dd[0],@ad[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Abs(Vector)',t2/t3,a.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsmaD(@ad[0],1,@vald,@cd[0],1,@cd[0],1,N);
    {$else}
    cblas_daxpy(N,vald,@ad[0],1,@cd[0],1);
    //for i:=0 to High(ad) do
    //  cd[i]:=vald*ad[i]+bd[i] ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAXPY_d(@dd[0],@ad[0],@dd[0],N,@vald);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : AXPY (a * Vector + Vector)',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N-1 do
      cd[i]:=vald*ad[i]+vald2*bd[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAXPBY_d(@dd[0],@ad[0],@bd[0],N,@vald,@vald2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : AXPBY (a * Vector + b * Vector)',t2/t3,a.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_dotprD(@ad[0],1,@bd[0],1,@d1,N);
    {$else}
    d1:=0;
    d1:=cblas_ddot(N,@ad[0],1,@bd[0],1);
    //for i:=0 to High(ad) do
    //  d1+=ad[i]*bd[i] ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    d2:=bulkDot_d(@ad[0],@bd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr(format('DOUBLE : Vector DOT Vector',[d1,d2]),t2/t3,ad.Count,t2,t3,d1,d2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_dotprD(@ad[0],1,@bd[0],F,@d1,N div F);
    {$else}
    d1:=0;
    for i:=0 to N div F-1 do
      d1+=ad[i]*bd[i*F] ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    d2:=bulkDot_d(@ad[0],@bd[0],F,N div F);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr(format('DOUBLE : Vector DOT Strided Vector',[d1,d2]),t2/t3,N div F,t2,t3,d1,d2);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=Sqr(ad[i]-bd[i]) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiffSqr_d(@dd[0],@ad[0],@bd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : (Vector - Vector)^2',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=Sqr(ad[i]-vald) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiffSqr_sd(@dd[0],@ad[0],@vald,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : (Scalar - Vector)^2',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=Sqr(ad[i]) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSqr_d(@dd[0],@ad[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Vector^2',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(ad) do
      cd[i]:=Sqrt(ad[i]*ad[i]) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSqr_d(@dd[0],@ad[0],N);
    bulkSqrt_d(@dd[0],@dd[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Vector^0.5',t2/t3,ad.Count,t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N div F -1 do
      cd[i]:=ad[i*F] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkGathera_d(@dd[0],@ad[0],F,N div F);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE : Gather',t2/t3,N div F,t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[i]+bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_ccd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector + ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[i]-bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_ccd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector - ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[i]*bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_ccd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector * ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[i]/bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_ccd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector / ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[0]+bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_csd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : Complex + ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[0]-bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_csd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : Complex - ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);


    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[0]*bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_csd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : Complex * ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    az:=TComplexArrayD(ad);bz:=TComplexArrayD(bd);cz:=TComplexArrayD(cd);
    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[0]/bz[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_csd(@dd[0],@az[0],@bz[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : Complex / ZVector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to (N div 2)-1 do
      cz[i]:=az[i]*bd[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_cvd(@dd[0],@bd[0],@az[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector * Vector',t2/t3,2*(N div 2),t2,t3,cd,dd);

    t1:=HighResTimer.NanoSeconds;
    zd1:=0;
    for i:=0 to N div 2 -1 do
      zd1.add(az[i]*bd[i]);
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDot_cvd(@zd2,@bd[0],@az[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector Dot Vector',t2/t3,N div 2,t2,t3,zd1,zd2);

    t1:=HighResTimer.NanoSeconds;
    zd1:=0;
    for i:=0 to N div 2 -1 do
      zd1.add(az[i]*bz[i]);
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDot_ccd(@zd2,@bz[0],@az[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : ZVector Dot ZVector',t2/t3,N div 2,t2,t3,zd1,zd2);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to N div 2 -1 do
      cd[i]:=az[i].mag;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMag_cd(@dd[0],@az[0],N div 2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('DOUBLE Complex : Mag(ZVector)',t2/t3,N div 2,t2,t3,cd,dd);

        //cd.fill(0);dd.fill(0);
        t1:=HighResTimer.NanoSeconds;
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_convD(@ad[0],1,@bd[0],1,@cd[0],1,N,F);
        {$else}
        for i:=0 to N -F do
          cd[i]:=ad[i]*bd[0];
        for j:=1 to F-1 do
          for i:=0 to N -F do
            cd[i]:=cd[i]+ad[i+j]*bd[j];
        {$endif}
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        bulkConv_d(@dd[0],@ad[0],@bd[0],N,F);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('DOUBLE Convolution : Conv(Vector, Vector)',t2/t3,N-F,t2,t3,cd,dd);
        t1:=HighResTimer.NanoSeconds;
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_imgfirD(@ad[0],W,W,@bd[0],@cd[0],F,F);
        {$else}
        FillQWord(cd[0],W*W,0);
        for y:=0 to W-F do
          for i:=0 to F-1 do
            for j:=0 to F-1 do
              for k:=0 to W -F do
                cd[(y+(F-1) div 2)*W+(F-1) div 2 + k]:=cd[(y+(F-1) div 2)*W+(F-1) div 2 + k]+ad[y*W+i*W + k+j]*bd[i*F + j];
        {$endif}
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        FillQWord(dd[0],W*W,0);
        bulkConv2d_d(@dd[0],@ad[0],@bd[0],W,W,F,F);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('DOUBLE Convolution 2D : Conv2D(Vector, Vector)',t2/t3,w*w,t2,t3,cd,dd);



        t1:=HighResTimer.NanoSeconds;
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_mtransD(@ad[0],1,@cd[0],1,w,w);
        {$else}
        for i:=0 to w-1 do
          for j:=0 to w-1 do
            cd[j*w+i]:=ad[i*w+j];
        {$endif}
        //for i:=0 to w-1 do
        //  bulkGathera_s(@c[i*w],@a[i],w,w);
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        for i:=0 to w-1 do
          bulkGathera_d(@dd[i*w],@ad[i],w,w);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('DOUBLE Transpose : Transpose(Matrix)',t2/t3,N div 2,t2,t3,cd,dd);


        t1:=HighResTimer.NanoSeconds;
        //FillDWord(c[0],w*w,0);
        //c.fill(0.0,0.0);
        //TSingles.gemm_nn(w,w,w,1,@a[0],w,@b[0],w,@c[0],w);
        //vDSP_mmul(@a[0],1,@b[0],1,@c[0],1,w,w,w);
        cblas_dgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,w,w,w,1,@ad[0],w,@bd[0],w,1,@cd[0],w);
        //for y:=0 to w-1 do
        //  for i:=0 to w-1 do begin
        //    d1:=ad[y*w+i];
        //    for x:=0 to w-1 do
        //    //begin
        //      //cd[y*w+x]:=0;
        //        cd[y*w+x]:=cd[y*w+x]+d1*bd[i*w+x]
        //    end;
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        //FillDWord(dd[0],w*w,0);
        //d.fill(0.0,0.0);
//        for i:=0 to 1000 do
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_mmulD(@ad[0],1,@bd[0],1,@dd[0],1,w,w,w);
        {$else}
        TDoubles.gemm_nn(w,w,w,1,@ad[0],w,@bd[0],w,@dd[0],w);
        {$endif}
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('DOUBLE GEMM: GEMM(Matrix, Matrix)',t2/t3,w*w,t2,t3,cd,dd);

     *)
     {$endif}
     t1:=HighResTimer.NanoSeconds;
     j:=ord(ad.isSorted());
     t2:=HighResTimer.NanoSeconds-t1;
     result+=logstr('DOUBLE isSorted',99,N,j,t2,ad,ad);

     ad.sort();
     t1:=HighResTimer.NanoSeconds;
     j:=ord(ad.isSorted());
     t2:=HighResTimer.NanoSeconds-t1;
     result+=logstr('DOUBLE isSorted',99,N,j,t2,ad,ad);



end;



initialization

//{$ifdef USE_AVX2}
//
//  bulkAdd_s   :=oprs_simd.bulkAdd_s        ;
//  bulkAdd_d   :=oprs_simd.bulkAdd_d        ;
//  bulkAdd_ss  :=oprs_simd.bulkAdd_ss       ;
//  bulkAdd_sd  :=oprs_simd.bulkAdd_sd       ;
//  bulkSub_s   :=oprs_simd.bulkSub_s        ;
//  bulkSub_d   :=oprs_simd.bulkSub_d        ;
//  bulkSub_ss  :=oprs_simd.bulkSub_ss       ;
//  bulkSub_sd  :=oprs_simd.bulkSub_sd       ;
//  bulkMul_s   :=oprs_simd.bulkMul_s        ;
//  bulkMul_d   :=oprs_simd.bulkMul_d        ;
//  bulkMul_ss  :=oprs_simd.bulkMul_ss       ;
//  bulkMul_sd  :=oprs_simd.bulkMul_sd       ;
//  bulkDiv_s   :=oprs_simd.bulkDiv_s        ;
//  bulkDiv_d   :=oprs_simd.bulkDiv_d        ;
//  bulkDiv_ss  :=oprs_simd.bulkDiv_ss       ;
//  bulkDiv_sd  :=oprs_simd.bulkDiv_sd       ;
//  bulkDot_s   :=oprs_simd.bulkDot_s        ;
//  bulkDot_d   :=oprs_simd.bulkDot_d        ;
//  interleave_s:=oprs_simd.interleave_s     ;
//  interleave_d:=oprs_simd.interleave_d     ;
//
//{$endif}


end.

