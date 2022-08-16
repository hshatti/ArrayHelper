unit oprs_multithread;

{$mode objfpc}{$H+} {.$define MTPROC}
interface

uses
  Classes, SysUtils, Math, arrayhelpercommon,{$ifdef unix}sysctl ,{$endif}UTF8Process
  {$ifdef USE_AVX2},oprs_simd{$endif}
  //{$ifdef USE_AVX2},pblas{$endif}
  {$ifdef MTPROC}, MTProcs{$endif};

type
  TTaskType=(ttNone,ttProcFFF,ttProcDDD,ttProcFFV,ttProcDDV,ttFuncSSV,ttFuncDDV,ttProcData);

  PParams=^TParams;
  TParams=packed record
    taskType:TTaskType;
    opt:PPointer;
    func:pointer;
    StartOffset:integer;
    case byte of
      0:(dst_s:pSingle; a_s:pSingle; b_s:pSingle;count_s:integer);
      1:(dst_d:pdouble; a_d:pdouble; b_d:pdouble;count_d:integer);
  end;

  {$ifndef MTPROC}

  { TOperationThread }

  TOperationThread=class(TThread)
  type

  private
    FCount: integer;
    FTaskType: TTaskType;
    FDone:boolean;
    Ev:PRTLEvent;
    procedure SetCount(AValue: integer);
  public
    ProcFFF:TProcFFF ;
    ProcDDD:TProcDDD ;
    ProcFFV:TProcFFV ;
    ProcDDV:TProcDDV ;
    FuncSSV:TFuncFFV ;
    FuncDDV:TFuncDDV ;
    ProcData:TProcData ;
    Params:TParams;
    returnFloat:Single;
    returnDouble:Double;
    Id:integer;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    property TaskType:TTaskType read FTaskType;
    property Count:integer read FCount write SetCount;
    procedure Setup(const aTaskType:TTaskType;const task:pointer;const aCount:integer);inline;
    procedure Execute; override;
  end;
  {$endif}
  function CallInParallel( func:TProcFFF;const dst,a,b:pSingle; Count:integer; nThreads:integer):pSingle;
  procedure CallInParallel(const func: TProcData;const opt: PPointer;const Offset,Count:Integer; nThreads: integer;const sync:boolean=true);
  var ss:string;
    nWorkingThreads:integer;
    MainEv:PRTLEvent;
//    CriticalSec:TRTLCriticalSection;
implementation

{ Multi Threading }
{$ifdef MTPROC}

procedure OperationProc(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);
var i,n,m:integer;params:pParams absolute data;
begin
  //DivMod(Params^.count_s,Item.Group.EndIndex,n,m);

  //ProcThreadPool.EnterPoolCriticalSection;
  //ss:=ss+#13#10+format('[%d] start[%d], count[%d]'#13#10,[index,index*n,ifthen(index=Item.Group.EndIndex,m,n)]) ;
  //for i:=index*n to index*n+ifthen((m>0) and (index=Item.Group.EndIndex),m,n)-1 do
  //  ss+=', '+FloatToStr(params^.b_s[i]) ;
  //ss:=ss+#13#10;
  //ProcThreadPool.LeavePoolCriticalSection;
  //writeln('Operation: ',Index,' ',Item.Group.MaxThreads,' ',params^.count_s);
  case Params^.taskType of
    ttProcData:TProcData(Params^.func)(Params^.opt,Index,Item.Group.MaxThreads,params^.count_s);
  end;

end;
{$else}
var thPool : array of TOperationThread;

{ TOperationThread }

procedure TOperationThread.SetCount(AValue: integer);
begin
  if FCount=AValue then Exit;
  FCount:=AValue;
end;

constructor TOperationThread.Create(CreateSuspended: Boolean);
begin
  inherited create(CreateSuspended);
  Ev:=RTLEventCreate;
  FDone:=True;
  FreeOnTerminate:=True;
end;

