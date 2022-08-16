unit complexarray;
{$macro on}
{.$undef fpc}
{$ifndef fpc}
  {$mode delphi}
{$else}
  {$mode objfpc}
{$endif}
{$H+}
{$ModeSwitch advancedrecords}
{$modeswitch typehelpers}

{.$define USE_AVX2}
{.$define use_lcl_complex}

interface
uses
  Classes, Types, SysUtils, Math,ArrayHelperCommon{$ifdef use_lcl_complex},ucomplex{$endif}
  {$ifdef USE_AVX2},oprs_simd{$endif}
  //{$ifdef USE_AVX2},pblas{$endif}
  {$ifdef USE_THREADS},oprs_multithread{$endif};

{$i ahdefines.inc}
type
  PPSingle=^PSingle;
  PPDouble=^PDouble;
  PPExtended=^PExtended;
  { TComplex }
  {$ifndef use_lcl_complex}
  {$ifdef fpc}generic{$endif} TComplex<T>=record
  //type _Complex=^TComplex;
  private

  public
    re:T;im:T;

    procedure add (const a:TComplex{$ifndef fpc}<T>{$endif});         overload;_inline
    procedure sub (const a:TComplex{$ifndef fpc}<T>{$endif});         overload;_inline
    procedure mul (const a:TComplex{$ifndef fpc}<T>{$endif});         overload;_inline
    procedure &div(const a:TComplex{$ifndef fpc}<T>{$endif});         overload;_inline
    procedure add (const a:Single);         overload;_inline
    procedure sub (const a:Single);         overload;_inline
    procedure mul (const a:Single);         overload;_inline
    procedure &div(const a:Single);         overload;_inline
    procedure add (const a:Double);         overload;_inline
    procedure sub (const a:Double);         overload;_inline
    procedure mul (const a:Double);         overload;_inline
    procedure &div(const a:Double);         overload;_inline
    function abs ()                : T;                _inline
    function arg ()                : T;                _inline
    procedure conj()                ;                  _inline
    procedure inv ()                ;                  _inline
    function det ()                : T;                _inline
    function mag ()                : T;                _inline
    procedure sqr ()               ;                   _inline
    procedure norm()                ;                   _inline
    procedure exp ()                ;                   _inline
    procedure ln ()                 ;                   _inline
    procedure sqrt()                ;                   _inline
    procedure pow(const a: TComplex{$ifndef fpc}<T>{$endif}) ;                    _inline
    procedure sin ()                 ;                   _inline
    procedure cos ()                 ;                   _inline
    procedure tan ()                ;                    _inline
    procedure cot ()                ;                    _inline
    procedure map(const rFrom,rTo,rStart,rEnd,iFrom,iTo,iStart,iEnd:T); _inline overload;
    procedure map(const rIntercept,rSlope,iIntercept,iSlope:T);         _inline overload;
    function ToString():string;
  public
    {$ifdef fpc}
    class operator :=(const a:T):TComplex;           overload;_inline
    class operator :=(const a:TComplex):string;      overload;_inline
    class operator :=(const a:array of T): TComplex; overload;_inline
    class operator +(const a,b:TComplex):TComplex;   overload;
    class operator -(const a,b:TComplex):TComplex;   overload;
    class operator -(const a: TComplex): TComplex;   overload;
    class operator *(const a,b:TComplex):TComplex;   overload;
    class operator *(const a:TComplex;const b:T):TComplex;   overload;
    class operator /(const a,b:TComplex):TComplex;   overload;
    class operator =(const a,b:TComplex):boolean;    overload;
    class operator **(const a,b:TComplex):TComplex;  overload;
    {$else}
    class operator Implicit(const a:T):TComplex<T>;           overload;_inline
    class operator Implicit(const a:TComplex<T>):string;      overload;_inline
    class operator Implicit(const a:array of T): TComplex<T>; overload;_inline
    class operator Add(const a,b:TComplex<T>):TComplex<T>;   overload;
    class operator Subtract(const a,b:TComplex<T>):TComplex<T>;   overload;
    class operator Subtract(const a: TComplex<T>): TComplex<T>;   overload;
    class operator Multiply(const a,b:TComplex<T>):TComplex<T>;   overload;
    class operator Divide(const a,b:TComplex<T>):TComplex<T>;   overload;
    class operator Equal(const a,b:TComplex<T>):boolean;    overload;

    class operator Add(const a:TComplex<T>;const b:Single):TComplex<T>;   overload;
    class operator Subtract(const a:TComplex<T>;const b:Single):TComplex<T>;   overload;
    class operator Multiply(const a:TComplex<T>;const b:Single):TComplex<T>;   overload;
    class operator Divide(const a:TComplex<T>;const b:Single):TComplex<T>;   overload;

    class operator Add(const a:TComplex<T>;const b:Double):TComplex<T>;   overload;
    class operator Subtract(const a:TComplex<T>;const b:Double):TComplex<T>;   overload;
    class operator Multiply(const a:TComplex<T>;const b:Double):TComplex<T>;   overload;
    class operator Divide(const a:TComplex<T>;const b:Double):TComplex<T>;   overload;

    class operator **(const a,b:TComplex<T>):TComplex<T>;  overload;
    {$endif}

    class function init(const rea,ima:T):TComplex{$ifndef fpc}<T>{$endif};static;
    class function vector(const theta, magn: T): TComplex{$ifndef fpc}<T>{$endif}; static;
    class function _i(): TComplex{$ifndef fpc}<T>{$endif};static;

  end;

  PPComplexF=^PComplexF;
  PComplexF=^ComplexF;
  PPComplexD=^PComplexD;
  PComplexD=^ComplexD;
  {$ifdef SUPPORT_EXTENDED}
  PPComplexE=^PComplexE;
  PComplexE=^ComplexE;
  {$endif}
  ComplexF={$ifdef fpc}specialize {$endif}TComplex<Single>;
  ComplexD={$ifdef fpc}specialize {$endif}TComplex<Double>;
  {$ifdef SUPPORT_EXTENDED}
  ComplexE={$ifdef fpc}specialize {$endif}TComplex<Extended>;
  {$endif}
  TComplexArrayF=array of ComplexF;
  TComplexArrayD=array of ComplexD;
  {$ifdef SUPPORT_EXTENDED}
  TComplexArrayE=array of ComplexE;
  {$endif}
