
{ TNumberArrayHelper }

procedure TNumberArrayHelper.SetCount(AValue: integer); _SETCOUNT_;

function TNumberArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TRecudeCallback<Number>; const init: Number): Number;
var i,l:integer;
begin
    l:=Length(Self);
    if l>0 then result:=func(init,self[0],0,self);
    if l>1 then for i:=1 to l-1 do
      result:=func(Self[i-1],self[i],i,self)
end;

function TNumberArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TSimpleReduceCallback<Number >): Number; _SIMPLEREDUCE_;

function TNumberArrayHelper.GetCount: Integer; _DOCOUNT_ ;

function TNumberArrayHelper.Sort(const CompareFunc:  {$ifdef fpc}specialize{$endif} TCompareFunc<Number>):TNumberDynArray;_DOSORT_;

function TNumberArrayHelper.Sorted(const CompareFunc:  {$ifdef fpc}specialize{$endif} TCompareFunc<Number>): TNumberDynArray; _SORTED_;

function TNumberArrayHelper.isSorted(const descending:boolean=false; CompareFunc:  {$ifdef fpc}specialize{$endif} TCompareFunc<Number> =nil): boolean; _ISSORTED_;

function TNumberArrayHelper.Lookup(const val:Number):integer;
begin
  // assuming that the array is sorted
  result:={$ifdef fpc}specialize{$endif} _BinSearch<Number,PNumber>(@Self[0],Val,Length(Self),{$ifdef fpc}specialize{$endif} TCompareFunc<Number>(@Self.cmp));
end;

function TNumberArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<Number> ): TNumberDynArray;_DOMAP_;

function TNumberArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<Number> ): TNumberDynArray; _SIMPLEMAP_;


function TNumberArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<Number>): TVariantArray;_DOMAP_;

function TNumberArrayHelper.Map(const a, b, a1, b1: Number): TNumberDynArray;
 var i:Integer;v,v1:Number;
begin
   v:=b-a;
   v1:=b1-a1;
   setLength(result,count);
   for i:=0 To Count-1 do
     Result[i]:=a1+round(v1*(Self[i]-a)/v);

end;

function TNumberArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>): TNumberDynArray; _FILTER_;

class function TNumberArrayHelper.uniqueFilt(const a:Number;const i:integer;arr:PNumber):boolean;
begin;
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;

function TNumberArrayHelper.unique():TNumberDynArray;
begin
  result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>(@uniqueFilt));
end;

function TNumberArrayHelper.indexOf(const val: Number): integer;_INDEXOF_;

function TNumberArrayHelper.toDoubleArray:TDoubleDynArray;
var i:integer;
begin
  setLength(result,count);
  for i:=0 to High(Self) do
    result[i]:=Self[i]
end;

class function TNumberArrayHelper.uniform(const vCount: integer;const maxVal:Number;const minVal: Number): TNumberDynArray;
var i:integer;
begin
  setLength(result,vCount);
  for i:=0 to vCount-1 do
    result[i]:=minVal+Random(maxVal);
end;

class function TNumberArrayHelper.normal(const vCount:Integer;const vMean,vStdDiv:Single): TNumberDynArray;
var i:integer;
begin
  setLength(Result,vCount);
  for i:=1 to vCount-1 do
    Result[i]:=round(RandG(vMean,vStdDiv));
end;

function TNumberArrayHelper.uniform(const maxVal:Number;const minVal: Number): TNumberDynArray;
var i:integer;
begin
 for i:=0 to Count-1 do
   Self[i]:=minVal+Random(maxVal-minval);
 result:=Self;
end;

function TNumberArrayHelper.normal(const vMean, vStdDiv: single): TNumberDynArray;
var i:integer;
begin
  for i:=1 to Count-1 do
    Self[i]:=round(RandG(vMean,vStdDiv));
  result:=Self
end;

