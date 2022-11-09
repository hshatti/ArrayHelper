{ TComplexArrayHelper }

 TComplexArrayHelper=type helper for TComplexArray
 type
   PType=^TType;
   TType=Complex;
   TCompareFuncComplex= {$ifdef fpc}specialize{$endif} TCompareFunc<Complex>;
 private
   function GetCount: integer;
   function GetImaginary: TFloatDynArray;
   function GetReal: TFloatDynArray;
   procedure SetCount(AValue: integer);
   procedure SetImaginary(AValue: TFloatDynArray);
   procedure SetReal(AValue: TFloatDynArray);
 public
   property Count:integer read GetCount write SetCount;
   function Filter(func:{$ifdef fpc}specialize{$endif} TFilterCallback<Complex,PComplex>):TComplexArray;    _inline
   function reduce(func:{$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Complex>):Complex;    _inline
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallback<complex>):TComplexArray;          _inline        overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallback<Complex>):TComplexArray;    _inline        overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackComplex<Complex>):TFloatDynArray; _inline  overload;
   function Map(func:{$ifdef fpc}specialize{$endif} TMapCallbackVar<Complex>):TVariantArray;       _inline        overload;
   function Sort(const Descending:boolean=false; CompareFunc: TCompareFuncComplex= nil):TComplexArray;            _inline
   function Sorted(const Descending:boolean=false; CompareFunc: TCompareFuncComplex= nil):TComplexArray;          _inline
   function Lookup(const val:Complex):integer;
   function Slice(start,_end:integer):TComplexArray;  _inline
   function Splice(start,deleteCount:integer;Items:TComplexArray):TComplexArray; _inline
   function Extract(const Indecies:TIntegerDynArray):TComplexArray; _inline
   procedure Scatter(const indecies:TIntegerDynArray;const Values:TComplexArray); _inline
   function IndexOf(const val: Complex): integer;_inline
   function Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<Complex>):TIntegerDynArray;     overload;
   function Find(const values:TComplexArray):TIntegerDynArray;                                                overload;
   function Find(const value:Complex):TIntegerDynArray;                                                          overload;
   function Intersect(const Other:TComplexArray;const binSearch:boolean=false):TComplexArray;
   function Difference(const Other:TComplexArray;const binSearch:boolean=false):TComplexArray;


   function add(const val:Float):TComplexArray;   _inline     overload;
   function sub(const val:Float):TComplexArray;   _inline     overload;
   function mul(const val:Float):TComplexArray;   _inline     overload;
   function &div(const val:Float):TComplexArray;   _inline     overload;
   function ElementSize:integer;
   function add(const val:complex):TComplexArray;  _inline     overload;
   function sub(const val:complex):TComplexArray;  _inline     overload;
   function mul(const val:complex):TComplexArray;  _inline     overload;
   function &div(const val:complex):TComplexArray; _inline     overload;
   function add(const val:TComplexArray):TComplexArray;  _inline     overload;
   function sub(const val:TComplexArray):TComplexArray;  _inline     overload;
   function mul(const val:TComplexArray):TComplexArray;  _inline     overload;
   function &div(const val:TComplexArray):TComplexArray; _inline     overload;
   function add(const val:TFloatDynArray):TComplexArray;  _inline     overload;
   function sub(const val:TFloatDynArray):TComplexArray;  _inline     overload;
   function mul(const val:TFloatDynArray):TComplexArray;  _inline     overload;
   function &div(const val:TFloatDynArray):TComplexArray; _inline     overload;
   function Split():TFloatArrayArray;
   function Mag():TFloatDynArray;                 _inline
   function abs():TFloatDynArray;                 _inline
   function ln():TComplexArray;                    _inline
   function exp():TComplexArray;                   _inline
   function Arg(): TFloatDynArray;                _inline
   function sqrt(): TComplexArray;                _inline
   function sqr(): TComplexArray;                _inline
   function conj(): TComplexArray;                _inline
   class procedure sqrt(const src, Result:PComplex;const N:integer); static;_inline  overload;
   class procedure sqr(const src, Result:PComplex;const N:integer);  static; _inline overload;
   class function PlanDFT(N: integer): TComplexArray;                      static;      overload;
   class procedure PlanDFT(var Plan:TFloatArrayArray;const N: integer);   static; overload;
   class function PlanFFT(N:integer):TComplexArrayArray;                   static; overload;
   class procedure PlanFFT(var plan:TFloatArrayArray;N:integer);               static; overload;
   class function PlanIFFT(N:integer):TComplexArrayArray;static;
   function fft():TComplexArray;                                                      overload;
   function fft(const plan: TComplexArrayArray; const l: integer): TComplexArray;     overload;
   function ifft():TComplexArray;                                                     overload;
   function ifft(const plan: TComplexArrayArray; const l: integer): TComplexArray;    overload;
   function dft():TComplexArray;                                overload;
   function dft(const Plan: TComplexArray): TComplexArray; overload;
   function bins(const SampleTime:Float):TFloatDynArray;    overload;
   function freq(const SampleRate:integer):TFloatDynArray;   overload;
   property Real:TFloatDynArray read GetReal write SetReal;
   property Imaginary:TFloatDynArray read GetImaginary write SetImaginary;
   function as2D(const Columns:integer;const Transposed:Boolean=true):{$ifdef fpc}specialize{$endif} TArray<TComplexArray>;_inline
   function Transpose(const Width:integer; Height:integer=0):TComplexArray; _inline overload;
   function interleave():TComplexArrayArray  ; _inline
   function Sum():Complex;
   function Product():Complex;
   function Dot(const Val:TComplexArray):Complex;
   class function Dot(const a,b:PComplex;N:Integer;bStride:integer=1):Complex;static;overload;
   function ToString():string;
   class function cmp(const a, b: Complex): integer; static;_inline
   class function fill(const vCount:integer; val:Complex; interval:Complex):TComplexArray;static;

   class procedure Add(const result:PComplex ;const N:integer;const Self,Vals:PComplex);                          static;_inline overload;
   class procedure Add(const result:PComplex ;const N:integer;const Self:PComplex;const Vals:Complex);            static;_inline overload;
   class procedure Sub(const result:PComplex ;const N:integer;const Self,Vals:PComplex);                          static;_inline overload;
   class procedure Sub(const result:PComplex ;const N:integer;const Self:PComplex;const Vals:Complex);            static;_inline overload;
   class procedure Mul(const result:PComplex ;const N:integer;const Self,Vals:PComplex);                          static;_inline overload;
   class procedure Mul(const result:PComplex ;const N:integer;const Self:PComplex;const Vals:Complex);            static;_inline overload;
   class procedure &Div(const result:PComplex;const N:integer ;const Self,Vals:PComplex);                         static;_inline overload;
   class procedure &Div(const result:PComplex;const N:integer ;const Self:PComplex;const Vals:Complex);           static;_inline overload;
   class procedure Conj(const result:PComplex;const N:integer ;const Self:PComplex);                              static;_inline overload;
   class procedure Gather(const dst,Self:PFloat;const Stride, N:integer);                                         static;_inline overload;
   private
     class procedure QuickSort(var Arr: TComplexArray; const L, R: Longint; const Descending:boolean;const Compare: TCompareFuncComplex); static;
 end;

