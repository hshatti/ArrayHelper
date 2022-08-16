
{ <Steroids : (Thread Pooling wrapper for Freepascal/Delphi) >

  Copyright (c) <2022> <Haitham Shatti  <haitham.shatti at gmail dot com> >

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
  USE OR OTHER DEALINGS IN THE SOFTWARE.
}



(* instead of the regular pascal for loop,
  Just prepare a TProcGroup (or TProcGroupNested or TMethodGroup) like prcedure
then call ir using "ParallelFor" you need to put in a loop

*******************************************************************************************
// example : Sine wave signal generator

program SineWaveGen;
{$mode objfpc}   // allow pointermath
uses {$ifdef unix} cthreads,{$endif} Classes, Types , Steroids, Crt;
const   N=1000000;  Freq=0.05;

var
  i,j,PortHeight:integer;
  a,b: array of Double;

  Amplitude: Double;

// prepare a parallel callback function
procedure _looper(const _start,_end:integer;params:PPointer);
var i:integer;
begin
  for i:=_start to _end do begin
    PDouble(params[0])[i]:=sin(i*freq); // array a is at parameter index 0
    PDouble(params[1])[i]:=cos(i*freq); // array b is at parameter index 1
  end;
end;

begin
  PortHeight:=ScreenHeight-2;
  Amplitude:=PortHeight*0.2;
  setLength(a,N);
  setLength(b,N);

// instead of the following loop :
{
for i:=0 to N-1 do begin
    a[i]:=sin(i*Freq);
    b[i]:=cos(i*Freq)
  end;
}
// put your loop on steroids!!, jump in the thread pool and use this :

  ParallelFor(TGroupProc(@_looper),0,N-1,[ @a[0], @b[0] ]); // remove the "@" when using delphi mode!

  DirectVideo:=True;
  CheckBreak:=True;

  j:=0;
  while true do begin
    inc(j);
    if j>=N then j:=0 ;
    TextBackground(black);
    ClrScr;
    TextColor(Green);
    for i:=0 to ScreenWidth-1 do begin
      GotoXY(i,PortHeight div 4+round(a[j+i]*Amplitude));
      Write('-');
    end;

    TextColor(Red);
    for i:=0 to ScreenWidth-1 do begin
      GotoXY(i,PortHeight * 3 div 4+round(b[j*2+i]*Amplitude));
      Write('o');
    end;
    GotoXY(1,ScreenHeight);
    TextBackground(LightGray);
    TextColor(Black);
    write('Press ESC to exit') ;
    Delay(10);
    if KeyPressed then if ReadKey=#27 then exit;
  end;
//  TextAttr:=TextAttr and not blink;

end.
//PLEASE USE IN PEACE!!

********************************************************************************************************

*)

unit steroids;



{$mode Delphi}{$H+}{$ModeSwitch nestedprocvars}

interface
uses Classes, Types {$ifdef windows}, windows{$endif} ;

type
  TGroupProc=procedure(const _start,_end:integer;const params:PPointer);
  TGroupProcNested=procedure(const _start,_end:integer;const params:PPointer)  is nested;
  TGroupMethod=procedure(const _start,_end:integer;const params:PPointer) of object;
TOPool = class;

{ TOThread }

TOThread=class(TThread)

  //TGroupProc=procedure(const params:PPointer);
private
  Fire:PRTLEvent;
  FStart,FEnd:integer;
  FCriticalSection:TRTLCriticalSection;
  FID:integer;
  FParams:PPointer;
  FProc:TGroupProc;
  FProcNested:TGroupProcNested;
  FMethod:TGroupMethod;
  FBusy:boolean;
  FPool:TOPool;
public
  procedure Execute; override;
  constructor Create(CreateSuspended: Boolean; const StackSize: SizeUInt= DefaultStackSize); overload;
  constructor Create(const Proc:TGroupProc;const Params:PPointer);                           overload;
  destructor Destroy; override;
  property Pool:TOpool read FPool;
  property Busy:boolean read FBusy;
  property Id:integer read FID;
  property From:integer read FStart;
  property &To:integer read FEnd;