function TNumberArrayHelper.as2d(const Columns:integer;Transposed:boolean):TNumberArrayArray;
var i,C,M,R,Rows:integer;
begin
  c:=Length(Self);
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

function TNumberArrayHelper.Transpose(const Width:integer; Height:integer):TNumberDynArray;
var x,y:integer;
begin
  setLength(Result,Length(Self));
  if Height=0 then Height:=Length(Self) div width;
  for y:=0 to Height-1 do
    for x:=0 to Width-1 do
      result[x*width+y]:=self[y*width+x]
end;

class function TNumberArrayHelper.fill(const vCount:Integer;val:Number;const interval:Number): TNumberDynArray;
var i:integer;
begin
  setLength(Result,vCount);
  i:=0;
  while i<vCount do begin
    result[i]:=Val;
    Val:=Val+Interval;
    inc(i)
  end;
end;

function TNumberArrayHelper.Abs():TNumberDynArray;
//var i:integer;
begin
  result:=Self;
  Abs(@result[0],@Self[0],Length(Self));
end;

function TNumberArrayHelper.fill(val:Number;const interval:Number=0): TNumberDynArray;
var i:integer;
begin
  i:=0;
  result:=self;
  while i<Count do begin
    result[i]:=Val;
    Val:=Val+Interval;
    inc(i)
  end;
end;

function TNumberArrayHelper.Magnitude(): Single;
begin
  result:=Sqrt(SumOfSquares());
end;

function TNumberArrayHelper.SumOfSquares(): Int64;
var r:integer;
begin
 result:=0;
 for r in Self do
   result:=result + r*r;
end;

function TNumberArrayHelper.product: Int64;
var i:integer;
begin
  Result:=1;
  for i:=0 to Count-1 do
    Result:=Result*Self[i]
end;

function TNumberArrayHelper.Sum(): Int64;
begin
  result:={$ifdef FPC}specialize {$endif}SumNumber<Number,Int64>(Self);
end;

function TNumberArrayHelper.Max(): Number;
begin
  Result:={$ifdef FPC}specialize {$endif}MaxNumber<Number>(Self);
end;

function TNumberArrayHelper.Min(): Number;
begin
  result:={$ifdef FPC}specialize {$endif}MinNumber<Number>(Self);
end;

function TNumberArrayHelper.Mean(): single;
begin
  result:=Self.Sum()/Length(Self);
end;

function TNumberArrayHelper.Mode(): single;
var i,C,e,r:integer;vs:TNumberDynArray;a:TIntegerDynArray;
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

function TNumberArrayHelper.Median(): single;
var C,c2:integer;a:TNumberDynArray;
begin
  a:=Self.Sorted;
  C:=Count;c:=c div 2;
  if count mod 2=0 then
    result:=(a[c2-1]+a[c2])/2
  else
    result:= a[c2];
end;

