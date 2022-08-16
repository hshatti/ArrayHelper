unit blas_u;

{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}{$ModeSwitch nestedprocvars}
{$macro on}
{$define _inline:=inline;}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Grids, StrUtils, Types, hirestimer, Math, ArrayHelper, oprs_simd
  {$if defined(USE_MKL)}
    ,mkl_types ,mkl_cblas, mkl_blas, mkl_vml, mkl_dfti, mkl_service
  {$elseif defined(USE_OPENBLAS)}
  ,openblas{$endif}, steroids;

type

{$ifdef fpc}generic{$endif} TComplex<T>=record
  //type _Complex=^TComplex;

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
  ComplexF={$ifdef fpc}specialize {$endif}TComplex<Single>;
  ComplexD={$ifdef fpc}specialize {$endif}TComplex<Double>;
  TComplexArrayF=array of ComplexF;
  TComplexArrayD=array of ComplexD;

const
  i_:ComplexF=(re:0;im:1);
  ii_:ComplexD=(re:0;im:1);
  _0:ComplexF=(re:0;im:0);
  _00:ComplexD=(re:0;im:0);

type
  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Splitter1: TSplitter;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private

  public

  end;




var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TComplex<> }
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
  tmp:=re*a.re - Im*a.Im;
  Im:= re*a.im + Im*a.re ;
  Re:= tmp
end;

procedure TComplex{$ifndef fpc}<T>{$endif}.&div(const a: TComplex{$ifndef fpc}<T>{$endif});
var denom,tmp,r,i:T;
begin
  denom := a.re*a.re + a.im*a.im;
  r:=(self.re*a.re + self.im*a.im)/denom;
  self.im:=(self.im*a.re - self.re*a.im)/denom;
  self.re:=r;
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


function SameValue(const aa,bb:PSingle;const N:integer=0;const epsilon:single=1e-3):integer; overload;
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
  result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'%s[%s]'+LineEnding,[oprstr,factor,ifthen(Count=0,Length(a),Count),tp,ts,ifthen(comp>-1,'@Index: '+comp.toString),ifthen(comp=-1,'OK','FAIL('+a[comp].ToString()+', '+b[comp].ToString()+')')]);
end;