end;

{ TOPool }

TOPool = class
  Pool : array of TOThread;
  OTCount:integer;
  PoolDone:PRTLEvent;
  constructor Create;
  destructor Destroy; override;
  procedure PoolJump;
  procedure ParallelFor(const Proc:TGroupProc;const _from,_to:integer;const Params:TPointerDynArray=nil); overload;
  procedure ParallelFor(const Proc:TGroupProcNested;const _from,_to:integer;const Params:TPointerDynArray=nil); overload;
  procedure ParallelFor(const Proc:TGroupMethod;const _from,_to:integer;const Params:TPointerDynArray=nil); overload;
end;

var MP:TOPool;

function GetSystemThreadCount: integer;
{$ifdef windows}

{$else}
const _SC_NPROCESSORS_ONLN = 58;
function sysconf(cmd: Integer): longint; cdecl; external name 'sysconf';
{$endif}

implementation

function GetSystemThreadCount: integer;
{$ifdef windows}
var
  SystemInfo: SYSTEM_INFO;
begin
    GetSystemInfo(SystemInfo);
    Result := SystemInfo.dwNumberOfProcessors;
end;
{$else}
begin
  result:= sysconf(_SC_NPROCESSORS_ONLN);
end;
{$endif}

{$asmmode intel}

{ TOPool }

constructor TOPool.Create;
var i:integer;
begin

  Setlength(Pool,GetSystemThreadCount+1);
  for i:=0 to High(Pool) do begin
    Pool[i]:=TOthread.Create(false);
    Pool[i].FID:=i;
    Pool[i].FPool:=Self
  end;
  PoolDone:=RTLEventCreate;

end;

destructor TOPool.Destroy;
var i:integer;
begin
  inherited Destroy;
  for i:=0 to High(Pool) do begin
    Pool[i].Terminate;
    RTLEventSetEvent(Pool[i].Fire);
  end;
  RTLEventDestroy(PoolDone);
end;

procedure TOPool.PoolJump;
begin
  InterlockedDecrement(OTCount);
  if OTCount<=0 then
    RTLEventSetEvent(PoolDone);  // jump out of the pool

end;

{ TOThread }

procedure TOThread.Execute;
//procedure lockInc(var int:integer);assembler;nostackframe; asm lock inc [int] end;
//procedure lockDec(var int:integer);assembler;nostackframe; asm lock Dec [int] end;
begin
  while true do begin
    RTLEventWaitFor(Fire);
    if not Terminated then begin
//    try
      FBusy:=true;
      //InterlockedIncrement(FPool^.OTCount);
   //   writeln('Thread GO > ['+FID,'], Count [',FPool.OTCount,']',' Start[',FStart,'] ,End[',Fend,']');

      if Assigned(FProc)       then FProc(FStart,FEnd,FParams);
      if Assigned(FProcNested) then FProcNested(FStart,FEnd,FParams);
      if Assigned(FMethod)     then FMethod(FStart,FEnd,FParams);

//    finally
      //EnterCriticalSection(FCriticalSection);
//      WriteLn('FPool^..OTCount = ',FPool^.OTCount);
      //Synchronize(
      //@
      EnterCriticalSection(FCriticalSection);
      FPool.PoolJump;
      LeaveCriticalSection(FCriticalSection);
      FBusy:=false;
      //);
      //InterlockedDecrement(FPool^.OTCount);
     // writeln('Thread OK < ['+FID,'], Count [',FPool.OTCount,']',' Start[',FStart,'] ,End[',Fend,']');

      //for i:=0 to High(FPool) do
      //  working:=working or FPool[i].FLooping;
      //if not Working then
      //  RTLEventSetEvent(PoolDone);
      //LeaveCriticalSection(FCriticalSection);
    end else
      exit;
  end
end;

