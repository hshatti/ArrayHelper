type
{ TFloatArrayHelper }
TFloatArrayHelper = type helper for TFloatDynArray
 // type TCompareFuncFloat= {$ifdef fpc}specialize{$endif} TCompareFunc<Float> ;
type
  PType=^TType;
  TType=Float;
  PFloat=^Float;

private
type
  procedure SetCount(AValue: Integer);   _inline
public
type
  function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<Float>;const init:Float=0):Float;  _inline     overload;
  function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Float>):Float;  _inline                  overload;
  function GetCount:integer;_inline
  function Sort(const CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<Float> = nil):TFloatDynArray;  _inline
  function Sorted(const CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<Float> = nil):TFloatDynArray;  _inline
  function isSorted(const descending:boolean =false; CompareFunc: {$ifdef fpc}specialize{$endif} TCompareFunc<Float> = nil):boolean;
  function Lookup(const val:Float):integer;
  function Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<Float>): TFloatDynArray;   _inline          overload;
  function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<Float>):TFloatDynArray;  _inline       overload;
  function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<Float>):TFloatDynArray;  _inline       overload;
  function Map(proc: {$ifdef fpc}specialize{$endif} TSIMDMap<PFloat>): TFloatDynArray;      _inline          overload;
  function Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<Float>): TVariantArray;  _inline         overload;
  function Map(const a,b,a1,b1:Float):TFloatDynArray;               _inline                                  overload;
  //function Filter(func:{$ifdef fpc}specialize{$endif} TFilterFunc<Float>):TFloatDynArray;  _inline
  function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<Float,PFloat>):TFloatDynArray;  _inline
  function indexOf(const val: Float): integer;                _inline
  function normal(const vMean, vStdDiv: Float; scaleVal: Float=1 ): TFloatDynArray;  _inline                                overload;
  class function normal(const vMean, vStdDiv: Float; const Cnt: integer;scaleVal: Float=1): TFloatDynArray;static;  _inline overload;
  class function Uniform(const vCount: integer;const maxVal:Float;const minVal:Float): TFloatDynArray; static;    _inline   overload;
  function Uniform(const maxVal: Float=1;const minVal:Float=0): TFloatDynArray;  _inline                                    overload;
  class function fill(const vCount:Integer;Value:Float;const interval:Float;const vStdDev:Float=0): TFloatDynArray; static;  _inline  overload;
  function fill(Value:Float;const interval:Float=0;const vStdDev:Float=0): TFloatDynArray; _inline                                    overload;
  class function polynomial(const vCount:integer;const coef:TFloatDynArray;const vStdDev:Float=0;const xInterval:Float=1):TFloatDynArray;static;_inline
  function Magnitude(): Float;  _inline
  function SumOfSquares(): Float;  _inline
  function Product():Extended;    _inline
  function Round():TIntegerDynArray; _inline
  procedure MinMax(out mi:Float;out ma:Float); _inline
  function Mean():Float;     _inline
  function Mode():Float;     _inline
  function Median():Float;    _inline
  function Interleave():TFloatArrayArray;_inline
  function fft():TComplexArray;                                       overload;
  function ifft():TComplexArray;                                      overload;
  function fft(const plan: TComplexArrayArray; const l: integer=0): TComplexArray; overload;
  function ifft(const plan: TComplexArrayArray; const l:integer=0): TComplexArray;overload;
  function dft:TComplexArray;                                                     overload;
  function dft(const Plan: TComplexArray): TComplexArray;                    overload;
  function Variance():Float;   _inline
  function Covariance(const vals:TFloatDynArray):Float;
  function Correlation(const vals:TFloatDynArray):Float;
  function SqrDiff(const Vals:TFloatDynArray):TFloatDynArray;overload;   _inline
  function SqrDiff(const Val:Float):TFloatDynArray;          overload;   _inline
  function StdDev():Float;        _inline
  function Ceil(): TIntegerDynArray;
  function Floor(): TIntegerDynArray;
  function Frac(): TFloatDynArray;
  function Trunc(): TIntegerDynArray;
  function Sqr():TFloatDynArray;                _inline  overload;
  function Sqrt():TFloatDynArray;                _inline overload;
  function Exp():TFloatDynArray;  _inline
  function Sin(const amplitude:Float=1):TFloatDynArray;                _inline
  function Cos(const amplitude:Float=1):TFloatDynArray;                _inline
  function Log10():TFloatDynArray;              _inline
  function Log2():TFloatDynArray;              _inline
  function LogN(base:Float):TFloatDynArray;      _inline
  function Ln():TFloatDynArray;                 _inline
  property Count:Integer read GetCount write SetCount;
  function unique():TFloatDynArray; _inline
  function Add(const Vals:TFloatDynArray):TFloatDynArray;                {_inline }  overload;
  function Add(const Vals:Float):TFloatDynArray;                         {_inline }  overload;
  function Sub(const Vals:TFloatDynArray):TFloatDynArray;                {_inline }  overload;
  function Sub( Vals:Float):TFloatDynArray;                              {_inline }  overload;
  function Mul(const Vals:TFloatDynArray):TFloatDynArray;                {_inline }  overload;
  function Mul(const Vals:Float):TFloatDynArray;                         {_inline }  overload;
  function &Div(const Vals:TFloatDynArray):TFloatDynArray;               {_inline }  overload;
  function &Div( Vals:Float):TFloatDynArray;                             {_inline }  overload;
  function SubstractFrom(const Vals:TFloatDynArray):TFloatDynArray;      {_inline }  overload;
  function SubstractFrom(const Vals:Float):TFloatDynArray;               {_inline }  overload;
  function DividedBy(const Vals:TFloatDynArray):TFloatDynArray;          {_inline }  overload;
  function DividedBy(const Vals:Float):TFloatDynArray;                   {_inline }  overload;
  function Dot(const Vals:TFloatDynArray):Float;                         _inline   overload;
  function CrossEntropy(const Vals:TFloatDynArray):Float;                _inline
  function Sum():Float;        _inline
  function Max():Float;        _inline                                            overload;
  function Min():Float;      _inline                                              overload;
  function Max(const val:Float):TFloatDynArray;      _inline                      overload;
  function Min(const Val:Float):TFloatDynArray;      _inline                      overload;
  function Max(const vals:TFloatDynArray):TFloatDynArray;      _inline            overload;
  function Min(const Vals:TFloatDynArray):TFloatDynArray;      _inline            overload;
  function Clamp(const minVal,maxVal:Float):TFloatDynArray;  _inline
  function as2D(const columns:integer;const Transposed:boolean=true):TFloatArrayArray;_inline
  function reverse():TFloatDynArray;
  function argMax():Integer;
  function argMin():Integer;
  function Abs():TFloatDynArray;
  function SumOfAbs():Float;
  function Normalize(const AMax:Float=1;const AMin:Float=0):TFloatDynArray;
  // heap operations are costy use carfully
  function Conj():TFloatDynArray;   _inline //Dummy Function for matrix Inverse compatability

  function Push(v:Float):Float;    _inline
  function Pop():Float;        _inline
  function UnShift(v:Float):Float;  _inline
  function Shift():Float;     _inline
  function Slice(start,_end:integer):TFloatDynArray;  _inline
  function Splice(start,deleteCount:integer;Items:TFloatDynArray):TFloatDynArray; _inline
  function Extract(const Indecies:TIntegerDynArray):TFloatDynArray; _inline
  procedure Scatter(const indecies:TIntegerDynArray;const Values:TFloatDynArray); _inline
  function Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<Float>):TIntegerDynArray;     overload;
  function Find(const values:TFloatDynArray):TIntegerDynArray;                                                overload;
  function Find(const value:Float):TIntegerDynArray;                                                          overload;
  function Intersect(const Other:TFloatDynArray;const binSearch:boolean=false):TFloatDynArray;
  function Difference(const Other:TFloatDynArray;const binSearch:boolean=false):TFloatDynArray;

  function concat(Items:TFloatDynArray):TFloatDynArray; _inline
  function ToString(const Seperator: string=', ';const digits:ShortInt=-1):string;
  function ToStringArray():TStringArray;_inline
  function ToSingles():TSingleDynArray;
  function ToDoubles():TDoubleDynArray;
  function Transpose(const Width:integer; Height:integer=0):TFloatDynArray; _inline overload;
  class function cmp(const a, b: Float): Integer; static; _inline
