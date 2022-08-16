unit Neurons;

{$mode objfpc}{$H+}
{$define centropy_short}


interface

uses
  Classes, Types, SysUtils, Math, ArrayHelper, Tensors,hirestimer
  //{$ifdef USE_AVX2}, oprs_simd{$endif}
  {$ifdef USE_AVX2}, pblas{$endif}
  {$ifdef DARWIN}, vDSP{$endif}
  {$ifdef USE_THREADS}, steroids{$endif}
  {$ifdef USE_GPU}, oprs_gpu{$endif}
  ;


type
  {.$define use_doubles}
  {$ifdef USE_DOUBLES}
  NeuronFloat=Double;
  TFloats=TDoubleDynArray;
  TNeuralTensor=TDoubleTensor;
  {$else}
  PNeuronFloat=^NeuronFloat;
  NeuronFloat=Single;
  TNeuronFloats=TSingleDynArray;
  TFloats2D=TSingles2D;

  PNeuralTensor=^TNeuralTensor;
  TNeuralTensor=TSingleTensor;
  {$endif}
  TNeuralNet=class;
  TCustomNeuralLayer=class;
  TActivationProcS=procedure (var result:TNeuronFloats;const values:TNeuronFloats);
  TOptimizerType=(otSDG,otADAM,otMomentum);
  TActivationType=(atSigmoid,atReLU,atLReLU,atTanH,atSELU,atSoftmax,atIdentity,atOther);
  TLossType=(lfMeanSquared, lfMeanAbsolute, lfCrossEntropy, lfOther);
  TLossFunction=function(const y,p:TNeuronFloats):NeuronFloat;
  TGradientProcedure=procedure (var e:TNeuronFloats;const y,p: TNeuronFloats);
  TOnEpochFinish=procedure (NN:TNeuralNet;const Epoch:integer;const Loss:NeuronFloat;const Hits:longword);
  TOnFitFinish=procedure (NN:TNeuralNet;const Loss:NeuronFloat;const Hits :LongWord);

  TActivationProcessorS=record
    Activate:TActivationProcS;
    Derivative:TActivationProcS;
    UseActivatedDerivative:boolean;  // Use activated tensor as a derivative function input

  end;

  { TNeuralLayer }

  { TCustomNeuralLayer }

  TCustomNeuralLayer=class
    Size:Integer;
    OutNeurons:TNeuralTensor;//  Raw Vector
    ANeurons:TNeuralTensor;// Activated Vector
    Neurons_T:TNeuralTensor;   // Temporary reference to transposed ANeurons
    Er,ErB:TNeuralTensor; // Error tensor
    Validation:TNeuralTensor;   // Also Used as Input
    Processor:TActivationProcessorS;
    ActivationType:TActivationType;
    Weights:TNeuralTensor;
    Biases:TNeuralTensor;
    Deltas,DeltasB:TNeuralTensor;
    Gradients, GradientsB:TNeuralTensor;
    LossFunc:TLossFunction;
    Loss:NeuronFloat;
    Next:TCustomNeuralLayer;
    Previous:TCustomNeuralLayer;
    NeuralNet:TNeuralNet;
    FTemp:TNeuronFloats;
    constructor Create(const ASize:integer; const AActivationType:TActivationType=atSigmoid; const ALossType:TLossType=lfMeanSquared;const alpha:NeuronFloat=0.1);  virtual;
    destructor Destroy; override;
    procedure FeedForward; virtual;
    function Backpropagate(const learningRate: NeuronFloat;const updateWeights:boolean=true):TCustomNeuralLayer; virtual;
  end;

  TFullyConnected=class(TCustomNeuralLayer)
  end;

  { TConv2D }

  TConv2D=class(TCustomNeuralLayer)
    FKernelSize:integer;
    FWidth:integer;
    FHeight:integer;
    FDepth:integer;
    oWidth:integer;
    oHeight:integer;
    FPadding:integer;
    FStride:integer;
    FFeatures:integer;
    FKernels:TNeuronFloats;
    private
      procedure Kernel2d(AInput: PNeuronFloat; const AOutput, Kernel: PNeuronFloat;
        const bias: NeuronFloat; const mKerSize, w, h: integer;
  Padding: integer=0; const Stride: integer=1);
    public
    constructor Create(const AFeatures, AWidth, AHeight, ADepth, AKernelSize:Integer; const AStride:integer=1; const APadding: integer=-1; const AActivationType: TActivationType=atReLU; const AAlpha: NeuronFloat=0.0);
    procedure FeedForward();override;
    function Backpropagate(const learningRate: NeuronFloat;const updateWeights:boolean=true):TCustomNeuralLayer; override;

  end;

  TNeuralLayers= array of TCustomNeuralLayer;

  { TNeuralNet }

  TNeuralNet=class
    Batch:integer;
    LearningRate:NeuronFloat;
    Epoch:integer;
    OptimizerType:TOptimizerType;
    Net:TNeuralLayers;
    TensorsProcessed:LongWord;
    TotalLoss:NeuronFloat;
    FLayerCount:integer;
    LossFunction:TLossFunction;
    LocalLoss:NeuronFloat;
    LossHistory:TNeuronFloats;
    GradientProc:TGradientProcedure;
    FOnEpochFinish:TOnEpochFinish;
    FOnFitFinished:TOnFitFinish;
    FLossGradients:TNeuronFloats;
    FOutput:TCustomNeuralLayer;
    constructor Create; virtual;
    constructor Create(const Layers: TNeuralLayers); virtual;
    destructor Destroy; override;
    procedure Add(const Layers:TNeuralLayers);virtual;
    procedure Add(const Layer:TCustomNeuralLayer);virtual;
    function Predict(const input: TNeuralTensor):TNeuralTensor; virtual;
    procedure CalcDefaultGradient(const Grad, Target: TNeuronFloats);
    procedure Fit(const Train, Targets: TNeuralTensor;const ALearningRate:NeuronFloat=0.01;const AEpoch:integer=10;const BatchSize:integer=4; const AOptimizerType: TOptimizerType=otSDG); virtual;
    procedure SaveToFile(FileName:string);
    procedure LoadFromFile(FileName:string);
  end;



  procedure AIdentity(var r:TNeuronFloats;const x:TNeuronFloats);
  procedure DIdentity(var r:TNeuronFloats;const x:TNeuronFloats);

  procedure ASigmoid(var r:TNeuronFloats;const x:TNeuronFloats);
  procedure DSigmoid(var r:TNeuronFloats;const x:TNeuronFloats);

  procedure AReLU(var r:TNeuronFloats;const x:TNeuronFloats);
  procedure DReLU(var r:TNeuronFloats;const x:TNeuronFloats);

  procedure ALReLU(var r:TNeuronFloats;const x:TNeuronFloats);
  procedure DLReLU(var r:TNeuronFloats;const x:TNeuronFloats);

  procedure ATanH(var r:TNeuronFloats;const x:TNeuronFloats);
  procedure DTanH(var r:TNeuronFloats;const x:TNeuronFloats);

  procedure ASoftmax(var r:TNeuronFloats;const x:TNeuronFloats);
  procedure DSoftmax(var r:TNeuronFloats;const x:TNeuronFloats);

  function LossMeanSqr(const y,p:TNeuronFloats):NeuronFloat;
  function LossMeanAbs(const y,p: TNeuronFloats): NeuronFloat;
  function LossCrossEntropy(const y,p:TNeuronFloats):NeuronFloat;

  procedure LossMeanSqrD(var e:TNeuronFloats;const y,p: TNeuronFloats);
  procedure LossMeanAbsD(var e:TNeuronFloats;const y,p: TNeuronFloats);
  procedure LossCrossEntropyD(var e:TNeuronFloats;const y,p: TNeuronFloats);

