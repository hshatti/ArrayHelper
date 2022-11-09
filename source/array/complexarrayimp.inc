
{ TComplexArrayHelper }

function TComplexArrayHelper.bins(const SampleTime:Float):TFloatDynArray;
var C,i:integer;
begin
  C:=Count;
  setLength(result,Trunc(C/2));
  for i:=1 to C do
      result[i-1]:=i/SampleTime;
end;

function TComplexArrayHelper.freq(const SampleRate:integer):TFloatDynArray;
var C,i:integer;dTime:Float;
begin
  C:=Count;
  setLength(result,Trunc(C/2));
  dTime:=C/SampleRate;
  for i:=1 to Length(result) do
      result[i-1]:=i/dTime;
end;

function TComplexArrayHelper.GetCount: integer;_DOCOUNT_;

procedure TComplexArrayHelper.SetCount(AValue: integer);_SETCOUNT_;

function cReal(const c:complex):Float;
begin
  result:=c.re;
end;

function cImag(const c:complex):Float;
begin
  result:=c.im;
end;

function TComplexArrayHelper.GetImaginary: TFloatDynArray;
var i:integer;
begin
  setLength(result,Length(Self));
  for i:=0 to High(Self) do
      result[i]:=Self[i].Im
  //result:=Map({$ifdef fpc}specialize{$endif} TSimpleMapCallbackComplex<Complex>({$ifdef fpc}@{$endif}cImag))
end;

function TComplexArrayHelper.GetReal: TFloatDynArray;
var i:integer;
begin
 setLength(result,Length(Self));
 for i:=0 to High(Self) do
     result[i]:=Self[i].Re
 //result:=Map({$ifdef fpc}specialize{$endif} TSimpleMapCallbackComplex<Complex>({$ifdef fpc}@{$endif}cReal))
end;

procedure TComplexArrayHelper.SetImaginary(AValue: TFloatDynArray);
var C,i:integer;
begin
  C:=High(Self);
  //Assert(High(Self)=High(AValue));
  for i:=0 to Min(C,High(AValue)) do
    Self[i].im:=AValue[i];
end;

procedure TComplexArrayHelper.SetReal(AValue: TFloatDynArray);
var C,i:integer;
begin
  C:=High(Self);
  //Assert(High(Self)=High(AValue));
  for i:=0 to Min(C,High(AValue)) do
    Self[i].re:=AValue[i];
end;

function TComplexArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<Complex,PComplex>
  ): TComplexArray; _FILTER_;

function TComplexArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TSimpleReduceCallback<
  Complex>): Complex; _SIMPLEREDUCE_;

function TComplexArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<complex>
  ): TComplexArray; _DOMAP_;

function TComplexArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<Complex>
  ): TComplexArray; _SIMPLEMAP_;

function TComplexArrayHelper.Map(func:{$ifdef fpc}specialize{$endif} TSimpleMapCallbackComplex<Complex>):TFloatDynArray;_SIMPLEMAP_;

function TComplexArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<Complex>
  ): TVariantArray; _DOMAP_;

function TComplexArrayHelper.Sort(const Descending:boolean; CompareFunc: TCompareFuncComplex): TComplexArray; _DOSORT_;
{ Sort by magnitute length}

function TComplexArrayHelper.Sorted(const Descending:boolean; CompareFunc: TCompareFuncComplex
  ): TComplexArray; _SORTED_;

function TComplexArrayHelper.Slice(start, _end: integer): TComplexArray; _SLICE_;

function TComplexArrayHelper.Splice(start, deleteCount: integer; Items: TComplexArray): TComplexArray; _SPLICE_;
function TComplexArrayHelper.IndexOf(const val: Complex): integer;_INDEXOF_;

function TComplexArrayHelper.Extract(const Indecies:TIntegerDynArray):TComplexArray; _EXTRACT_;
procedure TComplexArrayHelper.Scatter(const indecies:TIntegerDynArray;const Values:TComplexArray); _SCATTER_;
function TComplexArrayHelper.Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<Complex>):TIntegerDynArray;_FIND_;
function TComplexArrayHelper.Find(const values:TComplexArray):TIntegerDynArray; _FINDVALS1_;
function TComplexArrayHelper.Find(const value:Complex):TIntegerDynArray;   _FINDVALS2_;

