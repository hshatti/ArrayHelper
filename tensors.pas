

{

Neural Networks (NN)
  - Feed forward :
    $ Perceptrons
    § Input layers, Hidden layers, Output Layers
    § Weights and Biases
    § Feed Forwad
      "Sequential" structure of neurons
      "Dense" network where every neuron is connected to every neuron in the next layer
    § de-linearization (activation function : Sigmoid, TanH, RelU, softmax ( each value in the set based on the sum of the values, the result is [0≥ Values ≥ 1]) ,....)

  - feedback (Backpropagation) :
    $ loss function : ∑ ( mean absolute errors (errors=of differences), mean squareed errors, cross entropy ...) )
    § Learning rate
    § Derivetive function (Derivetive to the activation function)
    § (Stochastic) Gradient Descending (SGD): walking downwards towards minimas
    § Optimization function :
      variation of learning rate or the magnitude of steps taken through the gradient descents based on the loss value:
        SGD (no optimization or fixed steps/learning rate),
        ADAM,... etc

RNN (Recurrent Neural network)
  Keywords : Long-Short Term Memory layers (LSTM)

  a layer can feedback to itself or a neuron connect to neurons in the same layer
  used in NLP or language translation networks


Convolutional Neural Network (CNN)
  - Kernel Matrix and image filtering (element wise multiplicaton)
  - Adjustive weights and biases for the kernel matrices
  - Stride :marching steps through the image before applying the kernel matrix
  - Maxpooling: resize the image by half or N through taking the maximum pixel value among N
  - Flattening: convering 2D matricex to one line vector



Deep Generative Modeling: (composing outputs based on leaned models.. unsupervised)
     (Keyword: atenet model)
      -VAE :autoencoders and variational autoencoders
      -CycleGAN  :Generative adversarial Network


 }
unit Tensors;
{.$undef fpc}
{$ifndef fpc}{$mode delphi}{$endif}

{$H+}
{$ModeSwitch typehelpers}
{$ModeSwitch advancedrecords} {$inline on}{$macro on}
{.$define USE_AVX2}
{.$define use_lcl_complex}

interface

uses
  Classes, SysUtils, Types, Graphics, math,ArrayHelperCommon, arrayhelper
  {$ifdef USE_THREADS},steroids{$endif}
  {$ifdef use_lcl_complex},ucomplex{$endif}
  {$ifdef USE_AVX2}, oprs_simd{$endif}
  //{$ifdef USE_AVX2}, pblas{$endif}

  , complexarray
  {$ifdef USE_GPU} , oprs_gpu{$endif}
  ;

type
  TTensorType=(tsUnKnowen,tsChar,tsInt32,tsInt64,tsSingle,tsDouble,tsCurrency,tsString,tsDataTime)  ;

  //TFf=type helper for Single
  //end;


  { TCustomTensor }
  {$ifdef fpc}generic{$endif} TCustomTensor<T,TT,TTT> =record
  type
    PT=^T;
    TDataType=TT;
    TArray1d=Array of T;
    TArray2d=array of TArray1d;
    TArray3d=array of TArray2d;
  public
    Data:TArray1d;
  private
    //DataType:TTensorType;
    FShape:TIntegerDynArray;
    //FDP:function (const a,b:PT;const count:integer):T;
    function GetDimensions: integer;inline;
    function GetSize: Integer; inline;
    procedure SetShape(AValue: TIntegerDynArray);inline;
    //class function internalDot( a,b:PT;const Count:integer):T;register;static;overload; inline;
  public
    //constructor CreateAs(const dShape: TIntegerDynArray=nil);
    //constructor Create(const v: TArray1d; const dShape: TIntegerDynArray=nil);
    //constructor Create(const v: TArray2d); virtual;
    //class function Create():specialize TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}<T, TT, TTT>;static;
    function GetDataSize:SizeUInt;
    function GetRow(index: integer):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};//inline;
    procedure SetRow(index: integer; AValue:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});// inline;
    function GetColumn(index: integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};//inline;
    procedure SetColumn(index: integer; AValue:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); //inline;
    function Get(const x:integer):T;     {inline;}  overload;
    function Get(const x,y:integer):T;   {inline;}  overload;
    function Get(const x,y,z:integer):T; {inline;}  overload;
    procedure _Set(const x, y, z: integer; const val: T);       {inline;}  overload;
    procedure _Set(const x, y: integer; const val: T);          {inline;}  overload;
    procedure _Set(const x: integer; const val: T);             {inline;}  overload;
    function getRegion(const x,y,w,h:integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};      overload;
    function getRegion(const x,y,z,w,h:integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};    overload;
    function Init(const v: TArray1d; dShape: TIntegerDynArray=nil):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};  overload;
    function Init(const v: TArray2d):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                overload;
    function InitAs(const dShape: TIntegerDynArray): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    property Dimensions:integer read GetDimensions;
    property Size:Integer read GetSize;
    function AsArray2D():TArray2d; inline;
    function AsArray3D(): TArray3d;    inline;
    //procedure Init(v:array of const);
    //destructor Destroy; override;
    function Add(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};          {inline;}   overload;
    function Add(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                               {inline;}   overload;
    function Sub(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};          {inline;}   overload;
    function Sub(Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                                     {inline;}   overload;
    function Mul(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};          {inline;}   overload;
    function Mul(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                               {inline;}   overload;
    function &Div(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};         {inline;}   overload;
    function &Div(Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                                    {inline;}   overload;

    class procedure Add (var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T) ; static;  {inline;}   overload;
    class procedure Sub (var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T) ; static;  {inline;}   overload;
    class procedure Mul (var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T) ; static;  {inline;}   overload;
    class procedure &Div(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T) ; static;  {inline;}   overload;
    class procedure Sqrs (const src,result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); static;  {inline;}   overload;
    class procedure Sqrts(const src,result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); static;  {inline;}   overload;

    class procedure Add (var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); static;  {inline;}   overload;
    class procedure Sub (var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); static;  {inline;}   overload;
    class procedure Mul (var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); static;  {inline;}   overload;
    class procedure &Div(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}); static;  {inline;}   overload;


    function Dot(const Val: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): T;                                                     inline;   overload;
    function Cross(const Val: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};               inline;   overload;
    function Sums():TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    function Means():TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    function Variances(Mean:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    function StdDevs(var Mean:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    function Determinant():T;
    function Transpose: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};//inline;
    function Multiply(const Tensor:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};overload; //inline;
    class procedure Multiply(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Self,Tensor:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});static;overload;
    function Checkerboard: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};inline ;
    function Cofactors: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    function Inverse: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};//inline;
    function SubstractFrom(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};      inline;  overload;
    function SubstractFrom(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                           inline;  overload;
    function DividedBy(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};          inline;  overload;
    function DividedBy(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                               inline;  overload;
    function Uniform(const maxVal:T;const minVal: T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                               inline;  overload;
    function Uniform(const maxVal: Integer;const minVal: Integer=0):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};               inline;  overload;
    {.$if (T=Single) or (T=Double) or (T=Extended)}
    function Normal(const AMean,AStdDev:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};                                         inline;  overload;
    {.$endif}
    function Fill(const Val:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    function Degrade(const c,r:integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};inline;
    property Rows[index:integer]: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif} read GetRow write SetRow;
    property Columns[index:integer]: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif} read GetColumn write SetColumn;
    function TypeSize:integer;inline;
    function AsCharArray():TCharArray;deprecated;
    function AsIntegerArray():TIntegerDynArray;deprecated;
    function AsInt64Array():TInt64DynArray; deprecated;
    function AsSingleArray():TSingleDynArray; deprecated;
    function AsDoubleArray():TDoubleDynArray; deprecated;
    function AsCurrencyArray():TCurrencyArray; deprecated;
    function AsStringArray(const fmt:string):TStringDynArray;
    function AsDateTimeArray():TDateTimeArray;
    property Shape:TIntegerDynArray read FShape write SetShape;
    property Items[x:integer]:T read Get write _Set;
    property Items2d[x,y:integer]:T read Get write _Set;
    property Items3d[x,y,z:integer]:T read Get write _Set;
    property Width:integer  read FShape[0] write FShape[0] ;
    property Height:integer read FShape[1] write FShape[1] ;
    property Depth:integer  read FShape[2] write FShape[2] ;

  public
    class function Cross(const vec1,vec2: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};static;inline;
    class operator {$ifdef fpc}+{$else}add{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Vals:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}+{$else}add{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Vals: T):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}-{$else}subtract{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}-{$else}subtract{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Vals: T ):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}*{$else}multiply{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}*{$else}multiply{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Vals: T ):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}/{$else}divide{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}/{$else}divide{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Vals: T):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};  inline;
    class operator {$ifdef fpc}+{$else}add{$endif}(const Vals: T; const Self:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif} ):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}*{$else}multiply{$endif}(const Vals: T; const Self:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif} ):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    class operator {$ifdef fpc}-{$else}subtract{$endif}(const Vals: Extended; const Self:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};   inline;
    class operator {$ifdef fpc}/{$else}divide{$endif}(const Vals: Extended; const Self:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif} ):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; inline;
    //class operator:=(const Self: specialize TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}<T, TT, TTT>): string;
    class operator {$ifdef fpc}:={$else}Explicit{$endif}(const Self: TArray2d):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    class operator {$ifdef fpc}:={$else}Explicit{$endif}(const Self: TArray1d):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
    class operator {$ifdef fpc}:={$else}Explicit{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):string;
  end;

  PSingleTensor= ^TSingleTensor;
  TSingleTensor= {$ifdef fpc}specialize{$endif} TCustomTensor<Single,TSingleDynArray,TSingleArrayArray>;
  PDoubleTensor= ^TDoubleTensor;
  TDoubleTensor=  {$ifdef fpc}specialize{$endif} TCustomTensor<Double,TDoubleDynArray,TDoubleArrayArray>;
  PComplexTensorF= ^TComplexTensorF;
  TComplexTensorF= {$ifdef fpc}specialize{$endif} TCustomTensor<complexarray.ComplexF,TComplexArrayF,TComplexArrayArrayF>;
  PComplexTensorD= ^TComplexTensorD;
  TComplexTensorD= {$ifdef fpc}specialize{$endif} TCustomTensor<complexarray.ComplexD,TComplexArrayD,TComplexArrayArrayD>;
  PComplexTensor= ^TComplexTensor;
  TComplexTensor= TComplexTensorF;

  {$ifdef SUPPORT_EXTENDED}
  PExtrendedTensor= ^TExtendedTensor;
  TExtendedTensor={$ifdef fpc}specialize{$endif} TCustomTensor<Extended,TExtendedDynArray,TExtendedArrayArray>;
  {$endif}

  {$i tensorconvh.inc}

