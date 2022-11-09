unit ArrayHelperCommon;

{$mode objfpc}{$H+} {$ModeSwitch nestedprocvars}

interface

uses
  Classes, Types, SysUtils;
type

  TVariantArray=array of variant;
  TVariantArrayArray=array of TVariantArray;
  TByteArrayArray=array of TByteDynArray;
  TShortArrayArray=array of TShortIntDynArray;
  TIntegerArrayArray=array of TIntegerDynArray;
  TInt64ArrayArray=array of TInt64DynArray;
  TSingleArrayArray=array of TSingleDynArray;
  TDoubleArrayArray=array of TDoubleDynArray;
  TExtendedArrayArray=array of TExtendedDynArray;
  TCurrencyArrayArray=array of TCurrencyArray;
  TCompArrayArray=array of TCompDynArray;
  TStringArrayArray=array of TStringDynArray;

  //TProcData=procedure(const opt:pointer;const Id, Stride,Count:integer);
  //TProcFFF=procedure(const dst,a,b:pSingle;const count:integer);
  //TProcDDD=procedure(const dst,a,b:pDouble;const count:integer);
  //TProcFFV=procedure(const dst,a:pSingle;const b:Single;const count:integer);
  //TProcDDV=procedure(const dst,a:pDouble;const b:Double;const count:integer);
  //TFuncFFV=function(const dst,a:pSingle;const count:integer):single;
  //TFuncDDV=function(const dst,a:pDouble;const count:integer):Double;

  TDateTimeArray= array of TDateTime;
  {$ifdef fpc}generic{$endif} TReduceCallback<T> = function(const a,b:T;const i:integer;const arr:array of T):T;
  {$ifdef fpc}generic{$endif} TReduceCallbackNested<T> = function(const a,b:T;const i:integer;const arr:array of T):T is Nested;
  {$ifdef fpc}generic{$endif} TSimpleReduceCallback<T>=function(const a,b:T):T;
  {$ifdef fpc}generic{$endif} TSimpleReduceCallbackNested<T>=function(const a,b:T):T is nested;
  {$ifdef fpc}generic{$endif} TComparefunc<T> = function(const a,b:T):integer ;
  {$ifdef fpc}generic{$endif} TComparefuncNested<T> = function(const a,b:T):integer is nested;
  {$ifdef fpc}generic{$endif} TMapCallBack<T>=function (const a:T;i:Integer;Arr:array of T):T;
  {$ifdef fpc}generic{$endif} TMapCallBackNested<T>=function (const a:T;i:Integer;Arr:array of T):T is nested;
  {$ifdef fpc}generic{$endif} TMapCallBackR<T,R>=function (const a:T;i:Integer;Arr:array of T):R;
  {$ifdef fpc}generic{$endif} TMapCallBack2<T>=function (const a:T;i:Integer;Arr:array of T):Double;
  {$ifdef fpc}generic{$endif} TSimpleMapCallback<T>=function (a:T):T;
  {$ifdef fpc}generic{$endif} TSimpleMapCallbackNested<T>=function (a:T):T is Nested;
  {$ifdef fpc}generic{$endif} TConvertCallback<T,R>=function (const a:T):R;
  {$ifdef fpc}generic{$endif} TSimpleFilterCallback<T>=function (const a:T):boolean;
  {$ifdef fpc}generic{$endif} TSimpleFilterCallbackNested<T>=function (const a:T):boolean is Nested;
  {$ifdef fpc}generic{$endif} TSIMDMap<PT>=procedure (const a:PT;const C:PInteger;const L:integer);
  {$ifdef fpc}generic{$endif} TSimpleMapCallbackComplex<T>=function (a:T):Double;
  {$ifdef fpc}generic{$endif} TMapCallbackVar<T>=function (const a:T;const i:Integer; Arr:array of T):Variant;
  {$ifdef fpc}generic{$endif} TFilterCallback<T,PT>=function (const a:T;const i:Integer; Arr:PT):boolean;
  {$ifdef fpc}generic{$endif} TFilterCallbackNested<T,PT>=function (const a:T;const i:Integer; Arr:PT):boolean is nested;
  TMapCallbackSingle={$ifdef fpc}specialize{$endif} TMapCallback<Single>;
  TMapCallbackDouble={$ifdef fpc}specialize{$endif} TMapCallback<Double>;
  {$ifdef fpc}generic{$endif} function _Compare<T>(const a,b:T):integer;
  {$ifdef fpc}generic{$endif} function _BinSearch<T,PT>(const Arr:PT;const Val:T; R:integer; const Compare:{$ifdef fpc}specialize{$endif} TComparefunc<T>):integer;          overload;
  {$ifdef fpc}generic{$endif} function _BinSearch<T,PT>(const Arr:PT;const Val:T; R:integer; Compare:{$ifdef fpc}specialize{$endif} TComparefuncNested<T> =nil):integer;     overload;
  {$ifdef fpc}generic{$endif} procedure _QuickSort<T,PT>(const Arr: PT; L, R : Longint;const Descending:boolean; const Compare: {$ifdef fpc}specialize{$endif} TComparefunc<T>); inline ;
  {$ifdef fpc}generic{$endif} procedure _Reverse<T,PT>(const Arr: PT; const aCount: Longint); inline ;