constructor TOThread.Create(CreateSuspended: Boolean; const StackSize: SizeUInt);
begin
  inherited;
  FreeOnTerminate:=true;
  InitCriticalSection(FCriticalSection);
  Fire:=RTLEventCreate;
//  Priority:=tpHighest;
  FBusy:=False;
end;

constructor TOThread.Create(const Proc: TGroupProc; const Params: PPointer);
begin
  inherited Create(true);
  FProc:=Proc;
  FParams:=Params
end;

destructor TOThread.Destroy;
begin
  inherited Destroy;
  RTLEventDestroy(Fire);
  DoneCriticalSection(FCriticalSection);
end;

procedure TOPool.ParallelFor(const Proc:TGroupProc;const _from,_to:integer;const Params:TPointerDynArray=nil);
var i,N,group_m,group_t:integer;
begin
  while OTCount>0 do;// the pool is still hot! wait for it to cooldown before jumping in.
  N:=_to-_from;
  group_t:=N div High(Pool);
  group_m:=N mod High(Pool);
  if group_m=0 then
    for i:=0 to High(Pool)-1 do begin
      Pool[i].FStart:=_from+i*group_t;
      Pool[i].FEnd:=Pool[i].FStart+group_t-1;
      Pool[i].FParams:=@Params[0] ;
      Pool[i].FProc:=Proc;
//      asm lock inc [rip + OTCount] end;
      //InterlockedIncrement(OTCount);
//      WriteLn('OTCount = ',OTCount,' | range = [',.Pool[i].FStart,', ',.Pool[i].FEnd,' ]');
      Interlockedincrement(OTCount);
      RTLEventSetEvent(Pool[i].Fire);
    end
  else begin
    for i:=0 to High(Pool)-1 do begin
      Pool[i].FStart:=_from+i*group_t;
      Pool[i].FEnd:=Pool[i].FStart+group_t-1;
      Pool[i].FParams:=@Params[0] ;
      Pool[i].FProc:=Proc;
//      asm lock inc [rip + OTCount] end;
      //InterlockedIncrement(OTCount);
//      WriteLn('OTCount = ',OTCount,' | range = [',.Pool[i].FStart,', ',.Pool[i].FEnd,' ]');
      InterlockedIncrement(OTCount);
      RTLEventSetEvent(Pool[i].Fire);
    end;
    Pool[High(Pool)].FStart:=_from+High(Pool)*group_t;
    Pool[High(Pool)].FEnd:=_to;
    Pool[High(Pool)].FParams:=@Params[0] ;
    Pool[High(Pool)].FProc:=Proc;
//    asm lock inc [rip + OTCount] end;
    //InterlockedIncrement(OTCount);
//    WriteLn('OTCount = ',OTCount,' | range = [',.Pool[High(.Pool)].FStart,', ',.Pool[High(.Pool)].FEnd,' ]');
    InterlockedIncrement(OTCount);
    RTLEventSetEvent(Pool[High(Pool)].Fire);
  end;
  RTLEventWaitFor(PoolDone);
end;

procedure TOPool.ParallelFor(const Proc:TGroupProcNested;const _from,_to:integer;const Params:TPointerDynArray=nil);
var i,N,group_m,group_t:integer;
begin
  while OTCount>0 do;// the pool is still hot! wait for it to cooldown before jumping in.
  N:=_to-_from;
  group_t:=N div High(Pool);
  group_m:=N mod High(Pool);
  if group_m=0 then
    for i:=0 to High(Pool)-1 do begin
      Pool[i].FStart:=_from+i*group_t;
      Pool[i].FEnd:=Pool[i].FStart+group_t-1;
      Pool[i].FParams:=@Params[0] ;
      Pool[i].FProcNested:=Proc;
//      asm lock inc [rip + OTCount] end;
      //InterlockedIncrement(OTCount);