//  type TComplexArray=array [0..1] of double;
  {$ifdef fpc}
  //operator := (const Self:TSingleTensor):string;
  //operator := (const Self:TDoubleTensor):string;
  //{$ifdef SUPPORT_EXTENDED}
  // operator := (const Self:TExtendedTensor):string;
  //{$endif}
  //operator := (const Self:TComplexTensor):string;
  //operator := (const Self:Complex):string;
  {$else}

  {$endif}

  { TCustomVec }

  //{$ifdef fpc}generic{$endif} TCustomVec<T, TT, TTT>=record({$ifdef fpc}specialize{$endif} TCustomTensor<T, TT, TTT>)
  //   property Index[x:integer]:T read Get write _Set;default;
  //   property Value:TArray1D read Data;
  //end;
  //
  //generic TCustomMat2D<T, TT, TTT>=class(specialize TCustomTensor<T, TT, TTT>)
  //  property Index[x,y:integer]:T read Get write _Set;default;
  //  property Value:TArray2D read AsArray2D;
  //
  //end;
  //generic TCustomMat3D<T, TT, TTT>=class(specialize TCustomTensor<T, TT, TTT>)
  //  property Index[x,y,z:integer]:T read Get write _Set;default;
  //  property Value:TArray3D read AsArray3D;
  //end;

  //TMat2d=record helper for specialize TCustomTensor<Single>
  //end;
  //TVec=specialize TCustomTensor<Single>;

  //{ TMat2DHelper }
  //
  //TMatHelper=record helper for TMat2D
  //private
  //  function GetValue: TMat2D.TArray2D;
  //  function GetIndex(const x, y: integer): Double;
  //
  //  procedure SetValue(const AValue: TMat2D.TArray2D);
  //  procedure SetIndex(const x, y: integer; const AValue: Double);
  //public
  //  //function Degrade(const c,r:integer):TMat2D;
  //  //function Multiply(const Tensor: TMat2D): TMat2D;
  //  class function Identity(const degree:integer):TMat2D;static;
  //  property Index[x,y:integer]:Double read GetIndex write SetIndex;default;
  //  property Value:TMat2D.TArray2D read GetValue write SetValue;
  //end;

  { TVecHelper }

  //TVecHelper=record helper for TVec
  //private
  //  function GetValue: TVec.TArray1D;
  //  function GetIndex(const x: integer): Double;
  //
  //  procedure SetValue(const AValue: TVec.TArray1D);
  //  procedure SetIndex(const x: integer; const AValue: Double);
  //public
  //  function Dot(const Vec: TVec): Double;
  //  //function Multiply(const Tensor: TMat2D): TVec;
  //  property Index[x:integer]:Double read GetIndex write SetIndex;default;
  //  property Value:TVec.TArray1D read GetValue write SetValue;
  //end;


  //TMat2=specialize TCustomTensor<Single>;
  //TMat3=specialize TCustomTensor<Single>;
  //TMat4=specialize TCustomTensor<Single>;
  //TVec4=specialize TCustomTensor<Single>;
  //TVec3=specialize TCustomTensor<Single>;
  //TVec2=specialize TCustomTensor<Single>;
  { TVec2Helper }

  //TVec2Helper=record helper for TVec2
  //private
  //  function GetValue: TVec2.TArray1D;
  //  function GetIndex(const x: integer): Single;
  //
  //  procedure SetValue(const AValue: TVec2.TArray1D);
  //  procedure SetIndex(const x: integer; const AValue: Single);
  //public
  //  function Dot(const Vec: TVec2): Single;
  //  function Multiply(const Tensor: TMat2): TVec2;
  //  property Index[x:integer]:Single read GetIndex write SetIndex;default;
  //  property Value:TVec2.TArray1D read GetValue write SetValue;
  //end;
  //
  //{ TVec3Helper }
  //
  //TVec3Helper=record helper for TVec3
  //private
  //  function GetValue: TVec3.TArray1D;
  //  function GetIndex(const x: integer): Single;
  //
  //  procedure SetValue(const AValue: TVec3.TArray1D);
  //  procedure SetIndex(const x: integer; const AValue: Single);
  //public
  //  function Dot(const Vec: TVec3): Single;
  //  function Multiply(const Tensor: TMat3): TVec3;
  //  property Index[x:integer]:Single read GetIndex write SetIndex;default;
  //  property Value:TVec3.TArray1D read GetValue write SetValue;
  //end;
  //
  //{ TVec4Helper }
  //
  //TVec4Helper=record helper for TVec4
  //private
  //  function GetValue: TVec4.TArray1D;
  //  function GetIndex(const x: integer): Single;
  //  procedure SetValue(const AValue: TVec4.TArray1D);
  //  procedure SetIndex(const x: integer; const AValue: Single);
  //public
  //  function Dot(const Vec: TVec4): Single;
  //  function Multiply(const Tensor: TMat4): TVec4;
  //  property Index[x:integer]:Single read GetIndex write SetIndex;default;
  //  property Value:TVec4.TArray1D read GetValue write SetValue;
  //end;
//procedure _vmmuls(const opt:PPointer;const id,stride,count:integer);
//procedure _vmmuld(const opt:PPointer;const id,stride,count:integer);

//generic function im2col_get_pixel<T,PT>(im:PT; height, width, channels, row, col, channel, pad:integer):T;
//generic procedure im2col_cpu<T,PT>(data:PT; channels, height, width, ksize, stride, pad:integer; data_col:PT);
//procedure conv2d(const nFeatures, nImgSize, nDepth:integer ; const ALPHA:Single;
//        const Filter:PSingle;  const nKernelWidth:integer;   //Kernel Width
//        const Img:PSingle;  const nImgWidth:integer;   //Input width
//        const C:PSingle;  const ldc:integer);


//function RandG(const AMean,StdDiv:ComplexF):ComplexF;overload;
//function RandG(const AMean,StdDiv:ComplexD):ComplexD;


procedure splitRGB(const Data:PLongword;const Red,Green,Blue:PByte;const Count:integer);
procedure joinRGB(Data:PColorRec;const Red,Green,Blue:PByte;const Count:integer);
procedure DrawData(const Dest:TBitmap;const Src:PLongword;const x,y,width,height:integer;const scale:single=1.0);
{$ifdef fpc}generic {$endif}procedure aGathera<PT>(const dst,a:PT;const w,c:integer);inline;
{$ifdef fpc}generic {$endif}procedure im2col_cpu<T,PT>(data:PT; channels, height, width, ksize, stride, pad:integer; data_col:PT);inline;
{$ifdef fpc}generic {$endif}procedure _Conv2d<T,PT>(const Features, KernelSize, Width, Height, Depth, Stride,Padding:Integer;const AKernel,AIn,AOut:PT;ATemp:PT); inline;
//function Sqrt(const n:ComplexF):ComplexF;
//function Sqrt(const n:ComplexD):ComplexD;