const fEpsilon:NeuronFloat=1e-8;
      fDelta  :NeuronFloat=1e-7;
var
  IdentityProcessor:TActivationProcessorS=(Activate:@AIdentity; Derivative:@DIdentity; UseActivatedDerivative:true);
  SigmoidProcessor:TActivationProcessorS=(Activate:@ASigmoid; Derivative:@DSigmoid; UseActivatedDerivative:true);
  ReLUProcessor:TActivationProcessorS=(Activate:@AReLU; Derivative:@DReLU; UseActivatedDerivative:false);
  TanHProcessor:TActivationProcessorS=(Activate:@ATanH; Derivative:@DTanH; UseActivatedDerivative:true);
  LReLUProcessor:TActivationProcessorS=(Activate:@ALReLU; Derivative:@DLReLU; UseActivatedDerivative:true);
  SoftMaxProcessor:TActivationProcessorS=(Activate:@ASoftmax; Derivative:@DSoftmax; UseActivatedDerivative:true);

implementation

procedure AIdentity(var r: TNeuronFloats; const x: TNeuronFloats);
begin
  r:=x
end;

procedure DIdentity(var r: TNeuronFloats; const x: TNeuronFloats);
begin
  r.fill(1.0)
end;

procedure ASigmoid(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  //setLength(r,Length(x));
  for i:=0 to High(x) do
    r[i]:=1/(1+exp(-x[i]))
end;

procedure DSigmoid(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(x) do
    r[i]:=x[i]*(1-x[i])
end;

procedure AReLU(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(x) do
    r[i]:=ord(x[i]>0)*x[i]
    //if x[i]>0 then r[i]:=x[i] else r[i]:=0
end;

procedure DReLU(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(x) do
    r[i]:=ord(x[i]>0)
end;

procedure ALReLU(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(x) do
    r[i]:=ord(x[i]>0)*x[i]+ord(x[i]<=0)*x[i]*0.1
end;

procedure DLReLU(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(x) do
    r[i]:=ord(x[i]>0)+ord(x[i]>0)*0.1
end;

procedure ATanH(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;p,m:NeuronFloat;
begin
  //(e^x - e^-x)/(e^x + e^-x)
  for i:=0 to High(x) do begin
    r[i]:=TanH(x[i]);

    //p:=exp(2*x[i]);
    //r[i]:=(p-1)/(p+1)

    //p:=exp( x[i]);
    //m:=exp(-x[i]);
    //r[i]:=(p-m)/(p+m)
  end;
end;

procedure DTanH(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(x) do
    r[i]:=1-x[i]*x[i]
end;

procedure ASoftmax(var r: TNeuronFloats; const x: TNeuronFloats);
var i:integer;mx:single;
begin
  mx:=x.max();
  for i:=0 to High(x) do
    r[i]:=Exp( x[i]-mx);
  //r:=copy(x);
  //r.Exp();
  r.&div(r.sum)
end;

procedure DSoftmax(var r: TNeuronFloats; const x: TNeuronFloats);
//var i,d:integer;
begin

  DSigmoid(r,x);//use sigmoid function temporarly
end;

function LossMeanSqr(const y,p: TNeuronFloats): NeuronFloat;
begin
  result:=copy(y).sub(p).SumOfSquares()*0.5;
end;

function LossMeanAbs(const y,p: TNeuronFloats): NeuronFloat;
var r:TNeuronFloats;
begin
  r:=copy(y);
  r.sub(p);
  r.abs();
  result:=r.mean();
end;

function LossCrossEntropy(const y,p: TNeuronFloats): NeuronFloat;
var i:integer;dd:NeuronFloat;
begin
  result:=0;
  for i:=0 to High(p) do begin
    if y[i]=1 then
      result:=result-y[i]*Ln(max(p[i],fEpsilon))
    else
      result:=result-Ln(max(1-p[i],fEpsilon))
    ;
    //if isNan(result) then
    //  beep
  end;
  //result:=result/Length(y)
  //result:=y.CrossEntropy(p);

end;

//https://stats.stackexchange.com/questions/154879/a-list-of-cost-functions-used-in-neural-networks-alongside-applications/154880#154880
procedure LossMeanSqrD(var e:TNeuronFloats;const y,p: TNeuronFloats);
begin
  TNeuronFloats.Sub(@e[0],Length(y),@y[0],@p[0])
end;


procedure LossMeanAbsD(var e:TNeuronFloats;const y,p: TNeuronFloats);
var i:integer;
begin
  for i:=0 to High(y) do
    e[i]:=-1+2*ord(y[i]>=p[i])
end;

procedure LossCrossEntropyD(var e:TNeuronFloats;const y,p: TNeuronFloats);
var t,o:TNeuronFloats;i:integer;
begin
  TNeuronFloats.Sub(@e[0],Length(P),@y[0],@p[0])

  // -y/p + (1-y)/(1-p)
//  for i:=0 to High(y) do
    //e[i]:=y[i]-p[i]
  //  e[i]:=(p[i]-y[i])/max((1-p[i])*p[i],fEpsilon);
 //   e[i]:=-y[i]/max(p[i],fEpsilon)+(1-y[i])/max(1-p[i],fEpsilon)

end;

{ TConv2D }

constructor TConv2D.Create(const AFeatures, AWidth, AHeight, ADepth, AKernelSize, AStride, APadding: integer; const AActivationType: TActivationType; const AAlpha: NeuronFloat);
begin
  FWidth:=AWidth;
  FHeight:=AHeight;
  FDepth:=ADepth;
  FFeatures:=AFeatures;
  FKernelSize:=AKernelSize;
  if APadding=-1 then
    FPadding:=trunc(AKernelSize/2)
  else
    FPadding:=APadding;
  FStride:=AStride;
  Weights.initas([AKernelSize*AKernelSize,FFeatures,FDepth]);
  //FKernels:=Weights.Data;
  TNeuralTensor.TDatatype(Weights.Data).normal(0.0, sqrt(2/(FDepth*AKernelSize*AKernelSize)));
  //TNeuralTensor.TT(Weights.Data).fill(0.0);

 // Weights.&div(FKernelSize*FKernelSize div 2);
  Deltas.Initas([AKernelSize*AKernelSize,FFeatures,FDepth]);
  Biases.initas([1,FFeatures]);


  oWidth:=trunc((FWidth+2*FPadding-AKernelSize)/FStride)+1;
  oHeight:=trunc((FHeight+2*FPadding-AKernelSize)/FStride)+1;
  //writeln( format('conv  %5d %2d x%2d /%2d  %4d x%4d x%4d   ->  %4d x%4d x%4d  %5.3f BFLOPs',[ AFeatures, AKernelSize, AKernelSize, AStride, AWidth, AHeight, ADepth, oWidth, oHeight, FFeatures, (2.0 * AFeatures * AKernelSize*AKernelSize*ADepth* oHeight*oWidth)/1000000000.0]));

  OutNeurons.initas([oWidth,oHeight,FFeatures]);
  ANeurons.initas([oWidth,oHeight,FFeatures]);
  ER.initas([oWidth,oHeight,FFeatures]);
  ErB.initas([oWidth,oHeight,FFeatures]);
  Gradients.initAs([oWidth,oHeight,FFeatures]);


  FKernels:=TNeuronFloats.Uniform(FKernelSize*FKernelSize*FFeatures,1.0,-1.0);

//  FKernelS.Normalize(1.0,-1.0);
  GradientsB.initAs([1,FFeatures]);
  SetLength(FTemp,oHeight*oWidth*FKernelSize*FKernelSize*FDepth)

  ///
end;


procedure TConv2D.FeedForward();
var i,j,m,n,k:integer;a,b,c:PNeuronFloat;
begin
  //m:=FFeatures;
  //k:=FDepth*FKernelSize*FKernelSize;
  //n:=FWidth*FHeight;
  //a:=@Weights.Data[0];
  //b:=@Validation.Data[0];
  //c:=@OutNeurons.Data[0];

  {$ifdef fpc}specialize {$endif} _conv2d<NeuronFloat,TNeuronFloats>(FFeatures, FKernelSize, FWidth, FHeight, FDepth, FStride,FPadding,Weights.Data,Validation.Data,OutNeurons.Data,FTemp);
  //conv2d(m,n,Fdepth,0,a,3,b,FWidth,c,0);
  //gemm_cpu(0,0,m,n,k,1,a,k,b,n,1,c,n);
end;

procedure TConv2D.Kernel2d( AInput:PNeuronFloat; const AOutput, Kernel: PNeuronFloat;
  const bias: NeuronFloat; const mKerSize, w, h: integer; Padding: integer;
  const Stride: integer);
var i,j,x,y,xi,yi, mEdgeSize:integer;mV:single; //mData:TSingleDynArray;
begin
  //mKerSize:=trunc(Sqrt(Length(kernel)));
  mEdgeSize:=trunc(mKerSize / 2);
  //mWidth:=w;
  //mHeight:=h;
  //mData:=copy(Data);
  //mWidth:=w+Padding*2;
  //mHeight:=h+Padding*2;
//  setLength(mData,oWidth*oHeight);
  if Padding>0 then
    for i:=0 to h-1 do
      move(AInput[i*w],FTemp[Padding*FWidth+Padding+i*FWidth],w*SizeOf(Single))
  else FTemp:=TNeuronFloats(AInput);
  //setLength(mCrop,mKerSize*mKerSize);

  //Assert(length(kernel)>8,'Kernel size is not a 3x3') ;

  //{$ifdef USE_GPU}
  //OpenCL.SetGlobalWorkGroupSize(mWidth,mHeight);
  //OpenCL.SetGlobalOffsets(0,mEdgeSize);
  ////OpenCL.CallKernel(1,@mData[0],@Data[0],@kernel[0],bias,mKerSize);
  //
  //OpenCL.SetParamElementSizes([SizeOf(Single)*mWidth*mHeight, SizeOf(Single)*mWidth*mHeight, SizeOf(Single)*mKerSize*mKerSize, SizeOf(bias), sizeOf(mKerSize)]);
  //OpenCL.CallKernel(1,([@mData[0],@Data[0],@kernel[0],@bias,@mKerSize]));
  //
  //{$else}
  //{$if defined(USE_AVX2) and defined(USE_THREADS)}
  ////i:=(mHeight-mKerSize) div 12; j:=0;
  ////while yi<(mHeight-mKerSize) do begin
  ////  ConvKernel(@TPointerDynArray([@mData[0],@Data[0],@kernel[0],@mWidth,@mHeight,@mKerSize,@mHeight])[0],j,Yi,i);
  ////  inc(yi,i);
  ////  inc(j)
  ////end;
  //
  //CallInParallel(TProcData(@ConvKernel),@TPointerDynArray([@mData[0],@Data[0],@kernel[0],@mWidth,@mHeight,@mKerSize,@bias])[0],0+mEdgeSize,mHeight-mEdgeSize,0);
  //{$else}
//  SetLength(Data,mWidth*mHeight);

  i:=0;
  Yi:=0;//mEdgeSize;
  while Yi < oHeight-mEdgeSize*2 do begin
    xi:=0;
    while Xi < oWidth-mEdgeSize*2 do begin
      mV:=0;
      for y:=0 to mKerSize-1 do

        {$ifdef USE_AVX2}
       // move(Data[xi+mWidth*(yi+y)],mCrop[y*mKerSize],mKerSize*SizeOf(Single));
       //mV:=bulkDot_s(@mCrop[0],@kernel[0],length(kernel));     // <-- faster
        mV:=mV+bulkDot_s(@FTemp[xi+oWidth*(yi+y)],@kernel[y*mKerSize],mKerSize);     // <-- faster

        //begin vDSP_dotpr(@Data[xi+mEdgeSize+mWidth*(yi+y)],1,@kernel[y*mKerSize],1,@mV1,mKerSize);mV:=mv+mV1  end;
        {$else}
        //mV:=mV+internalDot(@AInput[xi+oWidth*(yi+y)],@kernel[y*mKerSize],mKerSize);
        for x:=0 to mKerSize-1 do
          mV:=mV+FTemp[xi+x+oWidth*(yi+y)]*kernel[x+y*mKerSize];
        {$endif}
      AOutput[i{trunc(Xi/stride) +trunc(Yi/stride)*mWidth}]:=mV+bias ;
      inc(i);
      inc(Xi,stride);
    end;
    inc(Yi,stride)
  end;
  //TNeuronFloats(AFeatures).Add(bias);
  //{$endif}
  //{$endif}
  //FShape[0]:=mWidth;
  //FShape[1]:=mHeight;

end;


function TConv2D.Backpropagate(const learningRate: NeuronFloat;
  const updateWeights: boolean): TCustomNeuralLayer;
begin
  Result:=inherited Backpropagate(learningRate, updateWeights);
end;

{ TNeuralNet }

constructor TNeuralNet.Create;
begin
  LossFunction:=@LossMeanSqr;
  //GradientProc:=@LossMeanSqrD;
  TotalLoss:=1;
end;

constructor TNeuralNet.Create(const Layers: TNeuralLayers);
begin
  Add(Layers);
  LossFunction:=@LossMeanSqr;
  //GradientProc:=@LossMeanSqrD;
  TotalLoss:=1;
end;

destructor TNeuralNet.Destroy;
begin
  inherited Destroy;
end;

procedure TNeuralNet.Add(const Layers: TNeuralLayers);
var i,C:integer;
  Lr:TNeuralLayers;
begin
  //C:=Length(Net);
  //Lr:=Net;
  //SetLength(Net,Length(Net)+Length(Layers));
  //** it seems like setLength does a copy of the array content to the
  //** new allocated one in case of new capacity is requested so the next "if" statement is not needed
  //if Net<>Lr then
  //  Move(Lr[0],Net[0],SizeOf(Net[0])*Length(Lr))
  for i:=0 to High(Layers) do
    Add(Layers[i]);
end;

procedure TNeuralNet.Add(const Layer: TCustomNeuralLayer);
var c:integer;
begin
  SetLength(Net,Length(Net)+1);
  C:=High(Net);
  Net[C]:=Layer;
  if C>0 then begin
    Net[C].Previous:=Net[C-1];
    Net[C].NeuralNet:=Self;
    Net[C].Weights.InitAs([Net[C-1].Size,Net[C].Size]);
    //if Net[C].ActivationType=atReLU then
    //  Net[C].Weights.uniform(1)
    //else
      Net[C].Weights.uniform(1.0,-1.0);
    Net[C].Biases.InitAs([Net[C].Size,1]);
    //if Net[C].ActivationType=atReLU then
    //  Net[C].Biases.uniform(1)
    //else
      Net[C].Biases.uniform(1.0,-1.0);
    Net[C].Deltas.InitAs([Net[C-1].Size,Net[C].Size]);
    Net[C].DeltasB.InitAs([Net[C-1].Size,Net[C].Size]);
    Net[C-1].Next:=Net[C];
  end;
  FLayerCount:=Length(Net);;
end;

function TNeuralNet.Predict(const input: TNeuralTensor): TNeuralTensor;
var Layer:TCustomNeuralLayer;
begin
  Layer:=Net[0];
  Layer.ANeurons:=input;
  repeat
    Layer:=Layer.next;
    Layer.FeedForward;
  until not Assigned(Layer.Next);
  result:=Layer.ANeurons;
end;

procedure TNeuralNet.CalcDefaultGradient(const Grad,Target:TNeuronFloats);
var i:integer;oData:TNeuronFloats;
begin
//  Grad.Count:=Length(Target.Data);

  for i:=0 to High(Grad) do begin
    oData:=Copy(FOutput.ANeurons.Data);
    oData[i]:=oData[i]+fDelta;

    Grad[i]:=(LocalLoss-LossFunction(Target,oData))/fDelta;
    //if isNan(Grad[i]) then
    //  beep
  end

end;

procedure TNeuralNet.Fit(const Train, Targets: TNeuralTensor; const ALearningRate: NeuronFloat;const AEpoch:integer;const BatchSize: integer; const AOptimizerType: TOptimizerType);
var i,j:integer;update:boolean;Layer:TCustomNeuralLayer;input,Target,predicted:TNeuralTensor;Err:NeuronFloat;Hits:longWord;
begin
  {$ifdef USE_THREADS}
  if nWorkingThreads>0 then exit;
  {$EndIf}
  FOutput:=Net[High(Net)] ;
  Assert((Train.Dimensions=2) and (Targets.Dimensions=2),'Training or Validation dataset dimensions must equal Two');
  OptimizerType:=AOptimizerType;
  Batch:=BatchSize;
  LearningRate:=ALearningRate;
  Epoch:=AEpoch;
  for j:=0 to epoch-1 do begin
    TensorsProcessed:=0;
    Hits:=0;
    Err:=0;
    for i:=0 to Train.Shape[1]-1 do begin
      input:=Train.GetRow(i);
      Target:=Targets.GetRow(i);
      Layer:=FOutput;
      predicted:=Predict(input);

      if (TSingles(Target.Data).argMax()=TSingles(predicted.Data).argMax()) then inc(Hits);
      LocalLoss:=LossFunction(Target.Data,Predicted.Data);
      Err:=Err+LocalLoss;
      if Assigned(GradientProc) then
        GradientProc(Layer.Er.Data,Target.Data,predicted.Data)
      else
      {$ifdef centropy_short}
      //https://towardsdatascience.com/derivative-of-the-softmax-function-and-the-categorical-cross-entropy-loss-ffceefc081d1
      if LossFunction=@LossCrossEntropy then
        TNeuronFloats.sub(@Layer.Er.Data[0],Length(Target.Data),@Target.Data[0],@predicted.Data[0])
      else
      {$endif}
      begin
        CalcDefaultGradient(Layer.Er.Data,Target.Data);
      end;

      update:= TensorsProcessed mod Batch=Batch-1;
      while update and Assigned(Layer.Backpropagate(LearningRate,update).Previous) do
        //if update then
          Layer:=Layer.Previous
        //else
          //break
          ;
      Inc(TensorsProcessed)
    end;
    TotalLoss:=Err/TensorsProcessed;//Layer.LossFunc(Output.Data,Predicted.Data);
    LossHistory.Push(TotalLoss);
    if Assigned(FOnEpochFinish) then
      FOnEpochFinish(Self,j,TotalLoss,Hits);

  end;
  if Assigned(FOnFitFinished) then
    FOnFitFinished(Self,TotalLoss,Hits);
end;

procedure TNeuralNet.SaveToFile(FileName: string);
var F:TextFile;s,sBuf:string;i,j,k:integer;
begin
  for i:=1 to FLayerCount-1 do begin
    s:=s+',{"weights":[';
    sBuf:='';
    for j:=0 to High(Net[i].Weights.Data) do
      sBuf:=sBuf+','+FloatToStr(Net[i].Weights.Data[j]);
    delete(sBuf,1,1);
    s:=s+sBuf+'],"biases":[' ;
    sBuf:='';
    for j:=0 to High(Net[i].Biases.Data) do
      sBuf:=sBuf+','+FloatToStr(Net[i].Weights.Data[j]);
    delete(sBuf,1,1);
    s:=s+sBuf+']}';
  end;
  delete(s,1,1);
  s:='['+s+']';
  Assignfile(F,FileName);
  rewrite(f);
  Write(f,s);
  CloseFile(f)
end;

procedure TNeuralNet.LoadFromFile(FileName: string);
begin

end;

{ TNeuralLayer }

constructor TCustomNeuralLayer.Create(const ASize: integer;
  const AActivationType: TActivationType; const ALossType: TLossType;
  const alpha: NeuronFloat);
begin
  Size:=ASize;
  OutNeurons.InitAs([ASize]);
  ANeurons.InitAs([ASize]);
  Er.InitAs([1,ASize]);
  ErB.InitAs([1,ASize]);
  Gradients.InitAs([1,ASize]);
  GradientsB.InitAs([1,ASize]);
  Neurons_T.InitAs([ASize,1]);
  Neurons_T.Data:=ANeurons.Data;
  case AActivationType of
    atSigmoid:Processor:=SigmoidProcessor;
    atReLU:Processor:=ReLUProcessor;
    atTanH:Processor:=TanHProcessor;
    atLReLU:Processor:=LReLUProcessor;
    atSoftmax:Processor:=SoftMaxProcessor;
    atIdentity:Processor:=IdentityProcessor;
  end;
  ActivationType:=AActivationType;
  case ALossType of
    lfMeanSquared:LossFunc:=@LossMeanSqr;
    lfMeanAbsolute:LossFunc:=@LossMeanAbs;
  end;


end;

destructor TCustomNeuralLayer.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomNeuralLayer.FeedForward;
begin
  if Assigned(Previous) then begin
    TNeuralTensor.Multiply(OutNeurons,Weights,Previous.ANeurons);
    OutNeurons.Add(Biases);
    Processor.Activate(ANeurons.Data,OutNeurons.Data);
  end;
end;

function TCustomNeuralLayer.Backpropagate(const learningRate:NeuronFloat;const updateWeights:boolean):TCustomNeuralLayer;
var i,j:integer;
begin
  Previous.Neurons_T.Data:=Previous.ANeurons.Data;
  if NeuralNet.Batch>1 then begin
    {$ifdef centropy_short}
    //https://peterroelants.github.io/posts/cross-entropy-softmax/
    if (NeuralNet.LossFunction=@LossCrossEntropy) and (ActivationType=atSoftmax) and (Next=nil) then
      Gradients.Data:=Copy(Er.Data)
    else
    {$endif}
    begin
      // http://neuralnetworksanddeeplearning.com/chap2.html
      Processor.Derivative(Gradients.Data,ANeurons.Data);         // δL=∇a C ⊙ σ′ (zL)  => δL=(aL−y)⊙σ′(zL)       //  σ′ = activation derivative , ∇aC = Cost change by output change vector , ⊙ is hadamard product
      Gradients.mul(Er);
    end;
    Gradients.mul(learningRate);
    TNeuralTensor.Multiply(Deltas,Gradients,Previous.Neurons_T);
    GradientsB.Add(Gradients);
    DeltasB.Add(Deltas);
    ErB.Add(Er);
    if updateWeights then begin
      Weights.Add(DeltasB);
      biases.Add(GradientsB);
//      Er:=ErB;
//      Previous.Neurons_T.Data:=Previous.ANeurons.Data;
//      Processor.Derivative(Gradients.Data,ANeurons.Data);
//      Gradients.mul(Er).mul(learningRate);
//      TNeuralTensor.Multiply(Deltas,Gradients,Previous.Neurons_T);
      //Weights.Add(Deltas);
      //biases.Add(Gradients);
      TNeuralTensor.Multiply(Previous.Er,Weights.Transpose,ErB);
      ErB.Fill(0);
      GradientsB.Fill(0);
      DeltasB.Fill(0);
    end;
  end else begin
    {$ifdef centropy_short}
    //https://peterroelants.github.io/posts/cross-entropy-softmax/
    if (NeuralNet.LossFunction=@LossCrossEntropy) and (ActivationType=atSoftmax) and (Next=nil) then
      Gradients.Data:=Copy(Er.Data)
    else
    {$endif}
    begin
      Processor.Derivative(Gradients.Data,ANeurons.Data);
      Gradients.mul(Er);
    end;
    TNeuralTensor.Multiply(Deltas,Gradients,Previous.Neurons_T);
    Weights.Add(Deltas);
    biases.Add(Gradients);
    TNeuralTensor.Multiply(Previous.Er,Weights.Transpose,Er);
  end;
  result:=Previous
end;

end.