function TComplexArrayHelper.Intersect(const Other:TComplexArray;const binSearch:boolean=false):TComplexArray;
var i,j:integer; tmp,tmp2:TComplexArray;  // compare:{$ifdef fpc}specialize{$endif}TCompareFuncNested<T>;
//  function cmp(const a,b:T):integer;begin result:=-1; if a=b then result:=0 else if b>a then result:=1 end;
begin
  if Length(Self)>Length(Other) then    // search in the smallest array to imporove perfomance?
    begin tmp:=Other;tmp2:=Self end
  else
    begin tmp:=Self;tmp2:=Other end;
  setLength(Result,length(tmp)) ;
  j:=0;
  if binSearch then begin
    for i:=0 to High(tmp) do
      if {$ifdef fpc}specialize{$endif} _BinSearch<Complex,PComplex>(@tmp2[0],tmp[i],length(tmp2))>=0 then begin
        result[j]:=tmp[i]  ;
        inc(j)
      end else
  end else
    for i:=0 to High(tmp) do
      if tmp2.indexOf(tmp[i])>=0 then begin
        result[j]:=tmp[i] ;
        inc(j)
      end ;
  setLength(result,j)
end;

function TComplexArrayHelper.Difference(const Other:TComplexArray;const binSearch:boolean=false):TComplexArray;
var i,j:integer;
begin
  setLength(Result,Length(Self));j:=0;
  if binSearch then
    for i:=0 to High(Self) do
      if {$ifdef fpc}specialize{$endif} _BinSearch<Complex,PComplex>(@Other[0],Self[i],length(other))<0 then begin
        Result[j]:=Self[i];
        inc(j)
      end else
  else
    for i:=0 to High(Self) do
      if Other.indexOf(Self[i])<0 then begin
        Result[j]:=Self[i];
        inc(j)
      end;
  setLength(result,j)
end;

function TComplexArrayHelper.Lookup(const val:Complex):integer;
begin
  // assuming that the array is sorted
  result:={$ifdef fpc}specialize{$endif} _BinSearch<Complex,PComplex>(@Self[0],Val,Length(Self),{$ifdef fpc}specialize{$endif} TCompareFunc<Complex>(@Self.cmp));
end;


