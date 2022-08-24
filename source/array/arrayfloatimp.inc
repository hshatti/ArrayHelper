//
//function SumOfSquares(const Vals:array of Currency):Currency; inline;
//var i:integer;
//begin
//  for i:=0 to Length(Vals)-1 do
//    result:=Result+Vals[i]*Vals[i]
//end;

{ TFloatArrayHelper }

class procedure TFloatArrayHelper.QuickSort(var Arr: TFloatDynArray; const L,
  R: Longint; const Compare: {$ifdef fpc}specialize{$endif} TComparefunc<Float>);
begin
    {$ifdef fpc}specialize{$endif} _QuickSort<Float,PFloat>(@Arr[0],L,R,Compare)
end;

class function TFloatArrayHelper.cmp(const a,b:Float):Integer  ;
begin
  result:=CompareValue(a,b);
  //result:=0;
  //if a>b then
  //  result:=1
  //else if a<b then
  //  result:=-1;
end;

procedure TFloatArrayHelper.SetCount(AValue: Integer); _SETCOUNT_;

function TFloatArrayHelper.as2D(const Columns:integer;const Transposed:boolean):TFloatArrayArray;
var i,C,M,R,Rows:integer;
begin
  c:=Count;
  Rows:=system.trunc(C/Columns);
  c:=Columns*Rows;
  setLength(result,Rows);      // for some reason using "setLength(result,Rows,Columns)" is slower than checking "if result[M]=nil then"
  if transposed then
  for i:=0 to C-1 do
    begin
      DivMod(i,Rows,r,M);
      if result[M]=nil then
        setLength(result[M],Columns);
      result[M,r]:=Self[i]
    end
  else
  for i:=0 to C-1 do
    begin
      DivMod(i,Columns,r,M);
      if result[r]=nil then
        setLength(result[r],Columns);
      result[r,M]:=Self[i]
    end;
end;

function TFloatArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TRecudeCallback<Float>;const init: Float): Float;_REDUCE_;

function TFloatArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Float>): Float;_SIMPLEREDUCE_;

function TFloatArrayHelper.GetCount: integer;_DOCOUNT_;

function TFloatArrayHelper.Sort(const CompareFunc: {$ifdef fpc}specialize{$endif} TComparefunc<Float>):TFloatDynArray; _DOSORT_ ;

function TFloatArrayHelper.Sorted(const CompareFunc: {$ifdef fpc}specialize{$endif} TComparefunc<Float>): TFloatDynArray; _SORTED_;

function TFloatArrayHelper.isSorted(const descending:boolean =false; CompareFunc: {$ifdef fpc}specialize{$endif} TCompareFunc<Float> = nil):boolean; _ISSORTED_;
//var i:integer;
//begin
//  result:=true;
//  if not Assigned(sortFunc) then
//    sortFunc:={$ifdef fpc}@{$endif}Self.cmp;
//  if descending then
//    for i:=1 to high(Self) do
//      if sortFunc(Self[i-1],Self[i])<0 then begin
//        result:=false;
//        exit()
//      end else
//  else for i:=1 to high(Self) do
//    if sortFunc(Self[i],Self[i-1])<0 then begin
//      result:=false;
//      exit()
//    end
//end;


function TFloatArrayHelper.Lookup(const val:Float):integer;
begin
  // assuming that the array is sorted
  result:={$ifdef fpc}specialize{$endif} _BinSearch<Float,PFloat>(@Self[0],Val,Length(Self),{$ifdef fpc}specialize{$endif} TCompareFunc<Float>(@Self.cmp));
end;

function TFloatArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<Float>): TFloatDynArray; _DOMAP_;

function TFloatArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<Float> ): TFloatDynArray;// _SIMPLEMAP_;
var i,C:integer;
begin
  c:=Count;
  setLength(result,C);
  for i:=0 To C-1 do
    Result[i]:=func(Self[i]);
end;

function TFloatArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<Float> ): TFloatDynArray;// _SIMPLEMAP_;
var i,C:integer;
begin
  c:=Count;
  setLength(result,C);
  for i:=0 To C-1 do
    Result[i]:=func(Self[i]);
end;

function TFloatArrayHelper.Map(proc: {$ifdef fpc}specialize{$endif} TSIMDMap<PFloat>): TFloatDynArray;
var C,L:Integer;
begin
  result:=Copy(Self);
  C:=0;L:=Length(Self);
  while C<L do
    proc(@result[C],@C,L)
end;

function TFloatArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<Float>): TVariantArray;_DOMAP_;

function TFloatArrayHelper.Map(const a, b, a1, b1: Float): TFloatDynArray;
var i:integer;v,v1:Float;
begin
  v:=b-a;
  v1:=b1-a1;
//  writeLn('a:[',v:2:2,'] ,b:[',v1:2:2,']');
  setLength(result,Count);
  if v=0 then
    for i:=0 to Count-1 do
      result[i]:=a1
  else for i:=0 To Count-1 do
    Result[i]:=a1+v1*(Self[i]-a)/v;

end;

function TFloatArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<Float,PFloat>): TFloatDynArray;_FILTER_;

class function TFloatArrayHelper.uniqueFilt(const a:float;const i:integer;arr:PFloat):boolean;
begin;
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;

function TFloatArrayHelper.unique():TFloatDynArray;
begin
  result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<float,PFloat>(@uniqueFilt));
end;

function TFloatArrayHelper.indexOf(const val: Float): integer; _INDEXOF_;

function TFloatArrayHelper.Abs():TFloatDynArray;
var i:integer;
begin
  SetLength(result,Length(Self));
{$if defined(USE_MKL) and ((Float=Single) or (Float=Double))}
  {$if Float=Single}
  vsAbs(Length(Self),@Self[0],@result[0]);
  {$elseif Float=Double}
  vdAbs(Length(Self),@Self[0],@result[0]);
  {$endif}
{$else}
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkAbs_s(@result[0],@Self[0],Count);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkAbs_d(@result[0],@Self[0],Count);
  {$else}
  for i:=0 to High(Self) do
    Result[i]:=system.Abs(Self[i])
  {$endif}
{$endif}
end;

