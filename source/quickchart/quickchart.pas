unit quickchart;

{$mode objfpc}{$H+} {$ModeSwitch advancedrecords}  {$inline on}
{.$define use_bgra}

interface

uses
  Classes, SysUtils,interfaces, Controls, Graphics, forms, Types, Math,ArrayHelperCommon, ArrayHelper,
  Complexarray {$ifdef USE_BGRA},BGRABitmap, BGRABitmapTypes, BGRACanvas,FPImage{$else}, FPImage, FPCanvas{$endif};

const
  TFluentColors : TLongWordDynArray =($FFB900a0,$E74850a0,$0078Da0,$0099BCa0
                                     ,$FF8C00a0,$E81120a0,$0063Ba0,$2D7D9Aa0
                                     ,$F7630Ca0,$EA0050a0,$8E8CDa0,$00B7C3a0
                                     ,$CA5010a0,$C30050a0,$6B69Da0,$038387a0
                                     ,$DA3B01a0,$E30080a0,$8764Ba0,$00B294a0) ;

  TMaterial1Colors : TLongWordDynArray =($c4ef55c0,  $ffb974c0 ,$ecec81c0, $fe9ba2c0, $dfe6e9c0
                                        ,$94b800c0,  $e38409c0 ,$c9ce00c0, $e75c6cc0, $b2bec3c0
                                        ,$a7eaffc0,  $7576ffc0 ,$a0b1fac0, $a879fdc0, $636e72c0
                                        ,$6ecbfdc0,  $3130d6c0 ,$5570e1c0, $9343e8c0, $2d3436c0);

  TMaterial2Colors : TLongWordDynArray =($12C3FFc0,  $C4CB12c0 ,$38E5C4c0, $DFA7FDc0, $674CEDc0
                                        ,$1F9FF7c0,  $A78912c0 ,$38CBA3c0, $FA80D9c0, $7134B5c0
                                        ,$245AEEc0,  $DD5206c0 ,$329400c0, $FA8099c0, $713483c0
                                        ,$2720EAc0,  $64141Bc0 ,$666200c0, $BB5857c0, $511E6Fc0);

type
  TAutoScale=(asBoth,asX,asY,asNone);
  PDataRange=^TDataRange;
  TDataRange=record
    maxVal:Single;
    minVal:Single;
  end;


  PPixel=^Tpixel;
  {$ifdef Darwin}
     TPixel=record
       case byte of
       0:(n:LongWord);
       1:(a,r,g,b:byte);
     end;


  {$endif}

  {$ifdef Windows}
  TPixel=record
    case byte of
    0:(n:LongWord);
    1:(a,r,g,b:byte);
  end;

  {$endif}

  {$ifdef Linux}
  TPixel=record
    case byte of
    0:(n:LongWord);
    1:(r,g,b,a:byte);
  end;

  {$endif}

  TGradientStyle=(grTop,grLeft,grTopLeft,grCircular) ;

    { TGradient }
  TGradient=record
    Colors:array[0..1] of TPixel;
    style: TGradientStyle;
    class operator := (const b:TPixel):TGradient;
    class operator := (const b:TGradient):TPixel;
    class operator := (const b:longword):TGradient;
    class operator := (const b:TGradient):longword;
  end;
  TDataRanges=array of TDataRange;

  { TStyler }

  TStyler=record
  private
    Fopacity: single;
    function Getx2: smallint; inline;
    function Gety2: smallint; inline;
    procedure Setopacity(AValue: single);
    procedure Setx2(AValue: smallint); inline;
    procedure Sety2(AValue: smallint); inline;

  public
    stroke:TGradient;
    strokeStyle:TPenStyle;
    strokeWidth:single;
    fill:TGradient;
