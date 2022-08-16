unit tensors_d;

{$mode objfpc}{$H+}
//{$ModeSwitch typehelpers}
{$ModeSwitch advancedrecords}
{$inline on}


interface

uses
  Classes, SysUtils, Types, math, arrayhelper;

type
  TTensorType=(tsUnKnowen,tsChar,tsInt32,tsInt64,tsSingle,tsDouble,tsCurrency,tsString,tsDataTime)  ;

  { TCustomTensor }
  TCustomTensorDouble =record
  type
    PT=^Double;
    TArray1d=array of Double;
    TArray2d=array of TArray1d;
    TArray3d=array of TArray2D;

  private
    DataType:TTensorType;
    FShape:TIntegerDynArray;
    class operator:=(const Self: TArray2d): TCustomTensorDouble;
    class operator:=(const Self: TArray1d): TCustomTensorDouble;
    function AsArray2D():TArray2d;
    function AsArray3D(): TArray3d;
    function GetColumn(index: integer): TCustomTensorDouble;
    function GetDimensions: integer;
    function GetRow(index: integer): TCustomTensorDouble;
    function GetSize: Integer;
    procedure SetColumn(index: integer; AValue: TCustomTensorDouble);
    procedure SetRow(index: integer; AValue: TCustomTensorDouble);
    procedure SetShape(AValue: TIntegerDynArray);
  public
    //constructor CreateAs(const dShape: TIntegerDynArray=nil);
    //constructor Create(const v: TArray1d; const dShape: TIntegerDynArray=nil);
    //constructor Create(const v: TArray2d); virtual;
    //class function Create():TCustomTensorDouble;static;
    Data:TArray1d;
    function Get(const x:integer):Double; inline;
    function Get(const x,y:integer):Double; inline;
    function Get(const x,y,z:integer):Double; inline;
    procedure _Set(const x, y, z: integer; const val: Double);inline;
    procedure _Set(const x, y: integer; const val: Double); inline;
    procedure _Set(const x: integer; const val: Double); inline;
    procedure Init(const v: TArray1d; dShape: TIntegerDynArray=nil);
    procedure Init(const v: TArray2d);
    function InitAs(const dShape: TIntegerDynArray):TCustomTensorDouble;
    property Dimensions:integer read GetDimensions;
    property Size:Integer read GetSize;
    //procedure Init(v:array of const);
    //destructor Destroy; override;
    function Add(const Vals:TCustomTensorDouble):TCustomTensorDouble;                inline;
    function Add(const Vals:Double):TCustomTensorDouble;                         inline;
    function Sub(const Vals:TCustomTensorDouble):TCustomTensorDouble;                inline;
    function Sub(const Vals:Double):TCustomTensorDouble;                         inline;
    function Mul(const Vals:TCustomTensorDouble):TCustomTensorDouble;                inline;
    function Mul(const Vals:Double):TCustomTensorDouble;                         inline;
    function &Div(const Vals:TCustomTensorDouble):TCustomTensorDouble;               inline;
    function &Div(const Vals:Double):TCustomTensorDouble;                       inline;
    function Determinant():Double;
    function Multiply(const Tensor: TCustomTensorDouble): TCustomTensorDouble; inline;
    function SubstractFrom(const Vals:TCustomTensorDouble):TCustomTensorDouble;      inline;
    function SubstractFrom(const Vals:Double):TCustomTensorDouble;               inline;
    function DividedBy(const Vals:TCustomTensorDouble):TCustomTensorDouble;          inline;
    function DividedBy(const Vals:Double):TCustomTensorDouble;                   inline;
    function uniform(maxVal:Double=1):TCustomTensorDouble;inline;
    function uniform(maxVal: Integer): TCustomTensorDouble;inline;
    function Transpose:TCustomTensorDouble;inline;
    function Degrade(const c,r:integer):TCustomTensorDouble;inline;
    property Row[index:integer]:TCustomTensorDouble read GetRow write SetRow;
    property Column[index:integer]:TCustomTensorDouble read GetColumn write SetColumn;
    function AsString:string;
    function TypeSize:integer;
    function AsCharArray():TCharArray;
    function AsIntegerArray():TIntegerDynArray;
    function AsInt64Array():TInt64DynArray;
    function AsSingleArray():TSingleDynArray;
    function AsDoubleArray():TDoubleDynArray;
    function AsCurrencyArray():TCurrencyArray;
    function AsStringArray(const fmt:string):TStringDynArray;
    function AsDateTimeArray():TDateTimeArray;
    property Shape:TIntegerDynArray read FShape write SetShape;
    function Checkerboard:TCustomTensorDouble;inline ;
    function Cofactors:TCustomTensorDouble; inline;
    function Inverse:TCustomTensorDouble;inline;
  public
    class operator+(const Self: TCustomTensorDouble; const Vals: TCustomTensorDouble): TCustomTensorDouble; inline;
    class operator+(const Self: TCustomTensorDouble; const Vals: Float): TCustomTensorDouble; inline;
    class operator-(const Self: TCustomTensorDouble;const Vals: TCustomTensorDouble): TCustomTensorDouble; inline;
    class operator-(const Self: TCustomTensorDouble; const Vals: Float ): TCustomTensorDouble; inline;
    class operator*(const Self: TCustomTensorDouble;const Vals: TCustomTensorDouble): TCustomTensorDouble; inline;
    class operator*(const Self: TCustomTensorDouble; const Vals: Float ): TCustomTensorDouble; inline;
    class operator/(const Self: TCustomTensorDouble;const Vals: TCustomTensorDouble): TCustomTensorDouble; inline;
    class operator/(const Self: TCustomTensorDouble; const Vals: Float): TCustomTensorDouble;  inline;
    class operator+(const Vals: Float; const Self: TCustomTensorDouble ): TCustomTensorDouble; inline;
    class operator*(const Vals: Float; const Self: TCustomTensorDouble ): TCustomTensorDouble; inline;
    class operator-(const Vals: Float; const Self: TCustomTensorDouble): TCustomTensorDouble;   inline;
    class operator/(const Vals: Float; const Self: TCustomTensorDouble ): TCustomTensorDouble; inline;
    class operator:=(const Self: TCustomTensorDouble): string;
  end;

  { TCustomVec }

  //TCustomVecDouble=record(TCustomTensorDouble)
  //   property Index[x:integer]:T read Get write _Set;default;
  //   property Value:TArray1D read Data;
  //end;
  //
  //TCustomMat2DDouble=class(TCustomTensorDouble)
  //  property Index[x,y:integer]:T read Get write _Set;default;
  //  property Value:TArray2D read AsArray2D;
  //
  //end;
  //TCustomMat3DDouble=class(TCustomTensorDouble)
  //  property Index[x,y,z:integer]:T read Get write _Set;default;
  //  property Value:TArray3D read AsArray3D;
  //end;

  //TMat2d=record helper for TCustomTensor<Single>
  //end;
  //TVec=TCustomTensor<Single>;
{
  { TMat2DHelper }

  TMatHelper=record helper for TMat2D
  private
    function GetValue: TMat2D.TArray2D;
    function GetIndex(const x, y: integer): Double;

    procedure SetValue(const AValue: TMat2D.TArray2D);
    procedure SetIndex(const x, y: integer; const AValue: Double);
  public
    //function Degrade(const c,r:integer):TMat2D;
    //function Multiply(const Tensor: TMat2D): TMat2D;
    class function Identity(const degree:integer):TMat2D;static;
    property Index[x,y:integer]:Double read GetIndex write SetIndex;default;
    property Value:TMat2D.TArray2D read GetValue write SetValue;
  end;

  { TVecHelper }

  TVecHelper=record helper for TVec
  private
    function GetValue: TVec.TArray1D;
    function GetIndex(const x: integer): Double;

    procedure SetValue(const AValue: TVec.TArray1D);
    procedure SetIndex(const x: integer; const AValue: Double);
  public
    function Dot(const Vec: TVec): Double;
    //function Multiply(const Tensor: TMat2D): TVec;
    property Index[x:integer]:Double read GetIndex write SetIndex;default;
    property Value:TVec.TArray1D read GetValue write SetValue;
  end;
 }
{
  TMat2=TCustomTensor<Single>;
  TMat3=TCustomTensor<Single>;
  TMat4=TCustomTensor<Single>;
  TVec4=TCustomTensor<Single>;
  TVec3=TCustomTensor<Single>;
  TVec2=TCustomTensor<Single>;
  { TVec2Helper }

  TVec2Helper=record helper for TVec2
  private
    function GetValue: TVec2.TArray1D;
    function GetIndex(const x: integer): Single;

    procedure SetValue(const AValue: TVec2.TArray1D);
    procedure SetIndex(const x: integer; const AValue: Single);
  public
    function Dot(const Vec: TVec2): Single;
    function Multiply(const Tensor: TMat2): TVec2;
    property Index[x:integer]:Single read GetIndex write SetIndex;default;
    property Value:TVec2.TArray1D read GetValue write SetValue;
  end;

  { TVec3Helper }

  TVec3Helper=record helper for TVec3
  private
    function GetValue: TVec3.TArray1D;
    function GetIndex(const x: integer): Single;

    procedure SetValue(const AValue: TVec3.TArray1D);
    procedure SetIndex(const x: integer; const AValue: Single);
  public
    function Dot(const Vec: TVec3): Single;
    function Multiply(const Tensor: TMat3): TVec3;
    property Index[x:integer]:Single read GetIndex write SetIndex;default;
    property Value:TVec3.TArray1D read GetValue write SetValue;
  end;

  { TVec4Helper }

  TVec4Helper=record helper for TVec4
  private
    function GetValue: TVec4.TArray1D;
    function GetIndex(const x: integer): Single;
    procedure SetValue(const AValue: TVec4.TArray1D);
    procedure SetIndex(const x: integer; const AValue: Single);
  public
    function Dot(const Vec: TVec4): Single;
    function Multiply(const Tensor: TMat4): TVec4;
    property Index[x:integer]:Single read GetIndex write SetIndex;default;
    property Value:TVec4.TArray1D read GetValue write SetValue;
  end;
}