function TFloatArrayHelper.SumOfAbs():Float;
var i:integer;
begin
{$if defined(USE_MKL) and ((Float=Single) or (Float=Double))}
  {$if Float=Single}
  result:=cblas_sasum(Length(Self),@Self[0],1);
  {$elseif Float=Double}
  result:=cblas_dasum(Length(Self),@Self[0],1);
  {$endif}
{$else}
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSumAbs_s(@result,@Self[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSumAbs_d(@result,@Self[0],Length(Self));
  {$else}
  result:=0;
  for i:=0 to High(Self) do
    Result:=Result+system.Abs(Self[i])
  {$endif}
{$endif}
end;

function TFloatArrayHelper.argMax():Integer;
var i,C:integer;F:Float;
begin
  C:=High(self);
  F:=Self[0];
  result:=0;
  for i:=1 to C do
    if F<Self[i] then begin
      F:=Self[i];
      result:=i;
    end
end;

function TFloatArrayHelper.argMin():Integer;
var i,C:integer;F:Float;
begin
  C:=High(self);
  F:=Self[0];
  result:=0;
  for i:=1 to C do
    if F>Self[i] then begin
      F:=Self[i];
      result:=i;
    end
end;

function TFloatArrayHelper.normal(const vMean, vStdDiv: Float;scaleVal:Float
  ): TFloatDynArray;
var i:integer;
begin
  for i:=0 to Count-1 do
    Self[i]:=RandG(vMean,vStdDiv)*scaleVal;
  Result:=Self
end;

class function TFloatArrayHelper.normal(const vMean, vStdDiv: Float;
  const Cnt: integer;scaleVal:Float): TFloatDynArray;
var i:integer;
begin
  setLength(Result,Cnt);
  for i:=0 to Cnt-1 do
    Result[i]:=RandG(vMean,vStdDiv)*scaleVal;
end;

class function TFloatArrayHelper.Uniform(const vCount: integer;const maxVal:Float;const minVal:Float): TFloatDynArray;
var i:integer;
begin
  setLength(Result,vCount);
  for i:=0 to vCount-1 do
    result[i]:=minVal+Random*(maxVal-minVal);
end;

function TFloatArrayHelper.Uniform(const maxVal,minVal:Float): TFloatDynArray;
var
  i: Integer;
begin
 for i:=0 to Count-1 do
   Self[i]:=minVal+Random*(maxVal-minVal);
  result:=Self
end;

class function TFloatArrayHelper.fill(const vCount:Integer;Value:Float;const interval:Float;const vStdDev:Float): TFloatDynArray;
var i:integer;
begin
  setLength(Result,vCount);
  i:=0;
  if vStdDev=0 then while i<vCount do begin
    result[i]:=Value;
    Value:=Value+Interval;
    inc(i)
  end else while i<vCount do begin
    result[i]:=Math.RandG(Value,vStdDev);
    Value:=Value+Interval;
    inc(i)
  end
end;

function TFloatArrayHelper.fill(Value:Float;const interval:Float;const vStdDev:Float): TFloatDynArray;
var i:integer;
begin
  result:=self;
  i:=0;
  if vStdDev=0 then while i<Count do begin
    result[i]:=Value;
    Value:=Value+Interval;
    inc(i)
  end else while i<Count do begin
    result[i]:=Math.RandG(Value,vStdDev);
    Value:=Value+Interval;
    inc(i)
  end
end;

function TFloatArrayHelper.Exp():TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=System.Exp(Self[i])
end;

function TFloatArrayHelper.Sin(const amplitude:float):TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=amplitude*System.Sin(self[i])
end;

function TFloatArrayHelper.Cos(const amplitude:float):TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=amplitude*System.Cos(self[i])
end;

function TFloatArrayHelper.Log10():TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=Math.Log10(self[i])
end;

function TFloatArrayHelper.Log2():TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=Math.Log2(self[i])
end;

function TFloatArrayHelper.LogN(base:Float):TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=Math.LogN(base,self[i])
end;

function TFloatArrayHelper.Ln():TFloatDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to Count-1 do
    result[i]:=System.Ln(self[i])
end;

class function TFloatArrayHelper.polynomial(const vCount:integer;const coef:TFloatDynArray;const vStdDev:Float;const xInterval:Float):TFloatDynArray;
var i,j,deg:integer;val:float;
  function xLinear(const n:integer;const x:Float):Float;inline;
  begin
    if n<deg then
      result:=coef[n]+x*xLinear(n+1,x)
    else
      result:=coef[n]
  end;
begin
  //Horner's Method https://en.wikipedia.org/wiki/Horner%27s_method
  setLength(result,vCount);
  deg:=coef.Count-1;

  for i:=0 to vCount-1 do begin
    val:=xLinear(0,i*xInterval);

    //val:=0;
    //if coef.count>0 then val:=coef[0];
    //for j:=1 to coef.count-1 do
    //  if coef[j]<>0 then  val:=val+coef[j]*power(i*xScaller,j);
    //result[i]:=val;

    if vStdDev>0 then
      result[i]:=Math.RandG(val,vStdDev)
    else result[i]:=val;
  end;

end;

function TFloatArrayHelper.Magnitude(): Float;
begin
  result:=System.Sqrt(Self.SumOfSquares)
end;

function TFloatArrayHelper.SumOfSquares(): Float;
var i:integer;
begin
{$if defined(USE_MKL) and ((Float=Single) or (Float=Double))}
  {$if Float=Single}
  result:=cblas_sdot(Count,@Self[0],1,@Self[0],1);
  {$elseif Float=Double}
  result:=cblas_ddot(Count,@Self[0],1,@Self[0],1);
  {$endif}
{$else}
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSumSqr_s(@result,@Self[0],Count);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSumSqr_d(@result,@Self[0],Count);
  {$else}
  result:=0.0;
  for i:=0 to High(Self) do
    result:=result+Self[i]*Self[i]
  {$endif}
{$endif}
end;

function TFloatArrayHelper.Product(): Extended;
  var i:integer;
begin
  Result:=1;
  for i:=0 to Count-1 do
    Result:=Result*Self[i]
end;

function TFloatArrayHelper.Sum(): Float;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSum_s(@result,@Self[0],Count);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSum_d(@result,@Self[0],Count);
  {$else}
   result:=Math.sum(Self);
  {$endif}
end;

function TFloatArrayHelper.Max(): Float;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkmax_s(@result,@Self[0],Count);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkMax_d(@result,@Self[0],Count);
  {$else}
  Result:=MaxValue(Self);
  {$endif}
end;

function TFloatArrayHelper.Min(): Float;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkMin_s(@result,@Self[0],Count);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkMin_d(@result,@Self[0],Count);
  {$else}
  Result:=MinValue(Self)
  {$endif}
end;

function TFloatArrayHelper.Max(const val:Float):TFloatDynArray;
var C,i:integer;
begin
  C:=High(Self);
  setLength(result,C);
  for i:=0 to C do
    result[i]:=Math.Max(val,Self[i])
end;

function TFloatArrayHelper.Min(const Val:Float):TFloatDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
  for i:=0 to C do
    result[i]:=Math.Min(val,Self[i])
end;

function TFloatArrayHelper.Max(const vals:TFloatDynArray):TFloatDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
{$if defined(USE_MKL) and ((Float=Single) or (Float=Double))}
  {$if Float=Single}
  vsFmax(C,@Self[0],@vals[0],@result[0]);
  {$elseif Float=Double}
  vdFmax(C,@Self[0],@vals[0],@result[0]);
  {$endif}
{$else}
  for i:=0 to C do
    result[i]:=Math.Max(vals[i],Self[i])
{$endif}
end;

function TFloatArrayHelper.Min(const Vals:TFloatDynArray):TFloatDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
{$if defined(USE_MKL) and ((Float=Single) or (Float=Double))}
  {$if Float=Single}
  vsFMin(C,@Self[0],@vals[0],@result[0]);
  {$elseif Float=Double}
  vdFMin(C,@Self[0],@vals[0],@result[0]);
  {$endif}
{$else}
  for i:=0 to C do
    result[i]:=Math.Min(vals[i],Self[i])
{$endif}
end;

function TFloatArrayHelper.Clamp(const minVal,maxVal:Float):TFloatDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(Result,C+1);
  for i:=0 to C do
    begin
      Result[i]:=Self[i];
      if Self[i]>maxVal then result[i]:=maxVal;
      if Self[i]<minVal then result[i]:=minVal;
    end;
end;

function TFloatArrayHelper.Mean(): Float;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSum_s(@result,@Self[0],Count);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSum_d(@result,@Self[0],Count);
  {$else}
  result:=Self.Sum();
  {$endif}
  result:=result / Length(Self);
  //result:=Math.Mean(Self);
end;

function TFloatArrayHelper.Mode(): Float;
var i,C,e,r:integer;vs:TFloatDynArray;a:TIntegerDynArray;
begin
  C:=Count;
  r:=0;
  for i:=0 to C-1 do
    begin
      e:=vs.Lookup(Self[i]);
      if e<0 then begin
        vs.Splice(e+1,0,[Self[i]]);
        a.Splice(e+1,0,[1]);
        if r<1 then r:=1;
      end else
        begin
          a[e]:=a[e]+1;
          if r<a[e] then r:=e
        end;
    end;
  result:=vs[r]
end;

function TFloatArrayHelper.Median(): Float;
var C:integer;a:TFloatDynArray;
begin
  a:=Self.Sorted;
  C:=Count div 2;
  if count mod 2=0 then
    result:=(a[c-1]+a[c])/2
  else
    result:= a[c];
end;

//function cpow(const base,exponent:complex):complex;inline;
//begin
//  result:= cexp(cln(base)*exponent);
//end;

function TFloatArrayHelper.Interleave():TFloatArrayArray;
var i,C,Columns:integer;
begin
  Columns:=Count shr 1;//system.trunc(C/2);
  C:=Columns shl 1;
  setLength(result,2);
  setLength(result[0],Columns);
  setLength(result[1],Columns);
  //setLength(result,2,Columns);

  {$if defined(USE_AVX2) and (Float=Single)}
   interleave_s(pSingle(result[0]),pSingle(result[1]),pSingle(self),c);
  {$elseif defined(USE_AVX2) and (Float=Double)}
   interleave_d(pDouble(result[0]),pDouble(result[1]),pdouble(self),c);
  {$else}
  i:=0;
  while i<Columns do begin
    result[0,i]:=Self[i shl 1];
    result[1,i]:=Self[1+i shl 1];
    inc(i);
  end;
  {$endif}
end;

(*
{$ifndef _fft}
{$define _fft}

procedure _dft(const dst:{$ifdef fpc}specialize{$endif}TComplex<Float>._Complex;const a:PFloat;const plan: TComplexArray; N:integer;const l:integer=0);
var j,k:integer;
begin
  for k:=0 to N-1 do
    {$if defined(USE_AVX2) and (SizeOf(Complex)=8)}
    bulkDot_cvs(@dst[k],@a[0],@plan[k*n],N);
    {.$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
    {$else}
    with dst[k] do begin
      dst[k]:=0;
      for j:=0 to N-1 do begin
        re:=re+a[j]*plan[k*N+j].re;
        im:=im+a[j]*plan[k*N+j].im
        //dst[k].add(plan[k*N+j]*a[j])
      end;
    end;
    {$endif}
  //{$endif}

end;

procedure _fft(const dst:{$ifdef fpc}specialize{$endif}TComplex<Float>._Complex;const a:PFloat;const plan: PPComplex; N:integer;const l:integer=0);
var i,j:integer;
  FFTButterf: array[0..32*1024-1] of Float;
  FFTTwid,FFTTmp: array[0..32*1024-1] of {$ifdef fpc}specialize{$endif}TComplex<Float>;
begin
  if n<=DFTThreshold then
    _dft(dst,a,DFTThresholdPlan,N,l)
  else begin
    n:=N shr 1;

    i:=0;
    while i<N do begin
      FFTButterf[i]:=a[i*2];
      FFTButterf[N+i]:=a[i*2+1];
      inc(i);
    end;

    _fft(@FFTTmp[0],@FFTButterf[0],Plan,n,l+1);
    _fft(@dst[n],@FFTButterf[N],Plan,n,l+1);


    {$if defined(USE_AVX2) and (Float=Single)}
    bulkMul_ccs(@FFTTwid[0],@Plan[l][0],@dst[n],n);
    bulkAdd_ccs(@dst[0],@FFTTmp[0],@FFTTwid[0],n);
    bulkSub_ccs(@dst[n],@FFTTmp[0],@FFTTwid[0],n);
    {$elseif defined(USE_AVX2) and (Float=Double)}
    bulkMul_ccd(@FFTTwid[0],@Plan[l][0],@dst[n],n);
    bulkAdd_ccd(@dst[0],@FFTTmp[0],@FFTTwid[0],n);
    bulkSub_ccd(@dst[n],@FFTTmp[0],@FFTTwid[0],n);
    {$else}

    Move(Plan[l][0],FFTTwid[0],SizeOf(Float)*n*4);
    for j:=0 to n-1 do
      //FFTTwid[j]:=Plan[l][j]*dst[n+j];
      FFTTwid[j].mul(dst[n+j]);
    for j:=0 to n-1 do
      begin
        dst[j]  :=FFTTmp[j]; dst[j].add(FFTTwid[j]);
        dst[n+j]:=FFTTmp[j];dst[n+j].sub(FFTTwid[j]);
      end;
    {$endif}
  end;
end;
{$endif}
*)

function TFloatArrayHelper.fft(const plan: TComplexArrayArray;const l:integer=0): TComplexArray;
var n,j:integer;theta:Float;w,wn,twid:Complex;twidAr,Ye,Yo:TComplexArray;
  P:TFloatArrayArray(*{$if SizeOf(Complex)=8}TComplexArrayArrayF
  {$elseif SizeOf(Complex)=16}TComplexArrayArrayD
  {$else}array of TComplexArray{$endif}*);
begin
  {$if Float=Single}
  setLength(result,Length(Self));
  //_fftct(@result[0],@self[0],@plan[0],Count);   // cooley tukey method
  _fft(@result[0],@self[0],@plan[0],Count,l); // divide and conquer methode
  {$else}
  n:=count;// n must be a power of 2;  (radix 2 FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  //if n=1 then result:=[Complex(Self[0])]
  if n<=DFTThreshold then
    result:=dft({$if SizeOf(Float)=4}DFTThresholdPlanF{$elseif SizeOf(Float)=8}DFTThresholdPlanD{$endif})
  else begin
    setLength(result,N);
    //w:=(-PIx2*i_/N);w.exp;
    //theta:=PIx2/N;
    //w.re:=system.cos(theta);
    //w.im:=system.sin(theta);
    P:=interleave;
    n:=N shr 1;
    //setLength(p[0],N);
    //setLength(p[1],N);
    //setLength(twidAr,n);
    //for j:=0 to n-1 do begin
    //  twidAr[j]:=w;
    //  twidAr[j].pow(j)
    //end;
    Ye:=p[0].fft(Plan,l+1);
    Yo:=p[1].fft(Plan,l+1);
    TwidAr:=Copy(Plan[l]);
    TwidAr.mul(Yo);
    {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
    bulkAdd_ccs(@result[0],PSingle(Ye),PSingle(TwidAr),n);
    bulkSub_ccs(@result[n],PSingle(Ye),PSingle(TwidAr),n);
    {$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
    bulkAdd_ccd(@result[0],PDouble(Ye),PDouble(TwidAr),n);
    bulkSub_ccd(@result[n],PDouble(Ye),PDouble(TwidAr),n);
    {$else}
    for j:=0 to n-1 do
      begin
        result[j]:=Ye[j]  ;result[j].add(twidAr[j]);
        result[j+n]:=Ye[j];result[j+n].sub(twidAr[j]);
      end;
    {$endif}
  end;
  {$endif}
end;

function TFloatArrayHelper.fft():TComplexArray;
var
  n,j:integer;theta:Float;w,wn,twid:complex;P:TFloatArrayArray;
  Ye,Yo:TComplexArray;
begin
  n:=count;// n must be a power of 2;  (implements radix 2 DIT FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');                   //  1+2/2  3+4/2     1+2+3+4/2
  if n<=DFTThreshold then
    result:=dft({$if Float=Single}DFTThresholdPlanF{$elseif Float=Double}DFTThresholdPlanD{$endif})
  else begin
    setLength(result,n);
    //w:=ucomplex.cexp(i_*2*PI/n); => w:=cos(2*PI/N) + i_*sin(2*PI/N)
    theta:=-PIx2/N;
    w.re:=system.cos(theta);
    w.im:=system.sin(theta);
    P:=interleave();
    n:=n shr 1;
    Ye:=p[0].fft();
    Yo:=p[1].fft();
    for j:=0 to n-1 do
      begin
{$ifdef fpc}
        twid:=(w**j)*Yo[j];
{$else}
        wn:=w;
        wn.pow(j);
        twid:=wn*Yo[j];
{$endif}
        result[j]:=Ye[j] +twid;
        result[j+n]:=Ye[j] -twid;
      end;
  end;
end;

function TFloatArrayHelper.ifft(const plan: TComplexArrayArray;const l:integer=0): TComplexArray;
var n,j:integer;theta:Float;w,wn,twidAr:TComplexArray;Ye,Yo:TComplexArray;
  P:TFloatArrayArray(*{$if SizeOf(Complex)=8}TComplexArrayArrayF
  {$elseif SizeOf(Complex)=16}TComplexArrayArrayD
  {$else}array of TComplexArray{$endif}*);
begin
  N:=count;// n must be a power of 2;  (radix 2 FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  setLength(result,n);
  if n=1 then result[0].re:=Self[0] else begin
    //w:=ucomplex.cexp(i_*2*PI/n);
    //theta:=PIx2/N;
    //w.re:=system.cos(theta);
    //w.im:=system.sin(theta);
    P:=interleave;
    n:=N shr 1;
    TwidAr:=Copy(Plan[l]);
{$ifdef fpc}
    Ye:=p[0].ifft(Plan,l+1);
    Yo:=p[1].ifft(Plan,l+1);
{$else}
    Ye:=(p[0]).ifft(Plan,l+1);
    Yo:=(p[1]).ifft(Plan,l+1);
{$endif}
    TwidAr.mul(Yo);
{$if defined(USE_AVX2) and (SizeOf(Float)=4)}
    bulkAdd_ccs(@result[0],PSingle(Ye),PSingle(TwidAr),n);
    bulkSub_ccs(@result[n],PSingle(Ye),PSingle(TwidAr),n);
{$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
    bulkAdd_ccd(@result[0],PDouble(Ye),PDouble(TwidAr),n);
    bulkSub_ccd(@result[n],PDouble(Ye),PDouble(TwidAr),n);
{$else}
    for j:=0 to n-1 do
      begin
        result[j]:=Ye[j]  ;result[j].add(twidAr[j]);
        result[j+n]:=Ye[j];result[j+n].sub(twidAr[j]);
      end;
{$endif}
  end;
end;

function TFloatArrayHelper.ifft():TComplexArray;
var
  n,j:integer;theta:Float;w,twid:complexArray.complex;P:TFloatArrayArray;
  Ye,Yo:TComplexArray;
begin
  N:=count;// n must be a power of 2;
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  setLength(result,n);
  if n=1 then result[0].re:=Self[0] else begin
    theta:=-PIx2/N;
    //ucomplex.cexp(-2*i*PI/N)/N;
    w.re:=system.cos(theta)/N;
    w.im:=system.sin(theta)/N;
    n:=n shr 1;
    P:=interleave;
    Ye:=p[0].ifft();
    Yo:=p[1].ifft();
    for j:=0 to N-1 do
      begin
        twid:=(w**j)*Yo[j];
        result[j]:=Ye[j] +twid;
        result[j+n]:=Ye[j] -twid;
      end;
  end;
end;

function TFloatArrayHelper.dft():TComplexArray;
var k,N,j:integer;si,co:Float;twid:complex;
begin
  N:=Count;
  setLength(result,n);
  for k:=0 to N-1 do with result[k] do begin
//    re:=0;im:=0;
    for j:=0 to N-1 do begin
      SinCos(PIx2*k*j/N,si,co);
      re:=re+self[j]*co;
      im:=im-self[j]*si;
      //twid:=-PIx2*k*j*i_/N;twid.exp;
      //result[k]:=result[k]+self[j]*twid
    end;
  end;
end;

function TFloatArrayHelper.dft(const Plan:TComplexArray):TComplexArray;
var k,N,j:integer;si,co:Float;twid:complex;
begin
  N:=Count;
  setLength(result,n);
  //{$if defined(USE_GPU)}
  //OpenCl.SetParamElementSizes([2,1,2]);
  //OpenCL.CallKernel(0,@result[0],@self[0],@plan[0],0.0,N);
  //{$else}
  for k:=0 to N-1 do
    {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
    bulkDot_cvs(@result[k],@self[0],@plan[k*n],N);
    {.$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
    {$else}
    with result[k] do begin
      for j:=0 to N-1 do begin
        re:=re+self[j]*plan[k*N+j].re;
        im:=im+self[j]*plan[k*N+j].im
      //result[k].add(self[j]*plan[k][j])
      end;
    end;
    {$endif}
  //{$endif}

end;

function TFloatArrayHelper.Variance: Float;
begin
  //{$if defined(USE_AVX2) and (Float=Single)}
  //{$elseif defined(USE_AVX2) and (Float=Double)}
  //{$else}
  result:=Math.Variance(Self);
  //{$endif}

end;

function TFloatArrayHelper.Covariance(const Vals:TFloatDynArray):Float;
var i:integer;uSelf,uVals:Float;
begin
  //cov(X,Y)=E[(X - E[X])   (Y - E[Y])]
  result:=0;
  uSelf:=Self.Mean();uVals:=vals.Mean();
  for i:=0 to High(Self) do
      result:=result+(Self[i]-uSelf)*(Vals[i]-uVals);
  result:=result/Length(Self)
end;

function TFloatArrayHelper.Correlation(const vals:TFloatDynArray):Float;
begin
  Result:=Self.Covariance(Vals)/(Self.StdDev()*Vals.StdDev());
end;

function TFloatArrayHelper.SqrDiff(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to high(Result) do
    result[i]:=System.Sqr(Self[i]-Vals[i])
end;

function TFloatArrayHelper.SqrDiff(const Val:Float):TFloatDynArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to high(Result) do
    result[i]:=System.Sqr(Self[i]-Val)
end;

function TFloatArrayHelper.StdDev: Float;
begin
  Result:=Math.StdDev(Self);
end;

procedure TFloatArrayHelper.MinMax(out mi:Float;out ma:Float);
var i,C:integer;
begin
  mi:=Self[0];
  ma:=Self[0];
  C:=High(Self);
  for i:=1 to C do begin
    if Self[i]>Ma then Ma:=Self[i];
    if Self[i]<Mi then Mi:=Self[i]
  end
end;

function TFloatArrayHelper.Push(v: Float): Float; _PUSH_;

function TFloatArrayHelper.Pop(): Float; _POP_;

function TFloatArrayHelper.UnShift(v: Float): Float;_UNSHIFT_;

function TFloatArrayHelper.Shift(): Float; _SHIFT_;

function TFloatArrayHelper.Slice(start, _end: integer): TFloatDynArray; _SLICE_;

function TFloatArrayHelper.Splice(start, deleteCount: integer; Items: TFloatDynArray): TFloatDynArray; _SPLICE_;

function TFloatArrayHelper.Extract(const Indecies: TIntegerDynArray): TFloatDynArray; _EXTRACT_;

procedure TFloatArrayHelper.Scatter(const indecies:TIntegerDynArray;const Values:TFloatDynArray);   _SCATTER_;

function TFloatArrayHelper.Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<Float>):TIntegerDynArray; _FIND_;

function TFloatArrayHelper.Find(const values:TFloatDynArray):TIntegerDynArray;    _FINDVALS1_;

function TFloatArrayHelper.Find(const value:Float):TIntegerDynArray;              _FINDVALS2_;

function TFloatArrayHelper.Intersect(const Other:TFloatDynArray;const binSearch:boolean):TFloatDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Intersect<Float>(Self,Other,binSearch);
end;

function TFloatArrayHelper.Difference(const Other:TFloatDynArray;const binSearch:boolean):TFloatDynArray;
begin
  result:={$ifdef fpc}specialize{$endif} Difference<Float>(Self,Other,binSearch);
end;

function TFloatArrayHelper.concat(Items: TFloatDynArray): TFloatDynArray; _CONCAT_;

function TFloatArrayHelper.reverse():TFloatDynArray; _REVERSE_;

function TFloatArrayHelper.Round():TIntegerDynArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to Self.Count-1 do
    result[i]:=System.round(Self[i]);
end;

function TFloatArrayHelper.Frac():TFloatDynArray;
var i:integer;
begin
  setLength(Result,Self.Count);
  for i:=0 to Self.Count-1 do
    result[i]:=System.Frac(Self[i]);
end;

function TFloatArrayHelper.Trunc():TIntegerDynArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to Self.Count-1 do
    result[i]:=System.Trunc(Self[i]);
end;

function TFloatArrayHelper.Floor():TIntegerDynArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to Self.Count-1 do
    result[i]:=Math.Floor(Self[i]);
end;

function TFloatArrayHelper.Ceil():TIntegerDynArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to Self.Count-1 do
    result[i]:=Math.Ceil(Self[i]);
end;

function TFloatArrayHelper.Sqr():TFloatDynArray;
var i:integer;
begin
  setLength(result,Count);
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSqr_s(@result[0],@Self[0],Length(Self))
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSqr_d(@result[0],@Self[0],Length(Self))
  {$else}
  for i:=0 to Self.Count-1 do
    result[i]:=System.Sqr(Self[i])
  {$endif}
end;

function TFloatArrayHelper.Sqrt():TFloatDynArray;
var i:integer;
begin
  setLength(result,Count);
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSqrt_s(@result[0],@Self[0],Length(Self))
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSqrt_d(@result[0],@Self[0],Length(Self))
  {$else}
  for i:=0 to Self.Count-1 do
    result[i]:=System.Sqrt(Self[i]);
  {$endif}
end;

class procedure TFloatArrayHelper.Sqr(const src, Result:PFloat;const N:integer );
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSqr_s(result,src,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSqr_d(result,src,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=System.Sqr(src[i])
  {$endif}
end;

class procedure TFloatArrayHelper.Sqrt(const src, result:PFloat;const N:integer );
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSqrt_s(result,src,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSqrt_d(result,src,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=System.Sqrt(src[i])
  {$endif}
end;


function TFloatArrayHelper.Normalize(const AMax:Float;const AMin:Float):TFloatDynArray;
var vMax,vMin:Float;
begin
  vMax:=Self.Max();vMin:=Self.Min();
  if (vMax-vMin)<>(AMax-AMin) then
    result:=Self.Mul(AMax-AMin);

  if vMin<>AMin then
    result:=Self.Add(AMin);

end;

function TFloatArrayHelper.ToString(const Seperator: string;const digits:shortint): string;
var i:integer;
begin
  Result:='';
  if digits>-1 then for i:=0 to Count-1 do
    Result:=Result+Seperator+Format('%.'+digits.ToString()+'f',[Self[i]])
  else
    for i:=0 to Count-1 do
      Result:=Result+Seperator+Self[i].ToString;
  if Count>0 then delete(result,1,length(Seperator));
  result:='['+result+']';
end ;

function TFloatArrayHelper.ToStringArray():TStringArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to High(Self) do
    result[i]:=FloatToStr(Self[i])
end;


function TFloatArrayHelper.Add(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),'ADD: Array size must match');
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkAdd_s(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkAdd_d(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] + Vals[i];
  {$endif}
end;

function TFloatArrayHelper.Add(const Vals:Float):TFloatDynArray;
var i:integer;
begin
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkAdd_ss(@Self[0],@Self[0],@Vals,Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkAdd_sd(@Self[0],@Self[0],@Vals,Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] + Vals;
  {$endif}
end;

function TFloatArrayHelper.Sub(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),'SUB: Array size must match');
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSub_s(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSub_d(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] - Vals[i];
  {$endif}
end;

function TFloatArrayHelper.Sub( Vals:Float):TFloatDynArray;
var i:integer;
begin
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  vals:=-vals;
  bulkAdd_ss(@Self[0],@Self[0],@Vals,Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  vals:=-vals;
  bulkAdd_sd(@Self[0],@Self[0],@Vals,Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] - Vals;
  {$endif}
end;

function TFloatArrayHelper.Mul(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),format('MUL: Array size must match %d<>%d',[Length(Self),Length(Vals)]));
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkMul_s(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkMul_d(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] * Vals[i];
  {$endif}
end;

function TFloatArrayHelper.Mul(const Vals:Float):TFloatDynArray;
var i:integer;
begin
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkMul_ss(@Self[0],@Self[0],@Vals,Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkMul_sd(@Self[0],@Self[0],@Vals,Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] * Vals;
  {$endif}
end;

function TFloatArrayHelper.&Div(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),'DIV: Array size must match');
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkDiv_s(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkDiv_d(@Self[0],@Self[0],@Vals[0],Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] / Vals[i];
  {$endif}
end;

function TFloatArrayHelper.&Div( Vals:Float):TFloatDynArray;
var i:integer;
begin
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  vals:=1/vals;
  bulkMul_ss(@Self[0],@Self[0],@Vals,Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  vals:=1/vals;
  bulkMul_sd(@Self[0],@Self[0],@Vals,Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Self[i] / Vals;
  {$endif}
end;

function TFloatArrayHelper.SubstractFrom(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),'SubFrom: Array size must match');
  Result:=Self;
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSub_s(@Self[0],@Vals[0],@Self[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSub_d(@Self[0],@Vals[0],@Self[0],Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Vals[i] - Self[i];
  {$endif}
end;

function TFloatArrayHelper.SubstractFrom(const Vals:Float):TFloatDynArray;
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSub_ss(@Self[0],@Self[0],@Vals,Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSub_sd(@Self[0],@Self[0],@Vals,Length(Self));
  {$else}
  for i:=0 to Self.Count-1 do
    Self[i]:=Vals - Self[i];
  {$endif}
  Result:=Self;
end;

function TFloatArrayHelper.DividedBy(const Vals:TFloatDynArray):TFloatDynArray;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),'DivBy: Array size must match');
  for i:=0 to Self.Count-1 do
    Self[i]:=Vals[i] / Self[i];
  Result:=Self;
end;

function TFloatArrayHelper.DividedBy(const Vals:Float):TFloatDynArray;
var i:integer;
begin
  Result:=Self;
  for i:=0 to Self.Count-1 do
    Self[i]:=Vals - Self[i];
end;

function TFloatArrayHelper.Dot(const Vals:TFloatDynArray):Float;
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  result:=bulkDot_s(@Self[0],@Vals[0],Length(Self));
  {$elseif defined(USE_AVX2) and (Float=Double)}
  result:=bulkDot_d(@Self[0],@Vals[0],Length(Self));
  {$else}
  result:=0;
  for i:=0 to High(Vals) do
    result+=Vals[i]*Self[i]
//  result:=copy(Self).Mul(vals).sum;
  {$endif}
end;

function TFloatArrayHelper.Conj():TFloatDynArray;    //Dummy Function for matrix Inverse compatability
begin
  result:=self
end;

class procedure TFloatArrayHelper.Conj(const result:PFloat;const N:integer ;const Self:PFloat);    //Dummy Function for matrix Inverse compatability
begin
  if result<>Self then
    move(Self^,Result^,N*SizeOf(Float))
end;

class function TFloatArrayHelper.Dot( a,b:PFloat;const N:integer {$ifndef USE_AVX2};const Stride:integer{$endif}):Float;
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  { TODO : Add Stride here for SIMD instructions  }
  result:=bulkDot_s(a,b,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  result:=bulkDot_d(a,b,N);
  {$else}
  result:=0;i:=0;
  while i < N do begin
    {$ifdef fpc}
    result:=result+a[i]*b[i];
    {$else}
    result:=result+a^*b^;
    inc(a,stride);
    inc(b,stride);
    {$endif}
    inc(i,stride);
  end;
  {$endif}
end;

function TFloatArrayHelper.CrossEntropy(const Vals:TFloatDynArray):Float;
var i:integer;
begin
  //{$if defined(USE_AVX2) and (Float=Single)}
  //result:=bulkCrossE2_s(@Self[0],@Vals[0],Length(Self));
  //{$elseif defined(USE_AVX2) and (Float=Double)}
  //result:=bulkCrossE2_d(@Self[0],@Vals[0],Length(Self));
  //{$else}
  result:=0;
  for i:=0 to High(Vals) do
    if Self[i]=1 then
      result:=result-Self[i]*System.Ln(Vals[i])
    else
      result:=result-System.ln(1-Vals[i]);
  //{$endif}
end;

//  ===========

class procedure TFloatArrayHelper.Add(const result:PFloat ;const N:integer;const Self,Vals:PFloat);
var i:integer;
begin
  //Assert(Length(Self)=Length(Vals),'ADD: Array size must match');
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkAdd_s(result,Self,Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkAdd_d(result,Self,Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] + Vals[i];
  {$endif}
end;

class procedure TFloatArrayHelper.Add(const result:PFloat ;const N:integer;const Self:PFloat;const Vals:Float);
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkAdd_ss(result,Self,@Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkAdd_sd(result,Self,@Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] + Vals;
  {$endif}
end;

class procedure TFloatArrayHelper.Sub(const result:PFloat ;const N:integer;const Self,Vals:PFloat);
var i:integer;
begin
  //Assert(Length(Self)=Length(Vals),'SUB: Array size must match');
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSub_s(result,Self,Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSub_d(result,Self,Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] - Vals[i];
  {$endif}
end;

class procedure TFloatArrayHelper.Sub(const result:PFloat ;const N:integer;const Self:PFloat; Vals:Float);
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  vals:=-vals;
  bulkAdd_ss(result,Self,@Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  vals:=-vals;
  bulkAdd_sd(result,Self,@Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] - Vals;
  {$endif}
end;

class procedure TFloatArrayHelper.Mul(const result:PFloat ;const N:integer;const Self,Vals:PFloat);
var i:integer;
begin
  //Assert(Length(Self)=Length(Vals),'MUL: Array size must match');
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkMul_s(result,Self,Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkMul_d(result,Self,Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] * Vals[i];
  {$endif}
end;

class procedure TFloatArrayHelper.Mul(const result:PFloat ;const N:integer;const Self:PFloat;const Vals:Float);
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkMul_ss(result,Self,@Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkMul_sd(result,Self,@Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] * Vals;
  {$endif}
end;

class procedure TFloatArrayHelper.&Div(const result:PFloat ;const N:integer;const Self,Vals:PFloat);
var i:integer;
begin
  //Assert(Length(Self)=Length(Vals),'DIV: Array size must match');
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkDiv_s(result,Self,Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkDiv_d(result,Self,Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] / Vals[i];
  {$endif}
end;

class procedure TFloatArrayHelper.&Div(const result:PFloat ;const N:integer;const Self:PFloat; Vals:Float);
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  vals:=1/vals;
  bulkMul_ss(result,Self,@Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  vals:=1/vals;
  bulkMul_sd(result,Self,@Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Self[i] / Vals;
  {$endif}
end;

class procedure TFloatArrayHelper.SubstractFrom(const result:PFloat ;const N:integer;const Self,Vals:PFloat);
var i:integer;
begin
  //Assert(Length(Self)=Length(Vals),'SubFrom: Array size must match');
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSub_s(result,Vals,Self,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSub_d(result,Vals,Self,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Vals[i] - Self[i];
  {$endif}
end;

class procedure TFloatArrayHelper.SubstractFrom(const result:PFloat ;const N:integer;const Self:PFloat;const Vals:Float);
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkSub_ss(result,Self,@Vals,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkSub_sd(result,Self,@Vals,N);
  {$else}
  for i:=0 to N-1 do
    result[i]:=Vals - Self[i];
  {$endif}
end;

class procedure TFloatArrayHelper.DividedBy(const result:PFloat ;const N:integer;const Self,Vals:PFloat);
var i:integer;
begin
  //Assert(Length(Self)=Length(Vals),'DivBy: Array size must match');
  for i:=0 to N-1 do
    result[i]:=Vals[i] / Self[i];
end;

class procedure TFloatArrayHelper.DividedBy(const result:PFloat ;const N:integer;const Self:PFloat;const Vals:Float);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Vals / Self[i];
end;

class function TFloatArrayHelper.FromIntegers(const Integers:TIntegerDynarray):TFloatDynarray;
var i:integer;
begin
  SetLength(result,Length(Integers));
  for i:=0 to High(Integers) do Result[i]:=Integers[i]
end;

class function TFloatArrayHelper.FromIntegers(const Integers:TInt64Dynarray):TFloatDynarray;
var i:integer;
begin
  SetLength(result,Length(Integers));
  for i:=0 to High(Integers) do Result[i]:=Integers[i]
end;

class function TFloatArrayHelper.FromIntegers(const Integers:TByteDynarray):TFloatDynarray;
var i:integer;
begin
  SetLength(result,Length(Integers));
  for i:=0 to High(Integers) do Result[i]:=Integers[i]
end;

class function TFloatArrayHelper.FromIntegers(const Integers:TWordDynarray):TFloatDynarray;
var i:integer;
begin
  SetLength(result,Length(Integers));
  for i:=0 to High(Integers) do Result[i]:=Integers[i]
end;

class function TFloatArrayHelper.FromIntegers(const Integers:TLongWordDynArray):TFloatDynarray;
var i:integer;
begin
  SetLength(result,Length(Integers));
  for i:=0 to High(Integers) do Result[i]:=Integers[i]
end;

class procedure TFloatArrayHelper.Gather(const dst,Self:PFloat;const Stride, N:integer);
var i:integer;
begin
  {$if defined(USE_AVX2) and (Float=Single)}
  bulkGathera_s(dst,Self,Stride,N);
  {$elseif defined(USE_AVX2) and (Float=Double)}
  bulkGathera_d(dst,Self,Stride,N);
  {$else}
  for i:=0 to N-1 do
    dst[i]:=Self[i*Stride]
  {$endif}
end;

class procedure TFloatArrayHelper.gemm( const TA,  TB,  M,  N,  K:integer; const ALPHA:Float;
      const A:PFloat  ; const lda:integer;
      const B:PFloat  ; const ldb:integer;
      const BETA:Float;
      const C: PFloat ; const ldc:integer);
var i,j:integer;
begin
    for i := 0 to M-1 do
    {$if defined(USE_AVX2) and (Float=Single)}
        bulkMul_ss(@C[i*ldc],@C[i*ldc],@BETA,N);
    {$elseif defined(USE_AVX2) and (Float=Double)}
        bulkMul_sd(@C[i*ldc],@C[i*ldc],@BETA,N);
    {$else}
        for j := 0 to N-1 do
            C[i*ldc + j] := C[i*ldc + j]*BETA;
    {$endif}
    if not boolean(TA) and  not boolean(TB) then
        gemm_nn(M, N, K, ALPHA,A,lda, B, ldb,C,ldc)
    else if boolean(TA) and not boolean(TB) then
        gemm_tn(M, N, K, ALPHA,A,lda, B, ldb,C,ldc)
    else if not boolean(TA) and boolean(TB) then
        gemm_nt(M, N, K, ALPHA,A,lda, B, ldb,C,ldc)
    else
        gemm_tt(M, N, K, ALPHA,A,lda, B, ldb,C,ldc)
end;

class procedure TFloatArrayHelper.gemm_nn(const M, N, K:integer; const ALPHA:Float;
        const A:PFloat; const lda:integer;
        const B:PFloat; const ldb:integer;
        const C:PFloat; const ldc:integer);
var A_PART:Float;i,j,kk:integer;

//procedure axpy(const s:Float; const b,c:PFloat;const N:integer); inline;
//var m:integer;
//begin
//  for m:=0 to n-1 do
//    c[m]:=s*b[m] + c[m]
//end;

begin
///    #pragma omp parallel for
    //writeln(format('ldb*K+N = [%d], M*lda+K=[%d], A=[%d], B=[%d], C=[%d]',[ldb*K+N,ldb*K+N,TSingles(A).Count,TSingles(C).Count,TSingles(C).Count]));
  {$ifdef USE_MKL}
    {$if Float=Single}
      cblas_sgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$elseif Float=Double}
      cblas_dgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$endif}
  {$else}
    for i := 0 to M-1 do begin
        for kk := 0 to K-1 do begin
            A_PART := ALPHA*A[i*lda+kk];
            {$if defined(USE_AVX2) and (Float=Single)}
            bulkAXPY_s(@C[i*ldc],@B[kk*ldb],@C[i*ldc],N,@A_PART);
            {$elseif defined(USE_AVX2) and (Float=Double)}
            bulkAXPY_d(@C[i*ldc],@B[kk*ldb],@C[i*ldc],N,@A_PART);
            {$else}
            for j := 0 to N-1 do
                C[i*ldc+j] := A_PART*B[kk*ldb+j] + C[i*ldc+j];
            {$endif}
        end;
    end
    {$endif}
end;

class procedure TFloatArrayHelper.gemm_nt(const M, N, K:integer ; const ALPHA:Float;
        const A:PFloat;  const lda:integer;
        const B:PFloat;  const ldb:integer;
        const C:PFloat;  const ldc:integer)  ;
var i,j,l:integer;sm:Float;
begin
  {$ifdef USE_MKL}
    {$if Float=Single}
      cblas_sgemm(CblasRowMajor,CblasNoTrans,CblasTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$elseif Float=Double}
      cblas_dgemm(CblasRowMajor,CblasNoTrans,CblasTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$endif}
  {$else}
    for i := 0 to M-1 do begin
        for j := 0 to N-1 do begin
            {$if defined(USE_AVX2) and (Float=Single)}
            sm:=bulkDot_s( @A[i*lda], @B[j*ldb], K);
            {$elseif defined(USE_AVX2) and (Float=Double)}
            sm:=bulkDot_d( @A[i*lda], @B[j*ldb], K);
            {$else}
            sm := 0;
            for l := 0 to K-1 do
                sm += A[i*lda+l]*B[j*ldb + l];
            {$endif}
            C[i*ldc+j] += ALPHA*sm;
        end
    end
  {$endif}
end;

class procedure TFloatArrayHelper.gemm_tn(const M, N, K:integer ; const ALPHA:Float;
        const A:PFloat;  const lda:integer;
        const B:PFloat;  const ldb:integer;
        const C:PFloat;  const ldc:integer)  ;
var A_PART:Float;i,j,kk:integer;
begin
    //#pragma omp parallel for
  {$ifdef USE_MKL}
    {$if Float=Single}
      cblas_sgemm(CblasRowMajor,CblasTrans,CblasNoTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$elseif Float=Double}
      cblas_dgemm(CblasRowMajor,CblasTrans,CblasNoTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$endif}
  {$else}
    for i := 0 to M-1 do begin
        for kk := 0 to K-1 do begin
            A_PART := ALPHA*A[kk*lda+i];
            {$if defined(USE_AVX2) and (Float=Single)}
            bulkAXPY_s(@C[i*ldc],@B[kk*ldb],@C[i*ldc],N,@A_PART);
            {$elseif defined(USE_AVX2) and (Float=Double)}
            bulkAXPY_d(@C[i*ldc],@B[kk*ldb],@C[i*ldc],N,@A_PART);
            {$else}
            for j := 0 to N-1 do
                C[i*ldc+j] += A_PART*B[kk*ldb+j];
            {$endif}
        end
    end
  {$endif}
end;

class procedure TFloatArrayHelper.gemm_tt(const M, N, K:integer ; const ALPHA:Float;
        const A:PFloat;  const lda:integer;
        const B:PFloat;  const ldb:integer;
        const C:PFloat;  const ldc:integer) ;
var sm:Float;i,j,l:integer;
begin
    //#pragma omp parallel for
  {$ifdef USE_MKL}
    {$if Float=Single}
      cblas_sgemm(CblasRowMajor,CblasTrans,CblasTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$elseif Float=Double}
      cblas_dgemm(CblasRowMajor,CblasTrans,CblasTrans,M,N,K,alpha,A,lda,B,ldb,0,C,ldc);
    {$endif}
  {$else}
    for i := 0 to M-1 do begin
        for j := 0 to N-1 do begin
            {$if defined(USE_AVX2) and (Float=Single)}
            sm:=bulkDot_s(@B[j*ldb],@A[i],lda,K);
            {$elseif defined(USE_AVX2) and (Float=Double)}
            sm:=bulkDot_d(@B[j*ldb],@A[i],lda,K);
            {$else}
            sm := 0;
            for l := 0 to K-1 do
                sm += A[l*lda+i]*B[j*ldb+l];
            {$endif}
            C[i*ldc+j] += ALPHA*sm;
        end
    end
  {$endif}
end ;

function TFloatArrayHelper.ToSingles():TSingleDynArray;
var i:integer;
begin
  SetLength(result,Count);
  for i:=0 to High(Self) do result[i]:=Self[i]
end;

function TFloatArrayHelper.ToDoubles():TDoubleDynArray;
var i:integer;
begin
  SetLength(result,Count);
  for i:=0 to High(Self) do result[i]:=Self[i]
end;

function TFloatArrayHelper.Transpose(const Width:integer; Height:integer):TFloatDynArray;
var x,y:integer;
begin
  setLength(Result,Length(Self));
  if Height<1 then Height:=Length(Self) div width;
  for y:=0 to Height-1 do
    for x:=0 to Width-1 do
      result[x*width+y]:=self[y*width+x]
end;

class function TFloatArrayHelper.Every(const dst:PFloat; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Float,PFloat>):boolean;  _EVERY_;

class function TFloatArrayHelper.Some(const dst:PFloat; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Float,PFloat>):boolean;   _SOME_;


{ TFloatArrayArrayHelper }

function TFloatArrayArrayHelper.GetCount: integer; _DOCOUNT_;

procedure TFloatArrayArrayHelper.SetCount(AValue: integer); _SETCOUNT_;

function TFloatArrayArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TRecudeCallback<TFloatDynArray>; const init: TFloatDynArray): TFloatDynArray;_REDUCE_;

function TFloatArrayArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TFloatDynArray>): TFloatDynArray;_SIMPLEREDUCE_;

function TFloatArrayArrayHelper.Sort(CompareFunc: {$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray>):TFloatArrayArray;_DOSORT_;

function TFloatArrayArrayHelper.Sorted(CompareFunc: {$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray>): TFloatArrayArray;_SORTED_;

function TFloatArrayArrayHelper.Lookup(const val:TFloatDynArray):integer;
begin
  // assuming that the array is sorted
  result:={$ifdef fpc}specialize{$endif} _BinSearch<TFloatDynArray,PFloatDynArray>(@Self[0],Val,Length(Self),{$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray>(@Self.cmp));
end;

function TFloatArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<TFloatDynArray>): TFloatArrayArray; _DOMAP_;

function TFloatArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<TFloatDynArray>): TFloatArrayArray;_SIMPLEMAP_;

function TFloatArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallbackNested<TFloatDynArray>): TFloatArrayArray;_SIMPLEMAP_;

function TFloatArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<TFloatDynArray>): TVariantArray;_DOMAP_;

function TFloatArrayArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<TFloatDynArray,PFloatDynArray>): TFloatArrayArray;_FILTER_;

//function TFloatArrayArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterFunc<TFloatDynArray>): TFloatArrayArray;_FILTER_;

class function TFloatArrayArrayHelper.uniqueFilt(const a:TFloatDynArray;const i:integer;arr:PFloatDynArray):boolean;
begin;
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;

function TFloatArrayArrayHelper.Transpose: TFloatArrayArray;_TRANSPOSE_;

function TFloatArrayArrayHelper.Push(v: TFloatDynArray): TFloatDynArray;_PUSH_;

function TFloatArrayArrayHelper.Pop(): TFloatDynArray;_POP_;

function TFloatArrayArrayHelper.UnShift(v: TFloatDynArray): TFloatDynArray;_UNSHIFT_;

function TFloatArrayArrayHelper.Shift(): TFloatDynArray; _SHIFT_;

function TFloatArrayArrayHelper.Slice(start, _end: integer): TFloatArrayArray; _SLICE_;

function TFloatArrayArrayHelper.Splice(start, deleteCount: integer; Items: TFloatArrayArray): TFloatArrayArray; _SPLICE_;

function TFloatArrayArrayHelper.concat(Items: TFloatArrayArray): TFloatArrayArray; _CONCAT_;

function TFloatArrayArrayHelper.ToString(const Seperator: string): string;
var i:integer;
begin
  result:='';
  for i:=0 to Count-1 do
    result:=Result+Seperator+#13#10+Self[i].ToString(Seperator) ;
  delete(result,1,Length(Seperator)+2);
  result:='['+result+']';
end;

class function TFloatArrayArrayHelper.cmp(const a, b: TFloatDynArray): integer;
var i:integer ;
begin
  for i:=0 to Min(high(a),high(b)) do begin
    result:=TFloatDynArray.cmp(a[i],b[i]);
    if result<>0 then exit;
  end;
  if Length(a)>Length(b) then result:=1
  else if Length(a)<Length(b) then result:=-1
  else result:=0;
end;

class function TFloatArrayArrayHelper.Every(const dst:PFloatDynArray; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<TFloatDynArray,PFloatDynArray>):boolean; _EVERY_;


class function TFloatArrayArrayHelper.Some(const dst:PFloatDynArray; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<TFloatDynArray,PFloatDynArray>):boolean;  _SOME_;


class procedure TFloatArrayArrayHelper.QuickSort(var Arr: TFloatArrayArray;const L, R: Longint; const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<TFloatDynArray>);
begin
 {$ifdef fpc}specialize{$endif} _QuickSort<TFloatDynArray,PFloatDynArray>(@Arr[0],L,R,Compare)
end;
{$ifdef fpc}
operator:=(const Arr:TFloatDynArray):string;
begin
    result:=Arr.toString
end;
operator:=(const Arr: TFloatArrayArray):string;
begin
    result:=Arr.toString
end;

operator+(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                       _AADD_;
operator+(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;                   _AADD_;
operator+(const Arr: TFloatDynArray    ;   const v: Float ): TFloatDynArray;      _ADD_ ;
operator+(const Arr: TFloatArrayArray  ;   const v: Float ): TFloatArrayArray;    _ADD_;
operator+(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;         _ADD_;
operator+(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;       _ADD_;


operator*(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                       _AMUL_;
operator*(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;                   _AMUL_;
operator*(const Arr: TFloatDynArray; const v: Float): TFloatDynArray;             _MUL_;
operator*(const Arr: TFloatArrayArray; const v: Float): TFloatArrayArray;         _MUL_;
operator*(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;         _MUL_;
operator*(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;       _MUL_;
operator/(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                       _ADIVIDE_;
operator/(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;                   _ADIVIDE_;
operator/(const Arr: TFloatDynArray; const v: Float): TFloatDynArray;             _DIVIDE1_;
operator/(const Arr: TFloatArrayArray; const v: Float): TFloatArrayArray;         _DIVIDE1_;
operator/(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;         _DIVIDE2_;
operator/(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;       _DIVIDE2_;
operator-(const Arr, Arr2: TFloatDynArray): TFloatDynArray;                       _ASUB_ ;
operator-(const Arr, Arr2: TFloatArrayArray): TFloatArrayArray;                   _ASUB_;
operator-(const Arr: TFloatDynArray; const v: Float): TFloatDynArray;             _SUB1_;
operator-(const Arr: TFloatArrayArray; const v: Float): TFloatArrayArray;         _SUB1_;
operator-(const v: Float ;const Arr: TFloatDynArray    ): TFloatDynArray;         _SUB2_;
operator-(const v: Float ;const Arr: TFloatArrayArray  ): TFloatArrayArray;       _SUB2_;
{$endif}