const
  PIx2=3.1415926535897932384626433*2;
  Log2E=1.4426950408889634;
  SqrtPIx2=sqrt(PIx2);
  {$if defined(USE_AVX2)}
  DFTThreshold=$20;

  {$else}
  DFTThreshold=$8;
  {$endif}
{ some window functions :  https://en.wikipedia.org/wiki/Window_function }
function windowHannSingle(const a:Single;const i:integer;Arr:array of Single):Single;
function windowHammingSingle(const a:Single;const i:integer;Arr:array of Single):Single;
{$ifdef fpc}generic{$endif} function windowHamming<T>(const a:T;const i:integer;Arr:array of T):T;
{$ifdef fpc}generic{$endif} function windowGaussian<T>(const a:T;const i:integer;Arr:array of T):T;
{$ifdef fpc}generic{$endif} function windowConfinedGaussian<T>(const a:T;const i:integer;Arr:array of T):T;
{$ifdef fpc}generic{$endif} function windowKaiser<T>(const a:T;const i:integer;Arr:array of T):T;
{$ifdef fpc}generic{$endif} function windowDolphChebyshev<T>(const a:T;const i:integer;Arr:array of T):T;
const
{$ifdef USE_AVX2}
   useAVX2:boolean=true;
{$else}
   useAVX2:boolean=false;
{$endif}
{$ifdef USE_THREADS}
   useThreads:boolean=true;
{$else}
   useThreads:boolean=false;
{$endif}

function CountLeadingZeros( x:UInt32):integer;
function CountTrailingZeros( x:UInt32):integer;
function CountBitsSet(x:UInt32):integer;
function BitReverse(x:Uint32):UInt32;
function HighestBitSet(const x:Uint32):integer;
{$ifdef fpc}generic{$endif} procedure BitsShiftRight<PT>(const bits:PT; const offset,N:integer);
{$ifdef fpc}generic{$endif} procedure BitsReverse<T,PT>(const bits:PT; const padding, N : integer);

implementation

{$ifdef fpc}generic{$endif} function _Compare<T>(const a,b:T):integer;
begin
 result:=1;
 if a=b then
   result:=0
 else
   if a<b then
   result:=-1
   //result:=b-a
end;

//  slightly modified from https://graphics.stanford.edu/~seander/bithacks.html
//  (NOTE : some listed alogrithms are buggy and corrected here)
function CountLeadingZeros( x:UInt32):integer;{$ifdef CPUX86_64} assembler;nostackframe;inline;{$AsmMode Intel}asm lzcnt eax, x end;{$else}
begin
	if (x = 0) then	exit(32);
	result := 0;
	if (x and $FFFF0000) = 0 then begin result := result + 16; x := x shl 16 end;
	if (x and $FF000000) = 0 then begin result := result + 8 ; x := x shl 8 end;
	if (x and $F0000000) = 0 then begin result := result + 4 ; x := x shl 4 end;
	if (x and $C0000000) = 0 then begin result := result + 2 ; x := x shl 2 end;
	if (x and $80000000) = 0 then begin result := result + 1 ; end;
end ;
{$endif}

function CountTrailingZeros( x:UInt32):integer;{$ifdef CPUX86_64} assembler;nostackframe;inline;{$AsmMode Intel}asm tzcnt eax, x end;{$else}
begin
  result := 32;
  x :=x and -int32(x);
  if x>0 then dec(result);
  if x and $0000FFFF > 0 then result := result - 16;
  if x and $00FF00FF > 0 then result := result - 8;
  if x and $0F0F0F0F > 0 then result := result - 4;
  if x and $33333333 > 0 then result := result - 2;
  if x and $55555555 > 0 then result := result - 1;
end;
{$endif}

function BitReverse(x:Uint32):UInt32;
begin
  //k:=1 shl (N-1);
  //result:=0;
  //for i:=0 to N-1 do
  //  result:=result or ((1 shl i) * ord(a and (k shr i)>0))

 x := ((x shr 1) and $55555555) or ((x and $55555555) shl 1);
 x := ((x shr 2) and $33333333) or ((x and $33333333) shl 2);
 x := ((x shr 4) and $0F0F0F0F) or ((x and $0F0F0F0F) shl 4);
 x := ((x shr 8) and $00FF00FF) or ((x and $00FF00FF) shl 8);
 x := (x shr 16) or (x shl 16);
 result:= x;
end;

function CountBitsSet(x:UInt32):integer;{$ifdef CPUX86_64} assembler;nostackframe;inline;{$AsmMode Intel}asm popcnt eax, x end;{$else}

// // the remarked from bithack page implemenation shows miss calculations and bugs, so replaced with the naive one
//v = v - ((v >> 1) & 0x55555555);                    // reuse input as temporary
//v = (v & 0x33333333) + ((v >> 2) & 0x33333333);     // temp
//c = ((v + (v >> 4) & 0xF0F0F0F) * 0x1010101) >> 24; // count
begin
  result:=0;
  while x>0 do begin
    x := x and (x - 1);// clear the least significant bit set
    inc(result)
  end;
end;
{$endif}

function HighestBitSet(const x:Uint32):integer;{$ifdef CPUX86_64} assembler;nostackframe;inline;{$AsmMode Intel}asm bsr eax, x end;{$else}
begin
  result := 31 - CountLeadingZeros(x);
end;
{$endif}


{$ifdef fpc}generic{$endif} procedure BitsShiftRight<PT>(const bits:PT; const offset,N:integer);
var leftOffset, i:integer;
begin
  assert(offset < sizeof(PT^) * 8);
  if (offset = 0) or (N=0) then
  	exit;
  leftOffset := sizeof(PT^) * 8 - offset;
  for i := 0 to N - 2 do
  	bits[i] := (bits[i] shr offset) or (bits[i + 1] shl leftOffset);
  bits[n-1] := bits[n-1] shr offset;
end;

// reverse a whole array of bits. padding is the number of 'dummy' bits at the end of the array
{$ifdef fpc}generic{$endif} procedure BitsReverse<T,PT>(const bits:PT; const padding, N : integer);
var first,last:integer; v:T;
begin
  assert(sizeof(PT^) = sizeof(uint32), 'Reverse only implemented for 32 bit types');

  // reverse all int's first (reversing the ints in the array and the bits in the ints at the same time)
  first :=0;  last := N-1;
  while first < last do begin
  	V := bits[first];
  	bits[first] := BitReverse(Bits[last]);
  	Bits[last]  := BitReverse(V);
          inc(first);
          dec(last)
  end;
  if first = last then
  	Bits[last] := BitReverse( Bits[last]);

  // now correct the int's if the bit size isn't a multiple of 32
  {$ifdef fpc}specialize{$endif} BitsShiftRight<PT>(bits, padding, N);
end;

function windowHammingSingle(const a:Single;const i:integer;Arr:array of Single):Single;
const a0=25/46;a1=1-a0;
var  N:integer;
begin
  N:=Length(Arr);
  result:=a*(a0-a1*cos(PIx2*i/N))
end;

function windowHannSingle(const a:Single;const i:integer;Arr:array of Single):Single;
var N:integer;
begin
  N:=Length(Arr);
  result:=a*0.5*(1-cos(PIx2*i/N))
end;

{$ifdef fpc}generic{$endif} function windowHamming<T>(const a:T;const i:integer;Arr:array of T):T;
const a0=25/46;a1=1-a0;  //a0 = 0.53836 ; a1 = 0.46164;
var  N:integer;
begin
  N:=Length(Arr);
  result:=a*(a0-a1*cos(PIx2*i/N))
end;
{$ifdef fpc}generic{$endif} function windowGaussian<T>(const a:T;const i:integer;Arr:array of T):T;
begin
  writeln('');
  raise Exception.Create('Funtion is not yet implemented, please check the updates.');
end;
{$ifdef fpc}generic{$endif} function windowConfinedGaussian<T>(const a:T;const i:integer;Arr:array of T):T;
begin
 writeln('');
 raise Exception.Create('Funtion is not yet implemented, please check the updates.');

end;
{$ifdef fpc}generic{$endif} function windowKaiser<T>(const a:T;const i:integer;Arr:array of T):T;
begin
 writeln('');
 raise Exception.Create('Funtion is not yet implemented, please check the updates.');

end;
{$ifdef fpc}generic{$endif} function windowDolphChebyshev<T>(const a:T;const i:integer;Arr:array of T):T;
begin
 writeln('');
 raise Exception.Create('Funtion is not yet implemented, please check the updates.');

end;


{$ifdef fpc}generic{$endif} function _BinSearch<T,PT>(const Arr:PT;const Val:T; R:integer; Compare:{$ifdef fpc}specialize{$endif} TComparefunc<T>):integer;
var
  L, I: Integer;
  CompareRes: PtrInt;isFound:boolean;
begin
  isFound := false;
  result:=-1;
  // Use binary search.
  L := 0;
  R := R - 1;
  while (L<=R) do
  begin
    I := L + (R - L) shr 1;
    CompareRes := Compare(Val, Arr[I]);
    if (CompareRes>0) then
      L := I+1
    else begin
      R := I-1;
      if (CompareRes=0) then begin
         isFound := true;
//         if (Duplicates<>dupAccept) then
            L := I; // forces end of while loop
      end;
    end;
  end;
  if isFound then result := L else result:=-L-1;
end;

{$ifdef fpc}generic{$endif} function _BinSearch<T,PT>(const Arr:PT;const Val:T; R:integer; Compare:{$ifdef fpc}specialize{$endif} TComparefuncNested<T>):integer;
var
  L, I: Integer;
  CompareRes: PtrInt;isFound:boolean;
  function cmp(const a,b:T):integer;
  begin
    result:=1;
    if a=b then
      result:=0
    else
      if a<b then
      result:=-1
  end;
begin
  isFound := false;
  result:=-1;
  if not assigned(Compare) then
    Compare:={$ifdef fpc}@{$endif}cmp;
  // Use binary search.
  L := 0;
  R := R - 1;
  while (L<=R) do
  begin
    I := L + (R - L) shr 1;
    CompareRes := Compare(Val, Arr[I]);
    if (CompareRes>0) then
      L := I+1
    else begin
      R := I-1;
      if (CompareRes=0) then begin
         isFound := true;
//         if (Duplicates<>dupAccept) then
            L := I; // forces end of while loop
      end;
    end;
  end;
  if isFound then result := L else result:=-L-1;
end;


{$ifdef fpc}generic{$endif} procedure _QuickSort<T,PT>(const Arr: PT; L, R : Longint; const Descending:boolean;const Compare: {$ifdef fpc}specialize{$endif} TComparefunc<T>); inline ;
var I,J ,neg :integer;
    P, Q :T;
begin
 //if not Assigned(Compare) then Compare:=@{$ifdef fpc}specialize{$endif}_Compare<T>;
 neg:={$ifdef fpc}specialize{$endif} ifthen<integer>(descending,-1,1);
 repeat
   I := L;
   J := R;
   P := Arr[ (L + R) div 2 ];
   repeat
     while neg*Compare(P, Arr[i]) > 0 do
       I := I + 1;
     while neg*Compare(P, Arr[J]) < 0 do
       J := J - 1;
     If I <= J then
     begin
       Q := Arr[I];
       Arr[I] := Arr[J];
       Arr[J] := Q;
       I := I + 1;
       J := J - 1;
     end;
   until I > J;
   if J - L < R - I then
   begin
     if L < J then
       {$ifdef fpc}specialize{$endif} _QuickSort<T,PT>(Arr, L, J, Descending, Compare);
     L := I;
   end
   else
   begin
     if I < R then
       {$ifdef fpc}specialize{$endif} _QuickSort<T,PT>(Arr, I, R, Descending, Compare);
     R := J;
   end;
 until L >= R;
end;

{$ifdef fpc}generic{$endif} procedure _Reverse<T,PT>(const Arr: PT; const aCount: Longint);
var V:T;i,j:Integer;   a,b:boolean;
begin
  i:=0;j:=aCount-1;
  while i<j do begin
    V:=Arr[j];
    Arr[j]:=Arr[i];
    Arr[i]:=V;
    inc(i);
    dec(j)
  end;
end;

initialization

end.