private
  class procedure QuickSort(var Arr: TFloatDynArray; const L, R: Longint; const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<Float>); static;  _inline
  class function uniqueFilt(const a:float;const i:integer;arr:PFloat):boolean; static;_inline
public
  class procedure gemm_nn(const M, N, K:integer; const ALPHA:Float; const A:PFloat; const lda:integer; const B:PFloat; const ldb:integer; const C:PFloat; const ldc:integer);                            static;
  class procedure gemm_nt(const M, N, K:integer; const ALPHA:Float; const A:PFloat; const lda:integer; const B:PFloat; const ldb:integer; const C:PFloat; const ldc:integer);                            static;
  class procedure gemm_tn(const M, N, K:integer; const ALPHA:Float; const A:PFloat; const lda:integer; const B:PFloat; const ldb:integer; const C:PFloat; const ldc:integer);                            static;
  class procedure gemm_tt(const M, N, K:integer; const ALPHA:Float; const A:PFloat; const lda:integer; const B:PFloat; const ldb:integer; const C:PFloat;  const ldc:integer);                           static;
  class procedure gemm(const TA, TB, M, N, K:integer; const ALPHA:Float; const A:PFloat; const lda:integer; const B:PFloat; const ldb:integer; const BETA:Float; const C: PFloat; const ldc:integer);    static;

  class function Dot(a,b:PFloat;const N:integer{$ifndef USE_AVX2};const Stride:integer=1{$endif}):Float;    static;_inline overload;
  class procedure Add(const result:PFloat ;const N:integer;const Self,Vals:PFloat);                          static;overload;
  class procedure Add(const result:PFloat ;const N:integer;const Self:PFloat;const Vals:Float);              static;overload;
  class procedure Sub(const result:PFloat ;const N:integer;const Self,Vals:PFloat);                          static;overload;
  class procedure Sub(const result:PFloat ;const N:integer;const Self:PFloat; Vals:Float);                   static;overload;
  class procedure Mul(const result:PFloat ;const N:integer;const Self,Vals:PFloat);                          static;overload;
  class procedure Mul(const result:PFloat ;const N:integer;const Self:PFloat;const Vals:Float);              static;overload;
  class procedure &Div(const result:PFloat;const N:integer ;const Self,Vals:PFloat);                         static;overload;
  class procedure &Div(const result:PFloat;const N:integer ;const Self:PFloat; Vals:Float);                  static;overload;
  class procedure SubstractFrom(const result:PFloat ;const N:integer ;const Self,Vals:PFloat);                static;overload;
  class procedure SubstractFrom(const result:PFloat ;const N:integer ;const Self:PFloat;const Vals:Float);    static;overload;
  class procedure DividedBy(const result:PFloat ;const N:integer ;const Self,Vals:PFloat);                    static;overload;
  class procedure DividedBy(const result:PFloat ;const N:integer ;const Self:PFloat;const Vals:Float);        static;overload;
  class procedure Sqrt(const src, result:PFloat;const N:integer );                                            static;_inline overload;
  class procedure Sqr(const src, result:PFloat;const N:integer );                                             static;_inline overload;
  class function FromIntegers(const Integers:TIntegerDynArray):TFloatDynarray;                            static;overload;
  class function FromIntegers(const Integers:TInt64Dynarray):TFloatDynarray;                              static;overload;
  class function FromIntegers(const Integers:TByteDynarray):TFloatDynarray;                               static;overload;
  class function FromIntegers(const Integers:TWordDynarray):TFloatDynarray;                               static;overload;
  class function FromIntegers(const Integers:TLongWordDynArray):TFloatDynarray;                           static;overload;
  class function Every(const dst:PFloat; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Float,PFloat>):boolean;  static;_inline overload;
  class function Some(const dst:PFloat; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Float,PFloat>):boolean;   static;_inline overload;
  class procedure Conj(const result:PFloat;const N:integer ;const Self:PFloat);  static; _inline //Dummy Function for complex matrix Inverse compatability
  class procedure Gather(const dst,Self:PFloat;const Stride, N:integer);                                  static;_inline overload;

