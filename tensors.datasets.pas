unit tensors.datasets;

{$mode objfpc}{$H+}

interface

uses
  Types, SysUtils, Classes, ArrayHelper, Tensors;


type


  { TTensorData }

{$ifdef fpc}generic{$endif}
  TTensorData<T> = class         // abstract class do not use
  private
    FInputDimensions:TIntegerDynArray;
    FOutnputDimensions:TIntegerDynArray;
    FSources : TStringDynArray;
    FPath:string;
    function LoadTraining(const TestPercentage:real=0.0):integer;virtual;abstract;
  public
    TrainingData:T;
    TrainingLabels:T;
    TestingData:T;
    TestingLabels:T;
    property SearchPath:string read FPath write FPath;
    property InputDimensions:TIntegerDynArray read   FInputDimensions;
    property OutnputDimensions:TIntegerDynArray read FOutnputDimensions;

    constructor Create(const Sources: TStringDynArray=nil; const TestPercentage: real= 0.0); virtual;
    destructor Destroy; override;
  end;

  { TMNISTData }

  TMNISTData = class({$ifdef fpc}specialize {$endif}TTensorData<TSingleTensor>)
    function LoadTraining(const TestPercentage: real=0.0): integer; override;
  end;

  { TCIFAR10Data }

  TCIFAR10Data = class({$ifdef fpc}specialize {$endif}TTensorData<TSingleTensor>)
  type TCifar10Rec=packed record  id:byte; Data:array[0..32*32*3-1] of byte end;
  private
    FCifar10File:TFileStream;
    FCifar10Labels :TStringList;
  public
    function LoadTraining(const TestPercentage: real=0.0): integer; override;
    destructor Destroy; override;
  end;

implementation

{ TCIFAR10Data }

function TCIFAR10Data.LoadTraining(const TestPercentage: real): integer;
var i,j,batch:integer; CR:TCifar10Rec ;
const BatchSize_t=10000; RecLength_t=32*32*3;
begin

  if not Assigned(FSources) then begin
    setLength(FSources,7);
    FSources[0]:=FPath+'data_batch_1.bin' ;
    FSources[1]:=FPath+'data_batch_2.bin' ;
    FSources[2]:=FPath+'data_batch_3.bin' ;
    FSources[3]:=FPath+'data_batch_4.bin' ;
    FSources[4]:=FPath+'data_batch_5.bin' ;
    FSources[5]:=FPath+'test_batch.bin' ;
    FSources[6]:=FPath+'batches.meta.txt' ;
  end;

  TrainingData.InitAs([32*32,3,50000]);
  TrainingLabels.InitAs([10,50000]);

  for batch:=0 to 4 do begin
    FCifar10File:=TFileStream.Create(FSources[batch],fmOpenRead);
    FCifar10File.Position:=0;
    for i:=0 to 9999 do begin
      FCifar10File.Read(CR,SizeOf(TCifar10Rec));
      for j:=0 to RecLength_t-1 do
        TrainingData.Data[batch*BatchSize_t*RecLength_t +i*RecLength_t+j]:=-1+2*CR.Data[j]/$ff;
      TrainingLabels.Data[batch*BatchSize_t+i+CR.id]:=1.0;
    end;
    FCifar10File.Free;
  end;

  TestingData.InitAs([32*32,3,10000]);
  TestingLabels.InitAs([10,10000]);
  FCifar10File:=TFileStream.Create(FSources[5],fmOpenRead);
  FCifar10File.Position:=0;
  for i:=0 to 9999 do begin
    FCifar10File.Read(CR,SizeOf(TCifar10Rec));
    for j:=0 to RecLength_t-1 do
      TestingData.Data[i*RecLength_t+j]:=-1+2*CR.Data[j]/$ff;
    TestingLabels.Data[i+CR.id]:=1.0;
  end;
  FCifar10File.Free;


  FCifar10Labels:=TStringList.Create;
  FCifar10Labels.LoadFromFile(FSources[6]);

end;

destructor TCIFAR10Data.Destroy;
begin
  FCifar10Labels.free;
  inherited Destroy;
end;

{ TMNISTData }

function TMNISTData.LoadTraining(const TestPercentage: real): integer;
 var
   buf1:record n_magic, n_count:Int32; w, h:Int32 end;
   i,j:integer; lbl:byte; mPixels:array [0..28*28-1] of byte;mLabel:array [0..9] of array [0..9] of single;
   MNISTImg, MNISTLbl: TFileStream;
begin
  if not Assigned(FSources) then begin
    setLength(FSources,4);
    FSources[0]:=FPath+'train-images-idx3-ubyte' ;
    FSources[1]:=FPath+'train-labels-idx1-ubyte' ;
    FSources[2]:=FPath+'t10k-images-idx3-ubyte' ;
    FSources[3]:=FPath+'t10k-labels-idx1-ubyte' ;
  end;
  for i:=0 to 9 do  begin
    FillByte(mLabel[i][0],10*sizeof(Single),0);
    mLabel[i][i]:=1.0;
  end;
  MNISTImg:=TFileStream.Create(FSources[0],fmOpenRead);
  MNISTLbl:=TFileStream.Create(FSources[1],fmOpenRead);
  MNISTImg.Position:=SizeOf(Buf1);
  MNISTLbl.Position:=8;
  TrainingData.InitAs([28*28,60000]);
  TrainingLabels.initAs([10,60000]);
  TestingData.InitAs([28*28,10000]);
  TestingLabels.initAs([10,10000]);

  for i:=0 to 59999 do begin
    MNISTImg.Read(mPixels,28*28);
    MNISTLbl.Read(lbl,1);
    for j:=0 to 28*28-1 do try
      TrainingData.Items2d[j,i]:=-1+2*mPixels[j]/$ff;
      Move(mLabel[lbl][0],TrainingLabels.Data[10*i],10*sizeof(Single));
    except
      writeln(format('error on item [%d] lbl:[%d]',[i,lbl]));
    end;
  end;
  MNISTImg.Free;
  MNISTLbl.Free;

  MNISTImg:=TFileStream.Create(FSources[2],fmOpenRead,fmOpenRead);
  MNISTLbl:=TFileStream.Create(FSources[3],fmOpenRead,fmOpenRead);
  MNISTImg.Position:=SizeOf(Buf1);
  //ShowMessage(SizeOf(Buf1).ToString);
//  MNISTImg.Read(Buf1,SizeOf(buf1));
  MNISTLbl.Position:=8;
  for i:=0 to 9999 do begin
    MNISTImg.Read(mPixels,28*28);
    MNISTLbl.Read(lbl,1);
    for j:=0 to 28*28-1 do try
      TestingData.Items2d[j,i]:=-1+2*mPixels[j]/$ff;
    Move(mLabel[lbl][0],TestingLabels.Data[10*i],10*sizeof(Single));
    except
      writeln(format('error on item [%d] lbl:[%d]',[i,lbl]));
    end;
  end;
  MNISTImg.Free;
  MNISTLbl.Free;

end;

{ TTensorData }

constructor TTensorData{$ifndef fpc}<T>{$endif}.Create(const Sources: TStringDynArray;const TestPercentage:real);
begin
  inherited Create;
  if Assigned(Sources) then
    FSources:=Sources;
  FPath:=ExtractFilePath(ParamStr(0)){$ifdef darwin} +'../../../' {$endif};
  LoadTraining(TestPercentage)
end;

destructor TTensorData{$ifndef fpc}<T>{$endif}.Destroy;
begin
  inherited Destroy;
end;

end.