const
  i_:ComplexF=(re:0;im:1);
  ii_:ComplexD=(re:0;im:1);
  _0:ComplexF=(re:0;im:0);
  _00:ComplexD=(re:0;im:0);
  {$else}
  i_:Complex=(re:0;im:1);
  {$endif}
type
  TComplexArrayArrayF=array of TComplexArrayF;
  TComplexArrayArrayD=array of TComplexArrayD;
  {$ifdef SUPPORT_EXTENDED}
  TComplexArrayArrayE=array of TComplexArrayE;
  {$endif}
  //PPComplex=^PComplex;
  //PComplex=^Complex;
  //Complex=ComplexF;
  //TComplexArray=array of Complex;
//  TComplexArrayArray=array of TComplexArray;
  TComplex2Ds=TComplexArrayArrayF;
  TComplex3Ds=array of TComplexArrayArrayF;
  TComplex2Dd=TComplexArrayArrayD;
  TComplex3Dd=array of TComplexArrayArrayD;
  {$ifdef SUPPORT_EXTENDED}
  TComplex2De=TComplexArrayArrayE;
  TComplex3De=array of TComplexArrayArrayE;
  {$endif}

  {$define Float:=Single}
  {$define PFloat:=PSingle}
  {$define TFloatArrayHelper:=TSingleArrayHelper}
  {$define TFloatDynArray:=TSingleDynArray}
  {$define TFloatArrayArray:=TSingleArrayArray}
  {$define Complex:=ComplexF}
  {$define PComplex:=PComplexF}
  {$define TComplexArrayHelper:=TComplexArrayHelperF}
  {$define TComplexArray:=TComplexArrayF}
  {$define TComplexArrayArray:=TComplexArrayArrayF}
  {$define TComplexArrayArrayHelper:=TComplexArrayArrayHelperF}
     {$I complexarrayh.inc}
  {$UnDef Complex}
  {$UnDef PComplex}
  {$UnDef TComplexArray}
  {$UnDef TComplexArrayHelper}
  {$UnDef TComplexArrayArray}
  {$UnDef TComplexArrayArrayHelper}
  {$UnDef Float}
  {$UnDef PFloat}
  {$UnDef TFloatArrayHelper}
  {$UnDef TFloatDynArray}
  {$UnDef TFloatArrayArray}

  {$define Float:=Double}
  {$define PFloat:=PDouble}
  {$define TFloatArrayHelper:=TDoubleArrayHelper}
  {$define TFloatDynArray:=TDoubleDynArray}
  {$define TFloatArrayArray:=TDoubleArrayArray}
  {$define Complex:=ComplexD}
  {$define PComplex:=PComplexD}
  {$define TComplexArrayHelper:=TComplexArrayHelperD}
  {$define TComplexArray:=TComplexArrayD}
  {$define TComplexArrayArray:=TComplexArrayArrayD}
  {$define TComplexArrayArrayHelper:=TComplexArrayArrayHelperD}
     {$I complexarrayh.inc}
  {$UnDef Complex}
  {$UnDef PComplex}
  {$UnDef TComplexArray}
  {$UnDef TComplexArrayHelper}
  {$UnDef TComplexArrayArray}
  {$UnDef TComplexArrayArrayHelper}
  {$UnDef Float}
  {$UnDef PFloat}
  {$UnDef TFloatArrayHelper}
  {$UnDef TFloatDynArray}
  {$UnDef TFloatArrayArray}

  {$ifdef SUPPORT_EXTENDED}
  {$define Float:=Extended}
  {$define PFloat:=PExtended}
  {$define TFloatArrayHelper:=TExtendedArrayHelper}
  {$define TFloatDynArray:=TExtendedDynArray}
  {$define TFloatArrayArray:=TExtendedArrayArray}
  {$define Complex:=ComplexE}
  {$define PComplex:=PComplexE}
  {$define TComplexArrayHelper:=TComplexArrayHelperE}
  {$define TComplexArray:=TComplexArrayE}
  {$define TComplexArrayArray:=TComplexArrayArrayE}
  {$define TComplexArrayArrayHelper:=TComplexArrayArrayHelperE}
     {$I complexarrayh.inc}
  {$UnDef Complex}
  {$UnDef PComplex}
  {$UnDef TComplexArray}
  {$UnDef TComplexArrayHelper}
  {$UnDef TComplexArrayArray}
  {$UnDef TComplexArrayArrayHelper}
  {$UnDef Float}
  {$UnDef PFloat}
  {$UnDef TFloatArrayHelper}
  {$UnDef TFloatDynArray}
  {$UnDef TFloatArrayArray}
  {$endif}

  function ctest:string;
      //FFTTwid:array [0..8191] of Complex;