implementation
{
{ TVec4Helper }

function TVec4Helper.GetValue: TVec4.TArray1D;
begin
  result:=Data;
end;

function TVec4Helper.GetIndex(const x: integer): Single;
begin
  result:=Get(x);
end;

procedure TVec4Helper.SetValue(const AValue: TVec4.TArray1D);
begin
  Init(AValue)
end;

procedure TVec4Helper.SetIndex(const x: integer; const AValue: Single);
begin
  _Set(x,AValue)
end;

function TVec4Helper.Dot(const Vec: TVec4): Single;
begin
  result:=Data[0]*Vec.Data[0]+Data[1]*Vec.Data[1]+Data[2]*Vec.Data[2]+Data[3]*Vec.Data[3]
end;

function TVec4Helper.Multiply(const Tensor: TMat4): TVec4;
var i,j,k:integer;S:Single;
begin
  Result.InitAs([4]);
  Result.Data[0]:=Data[0]*Tensor.Data[0]+Data[1]*Tensor.Data[4]+Data[2]*Tensor.Data[8 ]+Data[3]*Tensor.Data[12];
  Result.Data[1]:=Data[0]*Tensor.Data[1]+Data[1]*Tensor.Data[5]+Data[2]*Tensor.Data[9 ]+Data[3]*Tensor.Data[13];
  Result.Data[2]:=Data[0]*Tensor.Data[2]+Data[1]*Tensor.Data[6]+Data[2]*Tensor.Data[10]+Data[3]*Tensor.Data[14];
  Result.Data[3]:=Data[0]*Tensor.Data[3]+Data[1]*Tensor.Data[7]+Data[2]*Tensor.Data[11]+Data[3]*Tensor.Data[15];
end;

{ TVec3Helper }

function TVec3Helper.GetValue: TVec3.TArray1D;
begin
  result:=Data;
end;

function TVec3Helper.GetIndex(const x: integer): Single;
begin
  result:=Get(x);
end;

procedure TVec3Helper.SetValue(const AValue: TVec3.TArray1D);
begin
  Init(AValue)
end;

procedure TVec3Helper.SetIndex(const x: integer; const AValue: Single);
begin
  _Set(x,AValue)
end;

function TVec3Helper.Dot(const Vec: TVec3): Single;
begin
  result:=Data[0]*Vec.Data[0]+Data[1]*Vec.Data[1]+Data[2]*Vec.Data[2]
end;

function TVec3Helper.Multiply(const Tensor: TMat3): TVec3;
var i,j,k:integer;S:Single;
begin
  Result.InitAs([3]);
  Result.Data[0]:=Data[0]*Tensor.Data[0]+Data[1]*Tensor.Data[3]+Data[2]*Tensor.Data[6];
  Result.Data[1]:=Data[0]*Tensor.Data[1]+Data[1]*Tensor.Data[4]+Data[2]*Tensor.Data[7];
  Result.Data[2]:=Data[0]*Tensor.Data[2]+Data[1]*Tensor.Data[5]+Data[2]*Tensor.Data[8];
end;

{ TVec2Helper }

function TVec2Helper.GetValue: TVec2.TArray1D;
begin
  result:=Data;
end;

function TVec2Helper.GetIndex(const x: integer): Single;
begin
  result:=Get(x);
end;

procedure TVec2Helper.SetValue(const AValue: TVec2.TArray1D);
begin
  Init(AValue)
end;

procedure TVec2Helper.SetIndex(const x: integer; const AValue: Single);
begin
  _Set(x,AValue)
end;

function TVec2Helper.Dot(const Vec: TVec2): Single;
begin
  result:=Data[0]*Vec.Data[0]+Data[1]*Vec.Data[1]
end;

function TVec2Helper.Multiply(const Tensor: TMat2): TVec2;
begin
  Result.InitAs([2]);
  Result.Data[0]:=Data[0]*Tensor.Data[0]+Data[1]*Tensor.Data[2];
  Result.Data[1]:=Data[0]*Tensor.Data[1]+Data[1]*Tensor.Data[3];
end;
}
{
{ TVecHelper }

function TVecHelper.GetValue: TVec.TArray1D;
begin
  result:=Data;
end;

function TVecHelper.GetIndex(const x: integer): Double;
begin
  result:=Get(x);
end;

procedure TVecHelper.SetValue(const AValue: TVec.TArray1D);
begin
  Init(AValue)
end;

procedure TVecHelper.SetIndex(const x: integer; const AValue: Double);
begin
  _Set(x,AValue)
end;

function TVecHelper.Dot(const Vec:TVec): Double;
var i,l:integer;
begin
  Assert((Dimensions=1) and (Vec.Dimensions=1),'Tensors must be a vector');
  l:=Shape[0];
  Assert(Shape[0]=Vec.Shape[0],'Vectors must have the same length');
  Result:=0;
  for i:=0 to l-1 do
    begin
      result:=Result+Data[i]*Vec.Data[i];
    end;
end;

{function TVecHelper.Multiply(const Tensor: TMat2D): TVec;
var i,j,k:integer;S:Single;
begin
  Assert(Dimensions=1, 'Tensor must be a vector');
  Assert(Shape[0]=Tensor.FShape[1],'Matrix rows must match '+IntToStr(Tensor.FShape[0]));
  Result.InitAs([FShape[0]]);
  for i:=0 to Tensor.FShape[0]-1 do
//    for j:=0 to FShape[1]-1 do
    begin
      S:=0;
      for k:=0 to FShape[0]-1 do
        s:=s+Get(k{,j})*Tensor.Get(i,k);
      Result._Set(i{,j},S);
    end;
end;}

{ TMat2DHelper }


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

class function TMatHelper.Identity(const degree: integer): TMat2D;
var i:integer;
begin
  Result.InitAs([degree,degree]);
  for i:=0 to degree-1 do
    Result._Set(i,i,1);
end;


function TMatHelper.GetValue: TMat2D.TArray2D;
begin
  result:=AsArray2D();
end;

function TMatHelper.GetIndex(const x, y: integer): Double;
begin
  result:=Get(x,y);
end;

procedure TMatHelper.SetValue(const AValue: TMat2D.TArray2D);
begin
  Init(AValue)
end;

procedure TMatHelper.SetIndex(const x, y: integer; const AValue: Double);
begin
  _Set(x,y,AValue)
end;
}

