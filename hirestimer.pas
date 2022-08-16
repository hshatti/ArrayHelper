unit hirestimer;

{$mode objfpc}{$H+}{$W-}

{$ifndef CPUX86_64}
  {$ERROR High res timer requires an intel compatible x86/64 CPU}
{$endif}

interface
uses
  Classes, SysUtils;
{ THighResTimer }

type
  THighResTimer=class
  type
    TReg=record
      case byte of
        0:(a,b,c,d:uInt32);
        1:(reg:array[0..3] of uInt32);
        2:(str1,str2,str3,str4:array[0..3] of char);
    end;

  private
    FCPUInitTick,FInitTick:QWord;
    FCPUSpeed:QWord;// in Mhz
    FCPUMaxSpeed:QWord;
    FCPUBusSpeed:QWord;
    FCPUInfo:TReg;
    FCPUManifacturer: string;
    function CPUInfo(info:uInt32=0 {Default is CPU Highest Function and Manifacture Id }):TReg;
  public
    constructor Create;
    function NanoSeconds:QWord;inline;
    function MicroSeconds: QWord;inline;
    function GetCPUTick:QWord;assembler;nostackframe;
    function MeasureCPUSpeed: QWord;//in Mhz
    property CPUSpeed:QWord read FCPUSpeed;
    property CPUMaxSpeed:Qword read FCPUMaxSpeed;
    property CPUBusSpeed:Qword read FCPUBusSpeed;
    property CPUManifacturer:string read FCPUManifacturer;

  end;

  var HighResTimer:THighResTimer;
implementation

{ THighResTimer }

constructor THighResTimer.Create;
var r,r2:TReg;
begin
  inherited;
  r:=CPUInfo;
  FCPUManifacturer:=R.str2+R.str4+r.str3;
  r2:=CPUInfo($16);
  if ((r.a>=$16) and (r2.a>0)) then begin
    FInitTick:=GetTickCount64;
    FCPUInitTick:=GetCPUTick;
    with r2 do begin
        FCPUSpeed:=a;
        FCPUMaxSpeed:=b;
        FCPUBusSpeed:=c;
    end;
  end
  else begin  //CPU is not Skylake, guess~timate the CPU Frequency
    FInitTick:=GetTickCount64;
    FCPUInitTick:=GetCPUTick;
    Sleep(200);
    FCPUSpeed:=MeasureCPUSpeed
  end;
end;

function THighResTimer.NanoSeconds: QWord;inline;
begin
  result:=trunc(1000*(GetCPUTick/FCPUSpeed));
end;

function THighResTimer.MicroSeconds: QWord;inline;
begin
  //Assert(FCPUSpeed>0,'Cannot dertermine the CPU Speed');
  result:=round(GetCPUTick/FCPUSpeed);
end;

{$AsmMode intel}
function THighResTimer.GetCPUTick: QWord; assembler;nostackframe;
asm
    rdtsc
{$ifdef CPUX86_64}
  {$ifdef CPU64}
    shl rdx, 32
    or  rax, rdx
  {$else}
//    shl $32,%edx
//    or %edx,%eax
  {$endif}
{$else}

{$endif}
end;

function THighResTimer.MeasureCPUSpeed: QWord;
var a,b:QWord;
begin
  b:=GetTickCount64-FInitTick;
  a:=GetCPUTick-FCPUInitTick;
  result:=trunc(a / b) div 1000  // in Mhz
end;


function THighResTimer.CPUInfo(info: uInt32): TReg;
var a,b,c,d:LongWord;
begin
  asm
    mov    eax, info
    cpuid
    mov a, eax
    mov b, ebx
    mov c, ecx
    mov d, edx
  end['eax','ebx','ecx','edx'];
  result.a:=a;result.b:=b;result.c:=c;result.d:=d;
end;

initialization
  if not Assigned(HighResTimer) then
    HighResTimer:=THighResTimer.Create;
finalization
  FreeandNil(HighResTimer);
end.