{$define fft}
{$ifdef fft}
function rev(const a:longword;const N:integer):longword;
procedure brc(const dst:PComplexF;const src:PSingle;const N:integer);
procedure _fftct(const dst:PComplexF;const src:PSingle;const plan: PPComplexF; N:integer);  cdecl;
procedure _fft(const dst:PComplexF;const src:PSingle;const plan: PPComplexF; N:integer;const l:integer=0);// overload;
procedure _dft(const dst:PComplexF;const src:PSingle;const plan: PComplexF;const N:integer);cdecl;// overload;

procedure _fftSplit(const re_o, im_o, re_i, im_i:PSingle; N:integer;const plan:PPSingle;const l:integer=0); //overload
procedure _dftSplit(const re_o, im_o, re_i, im_i:PSingle;const N:integer;const plan:PPSingle); //overload;
{$endif}

var DFTThresholdPlanF:TComplexArrayF;
    DFTThresholdPlanSplitF:TSingleArrayArray;
    DFTThresholdPlanD:TComplexArrayD;
    DFTThresholdPlanSplitD:TDoubleArrayArray;

function ifthen(const term:boolean;const iftrue,iffalse:string):string;  overload;

implementation
var FFTBitRev: array[0..15] of TIntegerDynArray;

{$ifdef fft}
procedure _dftSplit(const re_o, im_o, re_i, im_i:PSingle;const N:integer;const plan:PPSingle);
var j,k:integer;
begin
  for k:=0 to N-1 do begin
    {$ifdef USE_AVX2}
    re_o[k]:=bulkDot_s(@re_i[0],@plan[0][k*N],N);
    im_o[k]:=bulkDot_s(@re_i[0],@plan[1][k*N],N);
    {$else}
    re_o[k]:=0;im_o[k]:=0;
    for j:=0 to N-1 do begin
      re_o[k]:=re_o[k]+re_i[j]*plan[0][k*N+j];
      im_o[k]:=im_o[k]+re_i[j]*plan[1][k*N+j]
      //dst[k].add(plan[k*N+j]*a[j])
    end;
    {$endif}
  end;
end;


procedure _fftSplit(const re_o, im_o, re_i, im_i:PSingle; N:integer;const plan:PPSingle;const l:integer=0);
var i,j:integer;
  FFTBtrflyR,FFTBtrflyI,FFTTwidR,FFTTmpR,FFTTwidI,FFTTmpI: array[0..$8*1024-1] of Single; tmp:single;