{ TCustomTensor }

function FloatArrayToStr(const v:TExtendedDynArray):string;
begin
  result:=v.ToString();
end;

function FloatArrayToStr(const v:TDoubleDynArray):string;
begin
  result:=v.ToString();
end;
function FloatArrayToStr(const v:TSingleDynArray):string;
begin
  result:=v.ToString();
end;

procedure TCustomTensorDouble.SetShape(AValue: TIntegerDynArray);
begin
  if FShape=AValue then Exit;
  Assert(AValue.sum=Size,'Data count must match shape summary '+AValue.ToString);
  FShape:=AValue;
end;

function TCustomTensorDouble.GetSize: Integer;
begin
  Result:=Length(Data)
end;

procedure TCustomTensorDouble.SetColumn(index: integer; AValue:
  TCustomTensorDouble);
var i:integer;
begin
  Assert((AValue.Dimensions=1) and (AValue.FShape[0]=FShape[1]),'Tensor must be a vector');
  for i:=0 to AValue.Shape[0]-1 do begin
    Data[Index+FShape[0]*i]:=AValue.Data[i];
  end;
end;

procedure TCustomTensorDouble.SetRow(index: integer; AValue: TCustomTensorDouble);
var i:integer;
begin
  Assert((AValue.Dimensions=1) and (AValue.FShape[0]=FShape[0]),'Tensor must be a vector');
  for i:=0 to AValue.Shape[0]-1 do begin
    Data[Index*FShape[0]+i]:=AValue.Data[i];
  end;