implementation

{$ifdef fpc}generic {$endif}function im2col_get_pixel<T,PT>(im:PT; height, width, channels, row, col, channel, pad:integer):T;
begin
    row -= pad;
    col -= pad;

    if (row < 0) or (col < 0) or (row >= height) or (col >= width) then exit(0);
    result:= im[width*(row + height*channel)+col];
end;


{$ifdef fpc}generic {$endif}procedure aGathera<PT>(const dst,a:PT;const w,c:integer);
var i,j:integer;
begin
  //i:=0;j:=0;
  for i:=0 to c-1 do
  //begin
    dst[i]:=a[i*w];
    //inc(j,w);
    //inc(i);
  //end;
end;

//From Berkeley Vision's Caffe!
//https://github.com/BVLC/caffe/blob/master/LICENSE
{$ifdef fpc}generic {$endif}procedure im2col_cpu<T,PT>(data:PT; channels, height, width, ksize, stride, pad:integer; data_col:PT);
var c,h{$ifndef USE_AVX2},w{$endif},height_col,width_col,channels_col,w_offset,h_offset,c_im,row,col,col_index:integer;
begin

    height_col := (height + 2*pad - ksize) div stride + 1;
    width_col := (width + 2*pad - ksize) div stride + 1;

    channels_col := channels * ksize * ksize;
    for c := 0 to channels_col-1 do begin
        w_offset := c mod ksize;
        //divmod(trunc(c / ksize),ksize,c_im,h_offset);
        h_offset := trunc(c / ksize) mod ksize;
        c_im := trunc(c / (ksize * ksize));
        //h:=pad;w:=pad;
        for h := pad to height_col-1 do begin
        //for h := 0 to height_col-1 do begin
            row := h_offset + h * stride;
               PT.Gather(@data_col[(c * height_col + h) * width_col],@data[width*(row-pad + height*c_im)+w_offset-pad],stride,width_col);
            //{$else}
            //{$ifdef fpc}specialize {$endif}aGathera<PT>(@data_col[(c * height_col + h) * width_col],@data[width*(row-pad + height*c_im)+w_offset-pad],stride,width_col);
            //{$endif}
            //for w := 0 to width_col-1 do begin
            //    col := w_offset + w * stride;
            //
            //    col_index := (c * height_col + h) * width_col + w;
            //    data_col[col_index] := im2col_get_pixel(data, height, width, channels, row, col, c_im, pad);
            //    //data_col[col_index] :=               data[width*(row-pad + height*c_im)+col-pad];
            //end;
        end
    end;
end;


{$ifdef fpc}generic {$endif}procedure _Conv2d<T,PT>(const Features, KernelSize, Width, Height, Depth, Stride,Padding:Integer;const AKernel,AIn,AOut:PT;ATemp:PT);// inline;
var oWidth, oHeight, i, j:integer;
begin
//    fill_cpu(l.outputs*l.batch, 0, l.output, 1);

    // if(l.xnor){
    //     binarize_weights(l.weights, l.n, l.c/l.groups*l.size*l.size, l.binary_weights);
    //     swap_binary(&l);
    //     binarize_cpu(net.input, l.c*l.h*l.w*l.batch, l.binary_input);
    //     net.input = l.binary_input;
    // }
    oWidth:=trunc((Width+2*Padding-KernelSize)/Stride)+1;
    oHeight:=trunc((Height+2*Padding-KernelSize)/Stride)+1;
    //for i := 0 to 0 do begin
    //    for j := 0 to 0 do begin
           if (KernelSize = 1) then
               ATemp := AIn
           else
               {$ifdef fpc}specialize {$endif}im2col_cpu<T,PT>(AIn, Depth, Height, Width, KernelSize, Stride, Padding, ATemp);
           PT.gemm_nn(Features, oWidth*oHeight, KernelSize*KernelSize*Depth, 1.0, @AKernel[0], KernelSize*KernelSize*Depth, @ATemp[0], oWidth*oHeight, {1.0,} @AOut[0], oWidth*oHeight);
    //    end;
    //end
end;


//function RandG(const AMean,StdDiv:ComplexF):ComplexF;
//begin
//
//end;

//function RandG(const AMean,StdDiv:ComplexD):ComplexD;
//begin
//
//end;


//{ TVec4Helper }
//
//function TVec4Helper.GetValue: TVec4.TArray1D;
//begin
//  result:=Data;
//end;
//
//function TVec4Helper.GetIndex(const x: integer): Single;
//begin
//  result:=Get(x);
//end;
//
//procedure TVec4Helper.SetValue(const AValue: TVec4.TArray1D);
//begin
//  Init(AValue)
//end;
//
//procedure TVec4Helper.SetIndex(const x: integer; const AValue: Single);
//begin
//  _Set(x,AValue)
//end;
//
//function TVec4Helper.Dot(const Vec: TVec4): Single;
//begin
//  result:=Data[0]*Vec.Data[0]+Data[1]*Vec.Data[1]+Data[2]*Vec.Data[2]+Data[3]*Vec.Data[3]
//end;
//
//function TVec4Helper.Multiply(const Tensor: TMat4): TVec4;
//var i,j,k:integer;S:Single;
//begin
//  Result.InitAs([4]);
//  Result.Data[0]:=Data[0]*Tensor.Data[0]+Data[1]*Tensor.Data[4]+Data[2]*Tensor.Data[8 ]+Data[3]*Tensor.Data[12];
//  Result.Data[1]:=Data[0]*Tensor.Data[1]+Data[1]*Tensor.Data[5]+Data[2]*Tensor.Data[9 ]+Data[3]*Tensor.Data[13];
//  Result.Data[2]:=Data[0]*Tensor.Data[2]+Data[1]*Tensor.Data[6]+Data[2]*Tensor.Data[10]+Data[3]*Tensor.Data[14];
//  Result.Data[3]:=Data[0]*Tensor.Data[3]+Data[1]*Tensor.Data[7]+Data[2]*Tensor.Data[11]+Data[3]*Tensor.Data[15];
//end;
//
//{ TVec3Helper }
//
//function TVec3Helper.GetValue: TVec3.TArray1D;
//begin
//  result:=Data;
//end;
//
//function TVec3Helper.GetIndex(const x: integer): Single;
//begin
//  result:=Get(x);
//end;
//
//procedure TVec3Helper.SetValue(const AValue: TVec3.TArray1D);
//begin
//  Init(AValue)
//end;
//
//procedure TVec3Helper.SetIndex(const x: integer; const AValue: Single);
//begin
//  _Set(x,AValue)
//end;
//
//function TVec3Helper.Dot(const Vec: TVec3): Single;
//begin
//  result:=Data[0]*Vec.Data[0]+Data[1]*Vec.Data[1]+Data[2]*Vec.Data[2]
//end;
//
//function TVec3Helper.Multiply(const Tensor: TMat3): TVec3;
//var i,j,k:integer;S:Single;
//begin
//  Result.InitAs([3]);
//  Result.Data[0]:=Data[0]*Tensor.Data[0]+Data[1]*Tensor.Data[3]+Data[2]*Tensor.Data[6];
//  Result.Data[1]:=Data[0]*Tensor.Data[1]+Data[1]*Tensor.Data[4]+Data[2]*Tensor.Data[7];
//  Result.Data[2]:=Data[0]*Tensor.Data[2]+Data[1]*Tensor.Data[5]+Data[2]*Tensor.Data[8];
//end;
//
//{ TVec2Helper }
//
//function TVec2Helper.GetValue: TVec2.TArray1D;
//begin
//  result:=Data;
//end;
//
//function TVec2Helper.GetIndex(const x: integer): Single;
//begin
//  result:=Get(x);
//end;
//
//procedure TVec2Helper.SetValue(const AValue: TVec2.TArray1D);
//begin
//  Init(AValue)
//end;
//
//procedure TVec2Helper.SetIndex(const x: integer; const AValue: Single);
//begin
//  _Set(x,AValue)
//end;
//
//function TVec2Helper.Dot(const Vec: TVec2): Single;
//begin
//  result:=Data[0]*Vec.Data[0]+Data[1]*Vec.Data[1]
//end;
//
//function TVec2Helper.Multiply(const Tensor: TMat2): TVec2;
//begin
//  Result.InitAs([2]);
//  Result.Data[0]:=Data[0]*Tensor.Data[0]+Data[1]*Tensor.Data[2];
//  Result.Data[1]:=Data[0]*Tensor.Data[1]+Data[1]*Tensor.Data[3];
//end;
//
//
//{ TVecHelper }
//
//function TVecHelper.GetValue: TVec.TArray1D;
//begin
//  result:=Data;
//end;
//
//function TVecHelper.GetIndex(const x: integer): Double;
//begin
//  result:=Get(x);
//end;
//
//procedure TVecHelper.SetValue(const AValue: TVec.TArray1D);
//begin
//  Init(AValue)
//end;
//
//procedure TVecHelper.SetIndex(const x: integer; const AValue: Double);
//begin
//  _Set(x,AValue)
//end;
//
//function TVecHelper.Dot(const Vec:TVec): Double;
//var i,l:integer;
//begin
//  Assert((Dimensions=1) and (Vec.Dimensions=1),'Tensors must be a vector');
//  l:=Shape[0];
//  Assert(Shape[0]=Vec.Shape[0],'Vectors must have the same length');
//  Result:=0;
//  for i:=0 to l-1 do
//    begin
//      result:=Result+Data[i]*Vec.Data[i];
//    end;
//end;
//
//function TVecHelper.Multiply(const Tensor: TMat2D): TVec;
//var i,j,k:integer;S:Single;
//begin
//  Assert(Dimensions=1, 'Tensor must be a vector');
//  Assert(Shape[0]=Tensor.FShape[1],'Matrix rows must match '+IntToStr(Tensor.FShape[0]));
//  Result.InitAs([FShape[0]]);
//  for i:=0 to Tensor.FShape[0]-1 do
////    for j:=0 to FShape[1]-1 do
//    begin
//      S:=0;
//      for k:=0 to FShape[0]-1 do
//        s:=s+Get(k{,j})*Tensor.Get(i,k);
//      Result._Set(i{,j},S);
//    end;
//end;
//
//{ TMat2DHelper }
//
//
//function TMat2DHelper.Multiply(const Tensor:TMat2D):TMat2D;
//var i,j,k:integer;S:Single;
//begin
//  Assert(Dimensions<=2, 'Tensor must be a vector or a Matrix');
//  Assert(Shape[0]=Tensor.FShape[1],'Matrix rows must match '+IntToStr(Tensor.FShape[0]));
//  Result.InitAs([Tensor.FShape[0],FShape[1]]);
//  for i:=0 to Tensor.FShape[0]-1 do
//    for j:=0 to FShape[1]-1 do begin
//      S:=0;
//      for k:=0 to FShape[0]-1 do
//        s:=s+Get(k,j)*Tensor.Get(i,k);
//      Result._Set(i,j,S);
//    end;
//end;
//
//class function TMatHelper.Identity(const degree: integer): TMat2D;
//var i:integer;
//begin
//  Result.InitAs([degree,degree]);
//  for i:=0 to degree-1 do
//    Result._Set(i,i,1);
//end;
//
//
//function TMatHelper.GetValue: TMat2D.TArray2D;
//begin
//  result:=AsArray2D();
//end;
//
//function TMatHelper.GetIndex(const x, y: integer): Double;
//begin
//  result:=Get(x,y);
//end;
//
//procedure TMatHelper.SetValue(const AValue: TMat2D.TArray2D);
//begin
//  Init(AValue)
//end;
//
//procedure TMatHelper.SetIndex(const x, y: integer; const AValue: Double);
//begin
//  _Set(x,y,AValue)
//end;
//


