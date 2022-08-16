
procedure splitRGB(const Data:PLongword;const Red,Green,Blue:PByte;const Count:integer);
var i:integer;
begin
  for i:=0 to Count-1 do begin
    with TColorRec(Data[i]) do begin
      Red[i]:=r;
      Green[i]:=g;
      Blue[i]:=b;
    end;
  end;
end;

procedure joinRGB( Data:PColorRec; const Red,Green,Blue:PByte;const Count:integer);
var i:integer;
begin

  for i:=0 to Count-1 do begin
    with Data^ do begin
      R:=Red[i]  ;
      G:=Green[i];
      B:=Blue[i] ;
      A:=$ff;
    end;
    inc(Data)
  end;
end;

procedure DrawData(const Dest:TBitmap;const Src:PLongword;const x,y,width,height:integer;const scale:single=1.0);
var w,i,j,k,l:integer;D:PLongword;
begin
  {$ifdef fpc} w:=Dest.RawImage.Description.Width;
  {$else} w:=Dest.width;
  {$endif}
  D:=Dest.scanline[0];
  if scale=1.0 then
    for i:=0 to Height-1 do
      Move(Src[i*Width],D[x+y*W+i*W],Width*SizeOf(LongWord))
  else
    for i:=0 to trunc(Height*Scale)-1 do
      for j:=0 to trunc(Width*Scale)-1 do
        D[x+j+(i+y)*w]:=Src[trunc(j/scale)+trunc(i/scale)*width]
end;

function Clamp(const v,vMin,vMax:integer):Integer;
begin
  result:=v;
  if v<vMin then result:=vMin;
  if v>vMax then result:=vMax
end;

{ TConvTensor }

function LoadBMP(const Filename:string;var Tensor:TSingleTensor;const asGrayScale:boolean=true;const bias:single=-1.0;const scale:single=2.0):Boolean;
var bmp:TBitmap;  i:integer;
begin
  bmp:=TBitmap.Create;
  bmp.PixelFormat:=pf32bit;
  bmp.LoadFromFile(Filename);
  Tensor.InitAs([bmp.Width,bmp.Height]);
  if asGrayScale then begin
    Tensor.InitAs([bmp.Width,bmp.Height]);
    for i:=0 to High(Tensor.Data) do
      Tensor.Data[i]:= bias+scale*(Integer(bmp.RawImage.Data[i*4+1])+Integer(bmp.RawImage.Data[i*4+2])+Integer(bmp.RawImage.Data[i*4+3]))/$300
  end else begin
    Tensor.InitAs([bmp.Width,bmp.Height,3]);
    for i:=0 to bmp.Width*bmp.Height-1 do begin
      Tensor.Data[i]                                    := bias+scale*bmp.RawImage.Data[i*4+1]/$ff;
      Tensor.Data[i+  Tensor.Shape[0]*Tensor.Shape[1]]  := bias+scale*bmp.RawImage.Data[i*4+2]/$ff;
      Tensor.Data[i+2*Tensor.Shape[0]*Tensor.Shape[1]]  := bias+scale*bmp.RawImage.Data[i*4+3]/$ff
    end;
  end;
  FreeAndNil(bmp);
  result:=true
end;

function LoadJPG(const Filename:string;var Tensor:TSingleTensor;const asGrayScale:boolean=true;const bias:single=-1.0;const scale:single=2.0):Boolean;
var bmp:TJPEGImage;  i,r,g,b:integer;
begin
  bmp:=TJPEGImage.Create;
  bmp.PixelFormat:=pf32bit;
  bmp.LoadFromFile(Filename);
  //Tensor.InitAs([bmp.Width,bmp.Height]);
  if asGrayScale then begin
    Tensor.InitAs([bmp.Width,bmp.Height]);
    for i:=0 to High(Tensor.Data) do
      Tensor.Data[i]:= bias+scale*(Integer(bmp.RawImage.Data[i*4+1])+Integer(bmp.RawImage.Data[i*4+2])+Integer(bmp.RawImage.Data[i*4+3]))/$300
  end else begin
    Tensor.InitAs([bmp.Width,bmp.Height,3]);
    for i:=0 to bmp.Width*bmp.Height-1 do begin
      Tensor.Data[i]                                    := bias+scale*bmp.RawImage.Data[i*4+1]/$ff;
      Tensor.Data[i+  Tensor.Shape[0]*Tensor.Shape[1]]  := bias+scale*bmp.RawImage.Data[i*4+2]/$ff;
      Tensor.Data[i+2*Tensor.Shape[0]*Tensor.Shape[1]]  := bias+scale*bmp.RawImage.Data[i*4+3]/$ff
    end;
  end;
  FreeAndNil(bmp);
  result:=true