end;


  { TFloatArrayArrayHelper }

TFloatArrayArrayHelper=type helper for TFloatArrayArray
//type TCompareFuncFloatAA={$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray>;
type
  PType=^TType;
  TType=TFloatDynArray;
  PFloatDynArray=^TFloatDynArray ;
private
   function GetCount: integer; _inline
   procedure SetCount(AValue: integer);   _inline
public
   function reduce(func:{$ifdef fpc}specialize{$endif} TReduceCallback<TFloatDynArray>;const init:TFloatDynArray=nil):TFloatDynArray; _inline  overload;
   function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TFloatDynArray>):TFloatDynArray; _inline                          overload;
   function Sort(CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray> = nil):TFloatArrayArray;    _inline
   function Sorted(CompareFunc:{$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray> = nil):TFloatArrayArray; _inline
   function Lookup(const val:TFloatDynArray):integer;
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<TFloatDynArray>):TFloatArrayArray;   _inline                                  overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<TFloatDynArray>):TFloatArrayArray;    _inline                           overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TFloatDynArray>):TFloatArrayArray;    _inline                           overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallbackVar<TFloatDynArray>):TVariantArray;   _inline                                  overload;
   function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<TFloatDynArray,PFloatDynArray>):TFloatArrayArray;    _inline
   //function Filter(func: {$ifdef fpc}specialize{$endif} TFilterFunc<TFloatDynArray>): TFloatArrayArray;_inline
   function Transpose: TFloatArrayArray;
   property Count:integer read GetCount write SetCount;
   // heap operations are costy use carfully
   function Push(v:TFloatDynArray):TFloatDynArray;    _inline
   function Pop():TFloatDynArray;      _inline
   function UnShift(v:TFloatDynArray):TFloatDynArray;   _inline
   function Shift():TFloatDynArray;      _inline
   function Slice(start,_end:integer):TFloatArrayArray;    _inline
   function Splice(start,deleteCount:integer;Items:TFloatArrayArray):TFloatArrayArray;  _inline
   function concat(Items:TFloatArrayArray):TFloatArrayArray;     _inline
   function ToString(const Seperator: string=', '): string;
   class function cmp(const a, b: TFloatDynArray): integer; static;_inline
   class function Every(const dst:PFloatDynArray; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<TFloatDynArray,PFloatDynArray>):boolean; static;_inline overload;
   class function Some(const dst:PFloatDynArray; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<TFloatDynArray,PFloatDynArray>):boolean;  static;_inline overload;