begin
  if n<=DFTThreshold then
    _dftSplit(re_o,im_o,re_i,im_i,N,@DFTThresholdPlanSplitF[0])
  else begin
    n:=N shr 1;

    {$ifdef USE_AVX2}
    interleave_s(@FFTBtrflyR[0],@FFTBtrflyR[N],@re_i[0],N shl 1);
    {$else}
    for i:=0 to N-1 do begin
      FFTBtrflyR[i]:=re_i[i*2];
      FFTBtrflyR[N+i]:=re_i[i*2+1];
    end;
    {$endif}
    _fftSplit(@FFTTmpR[0],@FFTTmpI[0],@FFTBtrflyR[0], @FFTBtrflyI[0], n, plan, l+1);
    _fftSplit(@re_o[n]   , @im_o[n]  ,@FFTBtrflyR[N], @FFTBtrflyI[N], n, Plan, l+1);
    {$ifdef USE_AVX2}
    bulkMulSplit_ccs(@FFTTwidR[0], @FFTTwidI[0],@Plan[l][0], @re_o[n], @Plan[l][n], @im_o[n], N );

    bulkAdd_s(@re_o[0],@FFTTmpR[0],@FFTTwidR[0],n);
    bulkAdd_s(@im_o[0],@FFTTmpI[0],@FFTTwidI[0],n);

    bulkSub_s(@re_o[n],@FFTTmpR[0],@FFTTwidR[0],n);
    bulkSub_s(@im_o[n],@FFTTmpI[0],@FFTTwidI[0],n);
    //bulkMul_ccs(@FFTTwid[0],@Plan[l][0],@dst[n],n);
    //bulkAdd_ccs(@dst[0],@FFTTmp[0],@FFTTwid[0],n);
    //bulkSub_ccs(@dst[n],@FFTTmp[0],@FFTTwid[0],n);
    {$else}
    for j:=0 to n-1 do begin
      FFTTwidR[j]:=Plan[l][j]*re_o[n+j] - Plan[l][n+j]*im_o[n+j];
      FFTTwidI[j]:=Plan[l][j]*im_o[n+j] + Plan[l][n+j]*re_o[n+j];
      //tmp:=mul(dst[n+j]);
    end;

    for j:=0 to n-1 do
      begin
        re_o[j]:=FFTTmpR[j]+FFTTwidR[j];
        im_o[j]:=FFTTmpI[j]+FFTTwidI[j];

        re_o[n+j]:=FFTTmpR[j]-FFTTwidR[j];
        im_o[n+j]:=FFTTmpI[j]-FFTTwidI[j];
        //dst[j]  :=FFTTmp[j]; dst[j].add(FFTTwid[j]);
        //dst[n+j]:=FFTTmp[j];dst[n+j].sub(FFTTwid[j]);
      end;
    {$endif}
  end;
end;