end;

function TCustomTensorDouble.AsArray2D(): TArray2d;
var y,x,r,c:integer;
begin
  Assert(Dimensions=2,'Tensor is not a 2D matrix');
  r:=FShape[1];c:=FShape[0];
  setLength(result,r);
  for y:=0 to r-1 do begin
    setLength(result[y],c);
    for x:=0 to c-1 do
      result[y][x]:=Data[x+y*c]
  end;
end;

function TCustomTensorDouble.AsArray3D(): TArray3d;
var z,y,x,  d,r,c:integer;   //depth, row, column
begin
  Assert(Dimensions=3,'Tensor is not a 3D matrix');
  d:=FShape[2];r:=FShape[1];c:=FShape[0];
  setLength(result,d);
  for z:=0 to d-1 do begin
    setLength(result[z],r);
    for y:=0 to r-1 do begin
      setLength(result[z][y],c);
      for x:=0 to c-1 do
        result[z][y][x]:=Data[x+y*c+z*r*c]
    end;
  end;
end;

function TCustomTensorDouble.GetColumn(index: integer): TCustomTensorDouble;
var i:integer;
begin
  Assert(Dimensions>1,'Tensor is not a matrix!');
  result.InitAs([FShape[1]]);
  for i:=0 to FShape[1]-1 do
    result.Data[i]:=Data[i*FShape[0]+Index]
