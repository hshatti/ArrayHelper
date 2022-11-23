unit hirestimer;
{$H+}{$W-}
{$ifdef fpc}
{$mode delphi}
{$endif}
{.$define USE_RDTSC}

interface
uses
  Classes, SysUtils {$ifdef mswindows}{$ifndef USE_RDTSC}, windows{$endif}{$endif}
  //{$ifndef CPUX86_64}
  //  {$ERROR High resolution timer requires an intel compatible x86/64 CPU}
  //{$endif}
  ;

type
  { THighResTimer }


{$ifdef unix}       // should work on darwin too!
  {.$linklib c}

  clockid_t=longint;
  timespec = record
    tv_sec: int64;
    tv_nsec: int64;
  end;
  PTimeSpec=^TTimeSpec;
  TTimeSpec=timespec;

  const
  {$if defined(linux)}
   //posix timer
  CLOCK_REALTIME                  = 0;
  CLOCK_MONOTONIC                 = 1;
  CLOCK_PROCESS_CPUTIME_ID        = 2;
  CLOCK_THREAD_CPUTIME_ID         = 3;
  CLOCK_MONOTONIC_RAW             = 4;
  CLOCK_REALTIME_COARSE           = 5;
  CLOCK_MONOTONIC_COARSE          = 6;

  {$elseif defined(darwin)}
  CLOCK_REALTIME                  = 0;
  CLOCK_MONOTONIC_RAW             = 4;
  CLOCK_MONOTONIC_RAW_APPROX      = 5;
  CLOCK_MONOTONIC                 = 6;
  CLOCK_UPTIME_RAW                = 8;
  CLOCK_UPTIME_RAW_APPROX         = 9;
  CLOCK_PROCESS_CPUTIME_ID        = 12;
  CLOCK_THREAD_CPUTIME_ID         = 16;

  {$else}  // libc
   CLOCK_REALTIME           = 0;
   CLOCK_PROCESS_CPUTIME_ID = 2;
   CLOCK_THREAD_CPUTIME_ID  = 3;
   CLOCK_MONOTONIC_RAW      = 4,

  {$endif}
  THE_CLOCK=CLOCK_MONOTONIC_RAW;
  strTimeError = 'cannot read OS time!, ErrorNo [%s]';

  function clock_gettime(clk_id : clockid_t; tp: ptimespec) : longint  ;cdecl; external;
type
{$endif}

  THighResTimer=class
  type
  {$if defined(USE_RDTSC) and defined(CPUX86_64)}
    TReg=record
      case byte of
        0:(a,b,c,d:uInt32);
        1:(reg:array[0..3] of uInt32);
        2:(str1,str2,str3,str4:array[0..3] of char);
    end;
  {$endif}
  private
    {$if defined(USE_RDTSC) and defined(CPUX86_64)}
    FCPUInitTick,FInitTick:QWord;
    FCPUSpeed:QWord;// in Mhz if USE_RDTSC
    FCPUMaxSpeed:QWord;
    FCPUBusSpeed:QWord;
    FCPUInfo:TReg;
    FCPUManifacturer: string;
    function CPUInfo(info:uInt32=0 {Default is CPU Highest Function and Manifacture Id }):TReg;
    {$elseif defined(unix)}
    FTimeSpec:TTimeSpec;
    {$elseif defined(mswindows)}
    FStartTick:Int64;
    FCPUSpeed:Int64;// in Ticks
    {$else}
      {.$message fatal 'I dont know what OS is this!'}

    {$endif}
  public
    constructor Create;
    function NanoSeconds:int64;inline;
    function MicroSeconds: int64;inline;
    function MilliSeconds: double;inline;

    {$if defined(USE_RDTSC) and defined(CPUX86_64)}
    function GetCPUTick:QWord;assembler;nostackframe;
    function MeasureCPUSpeed: QWord;//in Mhz
    property CPUSpeed:QWord read FCPUSpeed;
    property CPUMaxSpeed:Qword read FCPUMaxSpeed;
    property CPUBusSpeed:Qword read FCPUBusSpeed;
    property CPUManifacturer:string read FCPUManifacturer;
    {$elseif defined(MSwindows)}
    property CPUSpeed:Int64 read FCPUSpeed;
    {$endif}
  end;

  { TProfiler }
  TProfiler=class
    LogStr:string;
    m_Start,m_LastLog,m_Elapsed,m_LastSegment:int64;
    m_segments  : array[0..$f] of int64;
    procedure Log(const str:string);          overload;
    procedure Log(const SegmentId:integer);   overload;
    procedure LogSegments(const SegStrings:array of string);
    procedure Start;
    function Stop: int64;
  end;


  var Profiler:TProfiler;

  var HighResTimer:THighResTimer;

implementation

//function clock_gettime(clk_id: clockid_t; tp: ptimespec): longint;
//begin
//
//end;

{ THighResTimer }

constructor THighResTimer.Create;
{$if defined(USE_RDTSC) and defined(CPUX86_64)}
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
  else begin  //CPU is not Skylake or above, guess~timate the CPU Frequency
    FInitTick:=GetTickCount64;
    FCPUInitTick:=GetCPUTick;
    Sleep(200);
    FCPUSpeed:=MeasureCPUSpeed
  end;