//    strokeIsFill:boolean;
    x,y,w,h:smallint;
    textalign:TAlignment;
    r:integer;
    property x2:smallint read Getx2 write Setx2;
    property y2:smallint read Gety2 write Sety2;
    property opacity:single read Fopacity write Setopacity;
  end;

  { TFastBitmap }

  TFastBitmap=class(TBitmap)
  private
    FAlphaBlend: boolean;
    FData:PPixel;
    FImageWidth:integer;
    FPenPos: TPoint;
    procedure EllipseC(cx, cy, rx, ry: integer; fill: boolean);inline;
    procedure SetAlphaBlend(AValue: boolean);
    function setOpacity(const a: TPixel; const alpha: integer): TPixel;

    function GetP(const x, y: smallint): TPixel;inline;
    procedure Rect(s: TStyler; fill: boolean);
    procedure Line(s:TStyler);
    procedure SetP(const x, y: smallint; const AValue: TPixel); inline;
    procedure SetPenPos(AValue: TPoint);
  public
    Styler:TStyler;
    procedure SetSize(AWidth, AHeight: integer); override;
    procedure Clear(Pixel:TPixel);
    procedure Clear; override;
    function xy(const x, y: smallint): integer;inline;
    property P[x,y:smallint]:TPixel read GetP write SetP;
    property AlphaBlend:boolean read FAlphaBlend write SetAlphaBlend;
    constructor Create; override;
    procedure Line(x0, y0, x1, y1: smallint);
    procedure LineTo(x, y: smallint);inline;
    procedure Rect(x1, y1, x2, y2: smallint);inline;
    procedure EllipseC(cx, cy, rx, ry: integer);inline;
    procedure Ellipse(x1, y1, x2, y2: integer);inline;
    property PenPos:TPoint read FPenPos write SetPenPos;
    procedure MoveTo(x, y: smallint);
  end;


  TPlot=class;

  { TPlotAxis }

  TPlotAxis=class(TComponent)
  private
    FColor: TPixel;
    FFont: {$ifdef USE_BGRA}TBGRAFont{$else}TFont{$endif};
    FOnUpdate: TNotifyEvent;
    FPlot:TPlot;
    FSpacing: integer;
    FTickWidth: integer;
    Fwidth: integer;
    FMinimumTicks:integer;
    procedure SetColor(AValue: TPixel);
    procedure SetFont(AValue: {$ifdef USE_BGRA}TBGRAFont{$else}TFont{$endif});
    procedure SetMinimumTicks(AValue: integer);
    procedure SetOnUpdate(AValue: TNotifyEvent);
    procedure SetSpacing(AValue: integer);
    procedure SetTickWidth(AValue: integer);
    procedure Setwidth(AValue: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Font:{$ifdef USE_BGRA}TBGRAFont{$else}TFont{$endif} read FFont write SetFont;
    property Color:TPixel read FColor write SetColor;
    property width:integer read Fwidth write Setwidth;
    property TickWidth:integer read FTickWidth write SetTickWidth;
    property Spacing:integer read FSpacing write SetSpacing;
    property MinimumTicks:integer read FMinimumTicks write SetMinimumTicks;
    property OnUpdate:TNotifyEvent read FOnUpdate write SetOnUpdate ;
  end ;

  TGraphStyle=(gsScatter,gsBar,gsHBar,gsLine,gsArea);

  TGraphOption=record
    Fill:TGradient;
    Stroke:TGradient;
    StrokeWidth:integer;
    Stack:boolean;
    Horizontal:boolean;
    Style:TGraphStyle;
    Size:integer;

  end;

  //TBarOption=class (TGraphOption)
  //  Stack:boolean;
  //end;
  //
  //THBarOption=class (TGraphOption)
  //
  //end;
  //
  //TLineOption=class(TGraphOption)
  //
  //end;
  //
  //TScatterOption=class(TGraphOption)
  //
  //end;
  //
  //TAreaOption=class(TGraphOption)
  //
  //end;

  { TPlot }

  TPlot=class(TGraphicControl)
  private
    FActive: boolean;
    FAutoScale: TAutoScale;
    FAutoTicks: boolean;
    FAxisX: TPlotAxis;
    FAxisY: TPlotAxis;
    FBackground: TGradient;
    FBarsRatio: single;
    FColors: TLongWordDynArray;
    FData:TDoubleArrayArray;
    FMaxs,FMins:TDoubleDynArray;
    FMinY,FMaxY:double;
    FMinX,FMaxX:double;
    yMax,yMin:double;
    FBitmap:{$ifdef USE_BGRA}TBGRABitmap{$else}{$ifdef USE_FASTBITMAP}TFastBitmap{$else}TPortableNetworkGraphic{$endif}{$endif};
    FBases:TDoubleArrayArray;
    FPaddingLeft,FPaddingRight,FPaddingTop,FPaddingBottom,FtxtWidthY,FtxtWidthX,FtxtHeightY,FTxtHeightX:smallint;
    FGraphOptions:array of TGraphOption;
    function DoCombineColors(const color1, color2: TFPColor): TFPColor;
    function GetDataCount: integer;
    function GetGraphOptions(index: integer): TGraphOption;
    function GetPlotHeight: smallint;
    function GetPlotWidth: smallint;
    procedure SetActive(AValue: boolean);
    procedure SetAutoScale(AValue: TAutoScale);
    procedure SetAutoTicks(AValue: boolean);
    procedure SetAxisX(AValue: TPlotAxis);
    procedure SetAxisY(AValue: TPlotAxis);
    procedure SetBackground(AValue: TGradient);
    procedure SetBarsRatio(AValue: single);
    procedure SetColors(AValue: TLongWordDynArray);
    procedure SetDataCount(AValue: integer);
    procedure SetGraphOptions(index: integer; AValue: TGraphOption);
    procedure SetMaxX(AValue: double);
    procedure SetMaxY(AValue: double);
    procedure SetMinX(AValue: double);
    procedure SetMinY(AValue: double);
    procedure SetPaddingBottom(AValue: smallint);
    procedure SetPaddingLeft(AValue: smallint);
    procedure SetPaddingRight(AValue: smallint);
    procedure SetPaddingTop(AValue: smallint);
    procedure SetParent(NewParent: TWinControl); override;
    procedure xScale;
    procedure yScale;
  published

  protected
    procedure Resize; override;
  public
    procedure ShowPlot;
    procedure OnOwnerShow(Sender:TObject);
    function alignMaxTicks(range: extended; minTicks: integer=2): TDoubleDynArray;
    procedure SetBounds(aLeft, aTop, aWidth, aHeight: integer); override;
    property PlotWidth:smallint read GetPlotWidth;
    property PlotHeight:smallint read GetPlotHeight;
    property PaddingLeft:smallint read FPaddingLeft write SetPaddingLeft;
    property PaddingRight:smallint read FPaddingRight write SetPaddingRight;
    property PaddingTop:smallint read FPaddingTop write SetPaddingTop;
    property PaddingBottom:smallint read FPaddingBottom write SetPaddingBottom;
    property Active:boolean read FActive write SetActive;
    property AutoTicks:boolean read FAutoTicks write SetAutoTicks;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property GraphOptions[index:integer]:TGraphOption read GetGraphOptions write SetGraphOptions;
    function Add(const D: TDoubleDynArray; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TExtendedDynArray; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TSingleDynArray; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TComplexArrayF; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TComplexArrayD; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TIntegerDynArray; const GraphStyle: TGraphStyle=gsBar ): Integer;
    function Add(const D: TDoubleDynArray;  const base:TDoubleDynArray; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TExtendedDynArray;const base:TExtendedDynArray; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TSingleDynArray;  const base:TSingleDynArray; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TComplexArrayF;    const base:TComplexArrayF; const GraphStyle: TGraphStyle=gsBar): Integer;
    function Add(const D: TIntegerDynArray; const base:TIntegerDynArray; const GraphStyle: TGraphStyle=gsBar ): Integer;
    function Remove(const index:integer):TDoubleDynArray;
    function GetData(Index: Integer): TDoubleDynArray;
    function GetRanges(Index: integer): TDataRange;
    procedure SetData(Index: Integer; AValue: TDoubleDynArray);
    procedure SetRanges(Index: integer; AValue: TDataRange);
    procedure Paint; override;
    property Ranges[Index:integer]:TDataRange read GetRanges write SetRanges;
    property DataCount:integer read GetDataCount write SetDataCount;
    property Data[Index:Integer]:TDoubleDynArray read GetData write SetData;
    property AxisX:TPlotAxis read FAxisX write SetAxisX;
    property AxisY:TPlotAxis read FAxisY write SetAxisY;
    property Background:TGradient read FBackground write SetBackground;
    property BarsRatio:single read FBarsRatio write SetBarsRatio;
    property Colors:TLongWordDynArray read FColors write SetColors;
    property AutoScale:TAutoScale read FAutoScale write SetAutoScale;
    property MaxX:double read FMaxX write SetMaxX;
    property MaxY:double read FMaxY write SetMaxY;
    property MinX:double read FMinX write SetMinX;
    property MinY:double read FMinY write SetMinY;


    //property Scatter

  end;

{$ifdef USE_BGRA}
operator := (const p:TPixel):TBGRAPixel;  inline;
operator := (const p:LongWord):TBGRAPixel; inline;
operator := (const p:byte):TBGRAPixel; inline;
operator := (const p:TBGRAPixel):TPixel;  inline;
//operator := (const p:TBGRAPixel):LongWord; inline;
{$endif}

operator := (const c:TColor):TPixel; inline;
operator := (const c:TPixel):TColor; inline;
operator := (const c:TFPColor):TPixel; inline;
operator := (const c:TPixel):TFPColor; inline;


function Pixel(code:byte):TPixel; inline;
function Pixel(const r,g,b,a:Byte):TPixel;
function blend(const p1,p2:TPixel):TPixel;
function blend(const p1,p2:TFPColor):TFPColor;

var  Plot:Tplot;

implementation


function blend(const p1,p2:TPixel):TPixel;
var invA:word;
begin
   with p2 do
     if a=$ffff then
       begin
         result:=p2;
       end
     else if a=0 then
       result:=p1
     else begin
       invA:=$ffff-a;
       result.r:=trunc(r*a/$ffff + p1.r*p1.a*invA / $fffffff);
       result.g:=trunc(g*a/$ffff + p1.g*p1.a*invA / $fffffff);
       result.b:=trunc(b*a/$ffff + p1.b*p1.a*invA / $fffffff);
       result.a:=a+trunc(p1.a*invA / $ffff);
     end;
end;

function blend(const p1,p2:TFPColor):TFPColor;
var invA:byte;
begin
   with p2 do
     if Alpha=$ff then
       begin
         result:=p2;
       end
     else if Alpha=0 then
       result:=p1
     else begin
       invA:=$ff-Alpha;
       result.Red  :=trunc(Red*Alpha/$ff   + p1.Red*p1.Alpha*invA / $ffff);
       result.Green:=trunc(Green*Alpha/$ff + p1.Green*p1.Alpha*invA / $ffff);
       result.Blue :=trunc(Blue*Alpha/$ff  + p1.Blue*p1.Alpha*invA / $ffff);
       result.Alpha:=Alpha+trunc(p1.Alpha*invA / $ff);
     end;
end;

var frm:TForm;

function Pixel(const r,g,b,a:Byte):TPixel;
begin
  result.r:=r;result.g:=g;result.b:=b;result.a:=a;
end;
//function Pixel(const code:LongWord):TPixel; inline;
//begin
//  result.n:=code
//end;

function Pixel(code:byte):TPixel;inline;
begin
  result.r:=code;
  result.g:=code;
  result.b:=code;
  result.a:=$ff;
end;

function Pixel(code:string):TPixel; inline;
begin
  if code='' then exit;
  Assert(code[1]='#');
  code[1]:='$';
  Result.n:=StrToInt(Code);
end;


function lerp(const a,b,x:single):single; inline;
begin
  result:=a+x*b-x*a
end;

function lerp(const a,b:byte;x:single):byte; inline;
begin
  result:=round(a+x*b-x*a)
end;

function pixelInterp(const a,b:TPixel;const x:single):TPixel;
begin
  result.r:=lerp(a.r,b.r,x);
  result.g:=lerp(a.g,b.g,x);
  result.b:=lerp(a.b,b.b,x);
  result.a:=lerp(a.a,b.a,x);
end;

{$ifdef USE_BGRA}
operator :=(const p: TPixel): TBGRAPixel;
begin
  result.FromRGB(p.r,p.g,p.b,p.a);
end;

operator:=(const p: LongWord): TBGRAPixel;
begin
  result.FromColor(p shr 8,p and $ff);
end;

operator:=(const p: TBGRAPixel): TPixel;
begin
  with result do begin
    r:=p.red;
    g:=p.green;
    b:=p.blue;
    a:=p.alpha;
  end;

end;

operator:=(const p: byte): TBGRAPixel;
begin
  result.FromRGB(p,p,p);
end;
//operator := (const p:TBGRAPixel):LongWord; inline;
//begin
//  result:=(p.blue shl 24) or (p.green shl 16) or (p.blue shl 8) or (p.alpha);
//end;
{$endif}

operator:=(const c: TColor): TPixel;
begin
  result.n:=(c shl 8) or $ff;
end;

operator:=(const c: TPixel): TColor;
begin
  result:=c.n shr 8;
end;

operator:=(const c: TFPColor): TPixel;
begin
  with result do begin
    r:=c.red shr 8;
    g:=c.green shr 8;
    b:=c.blue shr 8;
    a:=c.Alpha shr 8;

  end;
end;
operator := (const c:TPixel):TFPColor; inline;
begin
  with result do
    begin
      red:=c.r shl 8;
      green:=c.g shl 8;
      blue:=c.b shl 8;
      alpha:=c.a shl 8;
    end;
end;

{ TPlotAxis }

procedure TPlotAxis.SetColor(AValue: TPixel);
begin
  if FColor.n=AValue.n then Exit;
  FColor:=AValue;
  if FPlot.Active then FPlot.update;
  if Assigned(FOnUpdate) then FOnUpdate(Self)
end;

procedure TPlotAxis.SetFont(AValue: {$ifdef USE_BGRA}TBGRAFont{$else}TFont{$endif});
begin
  if FFont=AValue then Exit;
  FFont:=AValue;
  if Assigned(FOnUpdate) then FOnUpdate(Self)
end;

procedure TPlotAxis.SetMinimumTicks(AValue: integer);
begin
  if FMinimumTicks=AValue then Exit;
  FMinimumTicks:=AValue;
  FPlot.update;
end;

procedure TPlotAxis.SetOnUpdate(AValue: TNotifyEvent);
begin
  if FOnUpdate=AValue then Exit;
  FOnUpdate:=AValue;
end;

procedure TPlotAxis.SetSpacing(AValue: integer);
begin
  if FSpacing=AValue then Exit;
  FSpacing:=AValue;
  if FPlot.Active then FPlot.update ;
  if Assigned(FOnUpdate) then FOnUpdate(Self)
end;

procedure TPlotAxis.SetTickWidth(AValue: integer);
begin
  if FTickWidth=AValue then Exit;
  FTickWidth:=AValue;
  if FPlot.Active then FPlot.update ;
  if Assigned(FOnUpdate) then FOnUpdate(Self)
end;

procedure TPlotAxis.Setwidth(AValue: integer);
begin
  if Fwidth=AValue then Exit;
  Fwidth:=AValue;
  if FPlot.Active then FPlot.update ;
  if Assigned(FOnUpdate) then FOnUpdate(Self)
end;

constructor TPlotAxis.Create(AOwner: TComponent);
begin
  Assert(AOwner is TPlot);
  inherited Create(AOwner);
  FPlot:=TPlot(AOwner);
  FColor:=Pixel($ff,$ff,$ff,$ff);
  FWidth:=1;
  FTickWidth:=2;
  FSpacing:=4;
  FMinimumTicks:=4;
  {$ifdef USE_BGRA}
  FFont:=TBGRAFont.Create;
  FFont.BGRAColor:=Pixel($ff,$ff,$ff,$aa);
  {$else}
  FFont:=TFont.Create;
  FFont.Color:=Pixel($ff,$ff,$ff,$aa);
  {$endif}
end;

destructor TPlotAxis.Destroy;
begin
  FreeandNil(FFont);
  inherited Destroy;
end;

{ TStyler }

procedure TStyler.Setopacity(AValue: single);
begin
  if Fopacity=AValue then Exit;
  Assert((AValue>=0) and (AValue<=1),'Opacity must be between 0 1nd 1');
  Fopacity:=AValue;
end;

function TStyler.Getx2: smallint;
begin
  result:=x+w
end;

function TStyler.Gety2: smallint;
begin
  result:=y+h
end;

procedure TStyler.Setx2(AValue: smallint);
begin
  w:=AValue-x
end;

procedure TStyler.Sety2(AValue: smallint);
begin
  h:=aValue-y
end;

{ TGradient }

class operator TGradient.:=(const b: TPixel): TGradient;
begin
  result.Colors[0]:=b;
  result.Colors[1]:=b;
end;

class operator TGradient.:=(const b: TGradient): TPixel;
begin
  result:=b.Colors[0]
end;

class operator TGradient.:=(const b: longword): TGradient;
begin
  result.Colors[0].n:=b;
  result.Colors[1].n:=b;
end;

class operator TGradient.:=(const b: TGradient): longword;
begin
  result:=b.Colors[0].n
end;


{ TFastBitmap }

procedure TFastBitmap.SetSize(AWidth, AHeight: integer);
begin
  inherited SetSize(AWidth, AHeight);
  FImageWidth:=RawImage.Description.BitsPerLine div RawImage.Description.BitsPerPixel;
  FData:=ScanLine[0];
end;

function TFastBitmap.GetP(const x, y: smallint): TPixel;
begin
  result:=FData[xy(x,y)]
end;


procedure TFastBitmap.SetP(const x, y: smallint;const  AValue: TPixel);
var c:TPixel;invA:byte;i:integer;
begin
  if (x<0) or (y<0) or (x> width-1) or (y>Height-1) then exit;
  i:=xy(x,y);
  if FAlphaBlend then
    with AValue do try
      if a=$ff then
        begin
          FData[i]:=Avalue;
        end
      else if a=0 then
        exit
      else begin
        c:=FData[i];
        invA:=$ff-a;
        c.r:=trunc(r*a/$ff + c.r*c.a*invA / $ffff);
        c.g:=trunc(g*a/$ff + c.g*c.a*invA / $ffff);
        c.b:=trunc(b*a/$ff + c.b*c.a*invA / $ffff);
        c.a:=a+trunc(c.a*invA / $ff);
        FData[i]:=c;
      end;
    except
      raise Exception.Create('Error on pixel setting');
    end
  else FData[i]:=AValue;
end;


procedure TFastBitmap.SetPenPos(AValue: TPoint);
begin
  if FPenPos=AValue then Exit;
  FPenPos:=AValue;
end;

procedure TFastBitmap.Clear(Pixel: TPixel);
var i,j:integer;
begin
  for i:=0 to Width-1 do
    for j:=0 to Height-1 do
      FData[xy(i,j)]:=Pixel
end;

procedure TFastBitmap.Clear;
begin
  inherited Clear;
end;

function TFastBitmap.xy(const x, y: smallint): integer;
begin
  result:=x+y*FImageWidth;
end;

constructor TFastBitmap.Create;
begin
  inherited Create;
  PixelFormat:=pf32bit;
end;

function TFastBitmap.setOpacity(const a: TPixel; const alpha: integer): TPixel;
begin
  result:=a;
  result.a:=trunc(result.a*alpha div 255);
end;

procedure TFastBitmap.Line(s: TStyler);
var x,y,dx,dy, x0, y0,x1,y1, err, e2, x2, y2, sx,sy,wd:integer;      a,ed:single;c1,c2:TPixel;
begin
  x1:=s.x2;y1:=s.y2;
  x0:=s.x;y0:=s.y;
//      dx := abs(s.x2-x0); sx := ifthen(x0 < s.x2 , 1 , -1);
//      dy := abs(s.y2-y0); sy := ifthen(y0 < s.y2 , 1 , -1);
//      err := dx-dy;                          (* error value e_xy *)
//      ed := ifthen((dx+dy) = 0 , 1 , sqrt(dx*dx+dy*dy));
//      wd:=trunc(s.strokeWidth);
//      wd := trunc((wd+1)/2);
//      while true do begin
//        p[x0,y0]:=Pixel(max(0,round($ff*((abs(err-dx+dy)/ed -wd +1)))));
//        e2 := err; x2 := x0;
//        if (2*e2 >= -dx) then begin
//           e2 += dy; y2 := y0; (* x step *)
//           while (e2 < ed*wd) and ((s.y2 <> y2) or (dx > dy)) do begin
//             y2 += sy;
//             p[x0, y2]:=Pixel(max(0,round($ff*((abs(e2)/ed -wd +1)))));
//             e2 += dx
//           end;
//           if (x0 = s.x2) then break;
//           e2 := err; err -= dy; x0 += sx;
//        end;
//        if (2*e2 <= dy) then begin                                            (* y step *)
//           e2 := dx-e2;
//           while (e2 < ed*wd) and ((s.x2 <> x2) or (dx < dy)) do begin
//             x2 += sx;
//             p[x2, y0]:=Pixel(max(0,round($ff*((abs(e2)/ed -wd +1)))));
//             e2 += dy
//           end;
//           if (y0 = s.y2) then break;
//           err += dx;
//           y0 += sy;
//        end;
//     end;
//exit;
//

  dy:=y1-y0;
  dx:=x1-x0;
  if (abs(dx)>abs(dy)) then a:=dy/dx else a:=dx/dy;
  //if s.strokeisFill then begin
  //  c1:=s.fill.Colors[0];
  //  c2:=s.fill.Colors[1];
  //end else
  begin
    c1:=s.stroke.Colors[0];
    c2:=s.stroke.Colors[1];
  end;
  if c1.n=c2.n then
    if abs(dx)>abs(dy) then begin
      x:=x0;
      while x<>x1 do begin
        p[x,round(y0+a*(x-x0))]:=c1;
        if x1>x0 then inc(x) else dec(x);
      end
    end else begin
      y:=y0;
      while y<>y1 do begin
        p[round(x0+a*(y-y0)),y]:=c1;
        if y1>y0 then inc(y) else dec(y);
      end
    end
  else if abs(dx)>abs(dy) then begin
      x:=x0;
      while x<>x1 do begin
        p[x,round(y0+a*(x-x0))]:=pixelInterp(c1,c2,(x-x0)/(s.w));
        if x1>x0 then inc(x) else dec(x);
      end
    end else begin
      y:=y0;
      while y<>y1 do begin
        p[round(x0+a*(y-y0)),y]:=pixelInterp(c1,c2,(y-y0)/s.h);
        if y1>y0 then inc(y) else dec(y);
      end
    end
end;

procedure TFastBitmap.Line(x0, y0, x1, y1: smallint);
procedure ln(const x0,y0,x1,y1:integer);
var s:TStyler;
begin
  s:=styler;s.x:=x0;s.y:=y0;s.x2:=x1;s.y2:=y1;
  Line(s);
end;

var fx,fy,d,dx,dy,hx,hy,i:integer; w,wx,wy,a,a1,a2:single;
begin

  if (styler.strokeWidth=0) or (styler.stroke.Colors[0].a or styler.stroke.Colors[0].a=0) then exit;
  w:=styler.strokeWidth;
  dx:=x1-x0;
  dy:=y1-y0;
  if abs(dx)>abs(dy) then begin
    a:=dy/dx;
    //    w*w=dx*dx+dy*dy
    // => dx*dx=w*w-dy*dy
    // => 1=w*w/dx*dx - dy*dy/dx*dx
    // => w*w/dx*dx = 1+dy*dy/dx*dx
    // => dx*dx/w*w = 1/(1+dy*dy/dx*dx)
    // => dx*dx = w*w/(1+a*a)
    // => |dx| = w*sqrt(1/(1+a*a))
    a1:=w*sqrt(1/(1+a*a));         // |cosine|
    a2:=w*sqrt(1*a*a/(a*a+1));     // |sine|

  end;
  if abs(dx)<abs(dy) then begin
    a:=dx/dy;
    a2:=w*sqrt(1/(1+a*a));
    a1:=w*sqrt(a*a/(a*a+1));
  end;
//  a1:=dx/dy;
  //wx:=sqrt(1/(1+a*a)) ;
  //wy:=sqrt(1/(1+a1*a1)) ;
  //d:=trunc(wx / 2);

  //if dy<>0 then begin
    d:=trunc(a1*0.5);
    for i:= -d to round(a1-d)-1 do begin
      ln(x0   ,y0+i,x1   ,y1+i);
    end;
  //end;

  //if dx<>0 then begin
    d:=round(a2*0.5);
    for i:= -d to ceil(a2-d)-1 do begin
      ln(x0+i,y0   ,x1+i,y1   );
    end;
  //end;
  //if (dx>dy) then begin
  //  for i:=0 to round(wx-1) do
  //    begin
  //      styler.x:=x1+trunc(i*wx)-d;
  //      styler.y:=y1+trunc(i*wy)-d;
  //      styler.x2:=x2+trunc(i*wx)-d;
  //      styler.y2:=y2+trunc(i*wy)-d;
  //      Line(styler);
  //    end;
  //end;

  //else
  //  for i:=0 to round(w-1) do
  //    begin
  //      styler.x:=x1+trunc(i*wy)-d;
  //      styler.y:=y1+trunc(i*wx)-d;
  //      styler.x2:=x2+trunc(i*wy)-d;
  //      styler.y2:=y2+trunc(i*wx)-d;
  //      Line(styler);
  //    end
end;

procedure TFastBitmap.MoveTo(x,y:smallint);
begin
  FPenPos.x:=x;
  FPenPos.y:=y
end;

procedure TFastBitmap.LineTo(x,y:smallint);
begin
  Line(FPenPos.x,FPenPos.y,x,y);
  FPenPos.x:=x;FPenPos.y:=y
end;

procedure TFastBitmap.Rect( s: TStyler;fill:boolean);
var x,y,i,d:integer;
begin
  if fill then
    if s.fill.Colors[0].n<>s.fill.Colors[1].n then
      case s.fill.style of
        grTop:
          for y:=s.y to s.y2 do
            for x:=s.x to s.x2 do
              P[x,y]:=pixelInterp(s.fill.Colors[0],s.fill.Colors[1],(y-s.y)/s.h);
        grLeft:
          //for x:=s.x to s.x2-1 do begin
          //  s.stroke:=pixelInterp(s.fill.Colors[0],s.fill.Colors[1],(x-s.x)/(s.x2-s.x));
          //  Line(x,s.y,x,s.y2);
          //end;
          for y:=s.y to s.y2 do
            for x:=s.x to s.x2 do
              P[x,y]:=pixelInterp(s.fill.Colors[0],s.fill.Colors[1],(x-s.x)/s.w);
        grTopLeft:
          for y:=s.y to s.y2 do
            for x:=s.x to s.x2 do
              P[x,y]:=pixelInterp(s.fill.Colors[0],s.fill.Colors[1],(x +y -s.x -s.y)/(s.h+s.w))
      end
    else
      for y:=s.y to s.y2 do
        for x:=s.x to s.x2 do
          P[x,y]:=s.fill.Colors[0]
  else
    begin
      d:=round(s.strokeWidth/2);
      for i:=-d to d do
        begin
          Moveto(s.x+d,s.y+d);
          LineTo(s.x2-d,s.y+d);
          LineTo(s.x2-d,s.y2-d);
          LineTo(s.x+d,s.y2-d);
          LineTo(s.x+d,s.y+d);
        end
    end;
    if fill then rect(s,false)
end;

procedure TFastBitmap.EllipseC(cx,cy,rx,ry:integer;fill:boolean);
var  dx,  dy,  d1,  d2,  x,  y,  x1,  x2,  y1,  y2:integer;s:TStyler;
begin

  //x*x/rx*rx + y*y/ry*ry=1
  //y*y/ry*ry = 1 - x*x/rx*rx
  //y = sqrt(ry*ry*(1 - x*x/rx*rx))
  //moveto(cx-rx,cy);
  //for x:=1-rx to rx do begin
  //  lineTo(cx+x, round(cy+ sqrt(ry*ry*(1 - x*x/(rx*rx)))));
  //
  //end;
  //for x:=rx downto -rx do begin
  //  lineTo(cx+x, round(cy -sqrt(ry*ry*(1 - x*x/(rx*rx)))));
  //
  //end;

  // converted from https://www.geeksforgeeks.org/midpoint-ellipse-drawing-algorithm/
  //exit;
//  styler.strokeIsFill:=true;

  x := 0;
  y := ry;
  // Initial decision parameter of region 1
  d1 := (ry * ry) - (rx * rx * ry) + trunc(0.25 * rx * rx);
  dx := 2 * ry * ry * x;
  dy := 2 * rx * rx * y;

  // For region 1
  while (dx < dy) do begin
      // Print points based on 4-way symmetry
      x1:=cx-x;
      x2:=cx+x;
      y1:=cy-y;
      y2:=cy+y;
      if fill then
        if (styler.fill.Colors[0].n>0) then
        begin
            s.stroke:=styler.fill;
            s.strokeWidth:=1;
            s.x:=x1;s.y:=y1;s.x2:=x2;s.y2:=y1;
            Line(s);
            s.x:=x1;s.y:=y2;s.x2:=x2;s.y2:=y2;
            Line(s);
        end else
      else if styler.stroke.Colors[0].n>0 then begin
        p[x1,y1]:=styler.stroke;
        p[x2,y1]:=styler.stroke;
        p[x1,y2]:=styler.stroke;
        P[x2,y2]:=styler.stroke;
      end;
      // Checking and updating value of
      // decision parameter based on algorithm
      if (d1 < 0) then begin
          inc(x);
          dx := dx + (2 * ry * ry);
          d1 := d1 + dx + (ry * ry);
      end
      else begin
          inc(x);
          dec(y);
          dx := dx + (2 * ry * ry);
          dy := dy - (2 * rx * rx);
          d1 := d1 + dx - dy + (ry * ry);
      end
  end;
  // Decision parameter of region 2
  d2 := trunc((ry * ry) * ((x + 0.5) * (x + 0.5))) + ((rx * rx) * ((y - 1) * (y - 1))) - (rx * rx * ry * ry);
  // Plotting points of region 2
  while (y >= 0) do begin
      // Print points based on 4-way symmetry
      x1:=cx-x;
      x2:=cx+x;
      y1:=cy-y;
      y2:=cy+y;
      if fill then
        if (styler.fill.Colors[0].n>0) then begin
            s.stroke:=styler.fill;
            s.strokeWidth:=1;
            s.x:=x1;s.y:=y1;s.x2:=x2;s.y2:=y1;
            Line(s);
            s.x:=x1;s.y:=y2;s.x2:=x2;s.y2:=y2;
            Line(s);
        end else
      else
        if styler.stroke.colors[0].n>0 then begin
          p[x1,y1]:=styler.stroke;
          p[x2,y1]:=styler.stroke;
          p[x1,y2]:=styler.stroke;
          P[x2,y2]:=styler.stroke;
        end;
      // Checking and updating parameter
      // value based on algorithm
      if (d2 > 0) then begin
          dec(y);
          dy := dy - (2 * rx * rx);
          d2 := d2 + (rx * rx) - dy;
      end else
      begin
          dec(y);
          inc(x);
          dx := dx + (2 * ry * ry);
          dy := dy - (2 * rx * rx);
          d2 := d2 + dx - dy + (rx * rx);
      end
  end;
end;

procedure TFastBitmap.SetAlphaBlend(AValue: boolean);
begin
  if FAlphaBlend=AValue then Exit;
  FAlphaBlend:=AValue;
end;

procedure TFastBitmap.EllipseC(cx, cy, rx, ry: integer);
var i,d,d2:integer;
begin
  d2:=trunc(ifthen(styler.strokeWidth=0,1,styler.strokeWidth));
  d:=trunc(styler.strokeWidth/2);
  EllipseC(cx,cy,2*rx-d,2*ry-d,true);
  for i:=0 to d2-1 do begin
    EllipseC(cx,cy,2*rx+i-d,2*ry-d,false) ;
    EllipseC(cx,cy,2*rx+d  ,2*ry+i-d,false)
  end;
end;

procedure TFastBitmap.Ellipse(x1, y1, x2, y2: integer);
var rx, ry, cx, cy:integer;
begin
  rx:=trunc((x2-x1)/2);
  ry:=trunc((y2-y1)/2);
  EllipseC(x1+rx,y1+ry,rx,ry)
end;

procedure TFastBitmap.Rect(x1,y1,x2,y2:smallint);
var x,y:integer;
begin
  styler.x:=x1;
  styler.y:=y1;
  styler.x2:=x2;
  styler.y2:=y2;
  rect(styler,true);
  //styler.stroke:=Pixel($ff,$ff,$ff,$ff);
  //styler.fill:=Pixel($ff,0,0,$ff);

  //EllipseC(round((x1+x2)/2),Round((y1+y2)/2),(x2-x1) div 2,(y2-y1) div 2);
end;



{ TPlot }

function TPlot.Add(const D: TDoubleDynArray;const GraphStyle:TGraphStyle): Integer;
begin
  Add(D,nil,GraphStyle);
end;

function TPlot.Add(const D: TExtendedDynArray; const GraphStyle: TGraphStyle): Integer;
var i:integer;DD:TDoubleDynArray;
begin
  setLength(DD,Length(D));
  for i:=0 to Length(D)-1 do
    DD[i]:=D[i];
  result:=Add(DD,GraphStyle);
end;

function TPlot.Add(const D: TSingleDynArray; const GraphStyle: TGraphStyle): Integer;
var i:integer;DD:TDoubleDynArray;
begin
  setLength(DD,Length(D));
  for i:=0 to Length(D)-1 do
    DD[i]:=D[i];
  result:=Add(DD,GraphStyle);
end;

function TPlot.Add(const D: TComplexArrayF; const GraphStyle: TGraphStyle): Integer;
begin
  add(d.Mag(),GraphStyle);

end;

function TPlot.Add(const D: TComplexArrayD; const GraphStyle: TGraphStyle): Integer;
begin
  add(d.Mag(),GraphStyle);

end;

function TPlot.Add(const D: TIntegerDynArray; const GraphStyle: TGraphStyle): Integer;
var i:integer;db:TDoubleDynArray;
begin
  setLength(db,Length(D));
  for i:=0 to High(db) do
    db[i]:=d[i];
  add(db,GraphStyle);
end;

function TPlot.Add(const D: TDoubleDynArray; const base: TDoubleDynArray; const GraphStyle: TGraphStyle): Integer;
begin
  FData.Push(D);
  if assigned(base)then FBases.Push(Base) else begin
    FBases.Push(TDoubleDynArray.fill(D.Count,0,0,0));
  end;
  if (FAutoScale in [asBoth,asY]) then begin
    FMaxs.Push(d.Max);
    FMins.push(d.Min);
    FMinY:=FMins.Min();
    FMaxY:=FMaxs.Max();
  end else if FMinY=FMaxY then begin
    FMinY:=0;
    FMaxY:=1;
  end;
  setLength(FGraphOptions,Length(FGraphOptions)+1);

  with FGraphOptions[High(FGraphOptions)] do
    begin
      Fill:=FColors[High(FGraphOptions) mod Length(FColors)];
      Style:=GraphStyle;
      BarsRatio:=0.8;
      Size:=4;
      if GraphStyle=gsLine then Stroke:=Fill
      else Stroke:=0;
      strokeWidth:=2;
    end;
  Result:=FData.Count-1;
  if FActive then Repaint

end;

function TPlot.Add(const D: TExtendedDynArray; const base: TExtendedDynArray; const GraphStyle: TGraphStyle): Integer;
var i:integer;DD,BB:TDoubleDynArray;
begin
  setLength(DD,Length(D));
  setLength(BB,Length(D));
  for i:=0 to Length(D)-1 do
    begin
      DD[i]:=D[i];
      BB[i]:=Base[i]
    end;
  result:=Add(DD,BB,GraphStyle);
end;

function TPlot.Add(const D: TSingleDynArray; const base: TSingleDynArray; const GraphStyle: TGraphStyle): Integer;
var i:integer;DD,BB:TDoubleDynArray;
begin
  setLength(DD,Length(D));
  setLength(BB,Length(D));
  for i:=0 to Length(D)-1 do
    begin
      DD[i]:=D[i];
      BB[i]:=Base[i]
    end;
  result:=Add(DD,BB,GraphStyle);
end;

function TPlot.Add(const D: TComplexArrayF; const base: TComplexArrayF; const GraphStyle: TGraphStyle): Integer;
begin
  add(d.Mag(),base.Mag(),GraphStyle);

end;

function TPlot.Add(const D: TIntegerDynArray; const base: TIntegerDynArray; const GraphStyle: TGraphStyle): Integer;
var i:integer;dd,bb:TDoubleDynArray;
begin
  setLength(DD,Length(D));
  setLength(BB,Length(D));
  for i:=0 to Length(D)-1 do
    begin
      DD[i]:=D[i];
      BB[i]:=Base[i]
    end;
  result:=Add(DD,BB,GraphStyle);
end;

function TPlot.Remove(const index: integer): TDoubleDynArray;
begin
  if not Assigned(FData) then exit;
  Result:=FData[index];
  FData.Splice(Index,1,nil);
  FBases.Splice(Index,1,nil);
  if FAutoScale in [asBoth,asY] then
    if DataCount>0 then
      begin
        FMins.Splice(Index,1,nil);
        FMaxs.Splice(Index,1,nil);
        FMinY:=FMins.Min();
        FMaxY:=FMaxs.Max()
      end
    else
      begin
        FMinY:=0;
        FMaxY:=0;
      end;
  delete(FGraphOptions,Index,1);
  if FActive then Repaint
end;

function TPlot.GetData(Index: Integer): TDoubleDynArray;
begin
  if Assigned(FData) then
    Result:=FData[index]
end;

function TPlot.GetRanges(Index: integer): TDataRange;
begin
  begin
    result.minVal:=GetData(index).Min();
    result.maxVal:=GetData(index).Max();
  end;
end;

procedure TPlot.SetData(Index: Integer; AValue: TDoubleDynArray);
begin
  if Length(AValue)=0 then
    FData[Index]:=nil
  else
    begin
      FData[index]:=AValue;
      if FAutoScale in [asBoth,asY] then
        begin
          FMins[Index]:=AValue.Min();
          FMaxs[Index]:=AValue.Max();
          FMinY:=FMins.Min();
          FMaxY:=FMaxs.Max();
        end;

    end;
  if FActive then Repaint
end;

procedure TPlot.SetRanges(Index: integer; AValue: TDataRange);
begin
  FMins[index]:=AValue.minVal;
  FMaxs[index]:=AValue.maxVal;
  FMinY:=FMins.Min();
  FMaxY:=FMaxs.Max();
  if FActive then Repaint
end;

procedure TPlot.SetDataCount(AValue: integer);
var i:integer;
begin
  if FData.Count=AValue then Exit;
  FData.Count:=AValue;
  if FAutoScale in [asBoth,asY] then begin
    FMins.Count:=AValue;
    FMaxs.Count:=AValue;
  end;
  //FColors.Count:=AValue;
  setLength(FGraphOptions,AValue);
  for i:=0 to AValue-1 do begin
    FGraphOptions[i].Fill:=FColors[i mod Length(FColors)];
    FGraphOptions[i].Stroke:=$0;
  end;
  if FActive then Repaint;
end;

procedure TPlot.SetGraphOptions(index: integer; AValue: TGraphOption);
begin
  if FActive then Repaint;
end;

procedure TPlot.SetMaxX(AValue: double);
begin
  if FMaxX=AValue then Exit;
  FMaxX:=AValue;
end;

procedure TPlot.SetMaxY(AValue: double);
begin
  if FMaxY=AValue then Exit;
  FMaxY:=AValue;
end;

procedure TPlot.SetMinX(AValue: double);
begin
  if FMinX=AValue then Exit;
  FMinX:=AValue;
end;

procedure TPlot.SetMinY(AValue: double);
begin
  if FMinY=AValue then Exit;
  FMinY:=AValue;
end;

procedure TPlot.SetBounds(aLeft, aTop, aWidth, aHeight: integer);
begin
  //if not Assigned(Parent) then exit;
//
  //FBitmap.SetSize(Self.Width,Self.Height);
  //if FActive then Repaint;
  inherited SetBounds(aLeft, aTop, aWidth, aHeight);


end;

procedure TPlot.Resize;
begin
  if (Width>0) and (Height>0) then
    FBitmap.SetSize(Width,Height);
  if FActive then Repaint;
  if FAutoTicks then begin
    FAxisY.FMinimumTicks:=max(Height div 100,1);
    FAxisX.FMinimumTicks:=max(Width div 100,1);
  end;
  inherited Resize;
end;

procedure TPlot.SetPaddingBottom(AValue: smallint);
begin
  if FPaddingBottom=AValue then Exit;
  FPaddingBottom:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetPaddingLeft(AValue: smallint);
begin
  if FPaddingLeft=AValue then Exit;
  FPaddingLeft:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetPaddingRight(AValue: smallint);
begin
  if FPaddingRight=AValue then Exit;
  FPaddingRight:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetPaddingTop(AValue: smallint);
begin
  if FPaddingTop=AValue then Exit;
  FPaddingTop:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetParent(NewParent: TWinControl);
begin
  inherited SetParent(NewParent);
  if not Assigned(Parent) then exit;
  //if ParentFont then begin
  //  Font.Assign(Parent.Font);
  //  FAxisX.FFont.Assign(Self.Font);
  //  FAxisY.FFont.Assign(Self.Font);
  //end;
end;

procedure TPlot.ShowPlot;
begin
  if (Owner is TForm) then
    TForm(Owner).ShowModal

end;

procedure TPlot.OnOwnerShow(Sender: TObject);
begin
//  Application.BringToFront;
end;

function TPlot.DoCombineColors(const color1, color2: TFPColor): TFPColor;
begin
//  Beep;
  //
end;

function TPlot.GetDataCount: integer;
begin
  result:=FData.Count
end;

function TPlot.GetGraphOptions(index: integer): TGraphOption;
begin
  result:=FGraphOptions[index];
end;

function TPlot.GetPlotHeight: smallint;
begin
  result:=Height-FPaddingTop-FPaddingBottom
end;

function TPlot.GetPlotWidth: smallint;
begin
  result:=Width-FPaddingLeft-FPaddingRight
end;

procedure TPlot.SetActive(AValue: boolean);
begin
  if FActive=AValue then Exit;
  FActive:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetAutoScale(AValue: TAutoScale);
begin
  if FAutoScale=AValue then Exit;
  FAutoScale:=AValue;
end;

procedure TPlot.SetAutoTicks(AValue: boolean);
begin
  if FAutoTicks=AValue then Exit;
  FAutoTicks:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetAxisX(AValue: TPlotAxis);
begin
  if FAxisX=AValue then Exit;
  FAxisX:=AValue;
end;

procedure TPlot.SetAxisY(AValue: TPlotAxis);
begin
  if FAxisY=AValue then Exit;
  FAxisY:=AValue;
end;

procedure TPlot.SetBackground(AValue: TGradient);
begin
  //if FBackground=AValue then Exit;
  FBackground:=AValue;
end;

procedure TPlot.SetBarsRatio(AValue: single);
begin
  if FBarsRatio=AValue then Exit;
  FBarsRatio:=AValue;
  if FActive then Repaint;
end;

procedure TPlot.SetColors(AValue: TLongWordDynArray);
begin
  if FColors=AValue then Exit;
  FColors:=AValue;
  if FActive then Repaint
end;

constructor TPlot.Create(AOwner: TComponent);
begin
  FAxisX:=TPlotAxis.Create(Self);
  FAxisY:=TPlotAxis.Create(Self);
  FAutoTicks:=true;
  {$if defined(USE_BGRA)}
  FBitmap:=TBGRABitmap.Create;
  {$elseif defined(USE_FASTBITMAP)}
  FBitmap:=TFastBitmap.Create;
  {$else}
  FBitmap:=TPortableNetworkGraphic.Create;
  FBitmap.Canvas.DrawingMode:=dmAlphaBlend;

  {$endif}
  FBitmap.Canvas.OnCombineColors:=@DoCombineColors;
  FPaddingLeft:=24;
  FPaddingRight:=24;
  FPaddingTop:=24;
  FPaddingBottom:=24;
  FBackground:=Pixel($00,$11,$11,$ff);
  FColors:=TMaterial2Colors;
  inherited Create(AOwner);
  //FBackground.Colors[1]:=Pixel($22,$0,$0,$ff);



end;

destructor TPlot.Destroy;
var i:integer;
begin
  FreeAndNil(FBitmap);
  inherited Destroy;
end;

function TPlot.alignMaxTicks( range:extended;minTicks:integer):TDoubleDynArray;
var i,p,lg,po:integer;vr:TDoubleDynArray;r:extended;
begin
    if range<=0 then exit([0,1]);
    if range<1 then
      lg:=10**abs(trunc(log10(range))-2)
    else
      lg:=10;
    setLength(vr,minTicks);
    for i:=0 to minTicks-1 do
      vr[i]:=ceil(range*lg/minticks+i)*(minticks+i)/lg;
    r:=Math.MinValue(vr);
    p:=vr.indexOf(r)+minticks;
    result:= [r,p];
end;

//TMapCallbackVar


procedure TPlot.xScale;
var i, w,h,tick,rounding,ticks,marginX:integer;Spacing,SpanX:single;v:TDoubleDynArray;textSize:TSize;
begin
  w:=PlotWidth;
  h:=PlotHeight;
  setLength(v,FData.Count);
  for i:=0 to High(v) do v[i]:=FData[i].Count;
  if FAutoScale in [asBoth,asX] then begin
    FMaxX:=round(v.Max());
  end;

  with {$ifdef USE_BGRA}FBitmap.CanvasBGRA {$else}FBitmap.Canvas{$endif}do begin
    Pen.{$ifdef USE_BGRA}BGRAColor{$else}Color{$endif}:=AxisX.Color;
    Pen.Width:=Axisx.Fwidth;
    Pen.Style:=psSolid;
    Font.Assign(AxisX.FFont);
    Brush.Style:=bsClear;
    MoveTo(FPaddingLeft+FTxtWidthY,FPaddingTop+H);
    LineTo(FPaddingLeft+W,FPaddingTop+H);
    //TextStyle.Alignment:=taLeftJustify;
    ticks:=round(alignMaxTicks(FMaxX,AxisX.FMinimumTicks)[1]);
    W:=W-FTxtWidthY;
    marginX:=round(W/FMaxX);
    rounding:=floor(log10(FMaxX)/ticks);
    spanx:=FMaxX/ticks;
    Spacing:=(W-marginX)/Ticks;
    for i:=0 to Ticks do begin
      tick:=trunc(FPaddingLeft+FTxtWidthY+Spacing*i+marginX div 2);
      pen.width:=1;
      if AxisX.FTickWidth>0 then begin
        MoveTo(tick,FPaddingTop+H-AxisX.Width);
        lineTo(tick,FPaddingTop+H-AxisX.width-AxisX.FTickWidth);
      end;
      textSize:=TextExtent(IntToStr(i));
      TextOut(tick-textSize.Width div 2,FPaddingTop+AxisX.FSpacing+H, FloatToStr(roundto(i*spanX,rounding)) {xLabels go here});
    end;
  end;
end;



procedure TPlot.yScale;
var w,h,i:integer;tick,rounding:integer;a:TDoubleDynArray;Spacing,Span,lg:Double;txt:string;textSize:TSize;
begin
  h:=PlotHeight;w:=PlotWidth;
  a:=alignMaxTicks(FMaxY-FMinY,AxisY.FMinimumTicks);

  Spacing:=H/a[1];
  yMax:=a[0]+FMinY;
  yMin:=FMinY;
  if ((yMax-yMin)/a[1])>1 then begin
    rounding:=-1;
    yMin:=Floor(FMinY);
  end else
  begin
    lg:=(yMax-yMin)/a[1];
    lg:=abs(log10(lg));
    rounding:=-ceil(lg);
    //yMin:=floor(FMinY*{0.5*}power(10,rounding+1))/(power(10,rounding+1){*0.5});
  end;
  Span:=(yMax-yMin)/a[1];

  //lg:=Log10(span);
//  if lg>0 then rounding:=0;
  with {$ifdef USE_BGRA}FBitmap.CanvasBGRA{$else}FBitmap.Canvas{$endif} do begin
    font.color:=clWhite;
//    TextOut(40,40,Rounding);
    textSize:=TextExtent(RoundTo(yMin,rounding).ToString);
    FtxtWidthY:=max(textSize.Width,TextExtent(RoundTo(yMax,rounding).ToString).Width);
    FTxtHeightY:=max(textSize.Height,TextExtent(RoundTo(yMax,rounding).ToString).Height);
    //TextOut(10,10,a);
    //TextOut(400,30,FMinY.ToString+',  '+FMaxY.ToString);
    Pen.{$ifdef USE_BGRA}BGRAColor{$else}Color{$endif}:=AxisY.Color;
    Pen.Width:=AxisY.Fwidth;
    Pen.Style:=psSolid;
    Font.Assign(AxisY.FFont);
    MoveTo(FPaddingLeft+FTxtWidthY,FPaddingTop);
    LineTo(FPaddingLeft+FTxtWidthY,FPaddingTop+h);
    for i:=0 to trunc(a[1]) do
      begin
        txt:=FloatToStr(RoundTo(yMin+i*span,rounding));
        tick:=trunc(FPaddingTop+H-i*Spacing-AxisY.width);
        if AxisY.FTickWidth>0 then
          begin
            MoveTo(FPaddingLeft+AxisY.width+FTxtWidthY,Tick);
            lineTo(FPaddingLeft+FTxtWidthY+AxisY.width+AxisY.FTickWidth,tick);
          end;
        textSize:=TextExtent(txt);
        TextOut(FPaddingLeft+FTxtWidthY-AxisY.Spacing-textSize.Width,tick-textSize.Height div 2,txt);
      end;

  end;

end;
//procedure TPlot.

var  scl:double=1;valSpan:integer=20;tSpan:integer=40 ;
procedure TPlot.paint;
var i,j,w,h,lPos, barWidth:integer; Spacing:Single ;D,B:TIntegerDynArray;
begin
  if not FActive or not Assigned(FData) then exit;
  {$ifdef USE_BGRA}
  {$else}
  //if FBitmap.Canvas.LockCount>0 then exit;
  //FBitmap.Canvas.TryLock;
  {$endif}
  w:=PlotWidth;
  h:=PlotHeight;
  with {$ifdef USE_BGRA} FBitmap.CanvasBGRA{$else}FBitmap.Canvas{$endif} do begin
    Brush.{$ifdef USE_BGRA}BGRAColor{$else}Color{$endif}:=FBackground.Colors[0];
    Brush.Style:=bsSolid;
    FillRect(0,0,Canvas.Width,Canvas.Height);
    pen.Style:=psSolid;
    for i:=0 to H-1 do      // paint background
      begin
        Pen.{$ifdef USE_BGRA}BGRAColor{$else}Color{$endif}:=pixelInterp(FBackground.Colors[0],FBackground.Colors[1],i/h);
        MoveTo(FPaddingLeft+FTxtWidthY,FPaddingTop+i);
        LineTo(FPaddingLeft+w,FPaddingTop+i);
      end;
  end;

  //FBitmap.CanvasBGRA.GradientFill(
  //  Rect(FPaddingLeft,  FPaddingTop+PlotHeight,  FPaddingLeft+PlotWidth,  FPaddingTop+PlotHeight),
  //  clSilver,//FBackground.Colors[0].n shr 8,
  //  clWhite, //FBackGround.Colors[1].n shr 8,
  //
  //  gdHorizontal
  //);
  //FBitmap.BeginUpdate();
  //FBitmap.Styler.fill:=Pixel($00,$a0,$ff,$ff);
  //FBitmap.Styler.stroke:=Pixel($ff,$ff,$ff,$ff);
  //FBitmap.Styler.strokeWidth:=9;
  //FBitmap.Styler.stroke.Colors[0]:=Pixel($ff,0,0,$ff);
//  FBitmap.Styler.stroke.Colors[1]:=Pixel(0,0,$ff,$ff);


//  with FBitmap.CanvasBGRA do begin
//    //Brush.Color:=clForm;
//    FillRect(Canvas.ClipRect);
//
//    //pen.style:=psSolid;
//    //Pen.Color:=clWhite;
//    //pen.Width:=10;
//
//    //Clear(Pixel(0,0,0,0));
//    MoveTo(FPaddingLeft+W div 2,FPaddingTop);
//    LineTo(FPaddingLeft+W, FPaddingTop+ H div 2);
//    Lineto(FPaddingLeft+W div 2,FPaddingTop+ H);
//    LineTo(FPaddingLeft,FPaddingTop+H div 2);
//    LineTo(FPaddingLeft+W div 2,FPaddingTop);
////
//    moveto(FPaddingLeft+W div 4,FPaddingTop+H div 4);
//    lineto(FPaddingLeft+W*3 div 4,FPaddingTop+h div 4);
//    lineto(FPaddingLeft+W*3 div 4,FPaddingTop+H*3 div 4);
//    lineto(FPaddingLeft+W div 4,FPaddingTop+H*3 div 4);
//    lineto(FPaddingLeft+W div 4,FPaddingTop+H div 4);
//
//    //Styler.strokeWidth:=1;
//    //Styler.stroke:=pixel(0,0,$ff,$ff);
//
//    Line(FPaddingLeft, FPaddingTop, FPaddingLeft+W, FPaddingTop);
//    Line(FPaddingLeft+W, FPaddingTop, FPaddingLeft+W, FPaddingTop+ H);
//    Line(FPaddingLeft+W, FPaddingTop+ H, FPaddingLeft, FPaddingTop+H);
//    Line(FPaddingLeft, FPaddingTop+H, FPaddingLeft, FPaddingTop);
//
//
//  end;
  //FBitmap.Canvas.pen.Style:=psSolid;
  //FBitmap.canvas.pen.color:=$ffffff;
  //FBitmap.canvas.Brush.FPColor:=FPColor($0,$8000,$ffff,$1000); // $ffa000;
  //FBitmap.canvas.pen.Width:=10;
  //FBitmap.CanvasBGRA.EllipseC(FPaddingLeft +w div 4,PaddingTop + h div 2, 100, 100);
  //FBitmap.CanvasBGRA.EllipseC(FPaddingLeft +w * 3 div 4,PaddingTop + h div 2, 100, 100);


  //FBitmap.Styler.fill:=Pixel($0,$80,$ff,0);;
  //FBitmap.styler.stroke:=pixel(0,$ff,0,$ff);
  //FBitmap.styler.strokeWidth:=8;

  //FBitmap.ellipsec(FPaddingLeft +w div 2,PaddingTop + h div 2, 100, 100);

  yScale;
  xScale;
  with {$ifdef USE_BGRA}FBitmap.CanvasBGRA{$else}FBitmap.Canvas{$endif} do begin
      Brush.Style:=bsSolid;
      Pen.Style:=psSolid;
      for j:=0 to Self.FData.Count-1 do begin
        {$ifdef USE_BGRA}
        Brush.BGRAColor:=FGraphOptions[j].Fill.Colors[0];
        Pen.BGRAColor:=FGraphOptions[j].Stroke.Colors[0];
        {$else}
        Brush.FPColor:=FGraphOptions[j].Fill.Colors[0];
        Pen.FPColor:=FGraphOptions[j].Stroke.Colors[0];
        {$endif}
        Pen.Width:=FGraphOptions[j].StrokeWidth;
        if (FGraphOptions[j].StrokeWidth=0) or (FGraphOptions[j].Stroke.Colors[0].n=0) then
          pen.Style:=psClear
        else
          pen.Style:=psSolid;
        D:=FData[j].Map(yMin,yMax,FPaddingTop+h-AxisY.Width,FPaddingTop).Round;
        Spacing:=(w-FTxtWidthY)/D.Count;
        barWidth:=round(Spacing*BarsRatio/2);
        if FGraphOptions[j].Style=gsBar then
          B:=FBases[j].Map(yMin,yMax,0,h).Round;
        for i:=0 to D.Count-1 do begin
          lPos:=FPaddingLeft+FTxtWidthY+trunc(Spacing/2)+trunc(i*Spacing);
          case FGraphOptions[j].Style of
            gsScatter :
              EllipseC(lPos,d[i],FGraphOptions[j].Size,FGraphOptions[j].Size);
            gsBar:begin
              if Assigned(b) then
                Rectangle(lPos-barWidth,d[i],max(lPos+barWidth,1),FPaddingTop+h-AxisY.Width - B[i])
              else
                Rectangle(lPos-barWidth,d[i],max(lPos+barWidth,1),FPaddingTop+h-AxisY.Width)

            end;
            gsLine:
              if i=0 then
                 MoveTo(lPos,d[i])
              else
                LineTo(lPos,d[i]);
          end;
        end;
      end;
    //      TextOut(60,60,format('yMix[%f] yMax[%f] FMinY[%f] FMaxY[%f]',[yMin, yMax, FMinY, FMaxY]) );
  end;
  {$ifdef USE_BGRA}
  {$else}
  //fBitmap.Canvas.Unlock;
  {$endif}
  //FBitmap.EndUpdate();
  Canvas.Draw(0,0,{$ifdef USE_BGRA}FBitmap.Bitmap{$else}FBitmap{$endif});
  inherited Paint;
end;

initialization
  if not (AppInitialized in Application.Flags) then begin
    Application.Initialize;
    frm:=TForm.Create(nil);
    Plot:=TPlot.Create(frm);
    frm.OnShow:=@plot.OnOwnerShow;
    Plot.Align:=alClient;
    Plot.Parent:=frm;
    frm.Width:=Screen.PrimaryMonitor.Width div 4;
    frm.Height:=Screen.PrimaryMonitor.Height div 4;
    frm.Position:=poDesktopCenter;
    Plot.Active:=true;
  end ;
finalization
  if assigned(frm) then begin
    FreeAndNil(Plot);
    FreeAndNil(frm);
  end
end.