end;

function TCustomTensorDouble.GetDimensions: integer;
begin
  result:=FShape.Count;
end;

function TCustomTensorDouble.GetRow(index: integer): TCustomTensorDouble;
begin
  Assert(Dimensions>1,'Tensor is not a matrix!');
  result.Init(copy(Data,index*FShape[0],FShape[0]));
end;

function TCustomTensorDouble.InitAs(const dShape: TIntegerDynArray):TCustomTensorDouble;
begin
  SetLength(Data,dShape.product);
  FShape:=copy(dShape);
  result:=Self
end;

//constructor TCustomTensorDouble.Create(const v: TArray1d;
//  const dShape: TIntegerDynArray);
//begin
//  init(v,dShape)
//end;

//constructor TCustomTensorDouble.Create(const v: TArray2d);
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

//class function TCustomTensorDouble.Create(): TCustomTensorDouble;
//begin
//
//end;

//destructor TCustomTensorDouble.Destroy;
//begin
//  setLength(Data,0);
//  inherited
//end;

function TCustomTensorDouble.Add(const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] + Vals.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.Add(const Vals:Double):TCustomTensorDouble;
var i:integer;
begin
  for i:=0 to Length(Self.Data) do
    Self.Data[i]:=Self.Data[i] + Vals;
  Result:=Self;
