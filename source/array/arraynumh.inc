type
{ TNumberArrayHelper }

 TNumberArrayHelper = type helper for TNumberDynArray
 type
   PType=^TType;
   TType=Number;
   PNumber=^Number;
   //TCompareFuncNumber={$ifdef fpc}specialize{$endif} TCompareFunc<Number>;
 private
   procedure SetCount(AValue: integer);
  public
   function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<Number>;const init:Number=0):Number;_inline  overload;
   function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Number>):Number; _inline               overload;
   function GetCount:Integer; _inline
   function Sort(const Descending:boolean=false; const CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<Number> = nil):TNumberDynArray; _inline
   function Sorted(const Descending:boolean=false; const CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<Number> = nil):TNumberDynArray;  _inline
   function isSorted(const descending:boolean=false;  CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<Number> = nil):boolean;
   function Lookup(const val:Number):integer;
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<Number>):TNumberDynArray;  _inline          overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<Number>):TNumberDynArray;  _inline    overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<Number>):TNumberDynArray;  _inline    overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallbackVar<Number>):TVariantArray;_inline           overload;
   function Map(const a,b,a1,b1:Number):TNumberDynArray; _inline                         overload;
   function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>):TNumberDynArray;  _inline
   function Unique():TNumberDynArray;_inline
   function toDoubleArray:TDoubleDynArray;
   function indexOf(const val: Number): integer;  _inline
   // some math (haitham)
   class function uniform(const vCount:integer;const maxVal:Number=100;const minVal:Number=0):TNumberDynArray;static;  _inline   overload;
   function uniform(const maxVal:Number;const minVal:Number):TNumberDynArray;  _inline                                           overload;
   class function normal(const vCount: integer;const vMean, vStdDiv: Single): TNumberDynArray; static;  _inline                  overload;
   function normal(const vMean,vStdDiv:single):TNumberDynArray;  _inline                                                         overload;
   class function fill(const vCount:Integer;val:Number;const interval:Number): TNumberDynArray; static;  _inline                 overload;
   function fill(val:Number;const interval:Number=0): TNumberDynArray; _inline                                                   overload;
   function Abs():TNumberDynArray;
   function Magnitude(): Single; _inline
   function SumOfSquares(): Int64;  _inline
   function product:Int64;  _inline
   function Sum():Int64;  {_inline } overload;
   function Mean():single;   _inline
   function Mode():single;   _inline
   function Median():Single;  _inline
   function Variance:single;  _inline
   function StdDev: single;  _inline
   function Factorial:TNumberDynArray; _inline
   // heap operations are costy, use them carfully
   function Push(v:Number):Number; _inline
   function Pop():Number;   _inline
   function UnShift(v:Number):Number; _inline
   function Shift():Number;  _inline
   function Slice(start,_end:integer):TNumberDynArray;   _inline
   function Splice(start,deleteCount:integer;Items:TNumberDynArray):TNumberDynArray; _inline
   function Extract(const Indecies:TIntegerDynArray):TNumberDynArray; _inline
   procedure Scatter(const indecies:TIntegerDynArray;const Values:TNumberDynArray);                                   _inline
   function Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<Number>):TIntegerDynArray;           _inline   overload;
   function Find(const values:TNumberDynArray):TIntegerDynArray;                                                      _inline   overload;
   function Find(const value:Number):TIntegerDynArray;                                                                _inline   overload;
   function Intersect(const Other:TNumberDynArray;const binSearch:boolean=false):TNumberDynArray;
   function Difference(const Other:TNumberDynArray;const binSearch:boolean=false):TNumberDynArray;

   function concat(Items:TNumberDynArray):TNumberDynArray;   _inline
   function ToString(const Seperator: string=', '):string;   _inline
   function ToStringArray():TStringArray;   _inline
   property Count:integer read GetCount write SetCount;
   function as2d(const Columns:integer;Transposed:boolean=true):TNumberArrayArray; _inline
   function Transpose(const Width:integer; Height:integer=0):TNumberDynArray;  _inline  overload;
   function Add(const Vals:TNumberDynArray):TNumberDynArray;                _inline  overload;
   function Add(const Vals:Number):TNumberDynArray;                         _inline  overload;
   function Sub(const Vals:TNumberDynArray):TNumberDynArray;                _inline  overload;
   function Sub(const Vals:Number):TNumberDynArray;                         _inline  overload;
   function Mul(const Vals:TNumberDynArray):TNumberDynArray;                _inline  overload;
   function Mul(const Vals:Number):TNumberDynArray;                         _inline  overload;
   function &Div(const Vals:TNumberDynArray):TNumberDynArray;               _inline  overload;
   function &Div(const Vals:Number):TNumberDynArray;                        _inline  overload;
   function SubstractFrom(const Vals:TNumberDynArray):TNumberDynArray;      _inline  overload;
   function SubstractFrom(const Vals:Number):TNumberDynArray;               _inline  overload;
   function DividedBy(const Vals:TNumberDynArray):TNumberDynArray;          _inline  overload;
   function DividedBy(const Vals:Number):TNumberDynArray;                   _inline  overload;
   function Dot(const Vals:TNumberDynArray):Number;
   function Max():Number; { _inline}                                                overload;
   function Min():Number; { _inline}                                                overload;
   function Max(const Val:Number):TNumberDynArray;  _inline                       overload;
   function Min(const Val:number):TNumberDynArray;  _inline                       overload;
   function Max(const Vals:TNumberDynArray):TNumberDynArray;  _inline             overload;
   function Min(const Vals:TNumberDynArray):TNumberDynArray;  _inline             overload;
   function Clamp(const minVal,maxVal:Number):TNumberDynArray;  _inline
   function reverse():TNumberDynArray;
   function argMax():Integer;
   function argMin():Integer;
   procedure MinMax(out Mi:Number;out Ma:Number);
   function &shr(const aShift:integer):TNumberDynArray;
   function &shl(const aShift:integer):TNumberDynArray;
   class function Sum(const a:PNumber;const aCount:integer):Int64;                      static;_inline overload;
   class function Min(const a:PNumber;const aCount:integer):Int64;                      static;_inline overload;
   class function Max(const a:PNumber;const aCount:integer):Int64;                      static;_inline overload;
   class procedure BitShr(const dst,a:PNumber;const ashift, aCount:integer);                static;_inline overload;
   class procedure BitShl(const dst,a:PNumber;const ashift, aCount:integer);                static;_inline overload;
   class procedure BitOr(const dst,a,b:PNumber;const aCount:integer);                   static;_inline overload;
   class procedure BitAnd(const dst,a,b:PNumber;const aCount:integer);                  static;_inline overload;
   class procedure BitXor(const dst,a,b:PNumber;const aCount:integer);                  static;_inline overload;
   class procedure BitXor(const dst,a:PNumber;const b:Number;const aCount:integer);      static;_inline overload;
   class procedure BitNot(const dst,a:PNumber;const aCount:integer);                  static;_inline overload;
   class procedure Add(const dst,a,b:PNumber;const aCount:integer);                     static;_inline overload;
   class procedure Sub(const dst,a,b:PNumber;const aCount:integer);                     static;_inline overload;
   class procedure Mul(const dst,a,b:PNumber;const aCount:integer);                     static;_inline overload;
   class procedure &Div(const dst,a,b:PNumber;const aCount:integer);                    static;_inline overload;
   class procedure Add(const dst,a:PNumber;const b:Number;const aCount:integer);       static;_inline overload;
   class procedure Sub(const dst,a:PNumber;const b:Number;const aCount:integer);       static;_inline overload;
   class procedure Mul(const dst,a:PNumber;const b:Number;const aCount:integer);       static;_inline overload;
   class procedure &Div(const dst,a:PNumber;const b:Number;const aCount:integer);      static;_inline overload;
   class function Dot(const a,b:PNumber;const aCount:integer):Int64;                    static;_inline overload;
   class procedure Abs(const dst,a:PNumber;const aCount:integer);                     static;_inline overload;
   class procedure Conv1D(const dst,a,krn:PNumber;const aCount,krnSize:integer;const aStride:integer=1);  static;_inline overload;
   class function Every(const dst:PNumber; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>):boolean;  static;_inline overload;
   class function Some(const dst:PNumber; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>):boolean;   static;_inline overload;
   class function cmp(const a, b: Number): Integer;static;
   class procedure Gather(const dst,Self:PNumber;const Stride, N:integer);            static;_inline overload;

 private
   class procedure QuickSort(var Arr: TNumberDynArray; const L, R: Longint;const Descending:boolean; const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<Number>); static;  _inline
   class function uniqueFilt(const a:Number;const i:integer;arr:PNumber):boolean;static;
 end;


 { TNumberArrayArrayHelper }

 TNumberArrayArrayHelper=type helper for TNumberArrayArray
 type
   //TCompareFuncNumberAA={$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray>;
   PNumberArray=^TNumberDynArray;
 private
   function GetCount: integer;     _inline
   procedure SetCount(AValue: integer);  _inline
 public
   function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TNumberDynArray>;const init:TNumberDynArray=nil):TNumberDynArray; _inline    overload;
   function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TNumberDynArray>):TNumberDynArray;   _inline                           overload;
   function Sort(const Descending:boolean=false; CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray> = nil):TNumberArrayArray;     _inline
   function Sorted(const Descending:boolean=false; CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray> = nil):TNumberArrayArray;   _inline
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TNumberDynArray>):TNumberArrayArray;     _inline                        overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TNumberDynArray>):TNumberArrayArray;    _inline                   overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TNumberDynArray>):TNumberArrayArray;    _inline                   overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallbackVar<TNumberDynArray>):TVariantArray;     _inline                         overload;
   function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TNumberDynArray,PNumberArray>):TNumberArrayArray;   _inline
   function Unique():TNumberArrayArray;_inline
   property Count:integer read GetCount write SetCount;
   function Transpose: TNumberArrayArray;
   // heap operations are costy use carfully
   function Push(v:TNumberDynArray):TNumberDynArray;  _inline
   function Pop():TNumberDynArray;           _inline
   function UnShift(v:TNumberDynArray):TNumberDynArray;    _inline
   function Shift():TNumberDynArray;               _inline
   function Slice(start,_end:integer):TNumberArrayArray;    _inline
   function Splice(start,deleteCount:integer;Items:TNumberArrayArray):TNumberArrayArray;   _inline
   function concat(Items:TNumberArrayArray):TNumberArrayArray;     _inline
   function ToString(const Seperator: string=', '): string;     _inline
   class function cmp(const a, b: TNumberDynArray): integer;static;
 private
   class procedure QuickSort(var Arr: TNumberArrayArray; const L, R: Longint;const Descending:boolean; const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray>); static;  _inline
   class function uniqueFilt(const a:TNumberDynArray;const i:integer;arr:PNumberArray):boolean;static;
 end;