end;

function LoadPNG(const Filename:string;var Tensor:TSingleTensor;const asGrayScale:boolean=true;const bias:single=-1.0;const scale:single=2.0):Boolean;
var bmp:TPortableNetworkGraphic;  i:integer;
begin
  bmp:=TPortableNetworkGraphic.Create;
  bmp.PixelFormat:=pf32bit;
  bmp.LoadFromFile(Filename);
  if asGrayScale then begin
    Tensor.InitAs([bmp.Width,bmp.Height]);
    for i:=0 to High(Tensor.Data) do
      Tensor.Data[i]:= bias+scale*(Integer(bmp.RawImage.Data[i*4+1])+Integer(bmp.RawImage.Data[i*4+2])+Integer(bmp.RawImage.Data[i*4+3]))/$2ff
  end else begin
    Tensor.InitAs([bmp.Width,bmp.Height,3]);
    for i:=0 to bmp.Width*bmp.Height-1 do begin
      Tensor.Data[i]                                    := bias+scale*bmp.RawImage.Data[i*4+1]/$ff;
      Tensor.Data[i+  Tensor.Shape[0]*Tensor.Shape[1]]  := bias+scale*bmp.RawImage.Data[i*4+2]/$ff;
      Tensor.Data[i+2*Tensor.Shape[0]*Tensor.Shape[1]]  := bias+scale*bmp.RawImage.Data[i*4+3]/$ff
    end;
  end;
  FreeAndNil(bmp);
  result:=true
end;

procedure TConvTensor.LoadFromFile(const filename: string; const asGrayScale:boolean;const bias,scale:single);
var fext:string;
begin
  fext:= LowerCase(ExtractFileExt(FileName));
  if fext='.bmp' then
        LoadBMP(Filename,Self, asGrayScale, bias, scale)
  else if fext='.jpg' then
        LoadJPG(Filename,Self, asGrayScale, bias, scale)
  else if fext='.png' then
        LoadPNG(FileName,Self, asGrayScale, bias, scale);
end;
//{$undef USE_AVX2}
//class function TConvTensor.internalDot(const a,b:PSingle;const count:integer ):Single ;
//{$ifndef USE_AVX2}var i:integer;{$endif}
//begin
//  {$ifdef USE_AVX2}
//  result:=bulkDot_s(a,b,count);
//  {$else}
//  result:=0;
//  for i:=0 to Count-1 do
//    result:=result+a[i]*b[i]
//  {$endif}
//end;

procedure TConvTensor.Draw(const toGraphic: TGraphic);
var {bm:TBitmap;}i,j,k,w,h:Integer; P:PColorRec; bmp:TBitmap absolute toGraphic;
begin
  Assert(Dimensions>1,'Not a 2D Convolutional tensor');
  //bm:=TBitmap.Create;
  //bm.PixelFormat:=pf32bit;
  //bm.SetSize(Shape[0],Shape[1]);

  with TBitmap(toGraphic) do try
    if toGraphic=nil then exit;
    if Self.Dimensions>2 then
      h:=Self.Shape[1]*Self.Shape[2]
    else
      h:=Self.Shape[1];
    SetSize(Self.Shape[0],h);
    P:=ScanLine[0];
    BeginUpdate();
    for i:=0 to High(Data) do //if i< Self.Shape[0]*h then
      //for j:=0 to Self.Height-1 do
      //  for k:=0 to Self.Width-1 do
          begin
            P[i].B:=Clamp(trunc((1.0+Data[i])*128),0,$ff);       //r
            P[i].G:=P[i].B;     //g
            P[i].R:=P[i].B;      //b ??
            P[i].A:=$ff   // alpha
          end;
    EndUpdate();
    //Canvas.Draw(0,0,bm);
  except end;
  //FreeAndNil(bm)
end;

{$if defined(USE_AVX2) and defined(USE_THREADS)}
procedure ConvKernel(const opt:PPointer; const Id,Stride,Count:integer);
var Yi,Xi,x,y,mEdgeSize,i:integer; mV,r:single;
  mData, Data, kernel:PSingle; mWidth,mHeight,mKerSize:integer;bias:single;
begin
//  WriteLn('Thread Started Offset:',Yi,'Id:',Id);
  mData:=PSingle(opt[0]);
  Data:=PSingle(opt[1]);
  Kernel:=PSingle(opt[2]);
  mWidth:=PInteger(opt[3])^;
  mHeight:=PInteger(opt[4])^;
  mKerSize:=PInteger(opt[5])^;
  bias:=PSingle(opt[6])^;
  //if (yi+mKerSize>=mHeight) then
  //  beep;
  mEdgeSize:=mKerSize shr 1;