end;

function TCustomTensorDouble.Sub(const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] - Vals.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.Sub(const Vals:Double):TCustomTensorDouble;
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] - Vals;
  Result:=Self;
end;

function TCustomTensorDouble.Mul(const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] * Vals.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.Mul(const Vals:Double):TCustomTensorDouble;
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] * Vals;
  Result:=Self;
end;

function TCustomTensorDouble.&Div(const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] / Vals.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.&Div(const Vals:Double):TCustomTensorDouble;
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] / Vals;
  Result:=Self;
end;

function TCustomTensorDouble.Determinant(): Double;
var i,L:integer;
begin
  result:=0;
  L:=FShape[0];
  if L=2 then
    result:=Data[0]*Data[3]-Data[1]*Data[2]
  else
    begin
      for i:=0 to L-1 do
        if i mod 2=0 then
          result:=result+Data[i]*Self.Degrade(i,0).Determinant()
        else
          result:=result-Data[i]*Self.Degrade(i,0).Determinant();
    end;
end;

function TCustomTensorDouble.SubstractFrom(const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals.Data[i] - Self.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.SubstractFrom(const Vals:Double):TCustomTensorDouble;
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals - Self.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.DividedBy(const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Array size must match');
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals.Data[i] / Self.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.DividedBy(const Vals:Double):TCustomTensorDouble;
var i:integer;
begin
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Vals / Self.Data[i];
  Result:=Self;
end;

function TCustomTensorDouble.Degrade(const c, r: integer): TCustomTensorDouble;
var cc,rr,ccc,rrr,L:integer;
begin
  L:=FShape[0]-1 ;
  Result.InitAs([L,L]);
  for rr:=0 to FShape[0]-1 do
    for cc:=0 to FShape[0]-1 do
      if (cc<>c) and (rr<>r) then begin
        if cc>c then ccc:=cc-1 else ccc:=cc;
        if rr>r then rrr:=rr-1 else rrr:=rr;
        Result._Set(ccc,rrr,Get(cc,rr))
    end;
end;

procedure TCustomTensorDouble.Init( const v:TArray1d;
   dShape: TIntegerDynArray);
var L:integer;
begin
  L:=Length(v);
  if l=0 then exit;
  if not Assigned(dShape) then dShape:=[l];
  Assert(dShape.Count<=3 ,'Dimentions above 3 are not Accepted!');
  Assert(dShape.Product=l ,'Init array count must match shape summary '+dShape.ToString());
  FShape:=copy(dShape);
  SetLength(Data,L);
  for l:=0 to L-1 do Data[l]:=v[l]
end;

procedure TCustomTensorDouble.Init(const v: TArray2d);
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
      Data[j+i*c]:=v[i][j];
  FShape:=[c,r]
end;

function TCustomTensorDouble.Get(const x: integer): Double;
begin
  //if Dimensions=1 then
    result:=Data[x];
end;

function TCustomTensorDouble.Get(const x, y: integer): Double;
begin
  //if Dimensions=2 then
    result:=Data[x+y*FShape[0]]
end;

function TCustomTensorDouble.Get(const x, y, z: integer): Double;
begin
  //if Dimensions=3 then
    result:=Data[x+y*FShape[0]+z*FShape[0]*FShape[1]]
end;

procedure TCustomTensorDouble._Set(const x: integer;const val:Double);
begin
  //if Dimensions=1 then
    Data[x]:=val;
end;

procedure TCustomTensorDouble._Set(const x, y: integer;const val:Double);
begin
  //if Dimensions=2 then
    Data[x+y*FShape[0]]:=val
end;

procedure TCustomTensorDouble._Set(const x, y, z: integer;const val:Double);
begin
  //if Dimensions=3 then
    Data[x+y*FShape[0]+z*FShape[0]*FShape[1]]:=val
end;

//class function TCustomTensorDouble.Create(): TCustomTensorDouble;
//begin
//
//end;

function TCustomTensorDouble.uniform(maxVal: Double): TCustomTensorDouble;
var i:integer;
begin
 for i:=0 to Length(Data)-1 do
    Data[i]:=maxVal*random;
  result:=self
end;

function TCustomTensorDouble.uniform(maxVal: Integer): TCustomTensorDouble;
var i:integer;
begin
 for i:=0 to Length(Data)-1 do
    Data[i]:=random(maxVal);
  result:=self
end;

function TCustomTensorDouble.Transpose: TCustomTensorDouble;
var i,j:integer;
begin
  Assert(Length(FShape)=2,'Tensor must be a 2D Matrix');
  result.FShape:=[FShape[1],FShape[0]];
  SetLength(result.Data,Length(Data));
  for i:=0 to FShape[0]-1 do
    for j:=0 to FShape[1]-1 do
      Result._Set(j,i,Get(i,j))
end;

function TCustomTensorDouble.AsString: string;
var x,y,z:integer;
begin
  result:='';
  case Dimensions of
    1:Result:=TDoubleDynArray(Data).ToString();
    2:begin
      for y:=0 to Shape[1]-1 do
        Result:=Result+#13#10+Copy(TDoubleDynArray(Data),y*Shape[0],Shape[0]).ToString();
        delete(result,1,2);
        result:='['+result+']' ;
      end;
    3:;
  end;
;
end;

function TCustomTensorDouble.TypeSize: integer;
begin
  result:=SizeOf(Double)
end;

function TCustomTensorDouble.AsCharArray(): TCharArray;
begin

end;

function TCustomTensorDouble.AsIntegerArray(): TIntegerDynArray;
begin

end;

function TCustomTensorDouble.AsInt64Array(): TInt64DynArray;
begin

end;

function TCustomTensorDouble.AsSingleArray(): TSingleDynArray;
begin

end;

function TCustomTensorDouble.AsDoubleArray(): TDoubleDynArray;
begin

end;

function TCustomTensorDouble.AsCurrencyArray(): TCurrencyArray;
begin

end;

function TCustomTensorDouble.AsStringArray(const fmt: string): TStringDynArray;
begin

end;

function TCustomTensorDouble.AsDateTimeArray(): TDateTimeArray;
begin

end;

function TCustomTensorDouble.Checkerboard: TCustomTensorDouble;
var j,i,L:integer;
begin
  L:=FShape[0];
  result.InitAs(FShape);
  for j:=0 to L do
    for i:=0 to L-1 do begin
      if i+j mod 2 =0 then Result.Data[i]:=1
      else Result.Data[i]:=-1
  end;
end;

function TCustomTensorDouble.Cofactors: TCustomTensorDouble;
var i,j,L:integer;
begin
  L:=FShape[0];
  result.InitAs(FShape);
  for j:=0 to L-1 do
    for i:= 0 to L-1 do
    if i+j mod 2=0 then
      result._Set(i,j, Self.Degrade(i,j).Determinant())
    else
      Result._Set(i,j,-Self.Degrade(i,j).Determinant())

end;

function TCustomTensorDouble.Inverse: TCustomTensorDouble;
var det:double;
begin
  det:=Self.Determinant();
  Assert(det<>0,'Matrix inverse is not resolvable!');
  if FShape[0]=2 then begin
    result.initAs(FShape);
    result.Data[3]:=Data[0];
    result.Data[1]:=-Data[1];
    result.Data[2]:=-Data[2];
    result.Data[0]:=Data[3];
    result.&Div(det);
  end
  else
   result:=Cofactors.Transpose.&div(det);
end;

function TCustomTensorDouble.Multiply(const Tensor:TCustomTensorDouble):TCustomTensorDouble;
var i,j,k,xx,yy:integer;S:Double;
begin
  Assert(Length(FShape)<=2, 'Tensor must be a vector or a Matrix');                    //check here.............

  if Length(Tensor.FShape)=1 then
    Assert(Shape[0]=Tensor.FShape[0],'Tensor count must match '+IntToStr(Tensor.FShape[0]));

  if Length(Tensor.FShape)=2 then
    Assert(FShape[0]=Tensor.FShape[1],'Matrix rows must match '+IntToStr(Tensor.FShape[1]));

  if Tensor.Dimensions = 1 then
    begin
      Result.InitAs([FShape[1]]);
      for i:=0 to FShape[1]-1 do
        //for j:=0 to FShape[1]-1 do
        begin
          S:=0;
          for j:=0 to FShape[0]-1 do
            s:=s+Get(j,i)*Tensor.Get(j);
          Result._Set(i,S);
        end;
    end
  else begin
    Result.InitAs([Tensor.FShape[0],FShape[1]]);
    for yy:=0 to FShape[1]-1 do
      for xx:=0 to Tensor.FShape[0]-1 do begin
        s:=0;
        for i:=0 to FShape[0]-1 do
          s:=s+get(i,yy)*Tensor.Get(xx,i);
        result._set(xx,yy,s)
      end;

  end;
end;

class operator TCustomTensorDouble.+ (const Self:TCustomTensorDouble;const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] + Vals.Data[i];
end;

class operator TCustomTensorDouble.+ (const Self:TCustomTensorDouble;const Vals:Float):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data) do
    Result.Data[i]:=Self.Data[i] + Vals;
end;

class operator TCustomTensorDouble.- (const Self:TCustomTensorDouble;const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] - Vals.Data[i];
end;

class operator TCustomTensorDouble.- (const Self:TCustomTensorDouble;const Vals:Float):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] - Vals;
end;