procedure _dft(const dst:PComplexF;const src:PSingle;const plan: PComplexF;const N:integer);  cdecl;
var j,k:integer;
begin
  for k:=0 to N-1 do
    {$ifdef USE_AVX2}
    bulkDot_cvs(@dst[k],@src[0],@plan[k*n],N);
    {.$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
    {$else}
    with dst[k] do begin
      dst[k]:=0;
      for j:=0 to N-1 do begin
        re:=re+src[j]*plan[k*N+j].re;
        im:=im+src[j]*plan[k*N+j].im
        //dst[k].add(plan[k*N+j]*a[j])
      end;
    end;
    {$endif}
  //{$endif}

end;
{.$undef USE_AVX2}
procedure _fft(const dst:PComplexF;const src:PSingle;const plan: PPComplexF; N:integer;const l:integer=0);
var i,j:integer;
  FFTBtrfly: array[0..$8*1024-1] of Single;
  FFTTwid,FFTTmp: array[0..$8*1024-1] of ComplexF;
begin
  if n>DFTThreshold then
  begin

    n:=N shr 1;

    for i:=0 to N-1 do begin
      FFTBtrfly[i]:=src[i*2];
      FFTBtrfly[N+i]:=src[i*2+1];
    end;

    _fft(@FFTTmp[0],@FFTBtrfly[0],Plan,n,l+1);
    _fft(@dst[n],@FFTBtrfly[N],Plan,n,l+1);
    {$ifdef USE_AVX2}
    bulkMul_ccs(@FFTTwid[0],@Plan[l][0],@dst[n],n);
    bulkAdd_ccs(@dst[0],@FFTTmp[0],@FFTTwid[0],n);
    bulkSub_ccs(@dst[n],@FFTTmp[0],@FFTTwid[0],n);
    {$else}
    Move(Plan[l][0],FFTTwid[0],SizeOf(Single)*n*4);
    for j:=0 to n-1 do
      //FFTTwid[j]:=Plan[l][j]*dst[n+j];
      FFTTwid[j].mul(dst[n+j]);
    for j:=0 to n-1 do
      begin
        dst[j]  :=FFTTmp[j]; dst[j].add(FFTTwid[j]);
        dst[n+j]:=FFTTmp[j];dst[n+j].sub(FFTTwid[j]);
      end;
    {$endif}
  end else
    _dft(dst,src,@DFTThresholdPlanF[0],N)
end;

function rev(const a:longword;const N:integer):longword;_inline
var i:integer;k:integer;
begin

  k:=1 shl (N-1);
  result:=0;
  for i:=0 to N-1 do
    result:=result or ((1 shl i) * ord(a and (k shr i)>0))
end;
{.$asmmode intel}
procedure brc(const dst:PComplexF;const src:PSingle;const N:integer);
var i,K:integer;
begin
  //asm
  //  BSF eax, N
  //  mov K,eax
  //end;
  k:=trunc(log2(N));
  for i:=0 to N-1 do
    //dst[rev(i,K)]:=src[i]
    dst[FFTBitRev[k][i]]:=src[i];
end;

// cooly tukey
procedure _fftct(const dst:PComplexF;const src:PSingle;const plan: PPComplexF; N:integer);   cdecl;
var i,k,m,nn,l,j:integer;
//  FFTBtrfly: {$ifdef USE_AVX2}array[0..$8*1024-1] of{$endif} Single;
  FFTTwid,FFTTmp: {$ifdef USE_AVX2}array[0..$8*1024-1] of{$endif} ComplexF;
begin

  //if n<=DFTThreshold then
  //  _dft(dst,src,@DFTThresholdPlanF[0],N)
  //else
  begin
//    brc(@dst[0],@src[0],N);
    l:=trunc(log2(N));
    //FillDWord(dst[0],N,0);
    for i:=0 to N-1 do
      dst[FFTBitRev[l][i]].re:=src[i];
    for i := 1 to l do  begin
        m := 1 shl i;
        nn := m shr 1;
        k := 0;
        while k< n-1 do begin
          {$ifdef USE_AVX2}
          //Move(dst[k],FFTTmp[0],SizeOf(ComplexF)*nn);
          //bulkMul_ccs(@FFTTwid[0],@Plan[l-i][0],@dst[k+nn],nn);
          //bulkAdd_ccs(@dst[k],@FFTTmp[0],@FFTTwid[0],nn);
          //bulkSub_ccs(@dst[k+nn],@FFTTmp[0],@FFTTwid[0],nn);

          bulkMul_ccs(@FFTTwid[0],@Plan[l-i][0],@dst[k+nn],nn);
          bulkSub_ccs(@dst[k+nn],@dst[k],@FFTTwid[0],nn);
          bulkAdd_ccs(@dst[k],@dst[k],@FFTTwid[0],nn);
          {$else}
          for j := 0 to nn - 1 do
            begin
              FFTTwid := plan[l-i][j] * dst[k + j + nn];
              //FFTTmp := dst[k + j];
              dst[k + j + nn] := dst[k + j] - FFTTwid   ;
              dst[k + j] := dst[k + j] + FFTTwid    ;
            end;
          {$endif}
          inc(k,m);
        end;

    end;
  end
end;

{$endif}
{$ifndef use_lcl_complex}
{ TComplex }

procedure TComplex{$ifndef fpc}<T>{$endif}.add(const a: TComplex{$ifndef fpc}<T>{$endif}) ;
begin
  Self.re:=Self.re+a.re;
  Self.im:=Self.im+a.im;
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.sub(const a: TComplex{$ifndef fpc}<T>{$endif}) ;
begin
  Self.re:=Self.re-a.re;
  Self.im:=Self.im-a.im;
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.mul(const a: TComplex{$ifndef fpc}<T>{$endif}) ;
var tmp:T;
begin

//{$if defined(USE_AVX2) and (SizeOf(Complex)=8)}
//    mul_ccs(@self,@self,@a)
//{.$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
//{$else}
  tmp:=re*a.re - Im*a.Im;
  Im:= re*a.im + Im*a.re ;
  Re:= tmp
//{$endif}
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.&div(const a: TComplex{$ifndef fpc}<T>{$endif});
var denom,tmp,r,i:T;
begin
  denom := a.re*a.re + a.im*a.im;
  r:=(self.re*a.re + self.im*a.im)/denom;
  self.im:=(self.im*a.re - self.re*a.im)/denom;
  self.re:=r;

  //if a.re<0 then r:=-a.re else r:=a.re;
  //if a.im<0 then i:=-a.im else i:=a.im;
  //
  //if ( r > i ) then begin
  //        tmp := a.im / a.re;
  //        denom := a.re + a.im * tmp;
  //        self.re := (self.re + self.im * tmp) / denom;
  //        self.im := (self.im - self.re * tmp) / denom;
  //end else begin
  //        tmp := a.re / a.im;
  //        denom := a.im + a.re * tmp;
  //        self.re := (self.im + self.re * tmp) / denom;
  //        self.im := (self.im * tmp - self.re) / denom;
  //end;
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.add(const a: Double);
begin
  re:=re+a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.sub(const a: Double);
begin
  re:=re-a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.mul(const a: Double);
begin
  re:=re*a;
  im:=im*a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.&div(const a: Double);
begin
  re:=re/a;
  IM:=IM/a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.add(const a: Single);
begin
  re:=re+a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.sub(const a: Single);
begin
  re:=re-a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.mul(const a: Single);
begin
  re:=re*a;
  im:=im*a
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.&div(const a: Single);
begin
  re:=re/a;
  IM:=IM/a
end;

function TComplex{$ifndef fpc}<T>{$endif}.abs(): T;
begin
  result:=system.sqrt(det)
end;

function TComplex{$ifndef fpc}<T>{$endif}.arg(): T;
begin
  result:=ArcTan2(im,re);
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.conj();
begin
  im:=-im
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.inv();
var denom:T;
begin
  denom := det();re:=re/denom;im:=-im/denom;
end;

function TComplex{$ifndef fpc}<T>{$endif}.det(): T;
begin
  result:=re*re + im*im
end;

function TComplex{$ifndef fpc}<T>{$endif}.mag(): T;
begin
  result:=system.sqrt(re*re+im*im)
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.sqr();
var tmp:T;
begin
  tmp :=re*re-im*im;
  im:=2*re*im;
  re:=tmp
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.norm();
var denom:T;
begin
  denom:=mag;
  re:=re/denom;
  im:=im/denom
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.exp();
var ex:T;
begin
  ex:=system.exp(re);
  re := ex * system.cos(im);
  im := ex * system.sin(im)
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.ln();
var tmp:T;
begin
  tmp := system.ln(mag());
  im := arctan2(im,re);
  re := tmp;
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.sqrt();
var root,q,r:T;
begin
  if (re<>0.0) or (im<>0.0) then begin
      if re<0 then r:=-re else r:=re;
      root := system.sqrt(0.5 * (r + mag()));
      q := im / (2.0 * root);
      if (re >= 0.0) then begin re := root;im := q end
      else if (im < 0.0 ) then begin re := -q;im := -root end
      else begin re:=  q;im :=  root end
  end;
end;


procedure TComplex{$ifndef fpc}<T>{$endif}.pow(const a:TComplex{$ifndef fpc}<T>{$endif});
begin
  ln();
  mul(a);
  exp();
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.cos();
var _re:T;
begin
  _re := system.cos(re) * math.cosh(im);
  im := -system.sin(re) * math.sinh(im);
  re := _re;
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.sin();
var _re:T;
begin
  _re := system.sin(re) * math.cosh(im);
  im := system.cos(re) * math.sinh(im);
  re :=_re;
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.tan();
var _cos:TComplex{$ifndef fpc}<T>{$endif};
begin
  _cos.re:=re;
  _cos.im:=im;
  _cos.cos();
  sin();
  &div(_cos);
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.cot();
var _sin:TComplex{$ifndef fpc}<T>{$endif};
begin
  _sin.re:=re;
  _sin.im:=im;
  _sin.sin();
  cos();
  &div(_sin);
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.map(const rFrom, rTo, rStart, rEnd, iFrom, iTo, iStart,iEnd: T);
begin
  re:=rStart+(re-rFrom)*(rEnd-rStart)/(rTo-rFrom);
  im:=iStart+(im-iFrom)*(iEnd-iStart)/(iTo-iFrom);

end;

procedure TComplex{$ifndef fpc}<T>{$endif}.map(const rIntercept,rSlope,iIntercept,iSlope:T);
begin
  re:=re*rSlope+rIntercept;
  im:=im*iSlope+iIntercept;
end;

function ifthen(const term:boolean;const iftrue,iffalse:string):string;
begin
  if term then result:=iftrue else result:=iffalse
end;

function TComplex{$ifndef fpc}<T>{$endif}.ToString(): string;
var sign,ii:string;
begin
  if self.im<0 then sign:='-' else if (self.im=0) or (self.re=0) then sign:='' else sign:='+';if (re<>0) and (im<>0) then sign:=' '+sign+' ';
  if self.im=1 then ii:='i' else if self.im=0 then ii:='' else ii:='%.3gi';
    result:=format('%s%s'+ii, [ifthen((self.re=0) and (self.im<>0) ,'',format('%.3g',[self.re])),  sign,  system.abs(valreal(self.im))]);
end;

{$ifdef fpc}
class operator TComplex.:=(const a: TComplex): string;
//var sign,ii:string;
begin
  result:=a.ToString();
  //if a.im<0 then sign:='-' else if a.im=0 then sign:='' else sign:='+';
  //if a.im=1 then ii:=' i' else if a.im=0 then ii:='' else ii:=' %.3g';
  //result:=format('%.3g %s'+ii, [a.re,sign,system.abs(valreal(a.im))]);
end;

class operator TComplex.:=(const a: T): TComplex;
begin
  result.re:=a;
  result.im:=0
end;

class operator TComplex.:=(const a:Array of T): TComplex;
begin
  result.re:=a[0];
  result.im:=a[1]
end;

class operator TComplex.+(const a, b: TComplex): TComplex;
begin
  result.re:=a.re+b.re;
  result.im:=a.im+b.im;

  //result:=a;
  //result.add(b)
end;

class operator TComplex.-(const a, b: TComplex): TComplex;
begin
  result.re:=a.re-b.re;
  result.im:=a.im-b.im;
  //result:=a;
  //result.sub(b)
end;

class operator TComplex.-(const a: TComplex): TComplex;
begin
  result.re:=-a.re;
  result.im:=-a.im;

end;

class operator TComplex.*(const a, b: TComplex): TComplex;
begin
  result.re:= a.re*b.re - a.im*b.im ;
  result.im:= a.re*b.im + a.im*b.re ;
  //result:=a;
  //result.mul(b)
end;

class operator TComplex.*(const a:TComplex;const b:T):TComplex;
begin
  result.re:= a.re*b;
  result.im:= a.im*b ;
end;

class operator TComplex./(const a, b: TComplex): TComplex;
var denom,tmp,r,i:T;
begin
  denom := b.re*b.re + b.im*b.im;
  result.re:=(a.re*b.re + a.im*b.im)/denom;
  result.im:=(a.im*b.re - a.re*b.im)/denom;

  //if b.re<0 then r:=-b.re else r:=b.re;
  //if b.im<0 then i:=-b.im else i:=b.im;
  //
  //if ( r > i ) then begin
  //        tmp := b.im / b.re;
  //        denom := b.re + b.im * tmp;
  //        result.re := (a.re + a.im * tmp) / denom;
  //        result.im := (a.im - a.re * tmp) / denom;
  //end else begin
  //        tmp := b.re / b.im;
  //        denom := b.im + b.re * tmp;
  //        result.re := (a.im + a.re * tmp) / denom;
  //        result.im := (a.im * tmp - a.re) / denom;
  //end;
end;

class operator TComplex.=(const a, b: TComplex): boolean;
begin
  result:=(a.re=b.re) and (a.im=b.im) ;
end;

class operator TComplex.**(const a, b: TComplex): TComplex;
begin
  result:=a;
  result.pow(b)
end;
{$else}
class operator TComplex<T>.Implicit(const a: TComplex<T>): string;
var sign:string;i:T;
begin
  i:=a.Im;
  if a.im<0 then begin sign:='-' ; i:=-a.Im  end
  else sign:='+';
  result:=format('%0.3g %s %.3gi', [a.re,sign,i]);
end;

class operator TComplex<T>.Implicit(const a: T): TComplex<T>;
begin
  result.re:=a;
  result.im:=0
end;

class operator TComplex<T>.Implicit(const a:Array of T): TComplex<T>;
begin
  result.re:=a[0];
  result.im:=a[1]
end;

class operator TComplex<T>.Add(const a, b: TComplex<T>): TComplex<T>;
begin
  result:=a;
  result.add(b)
end;

class operator TComplex<T>.Subtract(const a, b: TComplex<T>): TComplex<T>;
begin
  result:=a;
  result.sub(b)
end;

class operator TComplex<T>.Subtract(const a: TComplex<T>): TComplex<T>;
begin
  result.re:=-a.re;
  result.im:=-a.im;

end;

class operator TComplex<T>.Multiply(const a, b: TComplex<T>): TComplex<T>;
begin
  result:=a;
  result.mul(b)
end;

class operator TComplex<T>.Divide(const a, b: TComplex<T>): TComplex<T>;
begin
  result:=a;
  result.&div(b)
end;

class operator TComplex<T>.Equal(const a, b: TComplex<T>): boolean;
begin
  result:=(a.re=b.re) and (a.im=b.im) ;
end;

class operator TComplex<T>.Add(const a:TComplex<T>;const b: Single): TComplex<T>;
begin
  result:=a;
  result.add(b)
end;

class operator TComplex<T>.Subtract(const a:TComplex<T>;const b: Single): TComplex<T>;
begin
  result:=a;
  result.Sub(b)
end;

class operator TComplex<T>.Multiply(const a:TComplex<T>;const b: Single): TComplex<T>;
begin
  result:=a;
  result.Mul(b)
end;

class operator TComplex<T>.Divide(const a:TComplex<T>;const b: Single): TComplex<T>;
begin
  result:=a;
  result.&div(b)
end;

class operator TComplex<T>.Add(const a:TComplex<T>;const b: Double): TComplex<T>;
begin
  result:=a;
  result.add(b)
end;

class operator TComplex<T>.Subtract(const a:TComplex<T>;const b: Double): TComplex<T>;
begin
  result:=a;
  result.Sub(b)
end;

class operator TComplex<T>.Multiply(const a:TComplex<T>;const b: Double): TComplex<T>;
begin
  result:=a;
  result.Mul(b)
end;

class operator TComplex<T>.Divide(const a:TComplex<T>;const b: Double): TComplex<T>;
begin
  result:=a;
  result.&div(b)
end;

class operator TComplex<T>.**(const a, b: TComplex<T>): TComplex<T>;
begin
  result:=a;
  result.pow(b)
end;

{$endif}

class function TComplex{$ifndef fpc}<T>{$endif}.init(const rea, ima: T): TComplex{$ifndef fpc}<T>{$endif};
begin
  result.re:=rea;result.im:=ima
end;

class function TComplex{$ifndef fpc}<T>{$endif}.vector(const theta, magn: T): TComplex{$ifndef fpc}<T>{$endif};
begin
  result.re:=system.cos(theta)*magn;
  result.im:=system.sin(theta)*magn;
end;

class function TComplex{$ifndef fpc}<T>{$endif}._i():TComplex{$ifndef fpc}<T>{$endif};
begin
  result.re:=0;result.im:=1
end;

{$endif}

{$define Float:=Single}
{$define PFloat:=PSingle}
{$define TFloatArrayHelper:=TSingleArrayHelper}
{$define TFloatDynArray:=TSingleDynArray}
{$define TFloatArrayArray:=TSingleArrayArray}
{$define Complex:=ComplexF}
{$define PComplex:=PComplexF}
{$define TComplexArrayHelper:=TComplexArrayHelperF}
{$define TComplexArray:=TComplexArrayF}
{$define TComplexArrayArray:=TComplexArrayArrayF}
{$define TComplexArrayArrayHelper:=TComplexArrayArrayHelperF}
   {$I complexarrayimp.inc}
{$UnDef Complex}
{$UnDef PComplex}
{$UnDef TComplexArray}
{$UnDef TComplexArrayHelper}
{$UnDef TComplexArrayArray}
{$UnDef TComplexArrayArrayHelper}
{$UnDef Float}
{$UnDef PFloat}
{$UnDef TFloatArrayHelper}
{$UnDef TFloatDynArray}
{$UnDef TFloatArrayArray}


{$define Float:=Double}
{$define PFloat:=PDouble}
{$define TFloatArrayHelper:=TDoubleArrayHelper}
{$define TFloatDynArray:=TDoubleDynArray}
{$define TFloatArrayArray:=TDoubleArrayArray}
{$define Complex:=ComplexD}
{$define PComplex:=PComplexD}
{$define TComplexArrayHelper:=TComplexArrayHelperD}
{$define TComplexArray:=TComplexArrayD}
{$define TComplexArrayArray:=TComplexArrayArrayD}
{$define TComplexArrayArrayHelper:=TComplexArrayArrayHelperD}
   {$I complexarrayimp.inc}
{$UnDef Complex}
{$UnDef PComplex}
{$UnDef TComplexArray}
{$UnDef TComplexArrayHelper}
{$UnDef TComplexArrayArray}
{$UnDef TComplexArrayArrayHelper}
{$UnDef Float}
{$UnDef PFloat}
{$UnDef TFloatArrayHelper}
{$UnDef TFloatDynArray}
{$UnDef TFloatArrayArray}

{$ifdef SUPPORT_EXTENDED}
{$define Float:=Extended}
{$define PFloat:=PExtended}
{$define TFloatArrayHelper:=TExtendedArrayHelper}
{$define TFloatDynArray:=TExtendedDynArray}
{$define TFloatArrayArray:=TExtendedArrayArray}
{$define Complex:=ComplexE}
{$define PComplex:=PComplexE}
{$define TComplexArrayHelper:=TComplexArrayHelperE}
{$define TComplexArray:=TComplexArrayE}
{$define TComplexArrayArray:=TComplexArrayArrayE}
{$define TComplexArrayArrayHelper:=TComplexArrayArrayHelperE}
   {$I complexarrayimp.inc}
{$UnDef Complex}
{$UnDef PComplex}
{$UnDef TComplexArray}
{$UnDef TComplexArrayHelper}
{$UnDef TComplexArrayArray}
{$UnDef TComplexArrayArrayHelper}
{$UnDef Float}
{$UnDef PFloat}
{$UnDef TFloatArrayHelper}
{$UnDef TFloatDynArray}
{$UnDef TFloatArrayArray}
{$endif}

function ctest:string;
//var a,a1,a2:ComplexF;
//    b,b1,b2:ComplexD;
begin
  //a:=5+3*i_;
  //a.add(2);
  //a1:=-a*i_;
  //result:=a;
  //result:=result+' , '+string(a1)
end;

var i,j:integer;
initialization
  DFTThresholdPlanF:=TComplexArrayF.PlanDFT(DFTThreshold);
  TComplexArrayF.PlanDFT(DFTThresholdPlanSplitF,DFTThreshold);
  DFTThresholdPlanD:=TComplexArrayD.PlanDFT(DFTThreshold);
  TComplexArrayD.PlanDFT(DFTThresholdPlanSplitD,DFTThreshold);
  for i:= 0 to High(FFTBitRev) do begin
    setLength(FFTBitRev[i],1 shl i);
    for j:=0 to (1 shl i)-1 do
      FFTBitRev[i][j]:=rev(j,i);
  end

end.