destructor TOperationThread.Destroy;
begin

  RTLEventsetEvent(Ev);
  Terminate;
  RTLEventDestroy(Ev);
  inherited Destroy;
end;

procedure TOperationThread.Setup(const aTaskType: TTaskType;const task: pointer; const aCount: integer);
begin
  //case aTaskType of
  {$ifdef fpc}
    //ttProcFFF:ProcFFF:=TProcFFF(task);
    //ttProcDDD:ProcDDD:=TProcDDD(task);
    //ttProcFFV:ProcFFV:=TProcFFV(task);
    //ttProcDDV:ProcDDV:=TProcDDV(task);
    //ttFuncSSV:FuncSSV:=TFuncFFV(task);
    //ttFuncDDV:FuncDDV:=TFuncDDV(task);
    //ttProcData:
      ProcData:=TProcData(task);

  {$else}
    ttProcFFF:ProcFFF:=task;
    ttProcDDD:ProcDDD:=task;
    ttProcFFV:ProcFFV:=task;
    ttProcDDV:ProcDDV:=task;
    ttFuncSSV:FuncSSV:=task;
    ttFuncDDV:FuncDDV:=task;
    ttProcData:ProcData:=task;
  {$endif}
 // end;
  FCount:=aCount;
  //FTaskType:=aTaskType;
end;

procedure TOperationThread.Execute;
var i:integer;   Done:boolean;
begin
  while not Terminated do begin
    //WriteLn('Idle ',Id);
    RTLEventWaitFor(Self.ev);
    if Terminated then exit;
    FDone:=false;
    //if () then
    //try
//    WriteLn('In Threads:',nWorkingThreads);
   //try
   //case FTaskType of
   //   ttProcFFF:TProcFFF(Params.func)(Params.dst_s,Params.a_s,Params.b_s, FCount);
   //   ttProcDDD:TProcDDD(Params.func)(Params.dst_d,Params.a_d,Params.b_d, FCount);
   //   ttProcFFV:TProcFFV(Params.func)(Params.dst_s,Params.a_s,Params.b_s^,FCount);
   //   ttProcDDV:TProcDDV(Params.func)(Params.dst_d,Params.a_d,Params.b_d^,FCount);
   //   ttFuncSSV:returnFloat:=TFuncFFV(Params.func)(Params.a_s,Params.b_s, FCount);
   //   ttFuncDDV:returnDouble:=TFuncDDV(Params.func)(Params.a_d,Params.b_d,FCount);
   //   ttProcData:
        TProcData(Params.func)(Params.opt,Params.StartOffset,Length(thPool),Self.FCount);
    //end ;
    //except
      //WriteLn('error in Thread:',Id,'  Offset:',Params.StartOffset);
    //end;
    //FTaskType:=ttNone;
    //EnterCriticalSection(CriticalSec);
    if nWorkingThreads>0 then
      InterlockedDecrement(nWorkingThreads);
//    WriteLn('Threads= ',nWorkingThreads);
    //LeaveCriticalSection(CriticalSec);
    if (nWorkingThreads=0) then begin
//      WriteLn('All Threads finished');
//      WriteLn();
      RTLEventSetEvent(MainEv);
    end;
    //Done:=True;
    //for i:=0 to High(thPool) do
    //  if i<>id then  Done:=done and thPool[i].FDone;
    //if Done then
    //  RTLEventSetEvent(MainEv);
    FDone:=True;
  end;
end;

{$endif}

procedure CallInParallel(const func: TProcData;const opt: PPointer; const Offset, Count: Integer; nThreads: integer;const sync:boolean);
var {$ifndef MTPROC} i,j:integer;{$endif MRPROC}
    Params:TParams;  Done:boolean;
begin
  {$ifdef MTPROC}
  params.taskType:=ttProcData;
  params.opt:=opt;
  params.count_s:=Count;
  params.func:=func;
//writeln('CallInParallel: offset= ',Offset,'  Stride= ',ProcThreadPool.MaxThreadCount);
  ProcThreadPool.DoParallel(@OperationProc,Offset,Offset+ProcThreadPool.MaxThreadCount-1,@params);
  {$else}