end;
{$elseif defined(mswindows)}
begin
  QueryPerformanceFrequency( {$ifdef fpc}@{$endif}FCPUSpeed);
end;
{$else}
begin
end;
{$endif}

function THighResTimer.NanoSeconds: int64;
begin
  {$if defined(USE_RDTSC) and defined(CPUX86_64)}
  result:=trunc(1000*(GetCPUTick/FCPUSpeed));
  {$elseif defined(unix)}
  if clock_gettime(THE_CLOCK,@FTimeSpec) <>0 then
    raise Exception.Createfmt(strTimeError,[SysErrorMessage(GetLastOSError)]);
  result:=FTimeSpec.tv_sec*1000000000 + FTimeSpec.tv_nsec;
  {$elseif defined(mswindows)}
  QueryPerformanceCounter({$ifdef fpc}@{$endif}FStartTick);
  result:=FStartTick*1000000000 div FCPUSpeed
  {$endif}
end;

function THighResTimer.MicroSeconds: int64;
begin
  //Assert(FCPUSpeed>0,'Cannot dertermine the CPU Speed');
  {$if defined(USE_RDTSC) and defined(CPUX86_64)}
  result:=round(GetCPUTick/FCPUSpeed);
  {$elseif defined(unix)}
  if clock_gettime(THE_CLOCK,@FTimeSpec) <>0 then
    raise Exception.Createfmt(strTimeError,[SysErrorMessage(GetLastOSError)]);
  result:=FTimeSpec.tv_sec*1000000 + FTimeSpec.tv_nsec div 1000;
  {$elseif defined(mswindows)}
  QueryPerformanceCounter({$ifdef fpc}@{$endif}FStartTick);
  result:=FStartTick*1000000 div FCPUSpeed
  {$endif}
end;

function THighResTimer.MilliSeconds: Double;
begin
  {$if defined(USE_RDTSC) and defined(CPUX86_64)}
  result:=1000000*(GetCPUTick/FCPUSpeed)
  {$elseif defined(unix)}
  if clock_gettime(THE_CLOCK,@FTimeSpec) <>0 then
    raise Exception.Createfmt(strTimeError,[SysErrorMessage(GetLastOSError)]) ;
  result:=FTimeSpec.tv_sec*1000 + FTimeSpec.tv_nsec / 1000000;
  {$elseif defined(mswindows)}
  QueryPerformanceCounter({$ifdef fpc}@{$endif}FStartTick);
  result:=FStartTick*1000/FCPUSpeed
  {$endif}
end;

{$if defined(USE_RDTSC) and defined(CPUX86_64)}
{$ifdef fpc}{$AsmMode intel}  {$endif}
function THighResTimer.GetCPUTick: QWord; assembler;nostackframe;
asm
    rdtsc
{$ifdef CPUX86_64}
  {$ifdef CPU64}
    shl rdx, 32
    or  rax, rdx
  {$else}
    shl edx, 32
    or  eax, edx
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
{$endif}

{ TProfiler }

procedure TProfiler.Log(const str: string);
begin

   LogStr:=LogStr+format('Since Start[%3nms], Since LastLog[%3nms]: %s',[((HighResTimer.MicroSeconds - m_Start)/1000), (HighResTimer.MicroSeconds - m_LastLog)/1000, str])+sLineBreak;
   m_LastLog:=HighResTimer.MicroSeconds;
   m_LastSegment:=m_LastLog;
end;

procedure TProfiler.Log(const SegmentId: integer);
begin
  m_segments[SegmentId]:=m_segments[SegmentId]+HighResTimer.MicroSeconds-m_LastSegment;
  m_LastSegment:=HighResTimer.MicroSeconds;
end;

procedure TProfiler.LogSegments(const SegStrings: array of string);
var i:integer;sm:Int64;
begin
  sm:=0;
  for i:=0 to High(SegStrings) do begin
    LogStr:=Logstr+format(' +Segment summary : '+SegStrings[i]+' [%3nms]',[m_segments[i]/1000])+sLineBreak;
    sm :=sm+m_segments[i]
  end;
  LogStr:=Logstr+format('-------------------------------------'+sLineBreak+'Total Segments : [%3nms]',[sm/1000])+sLineBreak;
  m_LastSegment:=HighResTimer.MicroSeconds;
  m_LastLog:=m_LastSegment;
end;

procedure TProfiler.Start;
begin
  LogStr:='';
  FillChar(m_segments[0],length(m_segments)*SizeOf(Int64),0);
  m_Start:=HighResTimer.MicroSeconds;
  m_LastLog:=m_Start;
  m_LastSegment:=m_Start;
end;

function TProfiler.Stop:int64;
var m:int64;
begin
  m:=HighResTimer.MicroSeconds;
  m_Elapsed:=m - m_Start;
  m_LastLog:=m - m_LastLog;
  result:=m_Elapsed
end;

initialization
  if not Assigned(HighResTimer) then
    HighResTimer:=THighResTimer.Create;
  if not Assigned(Profiler) then
    Profiler:=TProfiler.Create;
finalization
  FreeandNil(HighResTimer);
  FreeandNil(Profiler)
end.