//      WriteLn('OTCount = ',OTCount,' | range = [',Pool[i].FStart,', ',Pool[i].FEnd,' ]');
      Interlockedincrement(OTCount);
      RTLEventSetEvent(Pool[i].Fire);
    end
  else begin
    for i:=0 to High(Pool)-1 do begin
      Pool[i].FStart:=_from+i*group_t;
      Pool[i].FEnd:=Pool[i].FStart+group_t-1;
      Pool[i].FParams:=@Params[0] ;
      Pool[i].FProcNested:=Proc;
//      asm lock inc [rip + OTCount] end;
      //InterlockedIncrement(OTCount);
//      WriteLn('OTCount = ',OTCount,' | range = [',Pool[i].FStart,', ',Pool[i].FEnd,' ]');
      InterlockedIncrement(OTCount);
      RTLEventSetEvent(Pool[i].Fire);
    end;
    Pool[High(Pool)].FStart:=_from+High(Pool)*group_t;
    Pool[High(Pool)].FEnd:=_to;
    Pool[High(Pool)].FParams:=@Params[0] ;
    Pool[High(Pool)].FProcNested:=Proc;
//    asm lock inc [rip + OTCount] end;
    //InterlockedIncrement(OTCount);
//    WriteLn('OTCount = ',OTCount,' | range = [',Pool[High(Pool)].FStart,', ',Pool[High(Pool)].FEnd,' ]');
    InterlockedIncrement(OTCount);
    RTLEventSetEvent(Pool[High(Pool)].Fire);
  end;
  RTLEventWaitFor(PoolDone);
end;

procedure TOPool.ParallelFor(const Proc:TGroupMethod;const _from,_to:integer;const Params:TPointerDynArray=nil);
var i,N,group_m,group_t:integer;
begin
  while OTCount>0 do;// the pool is still hot! waiting to cooldown before jumping in.
  N:=_to-_from;
  group_t:=N div High(Pool);
  group_m:=N mod High(Pool);
  if group_m=0 then
    for i:=0 to High(Pool)-1 do begin
      Pool[i].FStart:=_from+i*group_t;
      Pool[i].FEnd:=Pool[i].FStart+group_t-1;
      Pool[i].FParams:=@Params[0] ;
      Pool[i].FMethod:=Proc;
//      asm lock inc [rip + OTCount] end;
      //InterlockedIncrement(OTCount);
//      WriteLn('OTCount = ',OTCount,' | range = [',Pool[i].FStart,', ',Pool[i].FEnd,' ]');
      Interlockedincrement(OTCount);
      RTLEventSetEvent(Pool[i].Fire);
    end
  else begin
    for i:=0 to High(Pool)-1 do begin
      Pool[i].FStart:=_from+i*group_t;
      Pool[i].FEnd:=Pool[i].FStart+group_t-1;
      Pool[i].FParams:=@Params[0] ;
      Pool[i].FMethod:=Proc;
//      asm lock inc [rip + OTCount] end;
      //InterlockedIncrement(OTCount);
//      WriteLn('OTCount = ',OTCount,' | range = [',Pool[i].FStart,', ',Pool[i].FEnd,' ]');
      InterlockedIncrement(OTCount);
      RTLEventSetEvent(Pool[i].Fire);
    end;
    Pool[High(Pool)].FStart:=_from+High(Pool)*group_t;
    Pool[High(Pool)].FEnd:=_to;
    Pool[High(Pool)].FParams:=@Params[0] ;
    Pool[High(Pool)].FMethod:=Proc;
//    asm lock inc [rip + OTCount] end;
    //InterlockedIncrement(OTCount);
//    WriteLn('OTCount = ',OTCount,' | range = [',Pool[High(Pool)].FStart,', ',Pool[High(Pool)].FEnd,' ]');
    InterlockedIncrement(OTCount);
    RTLEventSetEvent(Pool[High(Pool)].Fire);
  end;
  RTLEventWaitFor(PoolDone);
end;

initialization
  MP:=TOPool.Create;
finalization
  MP.Free;
end.