function TNumberArrayHelper.Max(const Val:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
  for i:=0 to C do
    result[i]:=Math.Max(val,Self[i])
end;

function TNumberArrayHelper.Min(const Val:number):TNumberDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
  for i:=0 to C do
    result[i]:=Math.Min(val,Self[i])
end;

function TNumberArrayHelper.Max(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
  for i:=0 to C do
    result[i]:=Math.Max(vals[i],Self[i])
end;

function TNumberArrayHelper.Min(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(result,C);
  for i:=0 to C do
    result[i]:=Math.Min(vals[i],Self[i])
end;

procedure TNumberArrayHelper.MinMax(out Mi:Number;out Ma:Number);
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

function TNumberArrayHelper.&shr(const aShift:integer):TNumberDynArray;
var i:integer;
begin
  for i:=0 to High(Self) do
    self[i]:=self[i] shr ashift;
  result:=self
end;

function TNumberArrayHelper.&shl(const aShift:integer):TNumberDynArray;
var i:integer;
begin
  for i:=0 to High(Self) do
    self[i]:=self[i] shl ashift;
  result:=self
end;

function TNumberArrayHelper.Clamp(const minVal,maxVal:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=High(Self);
  setLength(Result,C);
  for i:=0 to C do
    begin
      Result[i]:=Self[i];
      if Self[i]>maxVal then result[i]:=maxVal;
      if Self[i]<minVal then result[i]:=minVal;
    end;
end;

function TNumberArrayHelper.Variance(): single;
var avg,r,v:double;i:integer;
begin
  avg:=Self.Mean();
  v:=0;
  for i:=0 to High(Self) do
    begin
      r:=Self[i]-avg;
      v:=v+r*r;
    end;
  result:=v/High(Self);
end;

function TNumberArrayHelper.StdDev: single;
begin
  result:=sqrt(variance);
end;

function TNumberArrayHelper.Factorial:TNumberDynArray;
var C,i:integer;r,j:Number;
begin
  C:=Count;
  setLength(Result,C);
  for i:=0 to C-1 do begin
    r:=Self[i];j:=System.abs(r);
    while j>2 do
      begin
        dec(j);
        r:=r*j;
      end ;
    result[i]:=r
  end;
end;

function TNumberArrayHelper.Push(v: Number): Number;_PUSH_;

function TNumberArrayHelper.Pop(): Number; _POP_;

function TNumberArrayHelper.UnShift(v: Number): Number;_UNSHIFT_;

function TNumberArrayHelper.Shift(): Number;_SHIFT_;

function TNumberArrayHelper.Slice(start, _end: integer): TNumberDynArray; _SLICE_;

function TNumberArrayHelper.Extract(const Indecies:TIntegerDynArray):TNumberDynArray; _EXTRACT_;

function TNumberArrayHelper.Splice(start, deleteCount: integer;  Items: TNumberDynArray): TNumberDynArray; _SPLICE_;

procedure TNumberArrayHelper.Scatter(const indecies:TIntegerDynArray;const Values:TNumberDynArray);   _SCATTER_;

function TNumberArrayHelper.Find(const func:{$ifdef fpc}specialize{$endif} TSimpleFilterCallBack<Number>):TIntegerDynArray; _FIND_;

function TNumberArrayHelper.Find(const values:TNumberDynArray):TIntegerDynArray;    _FINDVALS1_;

function TNumberArrayHelper.Find(const value:Number):TIntegerDynArray;              _FINDVALS2_;

function TNumberArrayHelper.concat(Items: TNumberDynArray): TNumberDynArray;_CONCAT_;

function TNumberArrayHelper.ToString(const Seperator: string): string;
var i:integer;
begin
  Result:='';
  for i:=0 to Count-1 do
    Result:=Result+Seperator+IntToStr(Self[i]);
  if Count>0 then delete(result,1,length(Seperator));
  result:='['+result+']';
end ;

function TNumberArrayHelper.ToStringArray():TStringArray;
var i:integer;
begin
  setLength(result,Count);
  for i:=0 to High(Self) do
    result[i]:=IntToStr(Self[i])
end;

class function TNumberArrayHelper.cmp(const a,b:Number):Integer  ;
begin
  result:=CompareValue(a,b);
end;

class function TNumberArrayHelper.Sum(const a:PNumber;const aCount:integer):Int64;
var i:integer;
begin
  result:=a[0];
  for i:=1 to aCount-1 do
    result:=result+a[i]
end;

class function TNumberArrayHelper.Min(const a:PNumber;const aCount:integer):Int64;
var i:integer;
begin
  result:=a[0];
  for i:=1 to aCount-1 do
    if a[i]<result then result:=a[i]
end;

class function TNumberArrayHelper.Max(const a:PNumber;const aCount:integer):Int64;
var i:integer;
begin
  result:=a[0];
  for i:=1 to aCount-1 do
    if a[i]>result then result:=a[i]
end;

class procedure TNumberArrayHelper.BitShr(const dst,a:PNumber;const ashift, aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i] shr ashift
end;

class procedure TNumberArrayHelper.BitShl(const dst,a:PNumber;const ashift, aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i] shl ashift

end;

class procedure TNumberArrayHelper.BitOr(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i] or b[i]

end;

class procedure TNumberArrayHelper.BitAnd(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i] and b[i]

end;

class procedure TNumberArrayHelper.BitXor(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i] xor b[i]

end;

class procedure TNumberArrayHelper.BitXor(const dst,a:PNumber;const b:Number;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i] xor b
end;

class procedure TNumberArrayHelper.BitNot(const dst,a:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=not a[i]
end;

class procedure TNumberArrayHelper.Add(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i]+b[i]
end;

class procedure TNumberArrayHelper.Sub(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i]-b[i]

end;

class procedure TNumberArrayHelper.Mul(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i]*b[i]

end;

class procedure TNumberArrayHelper.&Div(const dst,a,b:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=trunc(a[i]/b[i])

end;

class procedure TNumberArrayHelper.Add(const dst,a:PNumber;const b:Number;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i]+b


end;

class procedure TNumberArrayHelper.Sub(const dst,a:PNumber;const b:Number;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i]-b

end;

class procedure TNumberArrayHelper.Mul(const dst,a:PNumber;const b:Number;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=a[i]*b

end;

class procedure TNumberArrayHelper.&Div(const dst,a:PNumber;const b:Number;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=trunc(a[i]/b)

end;

class function TNumberArrayHelper.Dot(const a,b:PNumber;const aCount:integer):Int64;
var i:integer;
begin
  result:=a[0]*b[0];
  for i:=1 to aCount-1 do
    result:=result+a[i]*b[i]
end;

class procedure TNumberArrayHelper.Abs(const dst,a:PNumber;const aCount:integer);
var i:integer;
begin
  for i:=0 to aCount-1 do
    dst[i]:=System.abs(a[i])
end;

class procedure TNumberArrayHelper.Conv1D(const dst,a,krn:PNumber;const aCount,krnSize:integer;const aStride:integer);
var i,j,k,r:integer;
begin
  i:=0;k:=0;
  while i< aCount do begin
    r:=a[i]*krn[0];
    for j:=1 to krnSize-1 do
      r:=r+a[i+j]*krn[j];
    dst[k]:=r;
    inc(k);
    inc(i,aStride)
  end;
end;

class function TNumberArrayHelper.Every(const dst:PNumber; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>):boolean;  _EVERY_;

class function TNumberArrayHelper.Some(const dst:PNumber; const aCount:integer;const func:{$ifdef fpc}specialize{$endif} TFilterCallback<Number,PNumber>):boolean;   _SOME_;

class procedure TNumberArrayHelper.Gather(const dst,Self:PNumber;const Stride, N:integer);
var i:integer;
begin
  for i:=0 to N-1 do
    dst[i]:=Self[i*Stride]
end;

class procedure TNumberArrayHelper.QuickSort(var Arr: TNumberDynArray; const L, R: Longint; const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<Number>);
begin
   {$ifdef fpc}specialize{$endif} _QuickSort<Number,PNumber>(@Arr[0],L,R,Compare)
end;
function TNumberArrayHelper.Add(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Self[i] + Vals[i];
  Result:=Self;
end;

function TNumberArrayHelper.Add(const Vals:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Self[i] + Vals;
  Result:=Self;
end;

function TNumberArrayHelper.Sub(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Self[i] - Vals[i];
  Result:=Self;
end;

function TNumberArrayHelper.Sub(const Vals:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Self[i] - Vals;
  Result:=Self;
end;

function TNumberArrayHelper.Mul(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Self[i] * Vals[i];
  Result:=Self;
end;

function TNumberArrayHelper.Mul(const Vals:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Self[i] * Vals;
  Result:=Self;
end;

function TNumberArrayHelper.&Div(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=trunc(Self[i] / Vals[i]);
  Result:=Self;
end;

function TNumberArrayHelper.&Div(const Vals:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=trunc(Self[i] / Vals);
  Result:=Self;
end;

function TNumberArrayHelper.SubstractFrom(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Vals[i] - Self[i];
  Result:=Self;
end;

function TNumberArrayHelper.SubstractFrom(const Vals:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Vals - Self[i];
  Result:=Self;
end;

function TNumberArrayHelper.DividedBy(const Vals:TNumberDynArray):TNumberDynArray;
var i,C:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=trunc(Vals[i] / Self[i]);
  Result:=Self;
end;

function TNumberArrayHelper.DividedBy(const Vals:Number):TNumberDynArray;
var i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    Self[i]:=Vals - Self[i];
  Result:=Self;
end;

function TNumberArrayHelper.Dot(const Vals:TNumberDynArray):Number;
var i:integer;
begin
  Assert(Length(Self)=Length(Vals),'Array size must match');
  result:=0;
  for i:=0 to High(Vals) do
    result:=result +Vals[i]*Vals[i]
end;

function TNumberArrayHelper.reverse():TNumberDynArray;_REVERSE_;

function TNumberArrayHelper.argMax():Integer;
var i,C:integer;F:Number;
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

function TNumberArrayHelper.argMin():Integer;
var i,C:integer;F:Number;
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

{ TNumberArrayArrayHelper }

function TNumberArrayArrayHelper.GetCount: integer;_DOCOUNT_;

procedure TNumberArrayArrayHelper.SetCount(AValue: integer);_SETCOUNT_;

function TNumberArrayArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TRecudeCallback<TNumberDynArray>; const init: TNumberDynArray): TNumberDynArray; _REDUCE_;

function TNumberArrayArrayHelper.reduce(func: {$ifdef fpc}specialize{$endif} TSimpleReduceCallback<TNumberDynArray>): TNumberDynArray;_SIMPLEREDUCE_;

//self sort
function TNumberArrayArrayHelper.Sort(CompareFunc: {$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray>):TNumberArrayArray;_DOSORT_;

//new sorted array (Self is not affected)
function TNumberArrayArrayHelper.Sorted(CompareFunc: {$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray>): TNumberArrayArray;_SORTED_;

function TNumberArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallback<TNumberDynArray>): TNumberArrayArray;_DOMAP_;

function TNumberArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TSimpleMapCallback<TNumberDynArray>): TNumberArrayArray;_SIMPLEMAP_;

function TNumberArrayArrayHelper.Map(func: {$ifdef fpc}specialize{$endif} TMapCallbackVar<TNumberDynArray>): TVariantArray;_DOMAP_;

function TNumberArrayArrayHelper.Filter(func: {$ifdef fpc}specialize{$endif} TFilterCallback<TNumberDynArray,PNumberArray>): TNumberArrayArray;_FILTER_;

class function TNumberArrayArrayHelper.uniqueFilt(const a:TNumberDynArray;const i:integer;arr:PNumberArray):boolean;
begin;
  result:=true;
  if i>0 then
    result:=cmp(a,arr[i-1])<>0;
end;

function TNumberArrayArrayHelper.unique():TNumberArrayArray;
begin
  result:=Self.Sorted().Filter({$ifdef fpc}specialize{$endif} TFilterCallback<TNumberDynArray,PNumberArray>(@uniqueFilt));
end;

function TNumberArrayArrayHelper.Transpose: TNumberArrayArray;_TRANSPOSE_;

function TNumberArrayArrayHelper.Push(v: TNumberDynArray): TNumberDynArray;_PUSH_;

function TNumberArrayArrayHelper.Pop(): TNumberDynArray;_POP_;

function TNumberArrayArrayHelper.UnShift(v: TNumberDynArray ): TNumberDynArray;_UNSHIFT_;

function TNumberArrayArrayHelper.Shift(): TNumberDynArray; _SHIFT_;

function TNumberArrayArrayHelper.Slice(start, _end: integer ): TNumberArrayArray;_SLICE_;

function TNumberArrayArrayHelper.Splice(start, deleteCount: integer; Items: TNumberArrayArray): TNumberArrayArray; _SPLICE_;

function TNumberArrayArrayHelper.concat(Items: TNumberArrayArray): TNumberArrayArray;_CONCAT_;

function TNumberArrayArrayHelper.ToString(const Seperator: string): string;
var i:integer;
begin
  for i:=0 to Count-1 do
    result:=Result+Seperator+#13#10+Self[i].ToString(Seperator) ;
  delete(result,1,Length(Seperator)+2);
  result:='['+result+']';
end;

class function TNumberArrayArrayHelper.cmp(const a, b: TNumberDynArray): integer;
var i:integer ;
begin
  for i:=0 to Min(High(a),High(b)) do begin
    result:=TNumberDynArray.cmp(a[i],b[i]);
    if result<>0 then exit;
  end;
  if Length(a)>Length(b) then result:=1
  else if Length(a)<Length(b) then result:=-1
  else result:=0;
end;

class procedure TNumberArrayArrayHelper.QuickSort(var Arr: TNumberArrayArray;const L, R: Longint; const Compare: {$ifdef fpc}specialize{$endif} TCompareFunc<TNumberDynArray>);
begin
  {$ifdef fpc}specialize{$endif} _QuickSort<TNumberDynArray,PNumberArray>(@Arr[0],L,R,Compare)
end;

{$ifdef fpc}
operator:=(const Arr: TNumberDynArray): string;
begin
  result:=Arr.toString ;
end;
operator:=(const Arr: TNumberArrayArray): string;
begin
    result:=Arr.toString
end;

operator+(const Arr, Arr2: TNumberDynArray): TNumberDynArray;                      _AADD_;
operator+(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;                  _AADD_;
operator+(const Arr: TNumberDynArray   ;   const v: Number): TNumberDynArray;      _ADD_;
operator+(const Arr: TNumberArrayArray ;   const v: Number): TNumberArrayArray;    _ADD_;
operator+(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;          _ADD_;
operator+(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;       _ADD_;

operator-(const Arr, Arr2: TNumberDynArray): TNumberDynArray;                      _ASUB_  ;
operator-(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;                  _ASUB_ ;
operator-(const Arr: TNumberDynArray; const v: Number): TNumberDynArray;           _SUB1_;
operator-(const Arr: TNumberArrayArray; const v: Number): TNumberArrayArray;       _SUB1_;
operator-(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;          _SUB2_;
operator-(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;       _SUB2_;

operator*(const Arr, Arr2: TNumberDynArray): TNumberDynArray;                      _AMUL_;
operator*(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;                  _AMUL_;
operator*(const Arr: TNumberDynArray; const v: Number): TNumberDynArray;           _MUL_;
operator*(const Arr: TNumberArrayArray; const v: Number): TNumberArrayArray;       _MUL_;
operator*(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;          _MUL_;
operator*(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;       _MUL_;

operator/(const Arr, Arr2: TNumberDynArray): TNumberDynArray;                      _ADIV_;
operator/(const Arr, Arr2: TNumberArrayArray): TNumberArrayArray;                  _ADIVIDE_;
operator/(const Arr: TNumberDynArray; const v: Number): TNumberDynArray;           _DIV1_;
operator/(const Arr: TNumberArrayArray; const v: Number): TNumberArrayArray;       _DIVIDE1_;
operator/(const v: Number;const Arr: TNumberDynArray  ): TNumberDynArray;          _DIV2_;
operator/(const v: Number;const Arr: TNumberArrayArray ): TNumberArrayArray;       _DIVIDE2_;
{$endif}