function LogStr(oprStr:string;factor:double;Count:integer;tp,ts:double;a,b:TDoubleDynArray):string;overload;
var comp:integer;
begin
  comp := SameValue(PDouble(a),PDouble(b),ifthen(Count=0,Length(a),Count));
  result:= format('[%s]'#9'%f'#9'[%d]'#9'[%.0n / %.0n]nSec'#9'%s[%s]'+LineEnding,[oprstr,factor,ifthen(Count=0,Length(a),Count),tp,ts,ifthen(comp>-1,'@Index: '+comp.ToString),ifthen(comp=-1,'OK','FAIL('+a[comp].ToString()+', '+b[comp].ToString()+')')]);
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


{$asmmode intel}

procedure axpy(const s:Single; const b,c:PSingle;const N:integer);
//begin
//  bulkAXPY_s(c,b,c,NN,@s)
//end;

assembler;nostackframe;
const RegSize=$20;
const sz=SizeOf(s);
const elements=RegSize div sz;
const shifter = BsrByte(elements);
//begin
{  for i:=0 to NN-1 do
    c[i]:=s*b[i]+c[i]
}
  asm
    vbroadcastss ymm0, s
    xor rcx, rcx
    mov eax, N
    shr rax, shifter    // N div 8
    jz @skipL1
  @L1:
    //    vmovups ymm2, ymmword ptr [b+rcx*sz]
    vmovups ymm1, ymmword ptr [c+rcx*sz]
    vfmadd231ps ymm1, ymm0, ymmword ptr [b+rcx*sz]
    //vmulps  ymm3, ymm0, ymm2
    //vaddps  ymm1, ymm1, ymm3
    vmovups ymmword ptr [c+rcx*sz], ymm1
    //vmovups ymmword ptr [c+2*RegSize+rcx*sz], ymm3
    //vmovups ymmword ptr [c+3*RegSize+rcx*sz], ymm4
    lea rcx, [rcx+elements]
    dec rax
    jnz @L1
 @skipL1:
    mov eax, N
    and rax, elements - 1    // N mod 8
    jz @done
    vzeroupper
  @L2:
   //    vmovss  xmm2, dword ptr [b+rcx*sz]
    vmovss  xmm1, dword ptr [c+rcx*sz]
    vfmadd231ss xmm1, xmm0, dword ptr [b+rcx*sz]
    //vmulss  xmm3, xmm0, xmm2
    //vaddss  xmm1, xmm1, xmm3
    vmovss  dword ptr [c+rcx*sz], xmm1
    inc rcx
    dec rax
    jnz @L2
  @done:

  end;
//end;

procedure _gemm(const _start,_end:integer;const p:PPointer); inline;
var y,w,i:Integer ;
begin
  w:=PInteger(p[0])^;
//  writeln('[',_start,' , ',_end,']') ;
  for y:=_start to _end do
    for i:=0 to w-1 do
      axpy(PSingle(p[1])[y*w+i], @PSingle(p[2])[i*w], @PSingle(p[3])[y*w],w)
      //bulkAXPY_s(@PSingle(p[3])[y*w],@PSingle(p[2])[i*w],@PSingle(p[3])[y*w] ,W ,@PSingle(p[1])[y*w+i]);
      //cblas_saxpy(w,PSingle(p[1])[y*w+i],@PSingle(p[2])[i*w],1,@PSingle(p[3])[y*w] ,1);
      //for x:=0 to w-1 do
      //  PSingle(p[3])[y*w+x]+=PSingle(p[1])[y*w+i]*PSingle(p[2])[i*w+x];

end;

function dotest(pa: integer): string;

const N:integer=$800000+24+3; F=5;var W:integer;
var
  i,j,k,l,stride,x,y:int64;
  a,b,c,d:TSingleDynArray;ad,bd,cd,dd:TDoubleDynArray;
  ac,bc,cc,dc:TComplexArrayF;
  az,bz,cz,dz:TComplexArrayD;
  zs1,zs2:ComplexF;
  zd1,zd2:ComplexD;

  s1,s2:Single; d1,d2:Double;
  t1,t2,t3:uInt64;vals,vals2:single; vald,vald2:double;

begin
  w:=trunc(SQRT(N));
  result:='';
  {$ifdef USE_AVX2}
    vals:=random()*3;
    vald:=Random()*3;
    vals2:=random()*3;
    vald2:=Random()*3;
    setLength(a,N);
    setLength(b,N);
    setLength(c,N);
    setLength(d,N);
    setLength(ad,N);
    setLength(bd,N);
    setLength(cd,N);
    setLength(dd,N);


    for i:=0 to N-1 do
      a[i]:=2*Random()-1;
    for i:=0 to N-1 do
      b[i]:=2*Random()-1;
    for i:=0 to N-1 do
      ad[i]:=2*Random()-1;
    for i:=0 to N-1 do
      bd[i]:=2*Random()-1;


    result:=('Operation'#9'Factor'#9'Elements'#9'Elapsed No SIMD/ SIMD'#9'Result'#13#10);
    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vadd(@a[0],1,@b[0],1,@c[0],1,N);
    {$else}
    //for i:=0 to High(a) do
    //  c[i]:=a[i]+b[i];
    vsAdd(N,@a[0],@b[0],@c[0]) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAdd_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector + Vector',t2/t3,N,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsub(@b[0],1,@a[0],1,@c[0],1,N);
    {$else}
    //for i:=0 to High(a) do
    //  c[i]:=b[i]-a[i];
    vsSub(N,@a[0],@b[0],@c[0]);
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector - Vector',t2/t3,N,t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vmul(@a[0],1,@b[0],1,@c[0],1,N);
    {$else}
    vsMul(N,@a[0],@b[0],@c[0]);
    //for i:=0 to High(a) do
    //  c[i]:=a[i]*b[i];
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector * Vector',t2/t3,length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vdiv(@b[0],1,@a[0],1,@c[0],1,N);
    {$else}
    //for i:=0 to High(a) do
    //  c[i]:=a[i]/b[i];
    vsDiv(N,@a[0],@b[0],@c[0]);
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_s(@d[0],@a[0],@b[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector / Vector',t2/t3,Length(a),t2,t3,c,d);

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
    result+=logstr('SINGLE : Scalar + Vector',t2/t3,Length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=vals - a[i];
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSub_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar - Vector',t2/t3,Length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_vsmul(@a[0],1,@vals,@c[0],1,N);
    {$else}
    move(a[0],c[0],N*sizeof(vals));
    cblas_sscal(N,vals,@c[0],1);
    //for i:=0 to High(a) do
    //  c[i]:=a[i]*vals;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkMul_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar * Vector',t2/t3,Length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=vals / a[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiv_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Scalar / Vector',t2/t3,Length(a),t2,t3,c,d);

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
    result+=logstr('SINGLE : Max(Vector)',t2/t3,Length(a),t2,t3,s1,s2);

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
    result+=logstr('SINGLE : Min(Vector)',t2/t3,Length(a),t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_svemg(@a[0],1,@s1,N);
    {$else}
    //s1:=0;
    //for i:=0 to N-1 do
    //  s1:=s1+Abs(a[i]);
    s1:=cblas_sasum(N,@a[0],1);//Sum(a) ;
    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSumAbs_s(@s2,@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Sum(Abs(Vector))',t2/t3,Length(a),t2,t3,s1,s2);

    t1:=HighResTimer.NanoSeconds;
    {$if defined(DARWIN) and defined(USE_vDSP)}
    vDSP_svesq(@a[0],1,@s1,N);
    {$else}
    s1:= SumOfSquares(PSingle(@a[0]),N) ;

    {$endif}
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSumSqr_s(@s2,@a[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Sum(Vector^2)',t2/t3,Length(a),t2,t3,s1,s2);

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
    result+=logstr('SINGLE : Abs(Vector)',t2/t3,Length(a),t2,t3,c,d);

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
    result+=logstr('SINGLE : AXPY a * Vector + Vector',t2/t3,Length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    cblas_saxpby(N,vals,@a[0],1,vals2,@c[0],1);
    //for i:=0 to High(a) do
    //  c[i]:=vals*a[i]+vals2*b[i] ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkAXPBY_s(@d[0],@a[0],@d[0],N,@vals,@vals2);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : AXPBY a * Vector + b * Vector',t2/t3,Length(a),t2,t3,c,d);

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
    result+=logstr(format('SINGLE : Vector DOT Vector',[s1,s2]),t2/t3,Length(a),t2,t3,s1,s2);

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
    result+=logstr('SINGLE : (Vector - Vector)^2',t2/t3,Length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=Sqr(a[i]-vals) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkDiffSqr_ss(@d[0],@a[0],@vals,N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : (Scalar - Vector)^2',t2/t3,Length(a),t2,t3,c,d);

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
    result+=logstr('SINGLE : Vector^2',t2/t3,Length(a),t2,t3,c,d);

    t1:=HighResTimer.NanoSeconds;
    for i:=0 to High(a) do
      c[i]:=Sqrt(a[i]*a[i]) ;
    t2:=HighResTimer.NanoSeconds-t1;
    t1:=HighResTimer.NanoSeconds;
    bulkSqr_s(@d[0],@a[0],N);
    bulkSqrt_s(@d[0],@d[0],N);
    t3:=HighResTimer.NanoSeconds-t1;
    result+=logstr('SINGLE : Vector^0.5',t2/t3,Length(a),t2,t3,c,d);

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
        //for i:=0 to w-1 do
        //  bulkGathera_s(@d[i*w],@a[i],w,w);
        d:=a.Transpose(w);
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('SINGLE Transpose : Transpose(Matrix)',t2/t3,N div 2,t2,t3,c,d);


        FillDWord(c[0],w*w,0);
        t1:=HighResTimer.NanoSeconds;
        //c.fill(0.0,0.0);
        //TSingles.gemm_nn(w,w,w,1,@a[0],w,@b[0],w,@c[0],w);
        //vDSP_mmul(@a[0],1,@b[0],1,@c[0],1,w,w,w);
        //cblas_sgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,w,w,w,1,@a[0],w,@b[0],w,0,@c[0],w);
        //y:=0;


        MP.ParallelFor(@_gemm,0,w-1,[@w, @a[0], @b[0], @c[0]]);
    (*  for y:=0 to w-1 do
   //                    cblas_saxpy(w, a[y*w+i],@b[i*w],1,@c[y*w],1);
            //c[y*w+x]:=bulkDot_s(@a[y*w],@b[x],w,w);
          for i:=0 to w-1 do
            axpy(a[y*w+i],@b[i*w],@c[y*w],w);
            //for x:=0 to w-1 do
            //  c[y*w+x] := a[y*w+i]*b[i*w+x] + c[y*w+x];
        *)
        t2:=HighResTimer.NanoSeconds-t1;
        t1:=HighResTimer.NanoSeconds;
        //FillDWord(d[0],w*w,0);
        //d.fill(0.0,0.0);
//        for i:=0 to 1000 do
        {$if defined(DARWIN) and defined(USE_vDSP)}
        vDSP_mmul(@a[0],1,@b[0],1,@d[0],1,w,w,w);
        {$else}

        //ParallelFor(@_gemm,0,w-1,[@w, @a[0], @b[0], @d[0]]);
        cblas_sgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,w,w,w,1,@a[0],w,@b[0],w,0,@d[0],w);
        //TSingles.gemm_nn(w,w,w,1,@a[0],w,@b[0],w,@d[0],w);
        {$endif}
        t3:=HighResTimer.NanoSeconds-t1;
        result+=logstr('SINGLE GEMM: GEMM(Matrix, Matrix)',t2/t3,w*w,t2,t3,c,d);


        //for i:=0 to High(OP.Pool) do
        //  if OP.Pool[i].Busy then
        //    writeln('Pool Member #[',OP.Pool[i].Id,'] is drowned! | Start:',OP.Pool[i].from,' End:',OP.Pool[i].&to);

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
    result+=logstr('DOUBLE : Abs(Vector)',t2/t3,Length(a),t2,t3,cd,dd);

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
    result+=logstr('DOUBLE : AXPBY (a * Vector + b * Vector)',t2/t3,Length(a),t2,t3,cd,dd);

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


    {$endif}
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
        result+=logstr('DOUBLE GEMM: GEMM(Matrix, Matrix)',t2/t3,w*w,t2,t3,c,d);


end;

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
var s:string; nRows,nCols,i:integer;strData,strRow:array of string;
begin
  s:= dotest(0);
  //StringGrid1.r;
  with StringGrid1 do begin
    BeginUpdate;
    RowCount:=1;
    Columns.Clear;
    strData:=s.Split([LineEnding]);
    nRows:=High(strData);
    nCols:=WordCount(strData[0],[#9]);
    for i:=0 to nCols-1 do
      with Columns.Add do begin
        strRow:=strData[0].Split(#9);
        if i=1 then begin
          Alignment:=taRightJustify;
          color:=clMaroon;
        end;
        Title.Caption:=strRow[i];

      end;

    for i:=1 to nRows-1 do begin
      InsertRowWithValues(RowCount,strData[i].Split(#9));
      //Rows[i].Delimiter:=#9;
      //Rows[i].StrictDelimiter:=true;
      //Rows[i].DelimitedText:=strData[i];
    end;
    AutoSizeColumns;
    EndUpdate();

  end

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  with StringGrid1 do begin
    FocusColor:=clSkyBlue;
    GridLineColor:=clWhite;
    FixedGridLineColor:=clWhite;
    SelectedColor:=clSkyBlue;

  end;
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
const FocusRectPadding =4;
begin
  with StringGrid1 do begin
    //DefaultDrawCell(aCol,aRow,aRect,aState);
    if (gdSelected in aState) and not (gdFocused in aState) then
      Canvas.Font.Color:=clBlack;
    exit;
      if not (gdFocused in aState) then begin
        if Columns.Count>0 then
          Canvas.brush.Color:=specialize ifthen<TColor>(gdFixed in aState,Columns[aCol].Title.Color,specialize ifthen<TColor>(gdSelected in aState,SelectedColor,Columns[aCol].Color))
        else
          Canvas.brush.Color:=specialize ifthen<TColor>(gdFixed in aState,FixedColor,specialize ifthen<TColor>(gdSelected in aState,SelectedColor,Color));
//        Canvas.FillRect(aRect);
        Canvas.Font.Color:=specialize ifthen<TColor>(gdFixed in aState,TitleFont.Color,Font.Color);
 //       Canvas.TextRect(aRect,aRect.Left,aRect.Left,Cells[aCol,aRow],DefaultTextStyle);
        Canvas.Pen.Style:=psSolid;
      end else begin
        canvas.brush.Color:=FocusColor;
//        Canvas.FillRect(arect);
        Canvas.Font.Color:=clBlack;
//        Canvas.TextRect(aRect,aRect.Left,aRect.top,Cells[aCol,aRow],DefaultTextStyle);
        Canvas.Pen.Style:=psDot;
//        Canvas.DrawFocusRect(aRect.Create(aRect.Left+FocusRectPadding,aRect.Top+FocusRectPadding,aRect.Right-FocusRectPadding,aRect.Bottom-FocusRectPadding));
      end;
//    DefaultDrawCell(aCol,aRow,aRect,aState);
    //StringGrid1.Canvas.Brush.Style:=bsSolid;
    //StringGrid1.Canvas.Brush.Color:=StringGrid1.Color;
    //StringGrid1.Canvas.Font.Color:=StringGrid1.Font.Color;
  //  StringGrid1.Canvas.TextRect(aRect,aRect.Left,aRect.Top,Cells[aCol,aRow]);
  end;

end;



end.