//  for i:=-
  Yi:=Id;
  while Yi<Count do begin
    Xi:=mEdgeSize;
    while Xi<mWidth-mEdgeSize do begin
      mV:=0;
      for y:=0 to mKerSize-1 do begin
        //vDSP_dotpr(@Data[xi-mEdgeSize+mWidth*(yi+y-mEdgeSize)],1,@kernel[y*mKerSize],1,@r,mKerSize);
        //mV:=Mv+r;
        mV:=mV+bulkDot_s(@Data[xi-mEdgeSize+mWidth*(yi+y-mEdgeSize)],@kernel[y*mKerSize],mKerSize);
      end;
      mData[xi+yi*mWidth]:=mV +bias;
      inc(Xi);
    end;
    Yi:=Yi+Stride
  end;
end;

{$endif}

procedure TConvTensor.Kernel2d(const kernel: TSingleDynArray; const bias:Single;const stride:integer;Padding:integer);
var i,j,x,y,xi,yi,zi,mKerSize, mEdgeSize,mWidth,mHeight,oWidth,oHeight,oDepth:integer;mV:single; mData:TSingleDynArray;  ws:array[0..$fffff] of single;
begin
  mKerSize:=trunc(Sqrt(Length(kernel)));
  mEdgeSize:=trunc(mKerSize / 2);
  if Padding=-1 then
      Padding:=mEdgeSize;
  mWidth:=FShape[0];
  mHeight:=FShape[1];
  //mData:=copy(Data);
  oWidth:=mWidth+Padding*2;
  oHeight:=mHeight+Padding*2;
  if Dimensions>2 then oDepth:=FShape[2] else oDepth:=1;
  setLength(mData,oWidth*oHeight*FShape[2]);
  for i:=0 to oDepth-1 do for j:=0 to mHeight-1 do
    move(Data[mWidth*(j+i*mHeight)],mData[Padding+oWidth*((Padding+j)+i*oHeight)],mWidth*SizeOf(Single));

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
  mWidth:=trunc((oWidth-mKerSize)/stride)+1;
  mHeight:=trunc((oHeight-mKerSize)/stride)+1;

  if Dimensions>2 then
    SetLength(Data,mWidth*mHeight*FShape[2])
  else
    SetLength(Data,mWidth*mHeight);
  i:=0;
  Yi:=0;//mEdgeSize;
  zi:=0 ;
  while zi< oDepth do begin
    yi:=0;
    while Yi < oHeight-mEdgeSize*2 do begin
      xi:=0;
      while Xi < oWidth-mEdgeSize*2 do begin
        {.$define CACHE_CONV}
        {$ifndef CACHE_CONV}
        mV:=0;
        {$endif}
        for y:=0 to mKerSize-1 do
          {$ifdef USE_AVX2}
          {$ifdef CACHE_CONV}
          move(mData[xi+oWidth*(yi+y)],ws[y*mKerSize],mKerSize*4) ;
        mV:=bulkDot_s(@ws[0],@kernel[0],Length(kernel));
          {$else}
             mV:=mV+bulkDot_s(@mData[xi+oWidth*(yi+y)],@kernel[y*mKerSize],mKerSize);
          {$endif}
  //        mV:=mV+bulkDot_s(@mData[xi+oWidth*(yi+y)],@kernel[y*mKerSize],mKerSize);     // <-- faster

          //begin vDSP_dotpr(@Data[xi+mEdgeSize+mWidth*(yi+y)],1,@kernel[y*mKerSize],1,@mV1,mKerSize);mV:=mv+mV1  end;
          {$else}
          //mV:=mV+internalDot(@mData[xi+oWidth*(yi+y)],@kernel[y*mKerSize],mKerSize);
          for x:=0 to mKerSize-1 do
            mV:=mV+Data[xi+x+mWidth*(yi+y)]*kernel[x+y*mKerSize];
          {$endif}
        Data[i { trunc(Xi/stride) +trunc(Yi/stride)*mWidth } ]:=mV +bias;
        inc(Xi,stride);
        inc(i);
      end;
      inc(Yi,stride)
    end;
    inc(Zi);
  end   ;
  //TSingles(Data).Add(bias);
  //{$endif}
  //{$endif}
  FShape[0]:=mWidth;
  FShape[1]:=mHeight;

end;