{$ifdef SUPPORT_EXTENDED}
function FloatArrayToStr(const v:TExtendedDynArray):string; overload;
begin
  result:=v.ToString();
end;
{$endif}
function FloatArrayToStr(const v:TDoubleDynArray):string; overload;
begin
  result:=v.ToString();
end;
function FloatArrayToStr(const v:TSingleDynArray):string;  overload;
begin
  result:=v.ToString();
end;

{ TCustomTensor }

procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.SetShape(AValue: TIntegerDynArray);
begin
  if FShape=AValue then Exit;
  Assert(AValue.product=Size,'Data count must match shape '+AValue.ToString);
  FShape:=AValue;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.GetSize: Integer;
begin
  Result:=FShape.product
end;

procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.SetColumn(index: integer; AValue:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  Assert((AValue.Dimensions=1) and (AValue.Width=Height),'Tensor must be a vector');
  for i:=0 to AValue.Width-1 do begin
    Data[Index+Width*i]:=AValue.Data[i];
  end;
end;

procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.SetRow(index: integer; AValue:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  Assert((AValue.Dimensions=1) and (AValue.Width=Width),'Tensor must be a vector');
  for i:=0 to AValue.Width-1 do begin
    Data[Index*Width+i]:=AValue.Data[i];
  end;

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsArray2D(): TArray2d;
var y,x,r,c:integer;
begin
  Assert(Dimensions=2,'Tensor is not a 2D matrix');
  r:=Height;c:=Width;
  setLength(result,c,r);
  for y:=0 to r-1 do begin
    //setLength(result[y],c);
    for x:=0 to c-1 do
      result[y][x]:=Data[x+y*c]
  end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsArray3D(): TArray3d;
var z,y,x,  d,r,c:integer;   //depth, row, column
begin

  Assert(Dimensions=3,'Tensor is not a 3D matrix');
  d:=Depth;r:=Height;c:=Width;
  setLength(result,c,r,d);
  for z:=0 to d-1 do begin
    //setLength(result[z],r);
    for y:=0 to r-1 do begin
      //setLength(result[z][y],c);
      for x:=0 to c-1 do
        result[z][y][x]:=Data[x+y*c+z*r*c]
    end;
  end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.GetColumn(index: integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;P:PT;
begin
  Assert(Dimensions>1,'Tensor is not a matrix!');
  result.InitAs([Height]);
  P:=@Data[index];

  i:=0;while i< Height do begin
    result.Data[i]:=P^;
    inc(P,Width);
    inc(i)
  end;

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.GetRow(index: integer):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  Assert(Dimensions>1,'Tensor is not a matrix!');
  result.Init(copy(Data,index*Width,Width));
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.GetDimensions: integer;
begin
  result:=FShape.Count;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.InitAs(const dShape: TIntegerDynArray): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  FShape:=copy(dShape);
  SetLength(Data,FShape.product);
  result:=Self
end;

//constructor TCustomTensor.Create(const v: TArray1d;
//  const dShape: TIntegerDynArray);
//begin
//  init(v,dShape)
//end;

//constructor TCustomTensor.Create(const v: TArray2d);
//var i,j,c,r:integer;
//begin
//  if Assigned(v) then
//    r:=Length(v);  // num of rows
//  if r>0 then
//    c:=Length(v[0]);//num of cols
//
//  Assert((c>0) and (r >0),format('2D Matrix cannot be of dimension [%d,%d]',[c,r])) ;
//  for i:=0 to r-1 do
//    Assert(Length(v[i])=c,'Inconsistant number of columns accros the matrix.');
//  setLength(Data,r*c);
//  for i:=0 to r-1 do
//    for j:=0 to c-1 do
//      Data[j+i*c]:=v[i][j];
//  FShape:=[c,r]
//end;

//class function TCustomTensor.Create(): specialize TCustomTensor<T, TT, TTT>;
//begin
//
//end;

//destructor TCustomTensor.Destroy;
//begin
//  setLength(Data,0);
//  inherited
//end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Add(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  Result:=Self;
  TT(Result.Data).add(Vals.Data);

  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //    bulkAdd_s(@Self.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //    bulkAdd_d(@Self.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  //else
  //{$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] + Vals.Data[i];
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Add(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Result:=Self;
  TT(Result.Data).Add(Vals);
  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //  bulkAdd_ss(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //  bulkAdd_sd(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  //else
  //{$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] + Vals;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sub(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  Result:=Self;
  TT(Result.Data).Sub(Vals.Data);

  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //  bulkSub_s(@Self.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //  bulkSub_d(@Self.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  //else
  //{$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] - Vals.Data[i];

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sub(Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Result:=Self;
  TT(Result.Data).Sub(Vals);

//Vals:=-Vals;
//
//  {$ifdef USE_AVX2}
//  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
//    bulkAdd_ss(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
//  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
//    bulkAdd_sd(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
//  else
//  {$endif}
//  for i:=0 to High(Self.Data) do
//    Self.Data[i]:=Self.Data[i] + Vals;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Mul(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  Result:=Self;
  TT(Result.Data).mul(Vals.Data)

  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //  bulkMul_s(@Self.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //  bulkMul_d(@Self.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  //else
  //{$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] * Vals.Data[i];
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Mul(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Result:=Self;
  TT(Result.Data).mul(Vals);
  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //  bulkMul_ss(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //  bulkMul_sd(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  //else
  //{$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] * Vals;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.&Div(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  Result:=Self;
  TT(Result.Data).&div(Vals.Data)
  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //  bulkDiv_s(@Self.Data[0],@Self.Data[0],@vals.data[0],Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //  bulkDiv_s(@Self.Data[0],@Self.Data[0],@vals.data[0],Length(Self.Data))
  //else
  //{$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] / Vals.Data[i];
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.&Div(Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Result:=Self;
  TT(Result.Data).&div(Vals)

  //Vals:=1/Vals;
  //{$ifdef USE_AVX2}
  //if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
  //  bulkMul_ss(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  //else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
  //  bulkMul_sd(@Self.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  //else
  //  {$endif}
  //for i:=0 to High(Self.Data) do
  //  Self.Data[i]:=Self.Data[i] * Vals;
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Add(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  Assert((High(Self.Data)=High(Vals.Data)) and (High(Self.FShape)=High(Vals.FShape)),'Ternsor shapes does not match!');
  TT.Add(@result.Data[0], Length(Self.Data),@Self.Data[0], @Vals.Data[0]);
  (*
  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
      bulkAdd_s(@Result.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
      bulkAdd_d(@Result.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] + Vals.Data[i]; *)
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Add(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T);
var i:integer;
begin
//  Assert(High(Self.Data)=High(Vals.Data) and (High(Self.FShape)=High(Vals.FShape)),'Ternsor shapes does not match!');
  TT.Add(@result.Data[0], Length(Self.Data), @Self.Data[0], Vals);

(*  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkAdd_ss(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkAdd_sd(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] + Vals;  *)
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sub(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  Assert((High(Self.Data)=High(Vals.Data)) and (High(Self.FShape)=High(Vals.FShape)),'Ternsor shapes does not match!');
  TT.Sub(@result.Data[0],Length(Self.Data), @Self.Data[0], @Vals.Data[0]);

  (*
  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkSub_s(@Result.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkSub_d(@Result.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] - Vals.Data[i]; *)

end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sub(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T);
var i:integer;
begin
//  Assert(High(Self.Data)=High(Vals.Data) and (High(Self.FShape)=High(Vals.FShape)),'Ternsor shapes does not match!');
  TT.Sub(@result.Data[0], Length(result.Data), @Self.Data[0], Vals);
(*  Vals:=-Vals;
  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkAdd_ss(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkAdd_sd(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] + Vals; *)
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Mul(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  Assert((High(Self.Data)=High(Vals.Data)) and (High(Self.FShape)=High(Vals.FShape)),'Ternsor shapes does not match!');
  TT.Mul(@result.Data[0],Length(result.Data),@Self.Data[0],@Vals.Data[0])
  (*{$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkMul_s(@Result.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkMul_d(@Result.Data[0],@Self.Data[0],@vals.Data[0],Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] * Vals.Data[i];   *)
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Mul(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T);
var i:integer;
begin
  TT.Mul(@result.Data[0],Length(Self.Data),@Self.Data[0],Vals);
  (*
  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkMul_ss(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkMul_sd(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] * Vals;  *)
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.&Div(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  Assert((High(Self.Data)=High(Vals.Data)) and (High(Self.FShape)=High(Vals.FShape)),'Ternsor shapes does not match!');
  TT.&div(@result.Data[0],Length(Self.Data),@Self.Data[0],@Vals.Data[0])
  (*
  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkDiv_s(@Result.Data[0],@Self.Data[0],@vals.data[0],Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkDiv_d(@Result.Data[0],@Self.Data[0],@vals.data[0],Length(Self.Data))
  else
  {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] / Vals.Data[i];   *)
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.&Div(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T);
var i:integer;
begin
  TT.&div(@result.Data[0],Length(Self.Data),@Self.Data[0],Vals)
  (*
  Vals:=1/Vals;
  {$ifdef USE_AVX2}
  if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=4) then
    bulkMul_ss(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else if useAVX2 and (GetTypeKind(T)=tkFloat) and (SizeOf(T)=8) then
    bulkMul_sd(@Result.Data[0],@Self.Data[0],@vals,Length(Self.Data))
  else
    {$endif}
  for i:=0 to High(Self.Data) do
    Result.Data[i]:=Self.Data[i] * Vals;  *)
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Dot(const Val: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): T;
//var i:integer;
begin
  Assert((High(Self.Data)=High(Val.Data)) and (Dimensions=Val.Dimensions),'Array size must match');
  //Result:=0;
  result:=TT(Self.Data).dot(Val.data);
  ////for i:=0 to High(Self.Data) do
  //  result:=internalDot(@Self.Data[0],@Val.data[0],Length(Val.data));//result+Self.Data[i]*Val.data[i];
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Cross(const Val: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  Assert((Dimensions+val.Dimensions=2) and (Length(Self.Data)=3) and (Length(Val.Data)=3),'Tensors must be a 3D vectors');
  result:=Self;
  Result.data[0]:=Self.data[1]*Val.data[2]-Self.data[2]*Val.data[1];
  Result.data[1]:=Self.data[2]*Val.data[0]-Self.data[0]*Val.data[2];
  Result.data[2]:=Self.data[0]*Val.data[1]-Self.data[1]*Val.data[0];
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Determinant(): T;
var i,L:integer;det:T;
begin
  result:=0;
  L:=Width;
  case L of
    2:result:=Data[0]*Data[3]-Data[1]*Data[2];
    3:result:=data[0]*(data[4]*data[8] -data[5]*data[7])
             -data[1]*(data[3]*data[8] -data[5]*data[6])
             +data[2]*(data[3]*data[7] -data[4]*data[6]);
    4:result:=
    (data[0]*data[5]-data[4]*data[1])*(data[10]*data[15]-data[14]*data[11])-
    (data[0]*data[9]-data[8]*data[1])*(data[6]*data[15]-data[14]*data[7])+
    (data[0]*data[13]-data[12]*data[1])*(data[6]*data[11]-data[10]*data[7])+
    (data[4]*data[9]-data[8]*data[5])*(data[2]*data[15]-data[14]*data[3])-
    (data[4]*data[13]-data[12]*data[5])*(data[2]*data[11]-data[10]*data[3])+
    (data[8]*data[13]-data[12]*data[9])*(data[2]*data[7]-data[6]*data[3]);
  else
    begin
      assert(High(FShape)<2 ,'Something went wrong, try [clean and rebuild] project');
      for i:=0 to L-1 do //if assigned(Data) then
        begin
          det:=Self.Degrade(i,0).Determinant();
          if i and 1=0 then
            result:=result+det*Data[i]
          else
            result:=result-det*Data[i]
        end;
    end;
  end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.SubstractFrom(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals.Data[i] - Self.Data[i];
  Result:=Self;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.SubstractFrom(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals - Self.Data[i];
  Result:=Self;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.DividedBy(const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals.Data[i] / Self.Data[i];
  Result:=Self;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.DividedBy(const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals / Self.Data[i];
  Result:=Self;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Degrade(const c, r: integer):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var cc,rr,ccc,rrr,L:integer;
begin
    L:=Width-1 ;
    Result.InitAs([L,L]);
    for rr:=0 to Width-1 do
      for cc:=0 to Width-1 do
        if (cc<>c) and (rr<>r) then begin
          if cc>c then ccc:=cc-1 else ccc:=cc;
          if rr>r then rrr:=rr-1 else rrr:=rr;
          Result._Set(ccc,rrr,Get(cc,rr))
      end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.getRegion(const x,y,w,h:integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,fW:integer;
begin
  Assert(GetDimensions=2,'Tensor dimensions must equal [2]');
  fW:=Width;
  result.InitAs([w,h]);
  for i:=0 to y+h-1 do
    Move(Self.Data[x+Y*Fw], Result.Data[i*w],w*SizeOf(T))
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.getRegion(const x,y,z,w,h:integer): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,j,fW,fZ:integer;
begin
  Assert(GetDimensions=3,'Tensor dimensions must equal [3]');
  fW:=Width;
  fZ:=Height*fW;
  result.InitAs([w,h]);
  for i:=0 to y+h-1 do
    Move(Self.Data[x+y*fW+z*fZ], Result.Data[i*w],w*SizeOf(T))
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Init(const v: TArray1d; dShape: TIntegerDynArray): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var L:integer;
begin
  L:=Length(v);
  if l=0 then exit;
  if not Assigned(dShape) then dShape:=[l];
  //Assert(length(dShape)<=3 ,'Dimentions above 3 are not Accepted!');
  Assert(dShape.Product=l ,'Init array count must match shape summary '+dShape.ToString());
  FShape:=copy(dShape);
  //SetLength(Data,L);
  //Move(v[0],Data[0],L*TypeSize);
  //for l:=0 to L-1 do Data[l]:=v[l] ;
  Data:=Copy(v);
  result:=Self;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Init(const v: TArray2d): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,j,c,r:integer;
begin
  if Assigned(v) then
    r:=Length(v);  // num of rows
  if r>0 then
    c:=Length(v[0]);//num of cols

  Assert((c>0) and (r >0),format('2D Matrix cannot be of dimension [%d,%d]',[c,r])) ;
  for i:=0 to r-1 do
    Assert(Length(v[i])=c,'Inconsistant number of columns accros the matrix.');
  setLength(Data,r*c);
  for i:=0 to r-1 do
    for j:=0 to c-1 do
      Move(v[i][0],Data[i*c],C*TypeSize);
      //Data[j+i*c]:=v[i][j];
  FShape:=[c,r];
  result:=Self;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Get(const x: integer): T;
begin
  if Dimensions=1 then
    result:=Data[x];
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Get(const x, y: integer): T;
begin
  if Dimensions=2 then
    result:=Data[x+y*Width]
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Get(const x, y, z: integer): T;
begin
  if Dimensions=3 then
    result:=Data[x+Width*(y+z*Height)]
end;

procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}._Set(const x: integer;const val:T);
begin
  if Dimensions=1 then
    Data[x]:=val;
end;

procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}._Set(const x, y: integer;const val:T);
begin
  if Dimensions=2 then
    Data[x+y*Width]:=val
end;

procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}._Set(const x, y, z: integer;const val:T);
begin
  if Dimensions=3 then
    Data[x+Width*(y+z*Height)]:=val
end;

//class function TCustomTensor.Create(): specialize TCustomTensor<T, TT, TTT>;
//begin
//
//end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Uniform(const maxVal: T;const minVal: T):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
 for i:=0 to Length(Data)-1 do
    Data[i]:=minVal+(maxVal-minVal)*random;
  result:=self
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Uniform(const maxVal: Integer;const minVal: Integer):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
 for i:=0 to Length(Data)-1 do
    Data[i]:=minVal+random(maxVal-minVal);
  result:=self
end;

{.$if (T=Single) or (T=Double) or (T=Extended)}
function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Normal(const AMean,AStdDev:T):  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var x,y,s : T;
  i:integer;
begin
  //for i:=0 to High(Data) do begin
  //  repeat
  //    x:= 2*random-1;
  //    y:= 2*random-1;
  //    s:=x*x+y*y;
  //  until s<1.0;
  //  Data[i]:=Sqrt(-2*ln(s)/s)*x*AStdDev+AMean;
  //end;
end;
{.$endif}

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Fill(const Val:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  result:=Self;
  for i:=0 to High(Data) do
    Data[i]:=Val;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Transpose:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var w,h,n:integer;
begin
//  New(a);
  Assert((Dimensions=2) and Assigned(Data),'Tensor must be a 2D Matrix');
  SetLength(result.Data,Size);
  setLength(result.FShape,2);
  result.Width:=Height;
  result.Height:=Width;

  //for n:=0 to High(result.Data) do begin
  //  DivMod(n,Height,i,j);
  //  result.Data[n]:=Data[i+j*Width];
  //end;


  for h:=0 to Width-1 do
    TT.Gather(@result.Data[h*Height],@Data[h],Width,Height);
    //for w:=0 to Height-1 do
    //  result.Data[w+h*Height]:=Data[h+w*Width];

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Checkerboard:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var j,i,L:integer;
begin
  L:=Width;
  result.InitAs(FShape);
  for j:=0 to L do
    for i:=0 to L-1 do begin
      if (i+j) mod 2 =0 then Result.Data[i]:=1
      else Result.Data[i]:=-1
  end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Cofactors:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,j,L:integer;
begin
  L:=Width;
  result.InitAs(FShape);
  for j:=0 to L-1 do
    for i:= 0 to L-1 do
    if (i+j) mod 2=0 then
      result._Set(i,j, Self.Degrade(i,j).Determinant())
    else
      Result._Set(i,j,-Self.Degrade(i,j).Determinant());
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Inverse:  TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var det:T;i:integer;
begin
  det:=Self.Determinant();
  Assert((det<>0) and (Width=Height),'Matrix inverse is not resolvable!');
  det:=1/det;
  case Width of
    2:  begin
      result.initAs(FShape);
      result.Data[3]:= Data[0];
      result.Data[1]:=-Data[1];
      result.Data[2]:=-Data[2];
      result.Data[0]:= Data[3];
    //result.Mul(det);
    end;
    3:begin
      result.initAs(FShape);
      result.items2d[0,0]:= (get(1,1)*get(2,2)-get(2,1)*get(1,2));
      result.items2d[0,1]:=-(get(0,1)*get(2,2)-get(2,1)*get(0,2));
      result.items2d[0,2]:= (get(0,1)*get(1,2)-get(1,1)*get(0,2));
      result.items2d[1,0]:=-(get(1,0)*get(2,2)-get(2,0)*get(1,2));
      result.items2d[1,1]:= (get(0,0)*get(2,2)-get(2,0)*get(0,2));
      result.items2d[1,2]:=-(get(0,0)*get(1,2)-get(1,0)*get(0,2));
      result.items2d[2,0]:= (get(1,0)*get(2,1)-get(2,0)*get(1,1));
      result.items2d[2,1]:=-(get(0,0)*get(2,1)-get(2,0)*get(0,1));
      result.items2d[2,2]:= (get(0,0)*get(1,1)-get(1,0)*get(0,1));
    end;
    4:begin
      result.initAs(FShape);
      result.items2d[0,0]:=(items2d[1,1]*(items2d[2,2]*items2d[3,3]-items2d[2,3]*items2d[3,2])+
                                   items2d[1,2]*(items2d[2,3]*items2d[3,1]-items2d[2,1]*items2d[3,3])+
                                   items2d[1,3]*(items2d[2,1]*items2d[3,2]-items2d[2,2]*items2d[3,1]));
      result.items2d[0,1]:=(items2d[2,1]*(items2d[0,2]*items2d[3,3]-items2d[0,3]*items2d[3,2])+
                                   items2d[2,2]*(items2d[0,3]*items2d[3,1]-items2d[0,1]*items2d[3,3])+
                                   items2d[2,3]*(items2d[0,1]*items2d[3,2]-items2d[0,2]*items2d[3,1]));
      result.items2d[0,2]:=(items2d[3,1]*(items2d[0,2]*items2d[1,3]-items2d[0,3]*items2d[1,2])+
                                   items2d[3,2]*(items2d[0,3]*items2d[1,1]-items2d[0,1]*items2d[1,3])+
                                   items2d[3,3]*(items2d[0,1]*items2d[1,2]-items2d[0,2]*items2d[1,1]));
      result.items2d[0,3]:=(items2d[0,1]*(items2d[1,3]*items2d[2,2]-items2d[1,2]*items2d[2,3])+
                                   items2d[0,2]*(items2d[1,1]*items2d[2,3]-items2d[1,3]*items2d[2,1])+
                                   items2d[0,3]*(items2d[1,2]*items2d[2,1]-items2d[1,1]*items2d[2,2]));
      result.items2d[1,0]:=(items2d[1,2]*(items2d[2,0]*items2d[3,3]-items2d[2,3]*items2d[3,0])+
                                   items2d[1,3]*(items2d[2,2]*items2d[3,0]-items2d[2,0]*items2d[3,2])+
                                   items2d[1,0]*(items2d[2,3]*items2d[3,2]-items2d[2,2]*items2d[3,3]));
      result.items2d[1,1]:=(items2d[2,2]*(items2d[0,0]*items2d[3,3]-items2d[0,3]*items2d[3,0])+
                                   items2d[2,3]*(items2d[0,2]*items2d[3,0]-items2d[0,0]*items2d[3,2])+
                                   items2d[2,0]*(items2d[0,3]*items2d[3,2]-items2d[0,2]*items2d[3,3]));
      result.items2d[1,2]:=(items2d[3,2]*(items2d[0,0]*items2d[1,3]-items2d[0,3]*items2d[1,0])+
                                   items2d[3,3]*(items2d[0,2]*items2d[1,0]-items2d[0,0]*items2d[1,2])+
                                   items2d[3,0]*(items2d[0,3]*items2d[1,2]-items2d[0,2]*items2d[1,3]));
      result.items2d[1,3]:=(items2d[0,2]*(items2d[1,3]*items2d[2,0]-items2d[1,0]*items2d[2,3])+
                                   items2d[0,3]*(items2d[1,0]*items2d[2,2]-items2d[1,2]*items2d[2,0])+
                                   items2d[0,0]*(items2d[1,2]*items2d[2,3]-items2d[1,3]*items2d[2,2]));
      result.items2d[2,0]:=(items2d[1,3]*(items2d[2,0]*items2d[3,1]-items2d[2,1]*items2d[3,0])+
                                   items2d[1,0]*(items2d[2,1]*items2d[3,3]-items2d[2,3]*items2d[3,1])+
                                   items2d[1,1]*(items2d[2,3]*items2d[3,0]-items2d[2,0]*items2d[3,3]));
      result.items2d[2,1]:=(items2d[2,3]*(items2d[0,0]*items2d[3,1]-items2d[0,1]*items2d[3,0])+
                                   items2d[2,0]*(items2d[0,1]*items2d[3,3]-items2d[0,3]*items2d[3,1])+
                                   items2d[2,1]*(items2d[0,3]*items2d[3,0]-items2d[0,0]*items2d[3,3]));
      result.items2d[2,2]:=(items2d[3,3]*(items2d[0,0]*items2d[1,1]-items2d[0,1]*items2d[1,0])+
                                   items2d[3,0]*(items2d[0,1]*items2d[1,3]-items2d[0,3]*items2d[1,1])+
                                   items2d[3,1]*(items2d[0,3]*items2d[1,0]-items2d[0,0]*items2d[1,3]));
      result.items2d[2,3]:=(items2d[0,3]*(items2d[1,1]*items2d[2,0]-items2d[1,0]*items2d[2,1])+
                                   items2d[0,0]*(items2d[1,3]*items2d[2,1]-items2d[1,1]*items2d[2,3])+
                                   items2d[0,1]*(items2d[1,0]*items2d[2,3]-items2d[1,3]*items2d[2,0]));
      result.items2d[3,0]:=(items2d[1,0]*(items2d[2,2]*items2d[3,1]-items2d[2,1]*items2d[3,2])+
                                   items2d[1,1]*(items2d[2,0]*items2d[3,2]-items2d[2,2]*items2d[3,0])+
                                   items2d[1,2]*(items2d[2,1]*items2d[3,0]-items2d[2,0]*items2d[3,1]));
      result.items2d[3,1]:=(items2d[2,0]*(items2d[0,2]*items2d[3,1]-items2d[0,1]*items2d[3,2])+
                                   items2d[2,1]*(items2d[0,0]*items2d[3,2]-items2d[0,2]*items2d[3,0])+
                                   items2d[2,2]*(items2d[0,1]*items2d[3,0]-items2d[0,0]*items2d[3,1]));
      result.items2d[3,2]:=(items2d[3,0]*(items2d[0,2]*items2d[1,1]-items2d[0,1]*items2d[1,2])+
                                   items2d[3,1]*(items2d[0,0]*items2d[1,2]-items2d[0,2]*items2d[1,0])+
                                   items2d[3,2]*(items2d[0,1]*items2d[1,0]-items2d[0,0]*items2d[1,1]));
      result.items2d[3,3]:=(items2d[0,0]*(items2d[1,1]*items2d[2,2]-items2d[1,2]*items2d[2,1])+
                                       items2d[0,1]*(items2d[1,2]*items2d[2,0]-items2d[1,0]*items2d[2,2])+
                                       items2d[0,2]*(items2d[1,0]*items2d[2,1]-items2d[1,1]*items2d[2,0]));
    end
    else
      result:=Cofactors.Transpose;
  end;
  //TT.Conj(@result.data[0],Length(result.Data),@result.data[0]);  // incase of a Complex Matrix
  TT.mul(@result.data[0],Length(result.data),@result.data[0],det)

end;

//class function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.internalDot( a,b:PT;const Count:integer):T;
//var i:integer;
//begin
//  result:=TT.dot(a,b,Count)
////  {$ifdef USE_AVX2}
////  if (GetTypeKind(T)=tkFloat) then
////    if (SizeOf(T)=4) then begin
////      result:=bulkDot_s(pSingle(a),pSingle(b),Count);
////      exit
////    end else if(SizeOf(T)=8) then begin
////      result:=bulkDot_d(pDouble(a),pDouble(b),Count);
////      exit;
////    end;
////{$endif}
////  result:=0;i:=0;
////  while i < Count do begin
////    result:=result+a^*b^;
////    inc(a);inc(b);
////    inc(i)
////  end;
//end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.GetDataSize: SizeUInt;
begin
  result:=GetSize*SizeOf(T);
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Multiply(const Tensor: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,xx,yy:integer; tmp:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};s:T;
begin
  Assert(Dimensions<=2, 'Tensor must be a vector or a 2D Matrix');                    //check here.............

  if Tensor.Dimensions=1 then
    Assert(Width=Tensor.Width,format('Tensor count must match [%d] got [%d]',[Width,Tensor.Width]));

  if Tensor.Dimensions=2 then
    Assert(Width=Tensor.Height,format('Matrix rows must match [%d] got %d',[Width,Tensor.Height]));

  if Tensor.Dimensions = 1 then
    begin
      Result.InitAs([Height]);
      for yy:=0 to Height-1 do
          Result._Set(yy,TT.Dot(@Data[yy*Width],@Tensor.Data[0],Tensor.Width));
    end
  else begin
    Result.InitAs([Tensor.Width,Height]);
    (*  haitham shatti - note to self:
       here i found a significantly faster approach by
       doing a Matrix transform then use dot product of row pairs
       this works perfectly with SIMD instructions!
    *)
    tmp:=Tensor.Transpose;
    for yy:=0 to Height-1 do
      for xx:=0 to Tensor.Width-1 do begin
        //s:=0;
        //for i:=0 to Width-1 do
        //  s:=s+get(i,yy)*Tensor.Get(xx,i);
        //s:=InternalDot(@Data[yy*Width],@Tmp.Data[xx*Width],Width);
        result._set(xx,yy,
          //s
          //bulkDot_s(@Data[yy*Width],@Tensor.Data[xx],Tensor.Width,Width)
          TT.Dot(@Data[yy*Width],@Tmp.Data[xx*Width],Width)
        )
      end;

  end;
end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sqrs (const src,result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  TT.sqr(@src.data[0], @result.data[0], Length(src.data))
end;


class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sqrts(const src,result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i:integer;
begin
  TT.sqrt(@src.data[0], @result.Data[0],Length(src.Data))
end;

//procedure _vmmuls(const opt:PPointer;const id,stride,count:integer);
//var yy,i:integer;mWidth,mLen:pinteger;Res,Sel,Tensor:PSingle;
//begin
//  Res:=    opt[0];
//  Sel:=    opt[1];
//  Tensor:= opt[2];
//  mWidth:=opt[3];
//  mLen:=opt[4];
//  yy:=id;
//  while yy<Count do begin
//   Res[yy]:=0;
//    Res[yy]:=bulkDot_s(@Sel[id*mWidth^],@Tensor[0],mLen^);
//    yy:=yy+stride
//  end;
//end;
//
//procedure _vmmuld(const opt:PPointer;const id,stride,count:integer);
//var yy:integer;mWidth,mLen:Pinteger;Result,Self,Tensor:PDouble;
//begin
//  Result:=opt[0];
//  Self:=  opt[1];
//  Tensor:=opt[2];
//  mWidth:=PInteger(opt[3]);
//  mLen:=PInteger(opt[4]);
//  yy:=id;
//  while yy<Count do begin
//    Result[yy]:=bulkDot_d(@Self[yy*mWidth^],@Tensor[0],mLen^);
//    yy:=yy+stride
//  end;
//end;

class procedure TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Multiply(var result:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}; const Self,Tensor: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif});
var i,xx,yy,mWidth,mLen:integer; tmp:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};s:T;
  //opt:TPointerDynArray;
begin
  if Tensor.Dimensions=1 then
    Assert(Self.Width=Tensor.Width,format('Tensor count must match [%d] got [%d]',[Self.Width,Tensor.Width]));

  if Tensor.Dimensions=2 then
    {$ifdef fpc}Assert(Self.Width=Tensor.Height,format('Matrix rows must match %s got %s',[string(Self),string(Tensor)]));
    {$else}Assert(Self.Width=Tensor.Height,format('Matrix rows must match %d got %d',[Self.Width,Tensor.Height]));
    {$endif}
  //mWidth:=Self.Width;
  //mLen:=Tensor.Width;
  //opt:=TPointerDynArray([@result.data[0], @Self.data[0], @Tensor.Data[0],@mWidth,@mLen]) ;
//  {$ifdef USE_THREADS}writeln('Multiply::: ',Tensor.Width); {$endif}
  if Tensor.Dimensions = 1 then
    begin
      //{$ifdef USE_THREADS}
      //if (useAVX2) and  (useThreads) and (GetTypeKind(T)=tkFloat) then
      //  if SizeOf(T)=4 then
      //    //_vmmuls(PPointer(opt),0,1,Self.Height)
      //    CallInParallel(TProcData(@_vmmuls),PPointer(opt),0,Self.Height,0)
      //  else
      //    CallInParallel(TProcData(@_vmmuld),PPointer(opt),0,Self.Height,0)
      //else
      //{$endif}
        for yy:=0 to Self.Height-1 do
          Result._Set(yy,TT.Dot(@Self.Data[yy*Self.Width],@Tensor.Data[0],Tensor.Width))
    end
  else begin
    (*  haitham shatti - note to self:
       here i found a significantly faster approach by
       doing a Matrix transform then use dot product of row pairs
       this works perfectly with SIMD instructions!
    *)
    tmp:=Tensor.Transpose;
    for yy:=0 to Self.Height-1 do
      for xx:=0 to Tensor.Width-1 do begin
        //s:=0;
        //for i:=0 to Width-1 do
        //  s:=s+get(i,yy)*Tensor.Get(xx,i);
        //s:=InternalDot(@Data[yy*Width],@Tmp.Data[xx*Width],Width);
        result._set(xx,yy,
          //s
          TT.Dot(@Self.Data[yy*Self.Width],@Tmp.Data[xx*Self.Width],Self.Width)
        )
      end;
  end;
//  {$ifdef USE_THREADS}writeln('Done:::',nWorkingThreads);{$endif}

end;
function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Sums():TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,j,k:integer;
begin
  case Dimensions of
    1:begin
      result.initAs([1]);
      for i:=0 to Width-1 do result.data[0]:=result.Data[0]+Self.Data[i];
    end;
    2:begin
        result.initAs([Self.FShape[High(Self.FShape)]]);
        for i:=0 to Height-1 do
          for j:=0 to width do
            result.Data[i]:=result.Data[i]+Self.Data[j+i*Width];

    end;
      3:begin
        result.initAs([Self.FShape[High(Self.FShape)]]);
        for i:=0 to Depth-1 do
          for j:=0 to Height-1 do
            for k:=0 to Width-1 do
              result.Data[i]:=result.Data[i]+Self.Data[k+Width*(j+i*Height)];
    end;
  end;

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Means():TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  Result:=Self.Sums();
  case Dimensions of
      1,2: result.&Div(Self.Width);
      3: result.&Div(Self.Width*Self.Height);
  end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Variances(Mean:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i,j,k:integer; V:T;A:integer;
  function _Sqr(const r:T):T;begin _sqr:=r*r end;
begin
//  if Length(Data)<2 then exit;
  case Dimensions of
    1:begin
      result.initAs([1]);
      V:=0;
      for i:=0 to Width-1 do V:=V+_Sqr(Self.Data[i]-Mean.Data[0]);
      Result.Data[0]:=V/(Width-1);
    end;
    2:begin
        result.initAs([Self.FShape[High(Self.FShape)]]);
        for i:=0 to Height-1 do begin
          V:=0;
          for j:=0 to Width-1 do V:=V+_Sqr(Self.Data[j+i*Width]-Mean.Data[i]);
          result.Data[i]:=V/(Width-1);
        end
    end;
      3:begin
        result.initAs([Self.FShape[High(Self.FShape)]]);
        A:=Width*Height;
        for i:=0 to Depth-1 do begin
          V:=0;
          for j:=0 to Height-1 do
            for k:=0 to Width-1 do V:=V+_Sqr(Self.Data[k+Width*(j+i*Height)]-Mean.Data[i]);
          Result.Data[i]:=V / (A-1)
        end;
    end;
  end;
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.StdDevs(var Mean:TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  Mean:=Means();
  Result:=Variances(Mean);
  TT.sqrt(@result.data[0],@result.Data[0],Length(result.Data))
end;


function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.TypeSize: integer;
begin
  result:=SizeOf(T)
end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsCharArray(): TCharArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsIntegerArray(): TIntegerDynArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsInt64Array(): TInt64DynArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsSingleArray(): TSingleDynArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsDoubleArray(): TDoubleDynArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsCurrencyArray(): TCurrencyArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsStringArray(const fmt: string): TStringDynArray;
begin

end;

function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.AsDateTimeArray(): TDateTimeArray;
begin

end;

class function TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.Cross(const vec1, vec2: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  Assert((Vec1.Dimensions+Vec2.Dimensions=2) and (Length(Vec1.Data)=3) and (Length(Vec2.Data)=3),'Tensors must be a 3D vectors');
  result.InitAs([3]);
  Result.data[0]:=vec1.data[1]*vec2.data[2]-vec1.data[2]*vec2.data[1];
  Result.data[1]:=vec1.data[2]*vec2.data[0]-vec1.data[0]*vec2.data[2];
  Result.data[2]:=vec1.data[0]*vec2.data[1]-vec1.data[1]*vec2.data[0];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}+{$else}add{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  Result.FShape:=copy(Self.FShape);
  result.data:=copy(self.data);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] + Vals.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}+{$else}add{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] + Vals;
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}-{$else}subtract{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] - Vals.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}-{$else}subtract{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] - Vals;
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}*{$else}multiply{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] * Vals.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}*{$else}multiply{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] * Vals;
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}/{$else}divide{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] / Vals.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}/{$else}divide{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};const Vals:T): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    result.Data[i]:=Self.Data[i] / Vals;
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}+{$else}add{$endif}(const Vals:T;const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals + Self.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}*{$else}multiply{$endif}(const Vals:T;const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals * Self.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}-{$else}subtract{$endif}(const Vals:Extended;const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals - Self.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}/{$else}divide{$endif}(const Vals:Extended;const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals / Self.Data[i];
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}:={$else}Explicit{$endif}(const Self:TArray2d): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  result.Init(Self)
end;

class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}:={$else}Explicit{$endif}(const Self:TArray1d): TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif};
begin
  result.Init(Self)
end;


class operator TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}.{$ifdef fpc}:={$else}Explicit{$endif}(const Self: TCustomTensor{$ifndef fpc}<T, TT, TTT>{$endif}):string;
var x,y,z:integer;
begin
  result:='';
  case Self.Dimensions of
    1:Result:=TT(Self.Data).ToString;
    2:begin
      for y:=0 to Self.Height-1 do
        Result:=Result+#13#10+TT(Copy(Self.Data,y*Self.Width,Self.Width)).ToString;
        delete(result,1,2);
        result:='['+result+']' ;
      end;
    3:;
  end;
end;

//operator := (const Self: TSingleTensor):string;
//var x,y,z:integer;
//begin
//  result:='';
//  case Self.Dimensions of
//    1:Result:=TSingleDynArray(Self.Data).ToString();
//    2:begin
//      for y:=0 to Self.Height-1 do
//        Result:=Result+#13#10+Copy(TSingleDynArray(Self.Data),y*Self.Width,Self.Width).ToString();
//        delete(result,1,2);
//        result:='['+result+']' ;
//      end;
//    3:;
//  end;
//end;
//
//operator := (const Self: TDoubleTensor):string;
//var x,y,z:integer;
//begin
//  result:='';
//  case Self.Dimensions of
//    1:Result:=TDoubleDynArray(Self.Data).ToString();
//    2:begin
//      for y:=0 to Self.Height-1 do
//        Result:=Result+#13#10+Copy(TDoubleDynArray(Self.Data),y*Self.Width,Self.Width).ToString();
//        delete(result,1,2);
//        result:='['+result+']' ;
//      end;
//    3:;
//  end;
//end;
//
//{$ifdef SUPPORT_EXTENDED}
//operator := (const Self: TExtendedTensor):string;
//var x,y,z:integer;
//begin
//  result:='';
//  case Self.Dimensions of
//    1:Result:=TExtendedDynArray(Self.Data).ToString();
//    2:begin
//      for y:=0 to Self.Height-1 do
//        Result:=Result+#13#10+Copy(TExtendedDynArray(Self.Data),y*Self.Width,Self.Width).ToString();
//        delete(result,1,2);
//        result:='['+result+']' ;
//      end;
//    3:;
//  end;
//end;
//{$endif}
//
//operator := (const Self: TComplexTensor):string;
//var x,y,z,i:integer;
//begin
//  result:='';
//  case Self.Dimensions of
//    1:begin
//      for i:=0 to Length(Self.Data)-1 do
//        Result:=result+', '+string(Self.Data[i]);
//      delete(result,1,1);
//      result:='['+result+']';
//    end;
//    2:begin
//      for y:=0 to Self.Height-1 do
//        Result:=Result+#13#10+string(Copy(Self.Data,y*Self.Width,Self.Width));
//        delete(result,1,2);
//        result:='['+result+']' ;
//      end;
//    3:;
//  end;
//end;

//operator :=(const Self: Complex): string;
//begin
//  result:=self;
//end;


{$i tensorconvimp.inc}

end.