private
   class procedure QuickSort(var Arr: TFloatArrayArray; const L, R: Longint;const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray>); static;   _inline
   class function uniqueFilt(const a:TFloatDynArray;const i:integer;arr:PFloatDynArray):boolean;static; _inline
end;

{$ifdef fpc}
operator :=(const Arr:TFloatDynArray):string;                                 overload;//     _inline
operator :=(const Arr:TFloatArrayArray):string;                               overload;//      _inline
operator+(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                   overload;//      _inline
operator+(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;               overload;//         _inline
operator+(const Arr: TFloatDynArray    ;   const v: Float ): TFloatDynArray;  overload;// _inline
operator+(const Arr: TFloatArrayArray  ;   const v: Float ): TFloatArrayArray;overload;//  _inline
operator+(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;     overload;//_inline
operator+(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;   overload;//_inline
operator*(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                   overload;//  _inline
operator*(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;               overload;//     _inline
operator*(const Arr: TFloatDynArray; const v: Float): TFloatDynArray;         overload;//      _inline
operator*(const Arr: TFloatArrayArray; const v: Float): TFloatArrayArray;     overload;//       _inline
operator*(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;     overload;//_inline
operator*(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;   overload;//  _inline
operator/(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                   overload;//   _inline
operator/(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;               overload;//  _inline
operator/(const Arr: TFloatDynArray; const v: Float): TFloatDynArray;         overload;// _inline
operator/(const Arr: TFloatArrayArray; const v: Float): TFloatArrayArray;     overload;// _inline
operator/(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;     overload;// _inline
operator/(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;   overload;// _inline
operator-(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                   overload;// _inline
operator-(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;               overload;// _inline
operator-(const Arr: TFloatDynArray; const v: Float): TFloatDynArray;         overload;// _inline
operator-(const Arr: TFloatArrayArray; const v: Float): TFloatArrayArray;     overload;// _inline
operator-(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;     overload;// _inline
operator-(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;   overload;// _inline
{$endif}

(*
{$ifndef _ffth}
{$define _ffth}
procedure _dft(const dst:{$ifdef fpc}specialize{$endif}TComplex<Float>._Complex;const a:PFloat;const plan: TComplexArray; N:integer;const l:integer=0); _inline
procedure _fft(const dst:{$ifdef fpc}specialize{$endif}TComplex<Float>._Complex;const a:PFloat;const plan: PPComplex; N:integer;const l:integer=0); _inline
{$endif}
*)

