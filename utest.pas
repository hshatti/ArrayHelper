unit uTest;

{.$mode delphi}{$H+} {$inline on}{$ModeSwitch allowinline}

interface

uses
  Classes, SysUtils, StrUtils, Forms, Controls, Types, StdCtrls, Graphics,
  Dialogs, ExtCtrls, Buttons, tensors, ArrayHelperCommon, arrayhelper,
  math, quickchart, MediaFileReader, HiResTimer, complexarray
  {$ifdef USE_AVX2}, oprs_simd{$endif}
  //{$ifdef USE_AVX2}, pblas {$endif}
  {$ifdef darwin}{$endif}

  ;

type

   { TForm1 }
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Memo1: TMemo;
    Splitter1: TSplitter;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private

  public
//    Media:TMediaFileReader;
//    Player:TAudioPlayer;
  end;

var
  Form1: TForm1;
  png:TPortableNetworkGraphic;
implementation



{$R *.lfm}

{ TForm1 }

function cmp(const a,b:integer):integer;
begin
  result:=b-a
end;
function fil(const s:string;const i:integer;const arr:array of string):string;
begin
  result:=s+'--'
end;


function fade(x:double):double;
var xx:double;
begin
  xx:=x*x;
  result:=10*(xx*x) -15*(xx*xx) +6*(xx*xx*x)
end;


//type  TDoubleArray   = array[1..highestfloatelement] of Double;
//
//
//
//Function omvin(Var a, b: Double; n: ArbInt): Double;
//
//Var        pa, pb : ^TDoubleArray;
//                i : ArbInt;
//                s : Double;
//Begin
//  If n<1 Then
//    exit(0);
//  pa := @a;
// pb := @b;
// s := 0;
//  For i:=1 To n Do
//    Begin
//      s := s+pa^[i]*pb^[i]
//    End; {i}
//  omvin := s
//End; {omvinp}
//
//
//
//Procedure omvmm(Var a: Double; m, n, rwa: ArbInt;
//                 Var b: Double; k, rwb: ArbInt;
//                 Var c: Double; rwc: ArbInt);
//
//Var           pa, pb, pc : ^TDoubleArray;
//     i, j, l, inda, indc : ArbInt;
//                       s : Double;
//Begin
//  If (m<1) Or (n<1) Or (k<1) Then
//   exit;
//  pa := @a;
// pb := @b;
// pc := @c;
//  For i:=1 To m Do
//    Begin
//      inda := (i-1)*rwa;
//      indc := (i-1)*rwc;
//      For j:=1 To k Do
//        Begin
//          s := 0;
//          For l:=1 To n Do
//            s := s+pa^[inda+l]*pb^[(l-1)*rwb+j];
//          pc^[indc+j] := s
//        End {j}
//    End; {i}
//End; {omvmmm}
//
//Procedure omvmv(Var a: Double; m, n, rwidth: ArbInt; Var b, c: Double);
//
//Var     pa, pb, pc : ^TDoubleArray;
//            i, ind : ArbInt;
//Begin
//  If (m<1) Or (n<1) Then
//    exit;
//  pa := @a;
// pb := @b;
// pc := @c;
// ind := 0;
//  For i:=1 To m Do
//    Begin
//      pc^[i] := omvin(pa^[ind+1], pb^[1], n);
//      ind := ind+rwidth
//    End; {i}
//End; {omvmmv}
//
//
//
//procedure multiply(a,b:TFloatTensor;var c:TFloatTensor);
//var m,n,rwa,p,rwp,rwc:integer;
//begin
//
//  m:=a.Shape[1];
//  n:=a.Shape[0];
//  p:=b.Shape[0];
//  if Length(b.Shape)=2 then begin
//    setLength(c.Data,m*p);
//    c.Shape:=[p,m];
//    omvmm(a.data[0],m,n,n,b.data[0],p,p,c.data[0],p);
//  end
//  else begin
//    setLength(c.Data,m);
//    c.Shape:=[m];
//    omvmv(a.data[0],m,n,n,b.data[0],c.data[0]);
//  end;
//end;
type TTensor=TSingles;//specialize TArray<double>;