{$ifdef fpc}
operator :=(const Arr:TNumberDynArray):string;  _inline
operator :=(const Arr:TNumberArrayArray):string;   _inline
operator+(const Arr, Arr2: TNumberDynArray): TNumberDynArray;   _inline
operator+(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;   _inline
operator+(const Arr: TNumberDynArray   ;   const v: Number): TNumberDynArray;  _inline
operator+(const Arr: TNumberArrayArray ;   const v: Number): TNumberArrayArray;  _inline
operator+(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;       _inline
operator+(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;    _inline

operator-(const Arr, Arr2: TNumberDynArray): TNumberDynArray;    _inline
operator-(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;   _inline
operator-(const Arr: TNumberDynArray; const v: Number): TNumberDynArray; _inline
operator-(const Arr: TNumberArrayArray; const v: Number): TNumberArrayArray; _inline
operator-(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;    _inline
operator-(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;   _inline

operator*(const Arr, Arr2: TNumberDynArray): TNumberDynArray;             _inline
operator*(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;           _inline
operator*(const Arr: TNumberDynArray; const v: Number): TNumberDynArray;   _inline
operator*(const Arr: TNumberArrayArray; const v: Number): TNumberArrayArray;   _inline
operator*(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;      _inline
operator*(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;    _inline

operator/(const Arr, Arr2: TNumberDynArray): TNumberDynArray;     _inline
operator/(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;   _inline
operator/(const Arr: TNumberDynArray; const v: Number): TNumberDynArray;   _inline
operator/(const Arr: TNumberArrayArray; const v: Number): TNumberArrayArray;    _inline
operator/(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;    _inline
operator/(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;    _inline
{$endif}