//  if nThreads=0 then
    nThreads:=High(thPool);
  //DivMod(Count,Length(thPool),Dv,Mo);
  //dv:=trunc(Count/nThreads);
  //mo:=Count mod nThreads;
  for i:=0 to nThreads do
    if i<Count then begin
      params.taskType:=ttProcData;
      thPool[i].Params.func:=func;
      thPool[i].Params.opt:=opt;
      thPool[i].setup(ttProcData,{$ifndef fpc}@{$endif}func,Count);
      thPool[i].Params.StartOffset:=i+Offset
    end;

  //params.taskType:=ttProcData;
  //thPool[nThreads].Params.func:=func;
  //thPool[nThreads].Params.opt:=opt;
  //thPool[nThreads].setup(ttProcData,{$ifndef fpc}@{$endif}func,dv+Mo);
  //thPool[nThreads].Params.StartOffset:=nThreads*dv+Offset ;
  for i:=0 to nThreads do
    if i<Count then begin
      InterlockedIncrement(nWorkingThreads);
      RTLEventSetEvent(thPool[i].Ev);
    end;
  if sync and (nWorkingThreads>0) then begin
    RTLEventWaitFor(MainEv);
   end;
  {$endif}
end;


function CallInParallel(func: TProcFFF; const dst, a, b: pSingle; Count: integer; nThreads: integer): pSingle;
var
  {$ifndef MTPROC}dv,mo, i,j:integer;{$endif MRPROC}
  Params:TParams;
begin
  result:=dst;
  {$ifdef MTPROC}
  params.taskType:=ttProcFFF;
  params.dst_s:=@dst[0];
  params.a_s:=@a[0];
  params.b_s:=@b[0];
  params.count_s:=Count;
  params.func:=func;
  ProcThreadPool.DoParallel(@OperationProc,0,ProcThreadPool.MaxThreadCount*2-1,@Params);
  {$else}
  if nThreads=0 then
    nThreads:=High(thPool);
  DivMod(Count,nThreads,dv,mo);
  //dv:=trunc(Count/nThreads);
  //mo:=Count mod nThreads;
  for i:=0 to nThreads+1 do begin
      params.taskType:=ttProcFFF;
      thPool[i].Params.func:=func;
      thPool[i].Params.dst_s:=@dst[i*dv];
      thPool[i].Params.a_s:=@a[i*dv];
      thPool[i].Params.b_s:=@b[i*dv];
      thPool[i].setup(ttProcFFF,{$ifndef fpc}@{$endif}func,ifthen((i=nThreads),mo,mo+dv));
  end;
  for i:=0 to nThreads do
       RTLEventSetEvent(thPool[i].Ev);

  {$endif}
end;


function GetCPUCount: LongWord;
var req:array[0..1] of Integer;N:SizeInt; res:Integer;
begin
  {$ifdef unix}
  req[0]:=CTL_HW;//6;
  req[1]:=HW_NCPU;// 3;
  FPsysctl(@req[0],2,@res,@N,nil,0);
  result:=res;
  {$else}
  result:=GetSystemThreadCount;
  {$endif}
end;

var i:integer;ncpu:integer =1;
initialization
{$ifndef MTPROC}
  //InitCriticalSection(CriticalSec);
  MainEv:=RTLEventCreate();
  nWorkingThreads:=0;
  if not Assigned(thPool) then begin
    setLength(thPool,2*GetCPUCount);
    for i:=0 to high(thPool) do begin
      thPool[i]:=TOperationThread.Create(True);
      thPool[i].Id:=i;
      thPool[i].Start;
    end;
  end;
{$endif}

finalization
{$ifndef MTPROC}
  //DoneCriticalSection(CriticalSec);
  RTLEventDestroy(MainEv);
  //for i:=0 to high(thPool) do
  //  FreeAndNil(thPool[i]);
{$endif}

end.