function _sin(x:Single):Single;begin result:=0.5+RandG(0.1*sin(x),0.05); end;

procedure TForm1.Button1Click(Sender: TObject);
var
  T,TT:QWord;
  aa:TTensor;
  X, A, v2,re: TSingleTensor;
  i,N,j,k:integer; cc2:TComplexArrayF;
  cc:TComplexTensor;
  s:TStringArray; theta,v:Single;
  dd:pSingle;

begin
  //ten:=specialize TCustomVec<Single>.Create([[3,3],[4,4],[5,5]]);
  //ten.uniform();

  //Memo1.Lines.Add(d.toString(' ,',2));
  //Memo1.Lines.Add('Min:[%.2f], Max:[%.2f]',[d.Min,d.Max]);
  //Chart.DataCount:=1;
  //d:=TDoubleDynArray.uniform(10,10).sort;
  //if Chart.DataCount>0 then Chart.Remove(0);
  //Chart.Add(d,gsLine);
  //Memo1.Lines.Add(d);
  //Memo1.Lines.Add('Min:[%.2f], Max:[%.2f]',[Chart.Ranges[0].minVal,Chart.Ranges[0].maxVal]);
  //exit;

  // ((x * 6 -15) * x + 10) * power(x,3)
  // (6*power(x,2) -15*x + 10) * power(x,3)
  //10*x^3 -15*x^4 +6*x^5

  //memo1.lines.add(TIntegerDynArray.uniform(100,10,0).unique.ToString());
  cc:=[
       [1    , 1     , 5*i_  ],
       [3*i_ , 1     , 0     ],
       [0    , 12*i_ , 0     ]
      ]    ;
  Memo1.Lines.Add(string(cc) +#13#10+ string(cc.inverse));

  X:=[   TTensor.fill(100,1,0)
        ,TTensor.polynomial(100,[0,1])
        ,TTensor.polynomial(100,[0,0,1])
        ,TTensor.polynomial(100,[0,0,0,1])
        //,TTensor.polynomial(100,[0,0,0,0,1])
        //,TTensor.polynomial(100,[0,0,0,0,0,1])
        ////,TTensor.polynomial(100,[0,0,0,0,0,0,1])

        ];
  v2:=TTensor.fill(100,0.0,0.1).map(TSimpleMapSingleFunc(@_sin));

//  //v2:=TDoubleDynArray.fill(100,0,2*PI*0.01,0.1).Sin;
//
//  //Memo1.lines.Add(#13#10'X :');
//  Memo1.lines.Add(X);

  t:=HighResTimer.MicroSeconds;
  A:=X.Transpose;

  t:=HighResTimer.MicroSeconds-t;
  Memo1.Lines.Add('transpose took [%d]µs',[t]);


  A:=X.Multiply(A);
  //Memo1.lines.Add('A x A†');
  //Memo1.lines.Add(A);

  //Memo1.lines.Add('A^-1');
  A:=A.inverse;
  //Memo1.Lines.Add(A);
//
  //Memo1.Lines.Add(#13#10'A • X =:'#13#10);
  t:=HighResTimer.MicroSeconds;
  A:=A.Multiply(X);
  t:=HighResTimer.MicroSeconds-t;

//  Memo1.Lines.Add(A);
  Memo1.Lines.Add('Multiply took %dµs',[t]);

  Memo1.Lines.Add(#13#10'Polynomial Coefficiants =:'#13#10);

  re:=A.Multiply(v2);
  //memo1.lines.add(#13#10'D.v2 = Result :');
  memo1.lines.add(re);

  while plot.DataCount>0 do
    plot.Remove(0);
////
  plot.add(v2.data,gsScatter);
  plot.add(TTensor.polynomial(100,re.data),gsLine);
//  aa:=[1,2,3,4,5,6,7,8,9,0,11,22,33,44,55];
//  s.Count:=100;
//
//  for i:=0 to 99 do begin
//    s[i]:=format('%f',[sin(i*0.25)]);
//  end;
  //cc:=aa.fft();
  //Memo1.Lines.Add(cc);
    plot.showplot;
  exit;

  Memo1.Lines.add('CPU speed = %d, Max speed = %d', [HighResTimer.CPUSpeed,HighResTimer.CPUMaxSpeed]);
  aa:=TTensor.{Uniform(1024,1,0.5); }Uniform(100,0.1,-1);
  i:=0;
  TT:=GetTickCount64;
  T:=HighResTimer.MicroSeconds;
//  while t+1000>GetTickCount64 do
    begin
      cc:=aa.fft();
      inc(i);
    end;
  TT:=GetTickCount64-TT;
  T:=HighResTimer.MicroSeconds-T;
  //Memo1.Lines.Add('[FFT] Loops: [%d], %s per loop',[i,ifthen(i>=1000,format('%fus',[1000000/i]),format('%fms',[1000/i]))]);
  Memo1.Lines.Add('[FFT] : %d sample size @ [%s]',[aa.count,ifthen(T>=1000,format('%fms',[T/1000]),format('%fus',[T*1.0]))]);
  Application.ProcessMessages;
  i:=0;
  TT:=GetTickCount64;
  T:=HighResTimer.MicroSeconds;
//  while t+1000>GetTickCount64 do
    begin


      begin
        N:=Length(aa);//.Count;
        setLength(cc2,n);
        for k:=0 to N-1 do with cc2[k] do begin
          re:=0;im:=0;
          for j:=0 to N-1 do begin
            theta:=PIx2*k*j/N;
            re:=re+aa[j]*system.Cos(theta);
            im:=im-aa[j]*system.Sin(theta);
            //twid:=ucomplex.cexp(-i*PIx2*k*j/N);
            //result[k]:=result[k]+self[j]*twid
          end;
        end;
      end;


    end;
  TT:=GetTickCount64-TT;
  T:=HighResTimer.MicroSeconds-T;

  Memo1.Lines.Add('[DFT] : %d sample size @ [%s]',[aa.count,ifthen(T>=1000,format('%fms',[T/1000]),format('%fus',[T*1.0]))]);
  Application.ProcessMessages;
  //aa:=TDoubleDynArray.fill(1024,0,0.2).sin.mul(2);
  //chart.add(aa,gsLine);


  //chart.add(aa,gsLine);
  plot.add(aa,gsLine);
  plot.add(cc2,gsLine);

  exit;
  //Memo1.Lines.Add(10002.5253);

  //d.count:=10;
  //for i:=0 to 10-1 do d[i]:=fade(i*0.1) ;
  //
  //Chart.Add(TDoubleDynArray.polynomial(10,[0,0,0,10,-15,6],0.1),gsScatter);
  //Chart.add(d,gsLine);



  //chart.Add(v2.data,gsScatter);
  //chart.Add(TDoubleDynArray.polynomial(100,v.data),gsLine);

  //chart.Add(v2.Data,gsScatter);
  //chart.add(TDoubleDynArray.polynomial(100,v.data),gsLine);

  //v:=[
  //  [1,2,3,6,3,1,2,3,6,3]
  // ,[4,5,2,7,4,4,5,2,7,4]
  // ,[1,3,5,2,0,1,3,5,2,0]
  // ,[2,2,5,4,8,2,2,5,4,8]
  // ,[1,2,0,4,7,1,2,0,4,7]
  //];
  //v.uniform(5.0);
  //memo1.Lines.add(v);
  //V1:=[
  //     [1,2,5,3,8]
  //    ,[5,6,7,3,8]
  //    ,[9,1,2,4,8]
  //    ,[9,1,2,6,6]
  //    ,[9,1,2,6,9]
  //    ,[1,2,5,3,8]
  //    ,[5,6,7,3,8]
  //    ,[9,1,2,4,8]
  //    ,[9,1,2,6,6]
  //    ,[9,1,2,6,9]
  //    ];
  //v1.uniform(10.0);
  //memo1.lines.add(v1);
  ////v:=v.map(@log);
  ////Memo1.Lines.Add(v.sort.toString);
  ////Memo1.Lines.Add(v.Shape);
  //Memo1.Lines.Add(
  //  v1.multiply(v)
  //  );
  //);
 //       Memo1.Lines.Add(v1.inverse);
  //Memo1.Lines.Add(v1.Cofactors);

  //ten.free   ;
end;

var signale,signale2:TSingleDynArray;
const
  sampleTime=0.2;
  SampleSize=trunc(44100*sampleTime);

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
begin
  signale :=TSingleDynArray.fill(sampleSize, 0, 100*PIx2/44100,0).Sin(0.2);
  signale2:=TSingleDynArray.fill(sampleSize, 0, 200*PIx2/44100,0).Sin(0.2);

//  Player.SampleSize:=sampleSize;
//  Player.InterleavedChannel:=false;
//  Player.ChannelCount:=1;
//  Player.SampleSize:=SampleSize;
//  Player.Active:=True;
//  for i:=0 to 10 do begin
//    Player.PlayBuffer(@TSingleArrayArray([signale,signale])[0]);
////    Player.PlayBuffer(@TSingleArrayArray([signale2,signale2])[0]);
//  end;
  //Plot.Add(signale,gsline);
  //plot.ShowPlot;
end;

procedure TForm1.Button3Click(Sender: TObject);
var T1,T2,R:TSingleTensor; t:QWord;
begin

  T1.Init(TSingles.Uniform(1000000,10.0,-10.0),[1000,1000]);
  T2.Init(TSingles.Uniform(1000000,10.0,-10.0),[1000,1000]);
  t:=HighResTimer.MicroSeconds;
  R:=T1.Multiply(T2);
  t:=HighResTimer.MicroSeconds-t;
  Memo1.Lines.Add('Multiply took [%.0n]µs Hash %n',[t+0.0,TSingles(R.Data).Sum]);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var i:integer;
begin
  Memo1.Lines.Clear;

  Memo1.Lines.Add(dotest(0));//
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Memo1.Lines.Add(dotest(1));
end;

function RGBA(const r,g,b,a:byte):longword; inline;
begin
  result:=((b<<24)+(g<<16)+(r<<8)+a)
end;

procedure SIMDx2(const a:PSingle;const C:PInteger;const L:integer);
var i:integer;
begin
  if L-C^<8 then
    begin
      for i:=0 to L-C^-1 do
        a[i]*=2;
      inc(C^,8);
      exit
    end;
  a[0]*=2;
  a[1]*=2;
  a[2]*=2;
  a[3]*=2;
  a[4]*=2;
  a[5]*=2;
  a[6]*=2;
  a[7]*=2;
  inc(C^,8);
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var i,j,M:integer;ar,ar1,ar2,ar3:TSingles;dr:TSingles;ar2d:TDoubleArrayArray;  t0,t,t1:qword;
  c0,c:ComplexD;
  r:longWord;px:PLongWord; a0:Double {absolute c0.re};b0:Double {absolute c0.im};a:Single {absolute c.re}; b:Single {absolute c.im}; ss:Extended;
const iter=1000;   const N=$8003 ;co:single=60;
begin

  ar:=TSingles.Uniform(N,-5000,-10000);
//  dr:=TExtendeds.Uniform(N,100,0);
  //ar:=[3.14159, 3.14159, 3.14159 , 3.14159, 3.14159, 3.14159 ,3.14159, 3.14159, 10000.0,10000.0, 10000.0, 10000.0, 10000.0,10000.0,  10000.0, 10000.0];
  //ar1:=TSingleDynArray.fill(N,2.0,0);
  setLength(ar2,N);
  setLength(ar3,N);
  j:=0;  r:=0;
  setLength(ar2d,2,Length(ar) div 2);
//  while j<1 do begin
  i:=0;

  //ar3:=ar.map(TSIMDMap<PSingle>(@SIMDx2));
  //Memo1.Lines.Add('%s'#13#10'%s',[ar.ToString,ar3.ToString]);
//  exit;
  t:=HighResTimer.MicroSeconds;
  while i<1000 do begin
      a:=ar.max();
//      bulkDiffSqr_ss(@ar2[0],PSingle(ar),@co,ar.count) ;
      inc(i)
  end;
    //ar2d:=ar.interleave;
    //Interleave(psingle(ar2d[0]),psingle(ar2d[1]),psingle(ar),length(ar));
//    inc(j);
    //inc(r)
//  end;
  t:=HighResTimer.MicroSeconds-t;

  t0:=HighResTimer.MicroSeconds;
  i:=0;
  while i<1000 do begin
  //  ar3:=ar.DiffSqr(co);
    b:=MaxValue(ar);
    //b:=ar.sum;
    inc(i)
  end;
  t0:=HighResTimer.MicroSeconds-t0;

  //t1:=HighResTimer.MicroSeconds;
  //i:=0;
  //while i<1000 do begin
  ////  ar3:=ar.DiffSqr(co);
  //  ss:=ar.Max();
  //  //b:=ar.sum;
  //  inc(i)
  //end;
  //t1:=HighResTimer.MicroSeconds-t0;
  //t1:=HighResTimer.MicroSeconds;
  //i:=0;
  //while i<1000 do begin
  //////  ar3:=ar.DiffSqr(co);
  //  ss:=dr.sum;
  //  inc(i)
  //end;
  //t1:=HighResTimer.MicroSeconds-t1;

  Memo1.Lines.Add('%n elements '#13#10'max     (simd) of ar : is [%.5n] took [%.0n]µs',[ar.count+0.0, a, t+0.0]);
  Memo1.Lines.Add('%n elements '#13#10'max  (normal) of ar : is [%.5n] took [%.0n]µs',[ar.count+0.0,  b,  t0+0.0]);
//  Memo1.Lines.Add('%n elements '#13#10'Sum     (normal) of dr : is [%.5n] took [%.0n]µs',[dr.count.ToSingle,  ss,  t1.ToSingle]);
  exit;
  //Memo1.Lines.Add('complex test [%s]',[ctest]);

  px:=png.ScanLine[0];
  t:=HighResTimer.MicroSeconds;
  for j:=0 to png.Height-1 do
    for i:=0 to png.Width-1 do
      begin
        //a0:=0;
        //b0:=0;
        //a:=-2.2+i/250;
        //b:=-1.2+j/250;

        c0:=0;
        //c.re:=i;c.im:=j;
        c:=[i,j];
        //c.map(0,png.width,-2.2,0.8 ,0,png.height,-1.2,1.2);
        c.map(-2.2,0.004,-1.2,0.004);
        r:=0;
        while ({(a0*a0+b0*b0)} c0.det()<4) and (r<iter) do begin
          c0.sqr();
          //ss:=a0*a0-b0*b0;
          //b0:=2*a0*b0;
          //a0:=ss;
          c0.add(c);
          //a0:=a0+a;
          //b0:=b0+b;
          inc(r);
        end;
        if r>=iter then r:=0;
        r:=r*$FF div iter;
        px[j*png.Width+i]:=RGBA(r,r,r,$ff);//((iter<<24)+(iter<<16)+(iter<<8)+$ff)
      end;
  t:=HighResTimer.MicroSeconds-t;
  Image1.Picture.Graphic:=png;
  Memo1.Lines.add('Mandelbrot[640 X 480] Iteration[%d] took [%.0n]µs',[iter,t+0.0]);
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var vv:TStringArray;f1,f2,f3,f4,f5:extended;isfrac:boolean;
begin
//
//  if key=13  then begin
//    vv:=string(Edit1.Text).split(',');
//    f1:=vv[0];
//    if length(vv)>1 then
//        f2:=vv[1]
//    else
//        f2:=2;
//
//    memo1.lines.add(FloatToStr(RoundTo(f1,trunc(-f2))));
//
//    exit;
//    if Length(vv)>1 then
//      Memo1.Lines.Add(plot.alignMaxTicks(vv[0],vv[1]))
//    else
//      Memo1.Lines.Add(plot.alignMaxTicks(vv[0]))  ;
//  end;


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  png:=TPortableNetworkGraphic.Create;
  png.PixelFormat:=pf32bit;
  png.SetSize(800,600);
//  Media:=TMediaFileReader.Create;
//  Player:=TAudioPlayer.Create;

end;

end.