class operator TCustomTensorDouble.* (const Self:TCustomTensorDouble;const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] * Vals.Data[i];
end;

class operator TCustomTensorDouble.* (const Self:TCustomTensorDouble;const Vals:Float):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] * Vals;
end;

class operator TCustomTensorDouble./ (const Self:TCustomTensorDouble;const Vals:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  Assert(Length(Self.Data)=Length(Vals.Data),'Tensor sizes must match');
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Self.Data[i] / Vals.Data[i];
end;

class operator TCustomTensorDouble./ (const Self:TCustomTensorDouble;const Vals:Float):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Self.Data[i]:=Self.Data[i] / Vals;
end;

class operator TCustomTensorDouble.+ (const Vals:Float;const Self:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals + Self.Data[i];
end;

class operator TCustomTensorDouble.* (const Vals:Float;const Self:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals * Self.Data[i];
end;

class operator TCustomTensorDouble.- (const Vals:Float;const Self:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals - Self.Data[i];
end;

class operator TCustomTensorDouble./ (const Vals:Float;const Self:TCustomTensorDouble):TCustomTensorDouble;
var i:integer;
begin
  SetLength(result.data,Length(Self.Data));
  Result.FShape:=copy(Self.FShape);
  for i:=0 to Length(Self.Data)-1 do
    Result.Data[i]:=Vals / Self.Data[i];
end;

class operator TCustomTensorDouble.:= (const Self:TCustomTensorDouble):string;
begin
  result:=Self.AsString
end;

class operator TCustomTensorDouble.:= (const Self:TArray2d):TCustomTensorDouble;
begin
  result.Init(Self)
end;

class operator TCustomTensorDouble.:= (const Self:TArray1d):TCustomTensorDouble;
begin
  result.Init(Self)
end;

end.