function TComplexArrayHelper.add(const val: complex): TComplexArray;
var i:integer;
begin
  result:=Self;
  {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
  bulkAdd_css(@result[0],@self[0],@val,Length(Self));
  {$else}
  for i:=0 to High(Self) do with result[i] do begin
    re:=re+val.re;
    im:=im+val.Im
  end
  {$endif}
end;


function TComplexArrayHelper.add(const val: Float): TComplexArray;
var i,C:integer;
begin
  result:=Self;
  C:=Count;
  for i:=0 to C-1 do with result[i] do
    re:=re+val;
end;

function TComplexArrayHelper.sub(const val: complex): TComplexArray;
var i,C:integer;
begin
  {.$if defined(USE_AVX2) and (Float=Single)}
  {.$elseif defined(USE_AVX2) and (Float=Double)}
  {.$endif}
  result:=Self;
  C:=Count;
  for i:=0 to C-1 do with result[i] do begin
    re:=re-val.re;
    im:=im-val.Im
  end
end;

function TComplexArrayHelper.sub(const val: Float): TComplexArray;
var i,C:integer;
begin
  {.$if defined(USE_AVX2) and (Float=Single)}
  {.$elseif defined(USE_AVX2) and (Float=Double)}
  {.$endif}
  result:=Self;
  C:=Count;
  for i:=0 to C-1 do with result[i] do
    re:=re-val;
end;

function TComplexArrayHelper.mul(const val: complex): TComplexArray;
var i,C:integer;
begin
  {.$if defined(USE_AVX2) and (Float=Single)}
  {.$elseif defined(USE_AVX2) and (Float=Double)}
  {.$endif}
  result:=Self;
  C:=Count;
  for i:=0 to C-1 do
    result[i].mul(val)
end;

function TComplexArrayHelper.mul(const val: Float): TComplexArray;
var i,C:integer;
begin
  {.$if defined(USE_AVX2) and (Float=Single)}
  {.$elseif defined(USE_AVX2) and (Float=Double)}
  {.$endif}
  result:=Self;
  C:=Count;
  for i:=0 to C-1 do with result[i] do begin
    re:=re*val;
    im:=im*val
  end
end;

function TComplexArrayHelper.&div(const val: complex): TComplexArray;
var i,C:integer;
begin
  {.$if defined(USE_AVX2) and (Float=Single)}
  {.$elseif defined(USE_AVX2) and (Float=Double)}
  {.$endif}
  C:=Count;
  result:=Self;
  for i:=0 to C-1 do
    begin
      result[i]/=val
    end;
  //with result[i] do begin
  //  re:=re/val.re;
  //  im:=im/val.Im
  //end;
end;

function TComplexArrayHelper.&div(const val: Float): TComplexArray;
var i,C:integer;
begin
  C:=Count;
  result:=Self;
  for i:=0 to C-1 do with result[i] do begin
    re:=re/val;
    im:=im/val
  end
end;

function TComplexArrayHelper.ElementSize: integer;
begin
  result:=SizeOf(Float)*2
  //{$if SizeOf(Float)=4}
  //  result:=8;
  //{$elseif  SizeOf(Float)=8}
  //  result:=16;
  //{$endif}
end;

function TComplexArrayHelper.add(const val:TComplexArray):TComplexArray;    overload;
var i:integer;
begin
  result:=Self;
  {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
  bulkAdd_ccs(PSingle(result),PSingle(self),PSingle(val),Count);
  {$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
  bulkAdd_ccd(PDouble(result),PDouble(self),PDouble(val),Count);
  {$else}
  for i:=0 to high(result) do
    result[i].add(val[i]);
  {$endif}
end;

function TComplexArrayHelper.sub(const val:TComplexArray):TComplexArray;    overload;
var i:integer;
begin
  result:=Self;
  {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
  bulkSub_ccs(PSingle(result),PSingle(self),PSingle(val),Count);
  {$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
  bulkSub_ccd(PDouble(result),PDouble(self),PDouble(val),Count);
  {$else}
  for i:=0 to high(result) do
    result[i].sub(val[i]);
  {$endif}
end;

function TComplexArrayHelper.mul(const val:TComplexArray):TComplexArray;    overload;
var i:integer;
begin
  result:=Self;
  {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
  bulkMul_ccs(PSingle(result),PSingle(self),PSingle(val),Count);
  {$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
  bulkMul_ccd(PDouble(result),PDouble(self),PDouble(val),Count);
  {$else}
  for i:=0 to high(result) do
    result[i].mul(val[i]);
  {$endif}
end;

function TComplexArrayHelper.&div(const val:TComplexArray):TComplexArray;    overload;
var i:integer;
begin
  //{$if defined(USE_AVX2) and (SizeOf(Complex)=8)}
  //bulkDiv_ccs(PSingle(result),PSingle(self),PSingle(val),Count);
  //{$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
  //bulkDiv_ccd(PDouble(result),PFloat(self),PFloat(val),Count);
  //{$else}
  result:=Self;
  for i:=0 to high(result) do
    result[i].&div(val[i]);
  //{$endif}
end;

function TComplexArrayHelper.add(const val: TFloatDynArray): TComplexArray;
var i:integer;
begin
 result:=Self;
 for i:=0 to high(result) do
   result[i].Add(val[i]);
end;

function TComplexArrayHelper.sub(const val: TFloatDynArray): TComplexArray;
var i:integer;
begin
 result:=Self;
 for i:=0 to high(result) do
   result[i].Sub(val[i]);
end;

function TComplexArrayHelper.mul(const val: TFloatDynArray): TComplexArray;
var i:integer;
begin
 result:=Self;
 {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
 bulkMul_cvs(@result[0],@val[0],@self[0],Length(result));
 //{$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
 //bulkMul_cvd(@result[0],@val[0],@self[0],Length(result));
 {$else}
  for i:=0 to high(result) do
   result[i].Mul(val[i]);
 {$endif}
end;

function TComplexArrayHelper.&div(const val: TFloatDynArray): TComplexArray;
var i:integer;
begin
 result:=Self;
 for i:=0 to high(result) do
   result[i].&div(val[i]);
end;

function TComplexArrayHelper.Split():TFloatArrayArray;
var i:integer;
begin
  setLength(Result,2);
  setLength(Result[0],Length(Self));
  setLength(Result[1],Length(Self));
  {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
  interleave_s(@result[0][0],@result[1][0],@Self[0],Length(Self) shl 1);
  {$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
  interleave_d(@result[0][0],@result[1][0],@Self[0],Length(Self) shl 1);
  {$else}
  for i:=0 to high(Self) do begin
    result[0][i]:=Self[i].re;
    result[1][i]:=Self[i].im;
  end;
  {$endif}
end;

function TComplexArrayHelper.Mag(): TFloatDynArray;
var i:integer;
begin
  setLength(Result,Length(Self));
  {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
  bulkMag_cs(@result[0],@Self[0],Length(Self));
  //{$elseif defined(USE_AVX2) and (SizeOf(Complex)=16)}
  //bulkMag_cd(@result[0],@Self[0],Length(Self));
  {$else}
  for i:=0 to High(result) do with Self[i] do
    result[i]:=system.sqrt(re*re+im*im)
  {$endif}
end;

function TComplexArrayHelper.abs(): TFloatDynArray;
var i:integer;
begin
 setLength(result,Length(Self));
 for i:=0 to High(result) do with Self[i] do
   result[i]:=system.sqrt(re*re+im*im)
end;

function TComplexArrayHelper.ln(): TComplexArray;
var i:integer;
begin
  for i:=0 to High(Self) do
    Self[i].ln ;
  result:=self;
end;

function TComplexArrayHelper.exp(): TComplexArray;
var i:integer;
begin
  for i:=0 to High(Self) do
    Self[i].exp ;
  result:=self
end;

function TComplexArrayHelper.Arg(): TFloatDynArray;
var i,C:integer;
begin
   C:=Count;
   setLength(result,C);
   for i:=0 to High(result) do with Self[i] do
     result[i]:=Math.arctan2(im,re)
end;

function TComplexArrayHelper.sqrt(): TComplexArray;
var i:integer;
begin
  SetLength(Result,Length(Self));
  for i:=0 to High(Self) do begin
    Result[i]:=Self[i];Result[i].Sqrt();
  end;
end;

function TComplexArrayHelper.sqr(): TComplexArray;
var i:integer;
begin
  SetLength(Result,Length(Self));
  for i:=0 to High(Self) do begin
    Result[i]:=Self[i];Result[i].Sqr();
  end;
end;

function TComplexArrayHelper.conj(): TComplexArray;
var i:integer;
begin
  SetLength(Result,Length(Self));
  for i:=0 to High(Self) do begin
    Result[i].re:=Self[i].re;Result[i].im:=-Result[i].im;
  end;
end;

class procedure TComplexArrayHelper.sqrt(const src, Result:PComplex;const N:Integer);
var i:integer;
begin
  for i:=0 to N-1 do begin

    Result[i]:=src[i];result[i].Sqrt();
  end;
end;

class procedure TComplexArrayHelper.sqr(const src, Result:PComplex;const N:Integer);
var i:integer;
begin
  for i:=0 to N-1 do begin
    result[i]:=src[i];result[i].Sqr();
  end;
end;

function TComplexArrayHelper.interleave(): TComplexArrayArray;
var i,C,Columns:integer;
begin
  Columns:=Count shr 1;//system.trunc(C/2);
  C:=Columns shl 1;
  setLength(result,2);
  setLength(result[0],Columns);
  setLength(result[1],Columns);
  //setLength(result,2,Columns);
  i:=0;
  while i<Columns do begin
    result[0,i]:=Self[i*2];
    result[1,i]:=Self[1+i*2];
    inc(i);
  end;
end;

function TComplexArrayHelper.Sum(): Complex;
var i:integer;
begin
  result:=0;
  for i:=0 to High(Self) do
    result.add(Self[i])
end;

function TComplexArrayHelper.Product(): Complex;
var i:integer;
begin
  result:=0;
  for i:=0 to High(Self) do
   result.mul(Self[i])
end;

function TComplexArrayHelper.Dot(const Val:TComplexArray):Complex;
var i:integer;
begin
  result:=0;
  for i:=0 to High(Self) do
    result.add(Self[i]*Val[i])
end;

class function TComplexArrayHelper.Dot(const a,b:PComplex;N:Integer;bStride:integer):Complex;
var i:integer;
begin
  result:=0;
  for i:=0 to N do begin
    result.add(a[i]*b[i*bStride]);
  end;
end;

function TComplexArrayHelper.ToString(): string;
var i:integer;
begin
  result:='';
  for i:=0 to High(Self) do
    result:=result+', '+string(Self[i]);
  delete(result,1,2);
  result:='['+result+']'
end;

class function TComplexArrayHelper.PlanDFT(N:integer): TComplexArray;
var w,twid:Complex;i,j,k:integer;// theta:{$if SizeOf(Complex)=8}Float{$elseif SizeOf(Complex)=16}Float{$else}Extrended{$endif};
begin
  setLength(result,N*N);
  for i:=0 to N-1 do
    for j:=0 to N-1 do begin
      Twid:=-PIx2*i*j*Complex._i()/N ;
      twid.exp;
      result[i*N+j]:=twid;
    end;
end;

class procedure TComplexArrayHelper.PlanDFT(var Plan:TFloatArrayArray;const N: integer);
var w,twid:Complex;i,j,k:integer;// theta:{$if SizeOf(Complex)=8}Float{$elseif SizeOf(Complex)=16}Float{$else}Extrended{$endif};
begin
  setLength(Plan,2);
  setLength(Plan[0],N*N);
  setLength(Plan[1],N*N);
  for i:=0 to N-1 do
    for j:=0 to N-1 do begin
      Twid:=-PIx2*i*j*Complex._i()/N ;
      twid.exp;
      Plan[0][i*N+j]:=twid.re;
      Plan[1][i*N+j]:=twid.im;
    end;
end;

class function TComplexArrayHelper.PlanFFT(N:integer): TComplexArrayArray;
var w,twid:Complex;i,j,N2,k:integer;// theta:{$if SizeOf(Complex)=8}Float{$elseif SizeOf(Complex)=16}Float{$else}Extrended{$endif};
begin
  N2:=trunc(Log2(N));
  setLength(result,N2);
  j:=0;
    //w:=ucomplex.cexp(i_*2*PI/n);
  //theta:=-PIx2/N;
  //w.re:=system.cos(theta);
  //w.im:=system.sin(theta);

  while N>1 do begin
    twid:=-PIx2*Complex._i()/N;twid.exp;
//    w.re:=system.cos(theta);
//    w.im:=system.sin(theta);
    N:=N shr 1;
    setLength(result[j],N);
    for i:=0 to N-1 do begin
      w:=twid;w.pow(i);
      result[j][i]:=w;
      //result[j][i].pow(i)
    end;
    inc(j);
  end;
end;

class procedure TComplexArrayHelper.PlanFFT(var plan:TFloatArrayArray;N:integer);
var w,twid:Complex;i,j,N2,k:integer;// theta:{$if SizeOf(Complex)=8}Float{$elseif SizeOf(Complex)=16}Float{$else}Extrended{$endif};
begin
  N2:=trunc(Log2(N));
  setLength(plan,N2);
  j:=0;
    //w:=ucomplex.cexp(i_*2*PI/n);
  //theta:=-PIx2/N;
  //w.re:=system.cos(theta);
  //w.im:=system.sin(theta);

  while N>1 do begin
    twid:=-PIx2*Complex._i()/N;twid.exp;
//    w.re:=system.cos(theta);
//    w.im:=system.sin(theta);
    N:=N shr 1;
    setLength(plan[j],N*2);
    for i:=0 to N-1 do begin
      w:=twid;w.pow(i);
      plan[j][i]:=w.re;
      plan[j][i+n]:=w.im;
      //result[j][i].pow(i)
    end;
    inc(j);
  end;
end;

class function TComplexArrayHelper.PlanIFFT(N:integer): TComplexArrayArray;
var w:Complex;i,j,N2,k:integer;theta:Float;
begin
  N2:=trunc(Log2(N));
  setLength(result,N2);
  j:=0;
    //w:=ucomplex.cexp(i_*2*PI/n);
  while N>1 do begin
    theta:=-PIx2/N;
    w.re:=system.cos(theta)/N;
    w.im:=system.sin(theta)/N;
    N:=N shr 1;
    setLength(result[j],N);
    for i:=0 to High(result[j]) do begin
      result[j][i]:=w**i;
      //result[j][i].pow(i);
    end;
    inc(j);
  end;
end;

function TComplexArrayHelper.fft( const plan: TComplexArrayArray;const l:integer): TComplexArray;
var n,j:integer;theta:Float;w,wn,twidAr:TComplexArray;Ye,Yo:TComplexArray;
  P:TComplexArrayArray;
begin
  //setLength(result,Count);
  //_fft(@result[0],@Self[0],@plan[0],Count);
//  exit;
  n:=count;// n must be a power of 2;  (radix 2 FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  if n<=DFTThreshold then result:=dft({$if Float=Single}DFTThresholdPlanF{$elseif Float=Double}DFTThresholdPlanD{$endif} ) else begin
     setLength(result,N);
    //w:=ucomplex.cexp(i_*2*PI/n);
    //theta:=PIx2/N;
    //w.re:=system.cos(theta);
    //w.im:=system.sin(theta);
    P:=interleave;
    n:=N shr 1;
    Ye:=TComplexArray(p[0]).fft(Plan,l+1);
    Yo:=TComplexArray(p[1]).fft(Plan,l+1);
    SetLength(TwidAr,N);
    TwidAr:=Copy(Plan[l]);
    TwidAr.mul(Yo);
    {$if defined(USE_AVX2) and (SizeOf(Float)=4)}
    //bulkMul_ccs(@TwidAr[0],@Plan[l][0],@Yo[0],n);
    bulkAdd_ccs(@result[0],PSingle(Ye),PSingle(TwidAr),n);
    bulkSub_ccs(@result[n],PSingle(Ye),PSingle(TwidAr),n);
    {$elseif defined(USE_AVX2) and (SizeOf(Float)=8)}
    //bulkMul_ccd(@TwidAr[0],@Plan[l][0],@Yo[0],n);
    bulkAdd_ccd(@result[0],PDouble(Ye),PDouble(TwidAr),n);
    bulkSub_ccd(@result[n],PDouble(Ye),PDouble(TwidAr),n);
    {$else}
    for j:=0 to n-1 do begin
      result[j]:=Ye[j]+TwidAr[j];
      result[n+j]:=Ye[j]-TwidAr[j];
    end
    {$endif}
//    for j:=0 to n-1 do
//      begin
//{$ifdef fpc}
//        twid:=(w**j)*Yo[j];
//{$else}
//        wn:=w;
//        wn.pow(j);
//        twid:=wn*Yo[j];
//{$endif}
//        result[j]:=Ye[j] +twid;
//        result[j+n]:=Ye[j] -twid;
//      end;
  end;
end;

function TComplexArrayHelper.fft(): TComplexArray;
var n,j:integer;theta:Float;w,wn,twid:complex;Ye,Yo:TComplexArray;
  P:TComplexArrayArray;
begin
  n:=count;// n must be a power of 2;  (radix 2 FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  if n<=DFTThreshold then result:=dft({$if Float=Single}DFTThresholdPlanF{$elseif Float=Double}DFTThresholdPlanD{$endif})
  else begin
    setLength(result,n);
    //w:=ucomplex.cexp(i_*2*PI/n);
    theta:=-PIx2/N;
    w.re:=system.cos(theta);
    w.im:=system.sin(theta);
    P:=interleave;
    n:=N shr 1;
    Ye:=TComplexArray(p[0]).fft();
    Yo:=TComplexArray(p[1]).fft();
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

function TComplexArrayHelper.ifft(const plan: TComplexArrayArray;const l:integer): TComplexArray;
var n,j:integer;theta:Float;w,wn,twidAr:TComplexArray;Ye,Yo:TComplexArray;
  P:TComplexArrayArray;
begin
  n:=count;// n must be a power of 2;  (radix 2 FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  setLength(result,n);
  if n=1 then result[0]:=Self[0] else begin
    //ucomplex.cexp(-i_*2*PI/n)/n;
    //theta:=-PIx2/N;
    //w.re:=system.cos(theta)/n;
    //w.im:=system.sin(theta)/n;
    P:=interleave;
    n:=N shr 1;
    TwidAr:=Copy(Plan[l]);
    Ye:=TComplexArray(p[0]).ifft(Plan,l+1);
    Yo:=TComplexArray(p[1]).ifft(Plan,l+1);
    TwidAr.mul(Yo);
{$if defined(USE_AVX2) and (SizeOf(Float)=4)}
    bulkAdd_ccs(@result[0],PFloat(Ye),PFloat(TwidAr),n);
    bulkSub_ccs(@result[n],PFloat(Ye),PFloat(TwidAr),n);
{$elseif defined(USE_AVX) and (SizeOf(Float)=8)}
    bulkAdd_ccd(@result[0],PFloat(Ye),PFloat(TwidAr),n);
    bulkSub_ccd(@result[n],PFloat(Ye),PFloat(TwidAr),n);
{$else}
    for j:=0 to n-1 do
      begin
        result[j]:=Ye[j]  ;result[j].add(twidAr[j]);
        result[j+n]:=Ye[j];result[j+n].sub(twidAr[j]);
      end;
{$endif}
  end;
end;

function TComplexArrayHelper.ifft(): TComplexArray;
var n,j:integer;theta:Float;w,wn,twid:complex;Ye,Yo:TComplexArray;
    P:TComplexArrayArray;

begin
  n:=count;// n must be a power of 2;  (radix 2 FFT)
  //assert(system.frac(Math.Log2(n))=0,'Buffer Length must be a power of two');
  setLength(result,n);
  if n=1 then result[0]:=Self[0] else begin
    theta:=-PIx2/N;
    //ucomplex.cexp(-i_*2*PI/n)/n;
    w.re:=system.cos(theta)/n;
    w.im:=system.sin(theta)/n;
    P:=interleave;
    n:=N shr 1;
    Ye:=TComplexArray(p[0]).ifft();
    Yo:=TComplexArray(p[1]).ifft();
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

function TComplexArrayHelper.dft(const Plan:TcomplexArray): TComplexArray;
var k,N,j:integer;theta:Float;twid:Complex;
begin
  N:=Count;
  setLength(result,n);
  for k:=0 to N-1 do
    for j:=0 to N-1 do with result[k] do begin
      //theta:=PIx2*k*j/N;
      //re:=re+self[j]*system.cos(theta);
      //im:=im-self[j]*system.sin(theta);

//      twid:=-PIx2*k*j*i_/N;twid.exp;
      result[k].add(self[j]*Plan[k*N+j]);
    end;
end;

function TComplexArrayHelper.dft(): TComplexArray;
var k,N,j:integer;theta:Float;twid:Complex;
begin
  N:=Count;
  setLength(result,n);
  for k:=0 to N-1 do
    for j:=0 to N-1 do with result[k] do begin
      //theta:=PIx2*k*j/N;
      //re:=re+self[j]*system.cos(theta);
      //im:=im-self[j]*system.sin(theta);
      twid:=-PIx2*k*j*Complex._i()/N;twid.exp;
      result[k].add(self[j]*twid);
    end;
end;

function TComplexArrayHelper.as2D(const Columns: integer;
  const Transposed: Boolean): {$ifdef fpc}specialize{$endif} TArray<TComplexArray>;
var i,C,M,R,Rows:integer;
begin
 c:=Count;
 Rows:=system.trunc(C/Columns);
 c:=Columns*Rows;
 setLength(result,Rows);
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

function TComplexArrayHelper.Transpose(const Width:integer; Height:integer):TComplexArray;
var x,y:integer;
begin
  setLength(Result,Length(Self));
  if Height=0 then Height:=Length(Self) div width;
  for y:=0 to Height-1 do
    for x:=0 to Width-1 do
      result[x*width+y]:=self[y*width+x]
end;

class function TComplexArrayHelper.fill(const vCount: integer; val: Complex; interval: Complex): TComplexArray;
var i:integer;
begin
  setLength(result,vCount);
  if interval=0 then
    for i:=0 to High(Result) do
      result[i]:=val
  else
    for i:=0 to High(Result) do
      begin
        result[i]:=val;
        val.add(interval);
      end;
end;

class procedure TComplexArrayHelper.Add(const result:PComplex ;const N:integer;const Self,Vals:PComplex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]+Vals[i]
end;

class procedure TComplexArrayHelper.Add(const result:PComplex ;const N:integer;const Self:PComplex;const Vals:Complex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]+Vals
end;

class procedure TComplexArrayHelper.Sub(const result:PComplex ;const N:integer;const Self,Vals:PComplex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]-Vals[i]
end;

class procedure TComplexArrayHelper.Sub(const result:PComplex ;const N:integer;const Self:PComplex;const Vals:Complex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]-Vals
end;

class procedure TComplexArrayHelper.Mul(const result:PComplex ;const N:integer;const Self,Vals:PComplex);
var i:integer;
begin
   for i:=0 to N-1 do
    result[i]:=Self[i]*Vals[i]
end;

class procedure TComplexArrayHelper.Mul(const result:PComplex ;const N:integer;const Self:PComplex;const Vals:Complex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]*Vals
end;

class procedure TComplexArrayHelper.&Div(const result:PComplex ;const N:integer;const Self,Vals:PComplex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]/Vals[i]
end;

class procedure TComplexArrayHelper.&Div(const result:PComplex ;const N:integer;const Self:PComplex; const Vals:Complex);
var i:integer;
begin
  for i:=0 to N-1 do
    result[i]:=Self[i]/Vals
end;


{ Sort by real then imaginary or by magnitute length?}

class function TComplexArrayHelper.cmp(const a, b: Complex): integer;
//var m1,m2:Float;
begin
  result:=1;
  if a=b then
    result:=0
  else if a<b then result:=-1;

  //if a.re=b.re then
  //  if a.im=b.im then begin result:=0{;exit} end
  //  else if a.im<b.im then begin result:=-1{;exit} end else
  //else
  //  if a.re<b.re then
  //    result:=-1


  //m1:=a.mag();m2:=b.mag();
  //if m1>m2 then result:=1
  //else if m1<m2 then result:=-1 else result:=0;
end;

class procedure TComplexArrayHelper.QuickSort(var Arr: TComplexArray; const L, R: Longint; const Descending:boolean; const Compare: TCompareFuncComplex);
begin
    {$ifdef fpc}specialize{$endif} _QuickSort<Complex,PComplex>(@Arr[0],L,R,Descending,Compare)
end;

class procedure TComplexArrayHelper.Conj(const result:PComplex;const N:integer ;const Self:PComplex);
var i:integer;
begin
  if result<>Self then
    Move(Self^,result^,N*SizeOf(Complex));
  for i:=0 to N-1 do
    result[i].Im:=-result[i].Im
end;

class procedure TComplexArrayHelper.Gather(const dst,Self:PFloat;const Stride, N:integer);
var i:integer;
begin

  for i:=0 to N-1 do
    dst[i]:=Self[i*Stride]
end;

